import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/home/home_model.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_service.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/profile/profile_widgets.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  UserData? userData;
  Statistik? statsData;
  double average = 0;
  bool isLoading = true;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _triggerFetchData(); // Programmatically show RefreshIndicator on load
  }

  Future<void> _triggerFetchData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshKey.currentState?.show(); // Trigger the pull-to-refresh animation
    });
    await fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Fetch user info
      final BaseResponse<UserData> response = await _userService.fetchMyinfo();
      if (response.success && response.data != null) {
        setState(() {
          userData = response.data;
        });
      } else {
        _showErrorDialog("Fetch Failed (User Info)", response.message);
      }

      // Fetch statistics
      final BaseResponse<Statistik> responseStats =
          await _userService.fetchStats();
      if (responseStats.success && responseStats.data != null) {
        double opo = await Storage.getAvg() as double;
        setState(() {
          statsData = responseStats.data;
          average = opo;
        });
      } else {
        _showErrorDialog("Fetch Failed (Statistics)", responseStats.message);
      }
    } catch (e) {
      _showErrorDialog("Error", "An error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = average > 5
        ? ColorPrimary.green
        : average < 5 && average > 3
            ? ColorPrimary.blue
            : ColorPrimary.orange;

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshKey,
        color: ColorNeutral.black,
        onRefresh: fetchData, // Attach the fetchData function
        child: isLoading
            ? ListView(
                // Empty ListView for pull-to-refresh gesture
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                  ),
                ],
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 61),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          CustomIconButton(
                            Icons.chevron_left_rounded,
                            colorBackground: ColorNeutral.white,
                            size: IconSize.medium,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        ProfileIcon(
                          userData!.profileImage,
                          imageSize: 130,
                          borderColor: color,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CustomIconButton(
                            Icons.edit_outlined,
                            size: IconSize.small,
                            colorBackground: ColorNeutral.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    profileCard(Theme.of(context), userData!, average, color),
                    statsCardProfile(
                      Theme.of(context),
                      userData!.profileImage,
                      color: color,
                      stats: statsData!,
                    ),
                    CustomCardContent(
                      description:
                          "Kompetensi berdasarkan penugasan yang telah dilakukan",
                      crumbs: userData!.kompetensi
                          .map((it) => it.namaKompetensi)
                          .toList(),
                      header: [
                        Text(
                          "Kompetensi yang dikuasai",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    CustomBigButton(
                      wasIconOnRight: true,
                      onPressed: () => {
                        // Call password change flow
                      },
                      otherWidget: [],
                      icon: CustomIconButton(
                        "assets/icon/lock.svg",
                        colorBackground: Colors.white,
                      ),
                      buttonColor: ColorNeutral.black,
                      buttonLabel: "Ubah Password",
                    ),
                    CustomBigButton(
                      maxWidth: 240,
                      wasElevated: true,
                      padding: EdgeInsets.only(
                        left: 34,
                        top: 8,
                        bottom: 8,
                        right: 6,
                      ),
                      wasIconOnRight: true,
                      onPressed: () async {
                        await Storage.clearToken();
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/auth', (route) => false);
                      },
                      otherWidget: [],
                      icon: CustomIconButton(
                        "assets/icon/logout.svg",
                        colorBackground: Colors.white,
                        iconColorCustom: ColorPrimary.orange,
                      ),
                      buttonColor: ColorPrimary.orange,
                      customLabelColor: Colors.white,
                      buttonLabel: "Logout",
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

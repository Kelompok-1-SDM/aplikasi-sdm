import 'dart:io';

import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/home/home_model.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_service.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/profile/profile_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final TextEditingController _passwordBaruController = TextEditingController();
  final TextEditingController _passwordKonfirmasiController =
      TextEditingController();
  final UserService _userService = UserService();

  UserData? userData;
  Statistik? statsData;
  double average = 0;
  bool isLoading = true;
  bool isPasswordLoad = false;
  bool isUploadLoad = false;

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
    if (!isPasswordLoad || !isUploadLoad) {
      try {
        // Fetch user info
        final BaseResponse<UserData> response =
            await _userService.fetchMyinfo();
        if (response.success && response.data != null) {
          setState(() {
            userData = response.data;
          });
        } else {
          _showErrorDialog(context, "Fetch Failed (User Info)", response.message);
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
          _showErrorDialog(
              context, "Fetch Failed (Statistics)", responseStats.message);
        }
      } catch (e) {
        _showErrorDialog(context, "Error", "An error occurred: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _changePasswordCallback(String password) async {
    setState(() {
      isPasswordLoad = true;
    });
    _refreshKey.currentState?.show();
    try {
      final BaseResponse<UserData> response =
          await _userService.updatePassword(password);

      if (response.success) {
        _afterChange();
      } else {
        _showErrorDialog(context, "Update failed", response.message);
      }
    } catch (e) {
      _showErrorDialog(
          context, "Error", "An error occurred during forgot password: $e");
    } finally {
      _passwordBaruController.clear();
      _passwordKonfirmasiController.clear();
      setState(() {
        isPasswordLoad = false;
      });
    }
  }

  Future<void> _uploadPicture(File file) async {
    setState(() {
      isUploadLoad = true;
    });
    _refreshKey.currentState?.show();
    try {
      final BaseResponse<UserData> response =
          await _userService.updateProfile(file);

      if (response.success) {
        _afterChangeProfile();
      } else {
        _showErrorDialog(context, "Update failed", response.message);
      }
    } catch (e) {
      _showErrorDialog(
          context, "Error", "An error occurred during forgot password: $e");
    } finally {
      setState(() {
        isUploadLoad = false;
      });
    }
  }

  void pilihProfile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) {
      return; // No file selected
    }

    _uploadPicture(File(result.files.single.path!));
  }

  void _afterChangeProfile() {
    callBottomSheet(
      context,
      button: [
        CustomBigButton(
          onPressed: () => {
            Navigator.pop(context),
          },
          padding: EdgeInsets.all(
            24,
          ),
          buttonColor: ColorNeutral.black,
          buttonLabel: "Kembali ke profil",
          customLabelColor: ColorNeutral.white,
        ),
      ],
      title: Text(
        "Foto profil anda berhasil diperbarui",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 20,
            ),
      ),
    );
  }

  void _afterChange() {
    callBottomSheet(
      context,
      button: [
        CustomBigButton(
          onPressed: () => {
            Navigator.pop(context),
            Navigator.pop(context),
            Navigator.pop(context)
          },
          padding: EdgeInsets.all(
            24,
          ),
          buttonColor: ColorNeutral.black,
          buttonLabel: "Kembali ke profil",
          customLabelColor: ColorNeutral.white,
        ),
      ],
      title: Text(
        "Password anda berhasil diperbarui",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 20,
            ),
      ),
    );
  }

  void _doConfirmation() {
    final baru = _passwordBaruController.text.trim();
    final baruKonfirm = _passwordKonfirmasiController.text.trim();

    if (baru != baruKonfirm) {
      _showErrorDialog(context, "Validation Error",
          "Password and Password Confirmation must be the same.");
      return;
    }

    callBottomSheet(context,
        button: [
          CustomBigButton(
            onPressed: () => {Navigator.pop(context)},
            padding: EdgeInsets.all(
              24,
            ),
            buttonColor: ColorNeutral.black,
            buttonLabel: "Tidak",
            customLabelColor: ColorNeutral.white,
          ),
          CustomBigButton(
            onPressed: () => {_changePasswordCallback(baruKonfirm)},
            padding: EdgeInsets.all(
              24,
            ),
            buttonColor: ColorPrimary.orange,
            buttonLabel: "Ya",
            customLabelColor: ColorNeutral.white,
          )
        ],
        title: Text(
          "Apalah anda yakin mengubah password anda?",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 20,
              ),
        ),
        description: "Harap cek kembali password anda sebelum mengkonfirmasi");
  }

  void _changePassword() {
    callBottomSheet(
      context,
      button: [
        CustomBigButton(
          onPressed: () => {Navigator.pop(context)},
          padding: EdgeInsets.all(
            24,
          ),
          buttonColor: ColorNeutral.black,
          buttonLabel: "Batal",
          customLabelColor: ColorNeutral.white,
        ),
        CustomBigButton(
          onPressed: () => {_doConfirmation()},
          padding: EdgeInsets.all(
            24,
          ),
          buttonColor: ColorPrimary.orange,
          buttonLabel: "Ubah",
          customLabelColor: ColorNeutral.white,
        )
      ],
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          CustomTextField(
            controller: _passwordBaruController,
            label: "Password baru",
            hint: "Password baru",
            isPassword: true, // or true for password fields
            inputType: TextInputType.text, // For numeric input
          ),
          SizedBox(
            height: 16,
          ),
          CustomTextField(
            controller: _passwordKonfirmasiController,
            label: "Konfirmasi password baru",
            hint: "Konfirmasi password",
            isPassword: true, // or true for password fields
            inputType: TextInputType.text, // For numeric input
          ),
        ],
      ),
      title: Text(
        "Ubah Password",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 20,
            ),
      ),
    );
  }

  void _showErrorDialog(
      BuildContext dialogContext, String title, String message) {
    showDialog(
      context: dialogContext,
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
                            onPressed: () => pilihProfile(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    profileCard(Theme.of(context), userData!, average, color),
                    if (!isLoading && statsData != null)
                      statsCardProfile(
                        Theme.of(context),
                        userData!.profileImage,
                        color: color,
                        stats: statsData!,
                      ),
                    CustomBigButton(
                      wasIconOnRight: true,
                      onPressed: () => {_changePassword()},
                      otherWidget: [],
                      icon: CustomIconButton(
                        "assets/icon/lock.svg",
                        colorBackground: Colors.white,
                        size: IconSize.large,
                      ),
                      padding: EdgeInsets.only(
                          right: 6, top: 6, bottom: 6, left: 34),
                      buttonColor: ColorNeutral.black,
                      buttonLabel: "Ubah Password",
                    ),
                    CustomBigButton(
                      wasIconOnRight: true,
                      onPressed: () async {
                        await Storage.clearToken();
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/auth', (route) => false);
                      },
                      otherWidget: [],
                      icon: CustomIconButton(
                        "assets/icon/logout.svg",
                        colorBackground: ColorCard.working,
                        iconColorCustom: ColorNeutral.white,
                        size: IconSize.large,
                      ),
                      padding: EdgeInsets.only(
                          right: 6, top: 6, bottom: 6, left: 34),
                      buttonColor: ColorPrimary.orange,
                      maxWidth: 230,
                      customLabelColor: ColorNeutral.white,
                      buttonLabel: "Logout",
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

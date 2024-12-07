import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/kegiatan/detail_kegiatan_widgets.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_service.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:flutter/material.dart';

class DetailKegiatan extends StatefulWidget {
  const DetailKegiatan({super.key, required this.idKegiatan});

  final String idKegiatan;

  @override
  State<DetailKegiatan> createState() => _DetailKegiatanState();
}

class _DetailKegiatanState extends State<DetailKegiatan> {
  bool isLoading = true;
  String? myUid;
  KegiatanResponse? data;
  final KegiatanService _kegiatanService = KegiatanService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
      fetchData();
    });
  }

  Future<void> fetchData() async {
    // Trigger the swipe refresh animation programmatically
    _refreshIndicatorKey.currentState?.show();
    setState(() {
      isLoading = true; // Show loading indicator during initial fetch
    });

    try {
      // Fetch home data from the API
      final BaseResponse<KegiatanResponse> response =
          await _kegiatanService.fetchKegiatanById(widget.idKegiatan);
      UserData? apa = await Storage.getMyInfo();

      if (response.success && response.data != null) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            data = response.data;
            myUid = apa!.userId;
          });
        }
        print("Data fetched successfully");
      } else {
        if (mounted) {
          _showErrorDialog(context, "Fetch Failed",
              response.message); // Pass the current valid context
        }
      }
    } catch (e) {
      print("Error during data fetch: $e");
      if (mounted) {
        _showErrorDialog(context, "Error",
            "An error occurred while fetching data: $e"); // Pass the current valid context
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await fetchData(); // Refresh data using the existing fetchData method
  }

  void _showErrorDialog(
      BuildContext dialogContext, String title, String message) {
    showDialog(
      context: dialogContext, // Use the passed-in parent context
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
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

  bool _wasMePic(List<User> user) {
    for (var user in user) {
      if (user.userId == myUid) {
        return user.isPic ?? false;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool wasNow = false;
    if (!isLoading) {
      DateTime now = DateTime.now();
      wasNow = data!.tanggalMulai!.isAfter(now) &&
          data!.tanggalMulai!.isBefore(now) &&
          !data!.isDone!;
    }

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: ColorNeutral.black,
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 61, left: 22, right: 22),
          child: isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const SizedBox.shrink(), // Empty space during loading
                )
              : Column(
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
                    const SizedBox(height: 24),
                    if (!isLoading) kegiatanCard(context, kegiatan: data!, isFromDetail: true),
                    const SizedBox(height: 10),
                    if (!isLoading)
                      Column(
                        children: [
                          CustomCardContent(
                            header: [
                              Text(
                                "Brief penugasan",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 16),
                              )
                            ],
                            actionIcon: [],
                            colorBackground: Colors.white,
                            description: data!.deskripsi,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (!isLoading && !wasNow)
                      Column(
                        children: [
                          bigInfo(context,
                              kegiatan: data!,
                              wasMePic: _wasMePic(data!.users!)),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    if (!isLoading)
                      Column(
                        children: [
                          LiveChatButton(
                              withText: true, idKegiatan: data!.kegiatanId!),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    if (!isLoading && data!.agenda!.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (!isLoading)
                      Column(
                        children: [
                          dosenCard(Theme.of(context), data!.users!),
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (!isLoading && data!.lampiran!.isNotEmpty)
                      Column(
                        children: [
                          fileCard(Theme.of(context),
                              lampirans: data!.lampiran!),
                          const SizedBox(
                            height: 64,
                          ),
                        ],
                      )
                  ],
                ),
        ),
      ),
    );
  }
}

import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_service.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/home/homepage_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaftarKegiatanDitugaskan extends StatefulWidget {
  final UserData? userData;
  const DaftarKegiatanDitugaskan({super.key, this.userData});

  @override
  State<DaftarKegiatanDitugaskan> createState() =>
      _DaftarKegiatanDitugaskanState();
}

class _DaftarKegiatanDitugaskanState extends State<DaftarKegiatanDitugaskan> {
  ListKegiatan? kegiatanDat;
  bool isLoading = true;
  final KegiatanService _kegiatanService = KegiatanService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>(); // Key to trigger the RefreshIndicator

  @override
  void initState() {
    super.initState();
    // Trigger refresh when the page first loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show(); // Show the refresh indicator
      fetchData();
    });
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Show loading indicator during initial fetch
    });

    try {
      // Fetch home data from the API
      final BaseResponse<ListKegiatan> response =
          await _kegiatanService.fetchListKegiatanByUser(type: 'ditugaskan');

      if (response.success && response.data != null) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            kegiatanDat = response.data;
          });
        }
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
        // Check if the widget is still mounted
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      color: ColorNeutral.black,
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 61, left: 22, right: 22),
        child: Column(
          children: [
            HomeAppBar(
              userdat: widget.userData,
            ),
            const SizedBox(height: 24),
            if (isLoading)
              SizedBox.shrink()
            else
              Column(
                children: List.generate(
                  kegiatanDat!.kegiatan.length,
                  (index) => CustomCardContent(
                    header: [Text("Kamu sedang menghadiri")],
                    title: kegiatanDat!.kegiatan[index].judulKegiatan,
                    actionIcon: [
                      CustomIconButton(
                        "assets/icon/arrow-45.svg",
                        colorBackground: ColorNeutral.black,
                      )
                    ],
                    colorBackground: ColorRandom.getRandomColor(),
                    descIcon: [
                      CustomIconButton(
                        "assets/icon/calendar.svg",
                        colorBackground: Colors.transparent,
                        text: DateFormat.yMMMd()
                            .add_jm()
                            .format(kegiatanDat!.kegiatan[index].tanggal),
                      ),
                      CustomIconButton(
                        "assets/icon/location.svg",
                        colorBackground: Colors.transparent,
                        text: kegiatanDat!.kegiatan[index].lokasi,
                      ),
                    ],
                    crumbs: kegiatanDat!.kegiatan[index].kompetensi
                        .take(5)
                        .toList(),
                    onPressed: () =>
                        {Navigator.pushNamed(context, "/detail_tugas")},
                  ),
                ),
              ),
            if (isLoading)
              SizedBox.shrink()
            else
              const Text(
                "Itu saja yang kami temukan",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    fontSize: 20,
                    color: ColorNeutral.gray),
              ),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}

class DaftarTugasHistori extends StatefulWidget {
  final UserData userData;
  const DaftarTugasHistori({super.key, required this.userData});

  @override
  State<DaftarTugasHistori> createState() => _DaftarTugasHistoriState();
}

class _DaftarTugasHistoriState extends State<DaftarTugasHistori> {
  ListKegiatan? kegiatanDat;
  bool isLoading = true;
  final KegiatanService _kegiatanService = KegiatanService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>(); // Key to trigger the RefreshIndicator

  @override
  void initState() {
    super.initState();
    // Trigger refresh when the page first loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show(); // Show the refresh indicator
      fetchData();
    });
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Show loading indicator during initial fetch
    });

    try {
      // Fetch home data from the API
      final BaseResponse<ListKegiatan> response =
          await _kegiatanService.fetchListKegiatanByUser(type: 'selesai');

      if (response.success && response.data != null) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            kegiatanDat = response.data;
          });
        }
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
        // Check if the widget is still mounted
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      color: ColorNeutral.black,
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 61, left: 22, right: 22),
        child: Column(
          children: [
            HomeAppBar(
              userdat: widget.userData,
            ),
            const SizedBox(height: 24),
            if (isLoading)
              SizedBox.shrink()
            else
              Column(
                children: List.generate(
                  kegiatanDat!.kegiatan.length,
                  (index) => CustomCardContent(
                    header: [Text("Kamu sedang menghadiri")],
                    title: kegiatanDat!.kegiatan[index].judulKegiatan,
                    actionIcon: [
                      CustomIconButton(
                        "assets/icon/arrow-45.svg",
                        colorBackground: ColorNeutral.black,
                      )
                    ],
                    colorBackground: ColorRandom.getRandomColor(),
                    descIcon: [
                      CustomIconButton(
                        "assets/icon/calendar.svg",
                        colorBackground: Colors.transparent,
                        text: DateFormat.yMMMd()
                            .add_jm()
                            .format(kegiatanDat!.kegiatan[index].tanggal),
                      ),
                      CustomIconButton(
                        "assets/icon/location.svg",
                        colorBackground: Colors.transparent,
                        text: kegiatanDat!.kegiatan[index].lokasi,
                      ),
                    ],
                    crumbs: kegiatanDat!.kegiatan[index].kompetensi
                        .take(5)
                        .toList(),
                    onPressed: () =>
                        {Navigator.pushNamed(context, "/detail_tugas")},
                  ),
                ),
              ),
            if (isLoading)
              SizedBox.shrink()
            else
              const Text(
                "Itu saja yang kami temukan",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    fontSize: 20,
                    color: ColorNeutral.gray),
              ),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}

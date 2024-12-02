import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_service.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/home/homepage_widgets.dart';
import 'package:flutter/material.dart';

class DaftarKegiatan extends StatefulWidget {
  final UserData? userData;
  final bool isHistori;
  const DaftarKegiatan({super.key, this.userData, required this.isHistori});

  @override
  State<DaftarKegiatan> createState() => _DaftarKegiatanState();
}

class _DaftarKegiatanState extends State<DaftarKegiatan> {
  List<KegiatanResponse>? kegiatanDat;
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
      final BaseResponse<List<KegiatanResponse>> response =
          await _kegiatanService.fetchListKegiatanByUser(
              isDone: widget.isHistori);

      if (response.success && response.data != null) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            kegiatanDat = response.data;
          });
        }
      } else {
        if (mounted && response.message != 'Kegiatan not found') {
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
            // Handle loading state or empty data
            if (isLoading || kegiatanDat == null || kegiatanDat!.isEmpty)
              const SizedBox.shrink()
            else
              Column(
                children: List.generate(
                  kegiatanDat!.length,
                  (index) => kegiatanCard(
                    context: context,
                    kegiatan: kegiatanDat![index],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            // Always show the bottom text
            const Text(
              "Itu saja yang kami temukan",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                fontSize: 20,
                color: ColorNeutral.gray,
              ),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}

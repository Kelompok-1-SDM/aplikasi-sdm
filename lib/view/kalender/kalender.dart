import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_service.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/home/homepage_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/kalender/kalender_widget.dart';
import 'package:flutter/material.dart';

class Kalender extends StatefulWidget {
  final UserData? userData;
  const Kalender({super.key, this.userData});

  @override
  State<Kalender> createState() => _KalenderState();
}

class _KalenderState extends State<Kalender> {
  Map<DateTime, String> _events = {};

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
          await _kegiatanService.fetchListKegiatanByUser();

      if (response.success && response.data != null) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            kegiatanDat = response.data;

            for (var apa in kegiatanDat!.kegiatan) {
              DateTime pop = DateTime(
                  apa.tanggal.year, apa.tanggal.month, apa.tanggal.day);
              // If the date exists, add the new event to the existing list
              _events[pop] = apa.status;
            }
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
    final ThemeData theme = Theme.of(context);

    return RefreshIndicator(
      key: _refreshIndicatorKey, // Set the refresh indicator key
      color: ColorNeutral.black,
      onRefresh: _refreshData,
      child: ListView(
        padding: const EdgeInsets.only(top: 61),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                HomeAppBar(userdat: widget.userData),
                const SizedBox(height: 24),
                if (isLoading)
                  const SizedBox.shrink()
                else if (_events.isNotEmpty)
                  CustomTableCalendar(events: _events)
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (!isLoading)
            CustomBottomSheet(
              maxHeight: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  seminarCard(theme),
                  const SizedBox(height: 200),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_service.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/home/homepage_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/kalender/kalender_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Kalender extends StatefulWidget {
  final UserData? userData;
  const Kalender({super.key, this.userData});

  @override
  State<Kalender> createState() => _KalenderState();
}

class _KalenderState extends State<Kalender> {
  Map<DateTime, String> _events = {};
  ListKegiatan? kegiatanDat;
  bool isLoadingCalendar = true;
  bool isLoadingBottomSheet = true;
  final KegiatanService _kegiatanService = KegiatanService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show(); // Show the refresh indicator
      _fetchCalendarEvents();
      _fetchBottomSheetData(tanggal: DateTime.now().toIso8601String());
    });
  }

  // Fetch calendar events only
  Future<void> _fetchCalendarEvents() async {
    setState(() {
      isLoadingCalendar = true;
    });

    try {
      final BaseResponse<ListKegiatan> response =
          await _kegiatanService.fetchListKegiatanByUser();

      if (response.success && response.data != null) {
        setState(() {
          for (var apa in response.data!.kegiatan) {
            DateTime pop =
                DateTime(apa.tanggal.year, apa.tanggal.month, apa.tanggal.day);
            _events[pop] = apa.status;
          }
        });
      } else {
        _showErrorDialog(context, "Fetch Failed", response.message);
      }
    } catch (e) {
      print("Error during fetching calendar events: $e");
      _showErrorDialog(context, "Error", "An error occurred: $e");
    } finally {
      setState(() {
        isLoadingCalendar = false;
      });
    }
  }

  // Fetch data for the bottom sheet based on the selected date
  Future<void> _fetchBottomSheetData({String tanggal = ""}) async {
    if (tanggal.isEmpty) return;

    setState(() {
      isLoadingBottomSheet = true;
    });

    try {
      final BaseResponse<ListKegiatan> response =
          await _kegiatanService.fetchListKegiatanByUser(tanggal: tanggal);

      if (response.success && response.data != null) {
        setState(() {
          kegiatanDat = response.data;
        });
      }
    } catch (e) {
      print("Error during fetching bottom sheet data: $e");
      _showErrorDialog(context, "Error", "An error occurred: $e");
    } finally {
      setState(() {
        isLoadingBottomSheet = false;
      });
    }
  }

  void onDateSelected(DateTime selectedDay) {
    _fetchBottomSheetData(tanggal: selectedDay.toIso8601String());
  }

  Future<void> _refreshData() async {
    await _fetchCalendarEvents(); // Refresh calendar data
    await _fetchBottomSheetData(tanggal: DateTime.now().toIso8601String());
  }

  void _showErrorDialog(
      BuildContext dialogContext, String title, String message) {
    showDialog(
      context: dialogContext,
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
      key: _refreshIndicatorKey,
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
                if (isLoadingCalendar)
                  const CircularProgressIndicator()
                else if (_events.isNotEmpty)
                  CustomTableCalendar(
                    events: _events,
                    onDateSelected: onDateSelected,
                  )
                else
                  const Text("No events available"),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (!isLoadingCalendar)
            CustomBottomSheet(
              maxHeight: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  if (isLoadingBottomSheet)
                    const CircularProgressIndicator()
                  else if (kegiatanDat != null)
                    ...List.generate(
                      kegiatanDat!.kegiatan.length,
                      (index) => Column(
                        children: [
                          seminarCard(theme, kegiatanDat!.kegiatan[index]),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                  else
                    const Text("No data for the selected date"),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

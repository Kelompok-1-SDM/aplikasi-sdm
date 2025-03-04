import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:flutter/material.dart';

import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_service.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/view/home/homepage_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/kalender/kalender_widget.dart';

class Kalender extends StatefulWidget {
  const Kalender({super.key});

  @override
  State<Kalender> createState() => _KalenderState();
}

class _KalenderState extends State<Kalender> {
  final Map<DateTime, EventData> _events = {};
  List<KegiatanResponse>? kegiatanDat;
  UserData? userData;

  bool isLoading = true;
  List<KegiatanResponse>? filteredKegiatan;
  final KegiatanService _kegiatanService = KegiatanService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show(); // Show the refresh indicator
      fetchData();
    });
  }

  // Fetch calendar events only
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch home data from the API
      final BaseResponse<List<KegiatanResponse>> response =
          await _kegiatanService.fetchListKegiatanByUser();
      final UserData? user = await Storage.getMyInfo();

      if (response.success && response.data != null) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            userData = user;
            kegiatanDat = response.data!;
            for (var apa in response.data!) {
              DateTime pop = DateTime(apa.tanggalMulai!.year,
                  apa.tanggalMulai!.month, apa.tanggalMulai!.day);
              _events[pop] = EventData(
                isDone: apa.isDone!,
                tanggalMulai: apa.tanggalMulai!,
                tanggalAkhir: apa.tanggalAkhir!,
              );
            }
          });
        }
      } else {
        _showErrorDialog(context, "Fetch Failed", response.message);
      }
    } catch (e) {
      print("Error during fetching calendar events: $e");
      _showErrorDialog(context, "Error", "An error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onDateSelected(DateTime selectedDay) {
    DateTime normalizedSelectedDay = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
    );
    setState(() {
      filteredKegiatan = kegiatanDat?.where((kegiatan) {
        DateTime kegiatanDate = DateTime(
          kegiatan.tanggalMulai!.year,
          kegiatan.tanggalMulai!.month,
          kegiatan.tanggalMulai!.day,
        );
        return kegiatanDate == normalizedSelectedDay;
      }).toList();
    });
  }

  Future<void> _refreshData() async {
    await fetchData(); // Refresh calendar data
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
                if (userData == null)
                  SizedBox(
                    height: 60,
                  )
                else
                  HomeAppBar(userdat: userData),
                const SizedBox(height: 24),
                if (_events.isNotEmpty)
                  CustomTableCalendar(
                    events: _events,
                    onDateSelected: onDateSelected,
                  )
              ],
            ),
          ),
          const SizedBox(height: 24),
          // if (_events.isNotEmpty)
          CalendarBottomSheet(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    if (filteredKegiatan != null &&
                        filteredKegiatan!.isNotEmpty)
                      ...filteredKegiatan!.map((kegiatan) {
                        return Column(
                          children: [
                            seminarCard(context: context, kegiatan: kegiatan),
                            const SizedBox(height: 20),
                          ],
                        );
                      })
                    else
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 80),
                            child: const Text("No data for the selected date"),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

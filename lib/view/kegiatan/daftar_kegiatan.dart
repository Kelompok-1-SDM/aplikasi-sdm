import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:flutter/material.dart';

import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_service.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/home/homepage_widgets.dart';

class DaftarKegiatan extends StatefulWidget {
  final bool isHistori;
  const DaftarKegiatan({super.key, this.isHistori = false});

  @override
  State<DaftarKegiatan> createState() => _DaftarKegiatanState();
}

class _DaftarKegiatanState extends State<DaftarKegiatan> {
  Map<int, List<KegiatanResponse>> groupedKegiatan = {};
  UserData? userData;

  bool isLoading = true;
  final KegiatanService _kegiatanService = KegiatanService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>(); // Key to trigger the RefreshIndicator

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
      fetchData();
    });
  }

  Future<void> fetchData() async {
    UserData? user = await Storage.getMyInfo();

    setState(() {
      userData = user;
      isLoading = true;
    });

    try {
      final BaseResponse<List<KegiatanResponse>> response =
          await _kegiatanService.fetchListKegiatanByUser(
              isDone: widget.isHistori);

      if (response.success && response.data != null) {
        if (mounted) {
          // Group activities by year
          setState(() {
            groupedKegiatan = _groupByYear(response.data!);
          });
        }
      } else {
        if (mounted && response.message != 'Kegiatan not found') {
          _showErrorDialog(context, "Fetch Failed", response.message);
        }
      }
    } catch (e) {
      print("Error during data fetch: $e");
      if (mounted) {
        _showErrorDialog(
            context, "Error", "An error occurred while fetching data: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// Groups a list of KegiatanResponse by year (from tanggalMulai).
  Map<int, List<KegiatanResponse>> _groupByYear(
      List<KegiatanResponse> kegiatanList) {
    return kegiatanList.fold<Map<int, List<KegiatanResponse>>>({}, (map, item) {
      final year = item.tanggalMulai!.year; // Extract the year
      if (!map.containsKey(year)) {
        map[year] = [];
      }
      map[year]!.add(item);
      return map;
    });
  }

  Future<void> _refreshData() async {
    await fetchData();
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 61, left: 22, right: 22),
        child: Column(
          children: [
            if (isLoading && userData == null)
              SizedBox.shrink()
            else
              HomeAppBar(
                userdat: userData,
              ),
            const SizedBox(height: 24),
            // Handle loading state or empty data
            if (isLoading) const SizedBox.shrink(),
            if (!isLoading && groupedKegiatan.isNotEmpty)
              Column(
                children: groupedKegiatan.entries.map((entry) {
                  final year = entry.key;
                  final kegiatanList = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("$year",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 12)),
                            Divider(
                              color: ColorNeutral.gray,
                            )
                          ],
                        ),
                      ),
                      ...List.generate(
                        kegiatanList.length,
                        (index) => Column(
                          children: [
                            kegiatanCard(context,
                                kegiatan: kegiatanList[index],
                                isFromHistori: widget.isHistori),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),
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

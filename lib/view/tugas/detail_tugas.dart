import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/tugas/detail_tugas_widgets.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_service.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DetailTugas extends StatefulWidget {
  
  const DetailTugas({super.key});

  @override
  State<DetailTugas> createState() => _DetailTugasState();
}

class _DetailTugasState extends State<DetailTugas> {
  bool isLoading = true;
  ListKegiatan? kegiatanDat;
  bool histori = false;
  bool kehadiran = true;
  final KegiatanService _kegiatanService = KegiatanService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
      fetchData();
    });
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final BaseResponse<ListKegiatan> response = await _kegiatanService.fetchListKegiatanByUser(type: 'ditugaskan');

      if (response.success && response.data != null) {
        if (mounted) {
          setState(() {
            kegiatanDat = response.data;
          });
        }
      } else {
        _showErrorDialog(context, "Fetch Failed", response.message);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(context, "Error", "An error occurred while fetching data: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await fetchData();
  }

  void _showErrorDialog(BuildContext dialogContext, String title, String message) {
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
            const SizedBox(height: 24),
            if (isLoading)
              CircularProgressIndicator()
            else if (kegiatanDat != null && kegiatanDat!.kegiatan.isNotEmpty)
              CustomCardContent(
                header: [Text("Kamu sedang menghadiri")],
                title: kegiatanDat!.kegiatan[0].judulKegiatan,  // Menampilkan kegiatan pertama di database
                actionIcon: [
                  CustomIconButton(
                    "assets/icon/arrow-45.svg",
                    colorBackground: ColorNeutral.black,
                  ),
                ],
                colorBackground: ColorRandom.getRandomColor(),
                descIcon: [
                  CustomIconButton(
                    "assets/icon/calendar.svg",
                    colorBackground: Colors.transparent,
                    text: DateFormat.yMMMd().add_jm().format(kegiatanDat!.kegiatan[0].tanggal),
                  ),
                  CustomIconButton(
                    "assets/icon/location.svg",
                    colorBackground: Colors.transparent,
                    text: kegiatanDat!.kegiatan[0].lokasi,
                  ),
                ],
                crumbs: kegiatanDat!.kegiatan[0].kompetensi.take(5).toList(),
                onPressed: () => Navigator.pushNamed(context, "/detail_tugas"),
              ),
            const SizedBox(height: 10),
            CustomCardContent(
              header: [
                Text(
                  "Brief penugasan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
              actionIcon: [],
              colorBackground: Colors.white,
              description: kegiatanDat!.kegiatan[0].deskripsi,
            ),
            if (!histori) SizedBox(height: 10),
            if (!histori) LiveCard(),
            const SizedBox(height: 10),
            AgendaCard(),
            if (histori) SizedBox(height: 10),
            if (histori) DetailCard(),
            if (!kehadiran) const SizedBox(height: 10),
            if (!kehadiran) BuktiButton(),
            if (kehadiran) const SizedBox(height: 10),
            if (kehadiran) BuktiHadirButton(),
            const SizedBox(height: 10),
            DosenCard(),
            const SizedBox(height: 10),
            FileCard(),
          ],
        ),
      ),
    );
  }
}


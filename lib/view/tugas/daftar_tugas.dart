import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';

class DaftarTugas extends StatefulWidget {
  const DaftarTugas({super.key});

  @override
  State<DaftarTugas> createState() => _DaftarTugasState();
}

class _DaftarTugasState extends State<DaftarTugas> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ColorNeutral.black,
      onRefresh: () async {
        // Do something when refreshed
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 61),
        child: Column(
          children: [
            HomeAppBar(),
            CustomBigButton(
              buttonLabel: "Ke Detail tugas",
              buttonColor: ColorNeutral.black,
              onPressed: () => {Navigator.pushNamed(context, "/detail_tugas")},
              otherWidget: [],
            ),
            CustomCardContent(
              header: [Text("Kamu sedang menghadiri")],
              title: "Pemateri Seminar Teknologi Informasi",
              actionIcon: [
                CustomIconButton(
                  "assets/icon/arrow-45.svg",
                  colorBackground: ColorNeutral.black,
                )
              ],
              colorBackground: ColorPrimary.orange,
              descIcon: [
                CustomIconButton(
                  "assets/icon/calendar.svg",
                  colorBackground: Colors.transparent,
                  text: "12 Januari, 08:00-12:00",
                ),
                CustomIconButton(
                  "assets/icon/location.svg",
                  colorBackground: Colors.transparent,
                  text: "Auditorium Lt. 8, Teknik Sipil",
                ),
              ],
              crumbs: ["ujicoba"],
            ),
          ],
        ),
      ),
    );
  }
}

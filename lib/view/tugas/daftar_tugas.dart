import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/home/homepage_widgets.dart';
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
                  text: "Auditorium Lt.8, Teknik Sipil",
                ),
              ],
              crumbs: ['ujicoba'],
            ), 
            CustomCardContent(
              header: [Text("Kamu akan menghadiri acara ini")],
              title: "Pengawas ujian masuk maba",
              actionIcon: [
                CustomIconButton(
                  "assets/icon/arrow-45.svg",
                  colorBackground: ColorNeutral.black,
                )
              ],
              colorBackground: const Color(0xFFFFEB69),
              descIcon: [
                CustomIconButton(
                  "assets/icon/calendar.svg",
                  colorBackground: Colors.transparent,
                  text: "12 Januari 2025, 08:00-12:00",
                ),
                CustomIconButton(
                  "assets/icon/location.svg",
                  colorBackground: Colors.transparent,
                  text: "Online",
                ),
              ],
              crumbs: ['pengawas', 'ujian', 'online'],
            ),
            CustomCardContent(
              header: [Text("Kamu akan menghadiri acara ini")],
              title: "Bantu dekorasi ruang studio",
              actionIcon: [
                CustomIconButton(
                  "assets/icon/arrow-45.svg",
                  colorBackground: ColorNeutral.black,
                )
              ],
              colorBackground: ColorPrimary.green,
              descIcon: [
                CustomIconButton(
                  "assets/icon/calendar.svg",
                  colorBackground: Colors.transparent,
                  text: "12 Januari 2025, 08:00-12:00",
                ),
                CustomIconButton(
                  "assets/icon/location.svg",
                  colorBackground: Colors.transparent,
                  text: "Ruang studio, Lt.8, Gedung Teknik Sipil",
                ),
              ],
              crumbs: ['dekorasi'],
            ),
            const Text(
              "Belum ada penawaran baru",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                  color: ColorNeutral.gray),
            ),SizedBox(
              height: 200,
            ),
            CustomCardContent(
              header: [Text("Kamu telah menghadiri acara ini")],
              title: "Seminar di Auper",
              actionIcon: [
                CustomIconButton(
                  "assets/icon/category.svg",
                  colorBackground: ColorNeutral.black,
                )
              ],
              colorBackground: ColorPrimary.blue,
              descIcon: [
                CustomIconButton(
                  "assets/icon/calendar.svg",
                  colorBackground: Colors.transparent,
                  text: "12 Januari, 08:00-12:00",
                ),
                CustomIconButton(
                  "assets/icon/location.svg",
                  colorBackground: Colors.transparent,
                  text: "Aula Pertamina",
                ),
              ],
              crumbs: ['pengawas', 'ujian', 'online'],
            ),
            CustomCardContent(
              header: [Text("Kamu telah menghadiri acara ini")],
              title: "Juri lomba aplikasi",
              actionIcon: [
                CustomIconButton(
                  "assets/icon/category.svg",
                  colorBackground: ColorNeutral.black,
                )
              ],
              colorBackground: ColorPrimary.blue,
              descIcon: [
                CustomIconButton(
                  "assets/icon/calendar.svg",
                  colorBackground: Colors.transparent,
                  text: "12 Juli, Sampai selesai",
                ),
                CustomIconButton(
                  "assets/icon/location.svg",
                  colorBackground: Colors.transparent,
                  text: " Gedung Teknik Sipil",
                ),
              ],
              crumbs: ['juri'],
            ),
            const Text(
              "Hanya itu yang kami temukan",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                  color: ColorNeutral.gray),
            ),SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}

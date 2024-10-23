import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/tugas/detail_tugas_widgets.dart';
import 'package:flutter/material.dart';

class DetailTugas extends StatefulWidget {
  const DetailTugas({super.key});

  @override
  State<DetailTugas> createState() => _DetailTugasState();
}

class _DetailTugasState extends State<DetailTugas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: ColorNeutral.black,
        onRefresh: () async {
          // Do something when refreshed
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 61),
          child: Column(
            children: [
              CustomBigButton(
                buttonLabel: "Ke Livechat",
                buttonColor: ColorNeutral.black,
                onPressed: () => {Navigator.pushNamed(context, "/livechat")},
                otherWidget: [],
              ),

              const SizedBox(height: 20), // Spacer untuk memberikan jarak
              CustomCardContent(
                header: [Text("Kamu sedang menghadiri ")],
                title: "Pemateri Seminar Teknologi Informasi",
                actionIcon: [],
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
                crumbs: ["Detail Tugas"],
              ),

              const SizedBox(height: 10), // Spacer untuk memberikan jarak
              CustomCardContent(
                  header: [
                    Text(
                      "Brief penugasan",
                      style: TextStyle(
                          fontWeight: FontWeight.bold), // Menebalkan teks
                    )
                  ],
                  actionIcon: [],
                  colorBackground: ColorNeutral.white,
                  description:
                      "Yth. Bapak/Ibu dosen. Kami mengundang Anda untuk menghadiri penugasan ini sebagai kontribusi Anda selama bekerja di Polinema.\n\n"
                      "Kontribusi Anda akan dihitung dalam bentuk poin kredibilitas pada sistem kami, "
                      "yang nantinya juga akan dimanfaatkan untuk ke depannya sebagai sistem referensi."),

              const SizedBox(height: 10),
              LiveCard(),

              const SizedBox(height: 10),
              BuktiButton(),

              const SizedBox(height: 10),
              DosenCard(),

              const SizedBox(height: 10),
              FileCard(),
            ],
          ),
        ),
      ),
    );
  }
}

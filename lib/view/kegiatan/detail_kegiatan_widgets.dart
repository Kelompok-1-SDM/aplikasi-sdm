import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Seminar card widget
// CustomCardContent headerCard(BuildContext context,
//     {required KegiatanResponse kegiatan}) {
//   String title;
//   DateTime normalizedDay = DateTime(
//     kegiatan.tanggalMulai!.year,
//     kegiatan.tanggalMulai!.month,
//     kegiatan.tanggalMulai!.day,
//   );
//   DateTime now = DateTime.now();
//   DateTime nowNormalized = DateTime(now.year, now.month, now.day);

//   if (normalizedDay.isBefore(nowNormalized) && kegiatan.isDone!) {
//     title = "Kamu telah melaksanakan kegiatan";
//   } else if (normalizedDay.isAfter(nowNormalized)) {
//     title = "Kamu akan menghadiri kegiatan";
//   } else {
//     title = "Kamu sedang melaksanakan";
//   }
//   return CustomCardContent(
//     header: [Text(title)],
//     title: kegiatan.judul,
//     colorBackground: ColorRandom.getRandomColor(),
//     descIcon: [
//       CustomIconButton(
//         "assets/icon/calendar.svg",
//         colorBackground: Colors.transparent,
//         text: DateFormat.yMMMd().add_jm().format(kegiatan.tanggalMulai!),
//       ),
//       CustomIconButton(
//         "assets/icon/location.svg",
//         colorBackground: Colors.transparent,
//         text: kegiatan.lokasi,
//       ),
//     ]
//   );
// }

CustomCardContent bigInfo(BuildContext context,
    {required KegiatanResponse kegiatan, required bool wasMePic}) {
  String title;
  DateTime normalizedDay = DateTime(
    kegiatan.tanggalMulai!.year,
    kegiatan.tanggalMulai!.month,
    kegiatan.tanggalMulai!.day,
  );
  DateTime now = DateTime.now();
  DateTime nowNormalized = DateTime(now.year, now.month, now.day);

  if (normalizedDay.isBefore(nowNormalized) && kegiatan.isDone!) {
    title = "Kamu telah melaksanakan kegiatan";
  } else {
    title = "Kamu akan menghadiri kegiatan";
  }

  Color color = !kegiatan.isDone! && normalizedDay.isBefore(now)
      ? ColorPrimary.green
      : ColorPrimary.blue;
  double maxWidth = MediaQuery.of(context).size.width - 120;
  return CustomCardContent(
    colorBackground: color,
    header: [
      Text(
        title,
        style:
            Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16),
      )
    ],
    otherWidget: [
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Row(
          children: [
            CustomIconButton(
              "assets/icon/calendar.svg",
              colorBackground: Colors.transparent,
              iconColorCustom: ColorNeutral.black,
              size: IconSize.large,
            ),
            Text(
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              DateFormat.yMMMd().add_jm().format(kegiatan.tanggalMulai!),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 32),
            )
          ],
        ),
      ),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Row(
          children: [
            CustomIconButton(
              "assets/icon/time.svg",
              colorBackground: Colors.transparent,
              iconColorCustom: ColorNeutral.black,
              size: IconSize.large,
            ),
            Text(
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              DateFormat.yMMMd().add_jm().format(kegiatan.tanggalAkhir!),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 32),
            )
          ],
        ),
      ),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Row(
          children: [
            CustomIconButton(
              "assets/icon/location.svg",
              colorBackground: Colors.transparent,
              iconColorCustom: ColorNeutral.black,
              size: IconSize.large,
            ),
            Text(
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              kegiatan.lokasi!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 32),
            )
          ],
        ),
      ),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Row(
          children: [
            CustomIconButton(
              "assets/icon/user.svg",
              colorBackground: Colors.transparent,
              iconColorCustom: ColorNeutral.black,
              size: IconSize.large,
            ),
            Text(
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              wasMePic ? "PIC" : "Anggota",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 32),
            )
          ],
        ),
      ),
    ],
  );
}

Container _crumbWidget(String title, ThemeData theme) {
    Color textColor = ColorNeutral.black;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: ShapeDecoration(
        color: ColorNeutral.white,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 13,
          ),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: theme.textTheme.displayMedium!.copyWith(
              fontSize: 16,
              color: textColor,
            ),
      ),
    );
  }

CustomBigButton _anggotaCard(ThemeData theme, User user) {
  return CustomBigButton(
    wasIconOnRight: true,
    otherWidget: [
      SizedBox(
        width: 50,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned(
              child: ClipOval(
                child: ProfileIcon(
                  user.profileImage ?? "assets/icon/profile-1",
                  imageSize: 60,
                  borderColor: ColorNeutral.white,
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 16), // Jarak antara profil dan teks
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.nama!,
              style: TextStyle(
                color: ColorNeutral.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
      if (user.isPic!)
        CustomIconButton(
          "assets/icon/pic.svg",
          size: IconSize.large,
          colorBackground: ColorNeutral.gray,
        ),
    ],
    onPressed: () => {},
  );
}

CustomCardContent dosenCard(ThemeData theme, List<User> users) {
  return CustomCardContent(
    colorBackground: ColorNeutral.white,
    header: [
      Text(
        "Dosen yang menghadiri acara ini",
        style: theme.textTheme.bodyMedium!.copyWith(
          fontSize: 15,
          height: 1,
        ),
      ),
    ],
    otherWidget: List.generate(3, (index) => Column(children: [
      _anggotaCard(theme, users[index]),
      SizedBox(height: 10,)
    ],))
  );
}

Future<void> _openBrowserWithDownloadLink(String fileUrl) async {
  final Uri url = Uri.parse(fileUrl);
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // Opens in the external browser
    );
  } else {
    throw 'Could not launch $fileUrl';
  }
}

CustomBigButton fileButton(Lampiran lampiran) {
  String nama = lampiran.nama!.toLowerCase();
  Color color = nama.contains('sertifikat') || nama.contains('tugas')
      ? ColorPrimary.orange
      : ColorNeutral.black;
  return CustomBigButton(
    wasIconOnRight: true,
    buttonColor: color,
    otherWidget: [
      Text(
        lampiran.nama!,
        style: TextStyle(
          color: ColorNeutral.white,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
    ],
    padding: EdgeInsets.symmetric(horizontal: 10),
    onPressed: () => _openBrowserWithDownloadLink(lampiran.url!),
    icon: CustomIconButton(
      "assets/icon/paper.svg",
      size: IconSize.large,
      colorBackground: ColorNeutral.gray,
    ),
  );
}

CustomCardContent fileCard(ThemeData theme,
    {required List<Lampiran> lampirans}) {
  return CustomCardContent(
    colorBackground: ColorNeutral.white,
    header: [
      Text(
        "Arsip file penugasan",
        style: theme.textTheme.bodyMedium!.copyWith(
          fontSize: 15,
          height: 1,
        ),
      ),
    ],
    otherWidget: List.generate(
      lampirans.length,
      (index) => Column(
        children: [
          fileButton(lampirans[index]),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    ),
  );
}

class AgendaCard extends StatelessWidget {
  const AgendaCard({super.key});

  CustomCardContent agendaCard(ThemeData theme) {
    return CustomCardContent(
      colorBackground: Colors.white, // Warna background luar putih
      header: [
        Text(
          "Agenda kegiatan anda",
          style: theme.textTheme.bodyMedium!.copyWith(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
      otherWidget: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFF222222),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mencari materi",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "12 Oktober 2024",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons
                    .circle, // Contoh ikon lingkaran, sesuaikan sesuai kebutuhan
                color: Colors.grey[800],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            "2 agenda lainnya",
            style: TextStyle(
              color: ColorNeutral.gray,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "*waktu hanya perkiraan",
          style: TextStyle(
            color: ColorNeutral.gray,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return agendaCard(theme);
  }
}

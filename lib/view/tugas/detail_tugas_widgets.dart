import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_service.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/tugas/detail_tugas.dart';
import 'package:flutter/material.dart';

ListKegiatan? kegiatanDat;

class BuktiButton extends StatelessWidget {
  const BuktiButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBigButton(
      wasIconOnRight: true,
      otherWidget: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bukti Kehadiran",
              style: TextStyle(
                color: ColorNeutral.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 4), // Memberikan jarak antara kedua teks
            Text(
              "Silahkan upload bukti",
              style: TextStyle(
                color: ColorNeutral.white,
                fontWeight: FontWeight.w400,
                fontSize: 14, // Ukuran font yang lebih kecil
              ),
            ),
          ],
        ),
      ],
      onPressed: () => {},
      icon: CustomIconButton(
        "assets/icon/upload.svg",
        size: IconSize.large,
        colorBackground: ColorNeutral.gray,
      ),
    );
  }
}

class BuktiHadirButton extends StatelessWidget {
  const BuktiHadirButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBigButton(
      wasIconOnRight: true,
      otherWidget: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bukti Kehadiran",
              style: TextStyle(
                color: ColorNeutral.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 4), // Memberikan jarak antara kedua teks
            Text(
              "Sudah berhasil diverifikasi", // Updated text based on the image provided
              style: TextStyle(
                color: ColorNeutral.white,
                fontWeight: FontWeight.w400,
                fontSize: 14, // Ukuran font yang lebih kecil
              ),
            ),
          ],
        ),
      ],
      onPressed: () => {},
      icon: CustomIconButton(
        "assets/icon/centang.svg",
        size: IconSize.large,
        colorBackground:
            Color(0xFF1AC094), // Bright green for the circle background
        iconColorCustom: ColorNeutral.white, // White checkmark
      ),
      buttonColor: Color(0xFF13AE85), // Dark green for the button background
    );
  }
}

class DetailCard extends StatelessWidget {
  const DetailCard({super.key});

  CustomCardContent seminarCard(ThemeData theme, {double fontSize = 15.0}) {
    return CustomCardContent(
      colorBackground: Color(0xFF7BAFFF),
      header: [Text("Kamu sedang menghadiri")],
                title: kegiatanDat!.kegiatan[0].judulKegiatan, 
      otherWidget: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: ColorNeutral.black),
                const SizedBox(width: 10),
                Text(
                  "12 Januari 2024",
                  style:
                      theme.textTheme.bodyMedium!.copyWith(fontSize: fontSize),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time, color: ColorNeutral.black),
                const SizedBox(width: 10),
                Text(
                  "08:00–12:00",
                  style:
                      theme.textTheme.bodyMedium!.copyWith(fontSize: fontSize),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: ColorNeutral.black),
                const SizedBox(width: 10),
                Text(
                  "Aula Pertamina",
                  style:
                      theme.textTheme.bodyMedium!.copyWith(fontSize: fontSize),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.group, color: ColorNeutral.black),
                const SizedBox(width: 10),
                Text(
                  "Anggota",
                  style:
                      theme.textTheme.bodyMedium!.copyWith(fontSize: fontSize),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return seminarCard(theme, fontSize: 30.0);
  }
}

class LiveCard extends StatelessWidget {
  const LiveCard({super.key});

  CustomCardContent seminarCard(ThemeData theme) {
    return CustomCardContent(
      colorBackground: ColorPrimary.orange,
      header: [
        Text(
          "Acara sedang berlangsung",
          style: theme.textTheme.bodyMedium!.copyWith(
            fontSize: 15,
            height: 1,
          ),
        ),
      ],
      otherWidget: [
        Text(
          "Pemateri Seminar Teknologi Informasi",
          style: theme.textTheme.bodyMedium!.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Icon(Icons.location_on, color: ColorNeutral.black),
            const SizedBox(width: 4),
            Text(
              "Auditorium Lt. 8, Teknik Sipil",
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        ImageLoader(
          author: "Andika",
          imageUrl: "assets/icon/event.jpg",
          caption: 'Masih sepi nihh',
          authorUrl: 'assets/icon/profile-1.png',
        ),
        LiveChatDetailButton(
          withText: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return seminarCard(theme);
  }
}

class LiveChatDetailButton extends StatelessWidget {
  final bool withText;
  const LiveChatDetailButton({super.key, required this.withText});

  @override
  Widget build(BuildContext context) {
    return CustomBigButton(
      wasIconOnRight: true,
      otherWidget: [
        SizedBox(
          width: 140,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                child: ProfileIcon(
                  "assets/icon/profile-1.png",
                  imageSize: 60,
                ),
              ),
              Positioned(
                left: 34,
                child: ProfileIcon(
                  "assets/icon/profile-2.png",
                  imageSize: 60,
                ),
              ),
              Positioned(
                left: 68,
                child: ProfileIcon(
                  "assets/icon/profile-3.png",
                  imageSize: 60,
                ),
              ),
            ],
          ),
        ),
        if (withText)
          Text(
            "Live chat",
            style: TextStyle(
                color: ColorNeutral.white,
                fontWeight: FontWeight.w700,
                fontSize: 20),
          )
      ],
      onPressed: () => {Navigator.pushNamed(context, "/livechat")},
      icon: CustomIconButton(
        "assets/icon/chat.svg",
        size: IconSize.large,
        colorBackground: ColorNeutral.gray,
      ),
    );
  }
}

class AnggotaCard extends StatelessWidget {
  final bool withText;
  final bool withIcon;
  const AnggotaCard({super.key, required this.withText, this.withIcon = true});

  @override
  Widget build(BuildContext context) {
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
                    "assets/icon/profile-1.png",
                    imageSize: 60,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16), // Jarak antara profil dan teks
        if (withText)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Aditya Soemarno",
                  style: TextStyle(
                    color: ColorNeutral.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Pemateri",
                  style: TextStyle(
                    color: ColorNeutral.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        if (withIcon)
          CustomIconButton(
            "assets/icon/pic.svg",
            size: IconSize.large,
            colorBackground: ColorNeutral.gray,
          ),
      ],
      onPressed: () => {},
    );
  }
}

class AnggotaCard2 extends StatelessWidget {
  final bool withText;
  final bool withIcon;
  const AnggotaCard2({super.key, required this.withText, this.withIcon = true});

  @override
  Widget build(BuildContext context) {
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
                    "assets/icon/profile-2.png",
                    imageSize: 60,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16), // Jarak antara profil dan teks
        if (withText)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Andika Handayono",
                  style: TextStyle(
                    color: ColorNeutral.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Teknologi",
                  style: TextStyle(
                    color: ColorNeutral.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
      ],
      onPressed: () => {},
    );
  }
}

class AnggotaCard3 extends StatelessWidget {
  final bool withText;
  final bool withIcon;
  const AnggotaCard3({super.key, required this.withText, this.withIcon = true});

  @override
  Widget build(BuildContext context) {
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
                    "assets/icon/profile-3.png",
                    imageSize: 60,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16), // Jarak antara profil dan teks
        if (withText)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tiara Siagan",
                  style: TextStyle(
                    color: ColorNeutral.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Penalaran",
                  style: TextStyle(
                    color: ColorNeutral.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
      ],
      onPressed: () => {},
    );
  }
}

class DosenCard extends StatelessWidget {
  const DosenCard({super.key});

  CustomCardContent dosenCard(ThemeData theme) {
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
      otherWidget: [
        AnggotaCard(withText: true, withIcon: true),
        AnggotaCard2(withText: true, withIcon: true),
        AnggotaCard3(withText: true, withIcon: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return dosenCard(theme);
  }
}

class SuratButton extends StatelessWidget {
  const SuratButton({super.key, required bool withText});

  @override
  Widget build(BuildContext context) {
    return CustomBigButton(
      wasIconOnRight: true,
      otherWidget: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Surat No.1546",
              style: TextStyle(
                color: ColorNeutral.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 4), // Memberikan jarak antara kedua teks
            Text(
              "Silahkan cek surat",
              style: TextStyle(
                color: ColorNeutral.white,
                fontWeight: FontWeight.w400,
                fontSize: 14, // Ukuran font yang lebih kecil
              ),
            ),
          ],
        ),
      ],
      onPressed: () => {},
      icon: CustomIconButton(
        "assets/icon/paper.svg",
        size: IconSize.large,
        colorBackground: ColorNeutral.gray,
      ),
    );
  }
}

class SertifButton extends StatelessWidget {
  const SertifButton({super.key, required bool withText});

  @override
  Widget build(BuildContext context) {
    return CustomBigButton(
      wasIconOnRight: true,
      otherWidget: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sertifikat Semnas",
              style: TextStyle(
                color: ColorNeutral.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 4), // Memberikan jarak antara kedua teks
            Text(
              "Silahkan cek sertifikat",
              style: TextStyle(
                color: ColorNeutral.white,
                fontWeight: FontWeight.w400,
                fontSize: 14, // Ukuran font yang lebih kecil
              ),
            ),
          ],
        ),
      ],
      onPressed: () => {},
      icon: CustomIconButton(
        "assets/icon/paper.svg",
        size: IconSize.large,
        colorBackground: Color(0xFFFF7247),
        iconColorCustom: ColorNeutral.white,
      ),
      buttonColor: ColorPrimary.orange,
    );
  }
}

class FileCard extends StatelessWidget {
  const FileCard({super.key});

  CustomCardContent fileCard(ThemeData theme) {
    return CustomCardContent(
      colorBackground: ColorNeutral.white,
      header: [
        Text(
          "Dokumen",
          style: theme.textTheme.bodyMedium!.copyWith(
            fontSize: 15,
            height: 1,
          ),
        ),
      ],
      otherWidget: [
        SuratButton(withText: true),
        SertifButton(withText: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return fileCard(theme);
  }
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
            color:
                Color(0xFF222222), 
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


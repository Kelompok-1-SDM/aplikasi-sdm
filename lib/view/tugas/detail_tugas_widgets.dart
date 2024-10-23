import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';

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
      onPressed: () => {},
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
  const AnggotaCard({super.key, required this.withText});

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
                child: ProfileIcon(
                  "assets/icon/profile-1.png",
                  imageSize: 60,
                ),
              ),
            ],
          ),
        ),
        if (withText)
          Column(
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
                "pemateri",
                style: TextStyle(
                  color: ColorNeutral.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
      ],
      onPressed: () => {},
      icon: CustomIconButton(
        "assets/icon/chat.svg",
        size: IconSize.large,
        colorBackground: ColorNeutral.gray,
      ),
    );
  }
}

class AnggotaCard2 extends StatelessWidget {
  final bool withText;
  const AnggotaCard2({super.key, required this.withText});

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
                child: ProfileIcon(
                  "assets/icon/profile-2.png",
                  imageSize: 60,
                ),
              ),
            ],
          ),
        ),
        if (withText)
          Column(
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
                "pemateri",
                style: TextStyle(
                  color: ColorNeutral.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
      ],
      onPressed: () => {},
      icon: CustomIconButton(
        "assets/icon/chat.svg",
        size: IconSize.large,
        colorBackground: ColorNeutral.gray,
      ),
    );
  }
}

class AnggotaCard3 extends StatelessWidget {
  final bool withText;
  const AnggotaCard3({super.key, required this.withText});

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
                child: ProfileIcon(
                  "assets/icon/profile-3.png",
                  imageSize: 60,
                ),
              ),
            ],
          ),
        ),
        if (withText)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tiara Siagananwadari",
                style: TextStyle(
                  color: ColorNeutral.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "pemateri",
                style: TextStyle(
                  color: ColorNeutral.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
      ],
      onPressed: () => {},
      icon: CustomIconButton(
        "assets/icon/chat.svg",
        size: IconSize.large,
        colorBackground: ColorNeutral.gray,
      ),
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
        AnggotaCard(withText: true),
        AnggotaCard2(withText: true),
        AnggotaCard3(withText: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
        "assets/icon/upload.svg",
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
        "assets/icon/upload.svg",
        size: IconSize.large,
        colorBackground: ColorNeutral.gray,
      ),
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
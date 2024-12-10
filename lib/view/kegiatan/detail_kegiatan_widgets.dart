import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
  double maxWidth = MediaQuery.of(context).size.width - 160;
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
      Row(
        children: [
          CustomIconButton(
            "assets/icon/calendar-bold.svg",
            colorBackground: Colors.transparent,
            iconColorCustom: ColorNeutral.black,
            size: IconSize.large,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Text(
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              DateFormat.yMMMd().add_jm().format(kegiatan.tanggalMulai!),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 32),
            ),
          )
        ],
      ),
      Row(
        children: [
          CustomIconButton(
            "assets/icon/time.svg",
            colorBackground: Colors.transparent,
            iconColorCustom: ColorNeutral.black,
            size: IconSize.large,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Text(
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              DateFormat.yMMMd().add_jm().format(kegiatan.tanggalAkhir!),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 32),
            ),
          )
        ],
      ),
      Row(
        children: [
          CustomIconButton(
            "assets/icon/location-bold.svg",
            colorBackground: Colors.transparent,
            iconColorCustom: ColorNeutral.black,
            size: IconSize.large,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Text(
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              kegiatan.lokasi!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 32),
            ),
          )
        ],
      ),
      Row(
        children: [
          CustomIconButton(
            "assets/icon/user.svg",
            colorBackground: Colors.transparent,
            iconColorCustom: ColorNeutral.black,
            size: IconSize.large,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Text(
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              wasMePic ? "PIC" : "Anggota",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 32),
            ),
          )
        ],
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
        fontSize: 12,
        color: textColor,
      ),
    ),
  );
}

CustomBigButton _anggotaCard(BuildContext context, User user) {
  double maxWidth =
      MediaQuery.of(context).size.width - (!user.isPic! ? 180 : 260);
  return CustomBigButton(
    wasIconOnRight: true,
    otherWidget: [
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ProfileIcon(
            user.profileImage ?? "assets/icon/profile-1",
            borderColor: ColorNeutral.white,
            imageSize: 64,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.nama!,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 16, color: ColorNeutral.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  _crumbWidget(user.namaJabatan ?? "", Theme.of(context))
                ],
              ),
            ),
          )
        ],
      ),
    ],
    icon: user.isPic!
        ? CustomIconButton(
            "assets/icon/pic.svg",
            size: IconSize.large,
            colorBackground: ColorNeutral.gray,
          )
        : null,
    onPressed: () {},
  );
}

CustomCardContent dosenCard(BuildContext context, List<User> users) {
  return CustomCardContent(
    colorBackground: ColorNeutral.white,
    header: [
      Text(
        "Dosen yang menghadiri acara ini",
        style:
            Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16),
      )
    ],
    otherWidget: [
      ...List.generate(
        3,
        (index) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _anggotaCard(context, users[index]),
            SizedBox(
              height: 8,
            ),
            if (index == 2 && users.length > 3)
              TextButton(
                child: Text(
                  '${users.length - 3} dosen lainnya',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                ),
                onPressed: () => _showListOfDosen(context, users),
              ),
          ],
        ),
      ),
    ],
  );
}

void _showListOfDosen(BuildContext context, List<User> users) {
  callBottomSheet(
    context,
    button: [],
    title: Text(
      "Daftar dosen yang ditugaskan",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 20,
          ),
    ),
    child: Column(
      children: [
        ...List.generate(
          users.length,
          (index) => _anggotaCard(context, users[index]),
        )
      ],
    ),
  );
}

Future<void> _openBrowserWithDownloadLink(String fileUrl) async {
  final Uri url = Uri.parse(fileUrl);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

CustomBigButton fileButton(BuildContext context, Lampiran lampiran) {
  String nama = lampiran.nama!.toLowerCase();
  Color color = nama.contains('sertifikat') || nama.contains('tugas')
      ? ColorPrimary.orange
      : ColorNeutral.black;

  double maxWidth = MediaQuery.of(context).size.width - 240;
  return CustomBigButton(
    wasIconOnRight: true,
    padding: EdgeInsets.only(top: 8, right: 8, bottom: 8, left: 32),
    buttonColor: color,
    otherWidget: [
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Text(
          lampiran.nama!,
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(fontSize: 20, color: ColorNeutral.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      )
    ],
    icon: CustomIconButton(
      "assets/icon/paper.svg",
      size: IconSize.large,
      colorBackground:
          color == ColorPrimary.orange ? ColorCard.working : ColorNeutral.gray,
    ),
    onPressed: () => _openBrowserWithDownloadLink(lampiran.url!),
  );
}

CustomCardContent fileCard(BuildContext context,
    {required List<Lampiran> lampirans}) {
  return CustomCardContent(
    colorBackground: ColorNeutral.white,
    header: [
      Text(
        "Arsip file penugasan",
        style:
            Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16),
      )
    ],
    otherWidget: List.generate(
      lampirans.length,
      (index) => Column(
        children: [
          fileButton(context, lampirans[index]),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    ),
  );
}

Future<DateTime> selectDateTime(BuildContext context) async {
  // Show the Date Picker
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (pickedDate != null) {
    // Show the Time Picker if a date is selected
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      return DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
  }

  return DateTime.now();
}

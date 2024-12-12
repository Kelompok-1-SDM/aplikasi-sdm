import 'dart:io';

import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:file_picker/file_picker.dart';
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

Container _crumbWidget(String title, ThemeData theme,
    {Color color = ColorNeutral.white}) {
  Color textColor =
      color == ColorNeutral.black ? ColorNeutral.white : ColorNeutral.black;

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
    decoration: ShapeDecoration(
      color: color,
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
  double maxWidth = MediaQuery.of(context).size.width -
      (user.isPic == null || !user.isPic! ? 160 : 245);

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
                  if (user.namaJabatan != null)
                    _crumbWidget(user.namaJabatan!, Theme.of(context))
                ],
              ),
            ),
          )
        ],
      ),
    ],
    icon: user.isPic != null && user.isPic!
        ? CustomIconButton(
            "assets/icon/pic.svg",
            size: IconSize.large,
            colorBackground: ColorNeutral.gray,
          )
        : null,
    onPressed: () {
      callBottomSheet(
        context,
        title: Text(
          "Detail dosen yang ditugaskan",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 20,
              ),
        ),
        child: Column(
          children: [
            ProfileIcon(
              user.profileImage ?? "assets/icon/profile-1.png",
              imageSize: 80,
              borderColor: ColorNeutral.black,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              user.nama!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: 20,
                  ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              user.nip!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                  ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              user.email!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                  ),
            ),
            SizedBox(
              height: 8,
            ),
            _crumbWidget("${user.namaJabatan!} - ${user.isPic! ? 'PIC' : ''}",
                Theme.of(context),
                color: ColorNeutral.black),
          ],
        ),
        button: [
          CustomBigButton(
            buttonLabel: "Kembali",
            padding: EdgeInsets.all(24),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
    },
  );
}

CustomCardContent dosenCard(BuildContext context, List<User> users) {
  return CustomCardContent(
    colorBackground: ColorNeutral.white,
    header: [
      Text(
        "Dosen yang ditugaskan",
        style:
            Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16),
      )
    ],
    otherWidget: [
      ...List.generate(
        users.length > 2 ? 3 : users.length,
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
        "Lampiran kegiatan",
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

CustomCardContent agendaContainer(
    BuildContext context,
    List<Agenda> agenda,
    bool akuPic,
    Function(String) fetchAgendaCallback,
    Function(String, Agenda?) showCreateAgendaCallback,
    String uidKegiatan) {
  return CustomCardContent(
    colorBackground: ColorNeutral.white,
    header: [
      Text(
        "Agenda kegiatan ini",
        style:
            Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16),
      )
    ],
    otherWidget: [
      ...List.generate(
        agenda.length > 1 ? 2 : 1,
        (index) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            agendasCard(context, agenda[index], fetchAgendaCallback, false),
            SizedBox(
              height: 8,
            ),
            if (index == 1 && agenda.length > 2)
              TextButton(
                child: Text(
                  '${agenda.length - 1} agenda lainnya',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                ),
                onPressed: () =>
                    _showListOfAgenda(context, agenda, fetchAgendaCallback),
              ),
          ],
        ),
      ),
      if (akuPic)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomIconButton(
              Icons.add,
              onPressed: () => showCreateAgendaCallback(uidKegiatan, null),
              colorBackground: ColorNeutral.black,
              iconColorCustom: ColorNeutral.white,
            ),
          ],
        )
    ],
  );
}

CustomBigButton agendasCard(BuildContext context, Agenda agenda,
    Function(String) showAgendaCallback, bool isFromList) {
  double maxWidth = MediaQuery.of(context).size.width - 220;
  return CustomBigButton(
    wasIconOnRight: true,
    padding: EdgeInsets.all(24),
    otherWidget: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                width: 6,
                height: 54,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Color(0xFF13AE85),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agenda.namaAgenda!,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 24, color: ColorNeutral.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        agenda.deskripsiAgenda!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 15, color: ColorNeutral.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        DateFormat.yMMMd()
                            .add_jm()
                            .format(agenda.jadwalAgenda!),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 12, color: ColorNeutral.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      // _crumbWidget(user.namaJabatan ?? "", Theme.of(context))
                    ],
                  ),
                ),
              ),
            ],
          ),
          CustomIconButton(
            "assets/icon/centang.svg",
            colorBackground:
                agenda.isDone! ? ColorPrimary.green : ColorNeutral.gray,
            iconColorCustom:
                agenda.isDone! ? ColorNeutral.white : ColorNeutral.black,
            size: IconSize.small,
          )
        ],
      ),
    ],
    onPressed: () => {
      if (isFromList) Navigator.pop(context),
      showAgendaCallback(agenda.agendaId!)
    },
  );
}

CustomBigButton progressCard(
    BuildContext context, Progress progress, VoidCallback callback) {
  double maxWidth = MediaQuery.of(context).size.width - 170;
  return CustomBigButton(
    wasIconOnRight: true,
    padding: EdgeInsets.all(24),
    otherWidget: [
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 6,
            height: 41,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Color(0xFF13AE85),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth - 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          progress.deskripsiProgress!,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 24, color: ColorNeutral.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          DateFormat.yMMMd()
                              .add_jm()
                              .format(progress.createdAt!),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 12, color: ColorNeutral.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        // _crumbWidget(user.namaJabatan ?? "", Theme.of(context))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ],
    // onPressed: () => _showAgendaCallback(agenda.agendaId!),
    onPressed: callback,
  );
}

void _showListOfAgenda(BuildContext context, List<Agenda> agenda,
    Function(String) fetchAgendaCallback) {
  callBottomSheet(
    context,
    button: [],
    title: Text(
      "Daftar agenda pada kegiatan ini",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 20,
          ),
    ),
    child: Column(
      children: [
        ...List.generate(
          agenda.length,
          (index) =>
              agendasCard(context, agenda[index], fetchAgendaCallback, true),
        )
      ],
    ),
  );
}

void showDetailAgenda(
    BuildContext context,
    Agenda agenda,
    bool akuPic,
    Function(String, Agenda?) showEditCallback,
    Function(String) deleteCallback,
    Function(String, Progress?) callbackPanggilProgress) {
  // print('asdhaksdhasd');
  callBottomSheet(
    context,
    button: [
      CustomBigButton(
        onPressed: () => {
          Navigator.pop(context),
          callbackPanggilProgress(agenda.agendaId!, null)
        },
        buttonLabel: "Tambah Progress",
        buttonColor: ColorPrimary.orange,
        customLabelColor: ColorNeutral.white,
        padding: EdgeInsets.all(24),
      )
    ],
    title: Text(
      agenda.namaAgenda!,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 20,
          ),
    ),
    description: agenda.deskripsiAgenda!,
    child: Column(
      children: <Widget>[
        Wrap(
          spacing: 8,
          children: [
            if (akuPic)
              CustomIconButton(
                Icons.edit,
                colorBackground: ColorNeutral.black,
                onPressed: () => {
                  Navigator.pop(context),
                  showEditCallback(agenda.kegiatanId!, agenda)
                },
              ),
            if (akuPic)
              CustomIconButton(
                Icons.delete,
                colorBackground: ColorNeutral.black,
                onPressed: () async {
                  // Show confirmation dialog
                  bool? confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Konfirmasi"),
                      content:
                          Text("Apakah Anda yakin ingin menghapus agenda ini?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx, false); // Cancel deletion
                          },
                          child: Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx, true); // Confirm deletion
                          },
                          child: Text("Hapus"),
                        ),
                      ],
                    ),
                  );

                  // If the user confirmed the deletion
                  if (confirmDelete == true) {
                    Navigator.pop(
                        context); // Optional: pop current screen if needed
                    deleteCallback(
                        agenda.agendaId!); // Call your delete callback
                  }
                },
              )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Jadwal mulai ${DateFormat.yMMMd().add_jm().format(agenda.jadwalAgenda!)}",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 20,
              ),
        ),
        SizedBox(
          height: 16,
        ),
        Divider(),
        SizedBox(
          height: 16,
        ),
        if (agenda.users != null)
          Column(
            children: [
              Text(
                "Dosen yang ditugaskan",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: 20,
                    ),
              ),
              SizedBox(
                height: 8,
              ),
              ...List.generate(
                agenda.users!.length,
                (index) => _anggotaCard(context, agenda.users![index]),
              ),
            ],
          ),
        SizedBox(
          height: 16,
        ),
        Divider(),
        SizedBox(
          height: 16,
        ),
        if (agenda.progress != null)
          Column(
            children: [
              Text(
                "Progress agenda",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: 20,
                    ),
              ),
              SizedBox(
                height: 8,
              ),
              ...List.generate(
                agenda.progress!.length,
                (index) => progressCard(
                  context,
                  agenda.progress![index],
                  () {
                    Navigator.pop(context);
                    callbackPanggilProgress(
                        agenda.agendaId!, agenda.progress![index]);
                  },
                ),
              ),
            ],
          )
      ],
    ),
  );
}

void createOrEditProgress(
  Function(String uidAgenda, String deskripsiProgress, List<File>? fileProgress)
      showEditOrCreateCallbackProgress,
  Function(String uidProgress, String uidAttachment)
      deleteCallbackProgressAttachment,
  Function(String uidProgress) deleteCallbackProgress, {
  required BuildContext context,
  required String uidAgenda,
  Progress? progress,
}) {
  final TextEditingController progressAgenda =
      TextEditingController(text: progress?.deskripsiProgress ?? "");
  List<PlatformFile> selectedFiles = [];
  List<Attachment> existingAttachments = progress?.attachments ?? [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
        'jpeg',
        'pdf',
        'doc',
        'docx',
        'xlsx',
        'xls',
        'gif',
        'bmp',
        'webp',
        'svg',
      ],
    );
    if (result != null) {
      selectedFiles.addAll(result.files);
    }
  }

  callBottomSheet(
    context,
    button: [
      CustomBigButton(
        onPressed: () {
          Navigator.pop(context);
        },
        buttonLabel: "Batal",
        buttonColor: ColorNeutral.black,
        customLabelColor: ColorNeutral.white,
        padding: EdgeInsets.all(24),
      ),
      CustomBigButton(
        onPressed: () {
          // Invoke callback with updated data
          showEditOrCreateCallbackProgress(
            progress != null ? progress.progressId! : uidAgenda,
            progressAgenda.text,
            selectedFiles.isNotEmpty
                ? selectedFiles.map((e) => File(e.path!)).toList()
                : null,
          );
          Navigator.pop(context);
        },
        buttonLabel: progress == null ? "Tambahkan" : "Simpan",
        buttonColor: ColorPrimary.orange,
        customLabelColor: ColorNeutral.white,
        padding: EdgeInsets.all(24),
      ),
    ],
    title: Text(
      progress == null ? "Input Progress" : "Edit Progress",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 20,
          ),
    ),
    child: StatefulBuilder(
      builder: (ctx, setState) {
        return Column(
          children: [
            if (progress != null)
              CustomIconButton(
                Icons.delete,
                colorBackground: ColorNeutral.black,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text("Konfirmasi"),
                        content: Text(
                            "Apakah Anda yakin ingin menghapus progress ini?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx); // Close the dialog
                            },
                            child: Text("Batal",
                                style: TextStyle(color: ColorNeutral.gray)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx); // Close the dialog
                              Navigator.pop(ctx);
                              deleteCallbackProgress(
                                progress.progressId!,
                              );
                            },
                            child: Text("Hapus",
                                style: TextStyle(color: ColorPrimary.orange)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            SizedBox(height: 16),
            CustomTextField(
              label: "Progress agenda",
              hint: "Progress agenda",
              controller: progressAgenda,
              isPassword: false,
              isResizable: true,
              inputType: TextInputType.text,
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            Text(
              "Lampiran",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: 20,
                  ),
            ),
            SizedBox(height: 8),
            // Existing attachments
            if (existingAttachments.isNotEmpty)
              ...List.generate(
                existingAttachments.length,
                (index) => CustomBigButton(
                  onPressed: () => _openBrowserWithDownloadLink(
                      existingAttachments[index].url!),
                  icon: CustomIconButton(
                    "assets/icon/paper.svg",
                    colorBackground: ColorNeutral.gray,
                    iconColorCustom: ColorNeutral.white,
                  ),
                  padding:
                      EdgeInsets.only(top: 8, right: 8, bottom: 8, left: 35),
                  otherWidget: [
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 220),
                          child: Text(
                            existingAttachments[index].nama!,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    fontSize: 20, color: ColorNeutral.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        CustomIconButton(
                          Icons.delete,
                          colorBackground: ColorNeutral.gray,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: Text("Konfirmasi"),
                                  content: Text(
                                      "Apakah Anda yakin ingin menghapus lampiran ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text("Batal",
                                          style: TextStyle(
                                              color: ColorNeutral.gray)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx)
                                            .pop(); // Close the dialog
                                        deleteCallbackProgressAttachment(
                                          progress!.progressId!,
                                          existingAttachments[index]
                                              .attachmentId!,
                                        );
                                        setState(() {
                                          existingAttachments.removeAt(index);
                                        });
                                      },
                                      child: Text("Hapus",
                                          style: TextStyle(
                                              color: ColorPrimary.orange)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    )
                  ],
                  buttonColor: ColorNeutral.black,
                  wasIconOnRight: true,
                ),
              ),
            // Newly selected files
            if (selectedFiles.isNotEmpty)
              ...List.generate(
                selectedFiles.length,
                (index) => CustomBigButton(
                  onPressed: () => {},
                  icon: CustomIconButton(
                    "assets/icon/paper.svg",
                    colorBackground: ColorNeutral.gray,
                    iconColorCustom: ColorNeutral.white,
                  ),
                  padding:
                      EdgeInsets.only(top: 8, right: 8, bottom: 8, left: 35),
                  otherWidget: [
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 220),
                          child: Text(
                            selectedFiles[index].name,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    fontSize: 20, color: ColorNeutral.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        CustomIconButton(
                          Icons.delete,
                          colorBackground: ColorNeutral.gray,
                          onPressed: () {
                            setState(() {
                              selectedFiles.removeAt(index);
                            });
                          },
                        )
                      ],
                    )
                  ],
                  buttonColor: ColorNeutral.black,
                  wasIconOnRight: true,
                ),
              ),
            SizedBox(height: 16),
            CustomBigButton(
              buttonLabel: "Tambah Lampiran",
              buttonColor: ColorPrimary.orange,
              customLabelColor: ColorNeutral.white,
              padding: EdgeInsets.all(16),
              onPressed: () async {
                await _pickFiles(); // Wait for files to be picked
                setState(() {}); // Update the UI after files are picked
              },
            ),
          ],
        );
      },
    ),
  );
}

void createOrEditAgenda({
  required BuildContext context,
  required String uidKegiatan,
  Agenda? agenda,
  required List<User> anggota,
  required Function(
    String uidKegiatan,
    String nama,
    String deskripsi,
    DateTime datetime,
    bool isDone,
    List<User>? anggota,
  ) createOrEditAgendaCallback,
  required Function(String agendaId, String userId) onDeleteUserAgendaCallback,
}) {
  final TextEditingController namaAgendaController =
      TextEditingController(text: agenda?.namaAgenda ?? "");
  final TextEditingController deskripsiController =
      TextEditingController(text: agenda?.deskripsiAgenda ?? "");
  final TextEditingController datetimeController = TextEditingController(
    text: agenda != null
        ? DateFormat('EEEE, dd MMM yyyy HH:mm').format(agenda.jadwalAgenda!)
        : "",
  );

  DateTime? selectedDatetime = agenda?.jadwalAgenda;
  List<User> selectedUsers = agenda?.users ?? [];
  List<User> initialUsers = List.from(selectedUsers); // For pre-existing users
  bool isDone = agenda?.isDone ?? false;

  Future<void> selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDatetime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedDatetime != null
            ? TimeOfDay.fromDateTime(selectedDatetime!)
            : TimeOfDay.now(),
      );
      if (pickedTime != null) {
        selectedDatetime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        final formattedDatetime =
            DateFormat('EEEE, dd MMM yyyy HH:mm').format(selectedDatetime!);
        datetimeController.text = formattedDatetime;
      }
    }
  }

  Future<void> selectUsers(
      BuildContext context, Function setStateParent) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Pilih Anggota"),
        content: StatefulBuilder(
          builder: (ctx, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: anggota.map((user) {
                  bool isSelected = selectedUsers.any(
                      (selectedUser) => selectedUser.userId == user.userId);
                  return CheckboxListTile(
                    title: Text(
                        "${user.nama!} - Jumlah agenda ${user.agendaCount}"),
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        setStateParent(() {
                          if (value == true) {
                            selectedUsers.add(user);
                          } else {
                            selectedUsers.remove(user);
                          }
                        });
                      });
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  callBottomSheet(
    context,
    button: [
      CustomBigButton(
        onPressed: () {
          Navigator.pop(context);
        },
        buttonLabel: "Batal",
        buttonColor: ColorNeutral.black,
        customLabelColor: ColorNeutral.white,
        padding: EdgeInsets.all(24),
      ),
      CustomBigButton(
        onPressed: () {
          if (selectedDatetime != null) {
            if (namaAgendaController.text.isEmpty ||
                deskripsiController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Harap isi semua bidang wajib (Nama agenda, Deskripsi, dan Jadwal agenda)",
                  ),
                  backgroundColor: ColorPrimary.orange,
                ),
              );
              return;
            }

            createOrEditAgendaCallback(
              agenda != null ? agenda.agendaId! : uidKegiatan,
              namaAgendaController.text,
              deskripsiController.text,
              selectedDatetime!,
              isDone,
              selectedUsers,
            );
          }
          Navigator.pop(context);
        },
        buttonLabel: agenda == null ? "Tambahkan" : "Simpan",
        buttonColor: ColorPrimary.orange,
        customLabelColor: ColorNeutral.white,
        padding: EdgeInsets.all(24),
      ),
    ],
    title: Text(
      agenda == null ? "Input Agenda" : "Edit Agenda",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 20,
          ),
    ),
    child: StatefulBuilder(
      builder: (ctx, setState) {
        return Column(
          children: [
            SizedBox(height: 16),
            CustomTextField(
              label: "Nama agenda",
              hint: "Nama agenda",
              controller: namaAgendaController,
              isPassword: false,
              inputType: TextInputType.text,
            ),
            SizedBox(height: 16),
            CustomTextField(
              label: "Jadwal agenda",
              hint: "Pilih jadwal agenda",
              controller: datetimeController,
              onTap: () async => await selectDateTime(context),
              isPassword: false,
              customIcon: Icons.calendar_month,
              inputType: TextInputType.none,
            ),
            SizedBox(height: 16),
            CustomTextField(
              label: "Deskripsi Agenda",
              hint: "Deskripsi singkat agenda",
              controller: deskripsiController,
              isResizable: true,
              isPassword: false,
              inputType: TextInputType.text,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text("Status: "),
                Switch(
                  value: isDone,
                  onChanged: (value) {
                    setState(() {
                      isDone = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              "Dosen yang ditugaskan",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: 20,
                  ),
            ),
            SizedBox(height: 8),
            ...selectedUsers.map((user) {
              bool isInitial = initialUsers.contains(user);
              return ListTile(
                title: Text("${user.nama}"),
                trailing: CustomIconButton(
                  Icons.delete,
                  onPressed: () async {
                    if (isInitial && agenda != null) {
                      bool? confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Konfirmasi"),
                          content: Text(
                            "Apakah Anda yakin ingin menghapus pengguna ini dari agenda?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx, false); // Cancel deletion
                              },
                              child: Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx, true); // Confirm deletion
                              },
                              child: Text("Hapus"),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete == true) {
                        // Run the callback after confirmation
                        onDeleteUserAgendaCallback(
                            agenda.agendaId!, user.userId!);
                        setState(() {
                          selectedUsers.remove(user);
                        });
                      }
                    }
                  },
                  colorBackground: ColorNeutral.black,
                ),
              );
            }),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async => await selectUsers(context, setState),
              child: Text("Pilih Anggota"),
            ),
          ],
        );
      },
    ),
  );
}

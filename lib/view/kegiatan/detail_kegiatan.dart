import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/kegiatan/detail_kegiatan_widgets.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_service.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';

class DetailKegiatan extends StatefulWidget {
  const DetailKegiatan({super.key, required this.idKegiatan});

  final String idKegiatan;

  @override
  State<DetailKegiatan> createState() => _DetailKegiatanState();
}

class _DetailKegiatanState extends State<DetailKegiatan> {
  bool isLoading = true;
  bool akuPic = false;
  bool isAgendaLoad = false;
  String? myUid;
  KegiatanResponse? data;
  final KegiatanService _kegiatanService = KegiatanService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final TextEditingController _namaAgendaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
      fetchData();
    });
  }

  bool cariAku(List<User> users) {
    for (var user in users) {
      if (user.userId == myUid) {
        return user.isPic ?? false;
      }
    }
    return false;
  }

  Future<void> fetchData() async {
    // Trigger the swipe refresh animation programmatically
    _refreshIndicatorKey.currentState?.show();
    setState(() {
      isLoading = true; // Show loading indicator during initial fetch
    });

    try {
      // Fetch home data from the API
      final BaseResponse<KegiatanResponse> response =
          await _kegiatanService.fetchKegiatanById(widget.idKegiatan);
      UserData? apa = await Storage.getMyInfo();

      if (response.success && response.data != null) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            data = response.data;
            myUid = apa!.userId;
            akuPic = cariAku(data!.users!);
          });
        }
        print("Data fetched successfully");
      } else {
        if (mounted) {
          _showErrorDialog(context, "Fetch Failed",
              response.message); // Pass the current valid context
        }
      }
    } catch (e) {
      print("Error during data fetch: $e");
      if (mounted) {
        _showErrorDialog(context, "Error",
            "An error occurred while fetching data: $e"); // Pass the current valid context
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  Future<void> _showAgendaCallback(String idAgenda) async {
    setState(() {
      isAgendaLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();
    try {
      final BaseResponse<Agenda> response =
          await _kegiatanService.fetchAgendaById(idAgenda);

      if (response.success) {
        showDetailAgenda(context, response.data!);
      } else {
        _showErrorDialog(context, "Agenda Failed to fetch", response.message);
      }
    } catch (e) {
      _showErrorDialog(
          context, "Error", "An error occurred during forgot password: $e");
    } finally {
      setState(() {
        isAgendaLoad = false;
      });
    }
  }

  Future<void> _refreshData() async {
    if (!isAgendaLoad) {
      await fetchData(); // Refresh data using the existing fetchData method
    }
  }

  void _showErrorDialog(
      BuildContext dialogContext, String title, String message) {
    showDialog(
      context: dialogContext, // Use the passed-in parent context
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

  bool _wasMePic(List<User> user) {
    for (var user in user) {
      if (user.userId == myUid) {
        return user.isPic ?? false;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool wasNow = false;
    if (!isLoading) {
      DateTime now = DateTime.now();
      wasNow = data!.tanggalMulai!.isAfter(now) &&
          data!.tanggalMulai!.isBefore(now) &&
          !data!.isDone!;
    }

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: ColorNeutral.black,
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 61, left: 22, right: 22),
          child: isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const SizedBox.shrink(), // Empty space during loading
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          CustomIconButton(
                            Icons.chevron_left_rounded,
                            colorBackground: ColorNeutral.white,
                            size: IconSize.medium,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (!isLoading)
                      kegiatanCard(context,
                          kegiatan: data!, isFromDetail: true),
                    const SizedBox(height: 10),
                    if (!isLoading)
                      Column(
                        children: [
                          CustomCardContent(
                            header: [
                              Text(
                                "Brief penugasan",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 16),
                              )
                            ],
                            actionIcon: [],
                            colorBackground: Colors.white,
                            description: data!.deskripsi,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (!isLoading && !wasNow)
                      Column(
                        children: [
                          bigInfo(context,
                              kegiatan: data!,
                              wasMePic: _wasMePic(data!.users!)),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    if (!isLoading && data!.agenda!.isNotEmpty)
                      Column(
                        children: [
                          agendaContainer(context, data!.agenda!),
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (!isLoading)
                      Column(
                        children: [
                          dosenCard(context, data!.users!),
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (!isLoading && data!.lampiran!.isNotEmpty)
                      Column(
                        children: [
                          fileCard(context, lampirans: data!.lampiran!),
                          const SizedBox(
                            height: 64,
                          ),
                        ],
                      )
                  ],
                ),
        ),
      ),
    );
  }

  CustomCardContent agendaContainer(BuildContext context, List<Agenda> agenda) {
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
          2,
          (index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              agendasCard(context, agenda[index]),
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
                  onPressed: () => _showListOfAgenda(context, agenda),
                ),
            ],
          ),
        ),
        if (!akuPic)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomIconButton(
                Icons.add,
                colorBackground: ColorNeutral.black,
                iconColorCustom: ColorNeutral.white,
              ),
            ],
          )
      ],
    );
  }

  CustomBigButton agendasCard(BuildContext context, Agenda agenda) {
    double maxWidth = MediaQuery.of(context).size.width - 220;
    return CustomBigButton(
      wasIconOnRight: true,
      padding: EdgeInsets.all(24),
      otherWidget: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
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
                      DateFormat.yMMMd().add_jm().format(agenda.jadwalAgenda!),
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
      onPressed: () => _showAgendaCallback(agenda.agendaId!),
    );
  }

  CustomBigButton progressCard(BuildContext context, Progress progress) {
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
      onPressed: () {},
    );
  }

  void _showListOfAgenda(BuildContext context, List<Agenda> agenda) {
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
            (index) => agendasCard(context, agenda[index]),
          )
        ],
      ),
    );
  }

  void showDetailAgenda(BuildContext context, Agenda agenda) {
    callBottomSheet(
      context,
      button: [],
      title: Text(
        agenda.namaAgenda!,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 20,
            ),
      ),
      description: agenda.deskripsiAgenda!,
      child: Column(
        children: [
          Text(
            "Jadwal mulai ${DateFormat.yMMMd().add_jm().format(agenda.jadwalAgenda!)}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 20,
                ),
          ),
          SizedBox(
            height: 24,
          ),
          ...List.generate(
            agenda.progress!.length,
            (index) => progressCard(context, agenda.progress![index]),
          ),
          SizedBox(
            height: 32,
          ),
          CustomBigButton(
            onPressed: () {},
            buttonLabel: "Tambah Progress",
            buttonColor: ColorPrimary.orange,
            customLabelColor: ColorNeutral.white,
            padding: EdgeInsets.all(24),
          )
        ],
      ),
    );
  }

  void cerateAgenda(BuildContext context) {
    callBottomSheet(
      context,
      button: [],
      title: Text(
        "Input Agenda",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 20,
            ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          CustomTextField(
            // controller: _passwordBaruController,
            label: "Password baru",
            hint: "Password baru",
            isPassword: true, // or true for password fields
            inputType: TextInputType.text, // For numeric input
          ),
          
        ],
      ),
    );
  }
}

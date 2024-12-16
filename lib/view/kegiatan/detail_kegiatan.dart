import 'dart:io';

import 'package:flutter/material.dart';

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
  bool isOtherLoad = false;
  String? myUid;
  KegiatanResponse? data;
  final KegiatanService _kegiatanService = KegiatanService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
      _fetchData();
    });
  }

  bool _cariAku(List<User> users) {
    for (var user in users) {
      if (user.userId == myUid) {
        return user.isPic ?? false;
      }
    }
    return false;
  }

  Future<void> _fetchData() async {
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
            akuPic = _cariAku(data!.users!);
          });
        }
        print("Data fetched successfully");
      } else {
        if (mounted) {
          showErrorDialog(context, "Fetch Failed",
              response.message); // Pass the current valid context
        }
      }
    } catch (e) {
      print("Error during data fetch: $e");
      if (mounted) {
        showErrorDialog(context, "Error",
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

  Future<void> _fetchAgenda(String idAgenda) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();
    try {
      final BaseResponse<Agenda> response =
          await _kegiatanService.fetchAgendaById(idAgenda);

      if (response.success) {
        showDetailAgenda(context, response.data!, akuPic,
            _showCreateOrEditAgenda, _deleteAgenda, _showCreateOrEditProgress);
      } else {
        showErrorDialog(context, "Agenda Failed to fetch", response.message);
      }
    } catch (e) {
      showErrorDialog(
          context, "Error", "An error occurred during fetch agenda: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
      });
    }
  }

  Future<void> _showCreateOrEditAgenda(
      String uidKegiatan, Agenda? agenda) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();

    try {
      final BaseResponse<List<User>> response =
          await _kegiatanService.fetchAnggota(uidKegiatan);

      if (response.success) {
        createOrEditAgenda(
            context: context,
            uidKegiatan: uidKegiatan,
            anggota: response.data!,
            agenda: agenda,
            createOrEditAgendaCallback:
                agenda != null ? _editAgenda : _createAgenda,
            onDeleteUserAgendaCallback: _deleteUserFromAgenda);
      } else {
        showErrorDialog(context, "Anggota Failed to fetch", response.message);
      }
    } catch (e) {
      showErrorDialog(
          context, "Error", "An error occurred during fetch anggota: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
      });
    }
  }

  Future<void> _deleteUserFromAgenda(
      String uidAgenda, String uiduserKegiatan) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();

    try {
      final BaseResponse<KegiatanResponse> response = await _kegiatanService
          .deleteAnggotaAgenda(uidAgenda, uiduserKegiatan);

      if (response.success) {
        // Trigger the swipe refresh animation programmatically
        _refreshIndicatorKey.currentState?.show();
        setState(() {
          isLoading = true; // Show loading indicator during initial fetch
        });
      } else {
        showErrorDialog(context, "Agenda Failed to create", response.message);
      }
    } catch (e) {
      showErrorDialog(
          context, "Error", "An error occurred during create angenda: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
        isLoading = false;
      });
    }
  }

  Future<void> _createAgenda(String uidKegiatan, String nama, String deskripsi,
      DateTime datetime, bool isDone, List<User>? anggota) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();

    try {
      final BaseResponse<Agenda> response = await _kegiatanService.createAgenda(
          uidKegiatan, nama, deskripsi, datetime, isDone, anggota);

      if (response.success) {
        // Trigger the swipe refresh animation programmatically
        _refreshIndicatorKey.currentState?.show();
        setState(() {
          isLoading = true; // Show loading indicator during initial fetch
        });
      } else {
        showErrorDialog(context, "Agenda Failed to create", response.message);
      }
    } catch (e) {
      showErrorDialog(
          context, "Error", "An error occurred during create angenda: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
        isLoading = false;
      });
    }
  }

  Future<void> _editAgenda(String uidAgenda, String nama, String deskripsi,
      DateTime datetime, bool isDone, List<User>? anggota) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();

    try {
      final BaseResponse<Agenda> response = await _kegiatanService.editAgenda(
          uidAgenda, nama, deskripsi, datetime, isDone, anggota);

      if (response.success) {
        // Trigger the swipe refresh animation programmatically
        _refreshIndicatorKey.currentState?.show();
        setState(() {
          isLoading = true; // Show loading indicator during initial fetch
        });
      } else {
        showErrorDialog(context, "Agenda Failed to edit", response.message);
      }
    } catch (e) {
      showErrorDialog(
          context, "Error", "An error occurred during edit angenda: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
        isLoading = false;
      });
    }
  }

  Future<void> _deleteAgenda(String uidAgenda) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();

    try {
      final BaseResponse<Agenda> response =
          await _kegiatanService.deleteAgenda(uidAgenda);

      if (response.success) {
        // Trigger the swipe refresh animation programmatically
        _refreshIndicatorKey.currentState?.show();
        setState(() {
          isLoading = true; // Show loading indicator during initial fetch
        });
      } else {
        showErrorDialog(context, "Agenda Failed to delete", response.message);
      }
    } catch (e) {
      showErrorDialog(
          context, "Error", "An error occurred during delete angenda: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
        isLoading = false;
      });
    }
  }

  Future<void> _showCreateOrEditProgress(
      String uidAgenda, Progress? progress) async {
    createOrEditProgress(
      progress != null ? _editProgressAgenda : _createProgress,
      _deleteProgressAttachment,
      _deleteProgress,
      context: context,
      uidAgenda: uidAgenda,
      progress: progress,
    );
  }

  Future<void> _createProgress(
      String uidAgenda, String deskripsiProgress, List<File>? files) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();

    try {
      final BaseResponse<Agenda> response = await _kegiatanService
          .createProgressAgenda(uidAgenda, deskripsiProgress, files);

      if (response.success) {
        // Trigger the swipe refresh animation programmatically
        _refreshIndicatorKey.currentState?.show();
        setState(() {
          isLoading = true; // Show loading indicator during initial fetch
        });
      } else {
        showErrorDialog(context, "Progress Failed to create", response.message);
      }
    } catch (e) {
      showErrorDialog(
          context, "Error", "An error occurred during create progress: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
        isLoading = false;
      });
    }
  }

  Future<void> _editProgressKegiatan(
      String uidKegiatan, String progress) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();

    try {
      final BaseResponse<KegiatanResponse> response =
          await _kegiatanService.editProgress(uidKegiatan, progress);

      if (response.success) {
        // Trigger the swipe refresh animation programmatically
        _refreshIndicatorKey.currentState?.show();
        setState(() {
          isLoading = true; // Show loading indicator during initial fetch
        });
      } else {
        showErrorDialog(
            context, "Progress Failed to edit progress", response.message);
      }
    } catch (e) {
      showErrorDialog(
          context, "Error", "An error occurred during edit progress: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
        isLoading = false;
      });
    }
  }

  Future<void> _createLampiran(String uidKegiatan, List<File> files) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();

    try {
      final BaseResponse<KegiatanResponse> response =
          await _kegiatanService.createLampiran(uidKegiatan, files);

      if (response.success) {
        // Trigger the swipe refresh animation programmatically
        _refreshIndicatorKey.currentState?.show();
        setState(() {
          isLoading = true; // Show loading indicator during initial fetch
        });
      } else {
        showErrorDialog(
            context, "Progress Failed to edit progress", response.message);
      }
    } catch (e) {
      showErrorDialog(
          context, "Error", "An error occurred during edit progress: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
        isLoading = false;
      });
    }
  }

  Future<void> _deleteLampiran(String uidLampiran) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();

    try {
      final BaseResponse<KegiatanResponse> response =
          await _kegiatanService.deleteLampiran(uidLampiran);

      if (response.success) {
        // Trigger the swipe refresh animation programmatically
        _refreshIndicatorKey.currentState?.show();
        setState(() {
          isLoading = true; // Show loading indicator during initial fetch
        });
      } else {
        showErrorDialog(
            context, "Progress Failed to edit progress", response.message);
      }
    } catch (e) {
      showErrorDialog(
          context, "Error", "An error occurred during edit progress: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
        isLoading = false;
      });
    }
  }

  Future<void> _editProgressAgenda(
      String uidProgress, String deskripsiProgress, List<File>? files) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();

    try {
      final BaseResponse<Agenda> response = await _kegiatanService
          .editProgressAgenda(uidProgress, deskripsiProgress, files);

      if (response.success) {
        // Trigger the swipe refresh animation programmatically
        _refreshIndicatorKey.currentState?.show();
        setState(() {
          isLoading = true; // Show loading indicator during initial fetch
        });
      } else {
        showErrorDialog(context, "Progress Failed to edit progress agenda ",
            response.message);
      }
    } catch (e) {
      showErrorDialog(context, "Error",
          "An error occurred during edit progress agenda: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
        isLoading = false;
      });
    }
  }

  Future<void> _deleteProgress(String uidProgress) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();

    try {
      final BaseResponse<Progress> response =
          await _kegiatanService.deleteProgressAgenda(uidProgress);

      if (response.success) {
        // Trigger the swipe refresh animation programmatically
        _refreshIndicatorKey.currentState?.show();
        setState(() {
          isLoading = true; // Show loading indicator during initial fetch
        });
      } else {
        showErrorDialog(context, "Progress Failed to delete", response.message);
      }
    } catch (e) {
      showErrorDialog(
          context, "Error", "An error occurred during delete Progress: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
        isLoading = false;
      });
    }
  }

  Future<void> _deleteProgressAttachment(
      String uidProgress, String uidAttachment) async {
    setState(() {
      isOtherLoad = true;
    });
    _refreshIndicatorKey.currentState?.show();

    try {
      final BaseResponse<Progress> response = await _kegiatanService
          .deleteProgressAttachmentAgenda(uidProgress, uidAttachment);

      if (response.success) {
        // Trigger the swipe refresh animation programmatically
        _refreshIndicatorKey.currentState?.show();
        setState(() {
          isLoading = true; // Show loading indicator during initial fetch
        });
      } else {
        showErrorDialog(
            context, "Progress attachemnt Failed to delete", response.message);
      }
    } catch (e) {
      showErrorDialog(context, "Error",
          "An error occurred during delete Progress attachemnt: $e");
    } finally {
      setState(() {
        isOtherLoad = false;
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    if (!isOtherLoad) {
      await _fetchData(); // Refresh data using the existing fetchData method
    }
  }

  void showErrorDialog(
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
                    if (!isLoading)
                      Column(
                        children: [
                          CustomCardContent(
                            header: [
                              Text(
                                "Progress Kegiatan",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 16),
                              )
                            ],
                            actionIcon: [
                              if (akuPic)
                                CustomIconButton(
                                  Icons.edit,
                                  colorBackground: ColorNeutral.black,
                                  onPressed: () => {
                                    updateProgress(
                                      context,
                                      uidKegiatan: data!.kegiatanId!,
                                      progressSekarang: data!.progress,
                                      updateProgressCallback:
                                          _editProgressKegiatan,
                                    )
                                  },
                                ),
                            ],
                            colorBackground: Colors.white,
                            description: data?.progress,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (!isLoading && data!.agenda!.isNotEmpty)
                      Column(
                        children: [
                          agendaContainer(
                              context,
                              data!.agenda!,
                              akuPic,
                              _fetchAgenda,
                              _showCreateOrEditAgenda,
                              data!.kegiatanId!),
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
                          fileCard(
                            context,
                            uidKegiatan: data!.kegiatanId!,
                            lampirans: data!.lampiran!,
                            akuPic: akuPic,
                            callbackCreateLampiran: _createLampiran,
                            callbackDeleteLampiran: _deleteLampiran,
                          ),
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
}

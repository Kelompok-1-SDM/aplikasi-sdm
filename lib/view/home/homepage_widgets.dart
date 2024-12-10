import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/services/home/home_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:ui' as ui; // Alias the dart:ui import

class HomeAppBar extends StatefulWidget {
  final UserData? userdat;

  const HomeAppBar({super.key, this.userdat});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  OverlayEntry? _overlayEntry;
  final _layerLink = LayerLink();
  double statistik = 0;

  @override
  void initState() {
    _loadStatistik();
    super.initState();
  }

  Future<void> _loadStatistik() async {
    final savedStatistik = await Storage.getAvg();
    if (savedStatistik == null) {
      // Mock data for development
      statistik = 0;
    } else if (mounted) {
      setState(() {
        statistik = savedStatistik;
      });
    }
  }

  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        right: offset.dx + 90,
        top: offset.dy + 20,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(-270, 30),
          child: Stack(
            children: [
              const NotificationWidgetOverlay(),
              Positioned(
                right: 10,
                top: 10,
                child: CustomIconButton(
                  Icons.cancel,
                  colorBackground: ColorNeutral.background,
                  iconColorCustom: ColorNeutral.black,
                  onPressed: _hideOverlay,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    Color color = statistik > 5
        ? ColorPrimary.green
        : statistik < 5 && statistik > 3
            ? ColorPrimary.blue
            : ColorPrimary.orange;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: CustomIconButton(
            "assets/icon/notification.svg",
            colorBackground: ColorNeutral.white,
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showOverlay(context);
              });
            },
            size: IconSize.medium,
          ),
        ),
        const SizedBox(width: 16),
        ProfileIcon(
          widget.userdat?.profileImage ?? 'assets/images/default_profile.png',
          borderColor: color,
          onPressed: () {
            Navigator.pushNamed(context, "/profile");
          },
        ),
      ],
    );
  }
}

class Navbar extends StatelessWidget {
  final NavbarState state;
  final Function(int) onItemSelected;

  const Navbar({
    super.key,
    required this.state,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AnimatedPositioned(
            // Slide up when state is NavbarState.task, slide down when not
            bottom: state == NavbarState.task_1 || state == NavbarState.task_2
                ? 120
                : 30, // Adjust the off-screen position
            duration: const Duration(milliseconds: 300), // Animation duration
            curve: Curves.easeInOut,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: ShapeDecoration(
                color: ColorNeutral.black,
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 32,
                    cornerSmoothing: 0,
                  ),
                ),
              ),
              child: Wrap(
                spacing: 26,
                direction: Axis.horizontal,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                          EdgeInsets.zero), // Ensure padding is zero
                    ),
                    onPressed: () => onItemSelected(2),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 6),
                      decoration: BoxDecoration(
                        color: state == NavbarState.task_1
                            ? ColorNeutral
                                .white // White when selected (stateTugas == 0)
                            : Colors.transparent, // Gray when unselected
                        borderRadius:
                            BorderRadius.circular(24), // Rounded corners
                        border: Border.all(
                          color: Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        "Ditugaskan",
                        style: TextStyle(
                          color: state == NavbarState.task_1
                              ? ColorNeutral.black
                              : ColorNeutral.gray, // Text color
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                          EdgeInsets.zero), // Ensure padding is zero
                    ),
                    onPressed: () => onItemSelected(3),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 6),
                      decoration: BoxDecoration(
                        color: state == NavbarState.task_2
                            ? ColorNeutral
                                .white // White when selected (stateTugas == 0)
                            : Colors.transparent, // Gray when unselected
                        borderRadius:
                            BorderRadius.circular(24), // Rounded corners
                        border: Border.all(
                          color: Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        "Histori",
                        style: TextStyle(
                          color: state == NavbarState.task_2
                              ? ColorNeutral.black
                              : ColorNeutral.gray, // Text color
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        Positioned(
          bottom: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: ShapeDecoration(
              color: ColorNeutral.black,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 55,
                  cornerSmoothing: 0,
                ),
              ),
            ),
            child: Wrap(
              spacing: 26,
              direction: Axis.horizontal,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: CustomIconButton(
                    key: ValueKey(
                        state == NavbarState.calendar), // Unique Key for state
                    "assets/icon/calendar-bold.svg",
                    onPressed: () => {
                      onItemSelected(0),
                    },
                    size: IconSize.large,
                    padding: EdgeInsets.zero,
                    colorBackground: ColorNeutral.black,
                    isNotSelectable: state == NavbarState.calendar,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: CustomIconButton(
                    key: ValueKey(
                        state == NavbarState.home), // Unique Key for state
                    "assets/icon/home.svg",
                    onPressed: () => {
                      onItemSelected(1),
                    },
                    size: IconSize.large,
                    padding: EdgeInsets.zero,
                    colorBackground: ColorNeutral.black,
                    isNotSelectable: state == NavbarState.home,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: CustomIconButton(
                    key: ValueKey(state == NavbarState.task_1 ||
                        state == NavbarState.task_2), // Unique Key for state
                    "assets/icon/category-bold.svg",
                    onPressed: () => {
                      onItemSelected(2),
                    },
                    size: IconSize.large,
                    padding: EdgeInsets.zero,
                    colorBackground: ColorNeutral.black,
                    isNotSelectable: state == NavbarState.task_1 ||
                        state == NavbarState.task_2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

SizedBox headline(ThemeData theme, String username) {
  return SizedBox(
    width: double.maxFinite,
    child: Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        Text(
          "Halo 👋 $username",
          style: theme.textTheme.bodySmall!.copyWith(fontSize: 20),
        ),
        Text(
          "Mulai hari dengan\nmenjadi lebih produktif!",
          style: theme.textTheme.titleMedium!.copyWith(fontSize: 24),
        ),
      ],
    ),
  );
}

CustomCardContent currentTask(ThemeData theme, KegiatanResponse? tugas) {
  return CustomCardContent(
    header: [
      Text(
        "Tugas yang sedang berlangsung",
        style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
      ),
    ],
    title: tugas?.judul,
    actionIcon: [
      CustomIconButton(
        "assets/icon/category.svg",
        colorBackground: ColorNeutral.black,
        isNotSelectable: true,
      )
    ],
    colorBackground: ColorNeutral.white,
    descIcon: [
      CustomIconButton(
        "assets/icon/location.svg",
        colorBackground: Colors.transparent,
        text: tugas?.lokasi,
      )
    ],
    // otherWidget: [
    //   LiveChatButton(
    //     idKegiatan: tugas!.kegiatanId!,
    //   )
    // ],
  );
}

CustomCardContent homeCard(BuildContext context, JumlahTugasBulanSekarang? data,
    Function(int) onItemTapped) {
  return CustomCardContent(
    header: [
      CustomIconButton(
        "assets/icon/calendar.svg",
        colorBackground: Colors.transparent,
        iconColorCustom: ColorNeutral.gray,
        text: DateFormat('d EEEE').format(DateTime.now()),
      ),
    ],
    colorBackground: Color(0xFF40DDB3),
    // title: ,
    // title: nukll,
    actionIcon: [
      CustomIconButton(
        Icons.share,
        onPressed: () => {},
        colorBackground: ColorNeutral.white,
      ),
      CustomIconButton(
        "assets/icon/calendar.svg",
        onPressed: () => onItemTapped(0),
        colorBackground: ColorNeutral.black,
      )
    ],
    otherWidget: [
      Text(
        "Kamu memiliki",
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
      ),
      Text(
        "${data!.count} Kegiatan di Bulan ${DateFormat('MMMM').format(DateTime.now())} 🔥",
        softWrap: true,
        textWidthBasis: TextWidthBasis.parent,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 32,
            ),
      ),
      Divider(
        color: ColorNeutral.gray,
        thickness: 1,
      ),
    ],
    onPressed: () => onItemTapped(0),
  );
}

CustomCardContent statsCard(
    BuildContext context, Statistik? data, UserData userInfo, double avg) {
  Color color = avg > 5
      ? ColorPrimary.green
      : avg < 5 && avg > 3
          ? ColorPrimary.blue
          : ColorPrimary.orange;

  double measureTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection:
          ui.TextDirection.ltr, // Use TextDirection from material.dart
    );
    textPainter.layout();
    return textPainter.width;
  }

  final double textWidth = measureTextWidth(
    "${userInfo.nama.split(' ')[0]},kamu telah melakukan ",
    Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 36),
  );
  return CustomCardContent(
    onPressed: () => {Navigator.pushNamed(context, '/profile')},
    header: [
      CustomIconButton(
        "assets/icon/stats.svg",
        // padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        colorBackground: ColorNeutral.black,
      )
    ],
    actionIcon: [
      CustomIconButton(
        Icons.share,
        onPressed: () => {},
        colorBackground: ColorNeutral.background,
      )
    ],
    otherWidget: [
      Text(
        "Statistik",
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
      ),
      Stack(
        children: [
          Positioned(
            left: textWidth - 384,
            child: ProfileIcon(
              borderColor: color,
              userInfo.profileImage,
              imageSize: 60,
            ),
          ),
          Positioned(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "${userInfo.nama.split(' ')[0]}             ,kamu telah melakukan ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 36),
                  ),
                  TextSpan(
                    text: "${data?.totalDalamSetahun ?? 0} penugasan ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "dalam",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 36),
                  ),
                  TextSpan(
                    text: " setahun ini",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          Text("Ketuk untuk melihat lebih detail"),
          CustomIconButton(
            "assets/icon/arrow-45.svg",
            size: IconSize.small,
            padding: EdgeInsets.zero,
            colorBackground: ColorNeutral.black,
          )
        ],
      )
    ],
  );
}

class NotificationWidgetOverlay extends StatefulWidget {
  const NotificationWidgetOverlay({super.key});

  @override
  State<NotificationWidgetOverlay> createState() =>
      _NotificationWidgetOverlayState();
}

class _NotificationWidgetOverlayState extends State<NotificationWidgetOverlay> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(40),
      elevation: 1,
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 300,
          maxWidth: 320,
        ),
        child: Container(
          decoration: ShapeDecoration(
            color: ColorNeutral.white,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                topLeft: SmoothRadius(
                  cornerRadius: 40,
                  cornerSmoothing: .6,
                ),
                bottomLeft: SmoothRadius(
                  cornerRadius: 40,
                  cornerSmoothing: .6,
                ),
                bottomRight: SmoothRadius(
                  cornerRadius: 40,
                  cornerSmoothing: .6,
                ),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: ListView.separated(
              itemBuilder: (_, index) => createNotification(),
              separatorBuilder: (_, __) => Divider(),
              itemCount: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget createNotification() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ProfileIcon(
          "assets/icon/profile.png",
          imageSize: IconSize.large,
        ),
        SizedBox(
          width: 12,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 220),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Butuh verifikasi-mu",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Apakah rekan kamu Andika, hadir?",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
              )
            ],
          ),
        )
      ],
    );
  }
}

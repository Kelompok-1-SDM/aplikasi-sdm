import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final LayerLink layerlink = LayerLink();
  OverlayEntry? entry;

  void showOverlay() {
    final OverlayState overlay = Overlay.of(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    entry = OverlayEntry(
      builder: (context) => Positioned(
        right: offset.dx + 90,
        top: offset.dy + 20,
        child: CompositedTransformFollower(
            link: layerlink,
            showWhenUnlinked: false,
            offset: Offset(-offset.dx - 270, 30),
            child: Stack(children: [
              NotificationWidgetOverlay(),
              Positioned(
                right: 10,
                top: 10,
                child: CustomIconButton(
                  Icons.cancel,
                  colorBackground: ColorNeutral.background,
                  iconColorCustom: ColorNeutral.black,
                  onPressed: () => entry?.remove(),
                ),
              ),
            ])),
      ),
    );

    overlay.insert(entry!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CompositedTransformTarget(
          link: layerlink,
          child: CustomIconButton(
            "assets/icon/notification.svg",
            colorBackground: ColorNeutral.white,
            onPressed: () => {
              WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay())
            },
            size: IconSize.medium,
          ),
        ),
        SizedBox(
          width: 16,
        ),
        ProfileIcon(
          "assets/icon/profile.png",
          onPressed: () => {
            Navigator.pushNamed(
              context,
              "/profile",
            )
          },
        )
      ],
    );
  }
}

class Navbar extends StatelessWidget {
  final NavbarState state;
  final int stateTugas;
  final Function(int) onItemSelected;
  final Function(int) onDaftarSelected;

  const Navbar({
    super.key,
    required this.state,
    required this.onItemSelected,
    required this.onDaftarSelected,
    required this.stateTugas,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AnimatedPositioned(
            // Slide up when state is NavbarState.task, slide down when not
            bottom: state == NavbarState.task
                ? 120
                : 30, // Adjust the off-screen position
            duration: const Duration(milliseconds: 300), // Animation duration
            curve: Curves.easeInOut,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: ShapeDecoration(
                color: ColorNeutral.black,
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 24,
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
                    onPressed: () => onDaftarSelected(0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 6),
                      decoration: BoxDecoration(
                        color: stateTugas == 0
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
                          color: stateTugas == 0
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
                    onPressed: () => onDaftarSelected(1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 6),
                      decoration: BoxDecoration(
                        color: stateTugas == 1
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
                          color: stateTugas == 1
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
                    key: ValueKey(
                        state == NavbarState.task), // Unique Key for state
                    "assets/icon/category-bold.svg",
                    onPressed: () => {
                      onItemSelected(2),
                    },
                    size: IconSize.large,
                    padding: EdgeInsets.zero,
                    colorBackground: ColorNeutral.black,
                    isNotSelectable: state == NavbarState.task,
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

SizedBox headline(ThemeData theme) {
  return SizedBox(
    width: double.maxFinite,
    child: Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        Text(
          "Halo 👋 Ardian",
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

CustomCardContent currentTask(ThemeData theme) {
  return CustomCardContent(
    header: [
      Text(
        "Tugas yang sedang berlangsung",
        style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
      ),
    ],
    title: "Pemateri Semminar Teknnologi Informasi",
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
        text: "Auditorium Lt. 8, Teknik Sipil",
      )
    ],
    otherWidget: [
      LiveChatButton(
        withText: true,
      )
    ],
  );
}

CustomCardContent homeCard(ThemeData theme) {
  return CustomCardContent(
    header: [
      CustomIconButton(
        "assets/icon/calendar.svg",
        colorBackground: Colors.transparent,
        iconColorCustom: ColorNeutral.gray,
        text: "14 Sabtu",
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
        onPressed: () => {},
        colorBackground: ColorNeutral.black,
      )
    ],
    otherWidget: [
      Text(
        "Kamu memiliki",
        style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
      ),
      Text(
        "5 Kegiatan di Bulan September 🔥",
        softWrap: true,
        textWidthBasis: TextWidthBasis.parent,
        style: theme.textTheme.displayMedium!.copyWith(
          fontSize: 32,
        ),
      ),
      Divider(
        color: ColorNeutral.gray,
        thickness: 1,
      ),
    ],
    crumbs: ["webinar", "juri", "pengawas"],
  );
}

CustomCardContent statsCard(ThemeData theme) {
  return CustomCardContent(
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
        style: theme.textTheme.bodyMedium!.copyWith(fontSize: 14),
      ),
      Stack(
        children: [
          Positioned(
            left: 118,
            child: ProfileIcon(
              "assets/icon/profile.png",
              imageSize: 60,
            ),
          ),
          Positioned(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Ardian           ,kamu telah melakukan ",
                    style: theme.textTheme.bodyMedium!.copyWith(fontSize: 36),
                  ),
                  TextSpan(
                    text: "40 penugasan ",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "dalam",
                    style: theme.textTheme.bodyMedium!.copyWith(fontSize: 36),
                  ),
                  TextSpan(
                    text: " setahun ini",
                    style: theme.textTheme.bodyMedium!
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
    crumbs: ["🧑‍🏫 Pemateri", "⚖️ Juri", "🤖 AI"],
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

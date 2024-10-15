import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomIconButton(
          "assets/icon/notification.svg",
          colorBackground: ColorNeutral.white,
          onPressed: () => {},
          size: IconSize.medium,
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
          bottom: state == NavbarState.task ? 120 : 30, // Adjust the off-screen position
          duration: const Duration(milliseconds: 300), // Animation duration
          curve: Curves.easeInOut,
          child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                )
        ),
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

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

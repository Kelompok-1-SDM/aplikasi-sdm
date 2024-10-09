import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

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
    return Stack(alignment: Alignment.bottomCenter, children: [
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
                transitionBuilder: (Widget child, Animation<double> animation) {
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
                  isSelected: state == NavbarState.calendar,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
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
                  isSelected: state == NavbarState.home,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
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
                  isSelected: state == NavbarState.task,
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
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
        isSelected: true,
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
        "assets/icon/share.svg",
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
        "assets/icon/share.svg",
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
            child: ProfileIcon("assets/icon/profile.png"),
          ),
          Positioned(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Ardian           ,kamu\ntelah melakukan\n",
                    style: theme.textTheme.bodyMedium!.copyWith(fontSize: 36),
                  ),
                  TextSpan(
                    text: "40 penugasan\n",
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
        spacing: 4,
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

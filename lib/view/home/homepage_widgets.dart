import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final BuildContext context;
  final NavbarState state;
  final Function(int) onItemSelected;

  const Navbar(this.context,
      {super.key, required this.state, required this.onItemSelected});

  @override
  Widget build(BuildContext _) {
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
              CustomIconButton(
                context,
                "assets/icon/calendar-bold.svg",
                onPressed: () => {
                  onItemSelected(1),
                },
                size: IconSize.large,
                padding: EdgeInsets.zero,
                colorBackground: ColorNeutral.black,
                isSelected: state == NavbarState.calendar,
              ),
              CustomIconButton(
                context,
                "assets/icon/home.svg",
                onPressed: () => {
                  onItemSelected(0),
                },
                size: IconSize.large,
                padding: EdgeInsets.zero,
                colorBackground: ColorNeutral.black,
                isSelected: state == NavbarState.home,
              ),
              CustomIconButton(
                context,
                "assets/icon/category-bold.svg",
                onPressed: () => {
                  onItemSelected(2),
                },
                size: IconSize.large,
                padding: EdgeInsets.zero,
                colorBackground: ColorNeutral.black,
                isSelected: state == NavbarState.task,
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

CustomCard currentTask(BuildContext context) {
  return CustomCard(
    context,
    header: [
      Text(
        "Tugas yang sedang berlangsung",
        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
      ),
    ],
    title: "Pemateri Semminar Teknnologi Informasi",
    actionIcon: [
      CustomIconButton(
        context,
        "assets/icon/category.svg",
        colorBackground: ColorNeutral.black,
        isSelected: true,
      )
    ],
    colorBackground: ColorNeutral.white,
    descIcon: [
      CustomIconButton(
        context,
        "assets/icon/location.svg",
        colorBackground: Colors.transparent,
        text: "Auditorium Lt. 8, Teknik Sipil",
      )
    ],
    otherWidget: [LiveChatButton(context)],
  );
}

CustomCard homeCard(BuildContext context) {
  return CustomCard(
    context,
    header: [
      CustomIconButton(
        context,
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
        context,
        "assets/icon/share.svg",
        colorBackground: ColorNeutral.white,
      ),
      CustomIconButton(
        context,
        "assets/icon/calendar.svg",
        colorBackground: ColorNeutral.black,
      )
    ],
    otherWidget: [
      Text(
        "Kamu memiliki",
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
      ),
      Text(
        "5 Kegiatan di Bulan September 🔥",
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
    crumbs: ["webinar", "juri", "pengawas"],
  );
}

CustomCard statsCard(BuildContext context) {
  return CustomCard(
    context,
    header: [
      CustomIconButton(
        context,
        "assets/icon/stats.svg",
        // padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        colorBackground: ColorNeutral.black,
      )
    ],
    actionIcon: [
      CustomIconButton(
        context,
        "assets/icon/share.svg",
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
            left: 118,
            child: ProfileIcon("assets/icon/profile.png"),
          ),
          Positioned(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Ardian           ,kamu\ntelah melakukan\n",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 36),
                  ),
                  TextSpan(
                    text: "40 penugasan\n",
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
        spacing: 4,
        children: [
          Text("Ketuk untuk melihat lebih detail"),
          CustomIconButton(
            context,
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

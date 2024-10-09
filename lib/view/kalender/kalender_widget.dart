import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';

CustomCardContent currentTaskKalender(ThemeData theme) {
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
    colorBackground: ColorPrimary.orange,
    descIcon: [
      CustomIconButton(
        "assets/icon/location.svg",
        colorBackground: Colors.transparent,
        text: "Auditorium Lt. 8, Teknik Sipil",
      )
    ],
    otherWidget: [
      Container(
        child: Stack(
          children: [
            Positioned(
              child: Image.asset(
                "assets/icon/event.jpg",
              ),
            )
          ],
        ),
      ),
      LiveChatButton(
        withText: false,
      ),
    ],
  );
}

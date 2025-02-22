import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/home/home_model.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui; // Alias the dart:ui import

GenericCard profileCard(
    ThemeData theme, UserData user, double average, Color color) {
  String desc = average > 5
      ? "Bagus • Si Rajin"
      : average < 5 && average > 3
          ? "Newbie • Dibiasakan yaa.."
          : "Dipantau • Hati-hati";
  return GenericCard(
    child: SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.nama,
              style: theme.textTheme.displayLarge!.copyWith(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 13,
            ),
            Text(
              desc,
              style: theme.textTheme.displayLarge!.copyWith(
                color: color,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Text(
              user.nip,
              style: theme.textTheme.bodySmall!.copyWith(
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Text(
              user.email,
              style: theme.textTheme.bodySmall!.copyWith(
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Text(
              "Jika data anda tidak sesuai, harap hubungi admin",
              style: theme.textTheme.bodySmall!.copyWith(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

CustomCardContent statsCardProfile(
    ThemeData theme, String? imageProfile, VoidCallback share,
    {required Color color, required Statistik stats}) {
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
    "${stats.firstName},kamu telah melakukan ",
    theme.textTheme.bodyMedium!.copyWith(fontSize: 36),
  );
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
        onPressed: share,
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
            left: textWidth - 384,
            child: ProfileIcon(
              imageProfile ?? "assets/icon/profile.png",
              borderColor: color,
              imageSize: 60,
            ),
          ),
          Positioned(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "${stats.firstName}             ,kamu telah melakukan ",
                    style: theme.textTheme.bodyMedium!.copyWith(fontSize: 36),
                  ),
                  TextSpan(
                    text: "${stats.totalDalamSetahun} penugasan ",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "selama ini ",
                    style: theme.textTheme.bodyMedium!.copyWith(fontSize: 36),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      StatisticChart(color: color, stats: stats)
    ],
  );
}

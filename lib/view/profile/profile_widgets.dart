import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';

GenericCard profileCard(ThemeData theme) {
  return GenericCard(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 13,
          direction: Axis.vertical,
          children: [
            Text(
              "Ardian Budiono",
              style: theme.textTheme.displayLarge!.copyWith(
                fontSize: 24,
              ),
            ),
            Text(
              "Bagus • Si Rajin",
              style: theme.textTheme.displayLarge!.copyWith(
                color: ColorPrimary.green,
                fontSize: 14,
              ),
            ),
            Text(
              "2241760089",
              style: theme.textTheme.bodySmall!.copyWith(
                fontSize: 14,
              ),
            ),
            Text(
              "ardianbudiono@gmail.com",
              style: theme.textTheme.bodySmall!.copyWith(
                fontSize: 14,
              ),
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

CustomCardContent kompetensiCard(ThemeData theme) {
  return CustomCardContent(
    header: [
      Text(
        "Kompetensi yang dikuasai",
        style: theme.textTheme.displayMedium!.copyWith(
          fontSize: 16,
        ),
      ),
    ],
    description: "Kompetensi berdasarkan penugasan yang telah dilakukan",
    crumbs: [
      "⚖️ Juri",
      "🧑‍🏫 Pemateri",
      "🤖 Iot",
      "🤖 AI",
      "✨ Teknologi",
      "🧠 Penalaran",
    ],
  );
}

CustomCardContent statsCardProfile(ThemeData theme) {
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
                    text: "di",
                    style: theme.textTheme.bodyMedium!.copyWith(fontSize: 36),
                  ),
                  TextSpan(
                    text: "tahun 2024 ",
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
      ),
      StatisticChart()
    ],
  );
}

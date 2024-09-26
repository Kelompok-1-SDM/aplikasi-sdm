import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/presentation/global_components.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Container currentTask() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 24),
    decoration: ShapeDecoration(
      color: ColorNeutral.white,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 40,
          cornerSmoothing: 0.6,
        ),
      ),
    ),
    child: Column(
      children: [
        cardHeader(
            cardTitle: const Text(
              "Tugas yang sedang berlangsung",
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            cardOption: [
              iconButtonCustom("assets/icon/category.svg",
                  backgroundColor: ColorNeutral.black)
            ]),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pemateri Seminar Teknologi\nInformasi",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis),
              ),
              TextButton.icon(
                  onPressed: () => {},
                  style: const ButtonStyle(
                      shadowColor: WidgetStatePropertyAll(ColorNeutral.gray),
                      padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                  label: const Text("Auditorium Lt. 8, Teknik Sipil",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: ColorNeutral.black)),
                  icon: SvgPicture.asset(
                    "assets/icon/location.svg",
                    semanticsLabel: 'Location',
                    colorFilter: const ColorFilter.mode(
                        ColorNeutral.gray, BlendMode.srcIn),
                  )),
              Container(
                padding: const EdgeInsets.fromLTRB(14, 6, 8, 6),
                decoration: ShapeDecoration(
                  color: ColorNeutral.black,
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 40,
                      cornerSmoothing: 0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Positioned(
                              child: profileIcon("assets/icon/profile-1.png")),
                          Positioned(
                              left: 40,
                              child: profileIcon("assets/icon/profile-2.png")),
                          Positioned(
                              left: 80,
                              child: profileIcon("assets/icon/profile-3.png")),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: const Text(
                        "Live chat",
                        style: TextStyle(
                            color: ColorNeutral.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                    ),
                    iconButtonCustom("assets/icon/chat.svg",
                        backgroundColor: ColorNeutral.gray)
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Container homeCard() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
    decoration: ShapeDecoration(
      color: const Color(0xFF40DDB3),
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 40,
          cornerSmoothing: 0.6,
        ),
      ),
    ),
    child: Column(
      children: [
        cardHeader(
            cardTitle: TextButton.icon(
              onPressed: () => {},
              label: const Text(
                '14 Sabtu',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: ColorNeutral.black),
              ),
              style: const ButtonStyle(
                  shadowColor: WidgetStatePropertyAll(ColorNeutral.gray),
                  padding: WidgetStatePropertyAll(EdgeInsets.zero)),
              icon: SvgPicture.asset("assets/icon/calendar.svg",
                  semanticsLabel: 'Calendar',
                  colorFilter: const ColorFilter.mode(
                      ColorNeutral.gray, BlendMode.srcIn)),
            ),
            cardOption: [
              iconButtonCustom(
                "assets/icon/share.svg",
                padding:
                    const EdgeInsets.symmetric(vertical: 11, horizontal: 13),
              ),
              iconButtonCustom(
                "assets/icon/calendar.svg",
                backgroundColor: ColorNeutral.black,
              )
            ]),
        const SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kamu memiliki",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              Text(
                "5 Kegiatan di\nBulan September 🔥",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        const Divider(
          color: ColorNeutral.black,
        ),
        const SizedBox(
          height: 17,
        ),
        SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [crumbs("webinar"), crumbs("juri"), crumbs("pengawas")],
          ),
        )
      ],
    ),
  );
}

Container statsCard() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
    decoration: ShapeDecoration(
      color: ColorNeutral.white,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 40,
          cornerSmoothing: 0.6,
        ),
      ),
    ),
    child: Column(
      children: [
        cardHeader(
            cardTitle: iconButtonCustom("assets/icon/stats.svg",
                backgroundColor: ColorNeutral.black,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12)),
            cardOption: [
              iconButtonCustom("assets/icon/share.svg",
                  backgroundColor: ColorNeutral.background,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16))
            ]),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Statistik",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              Stack(
                children: [
                  Positioned(
                      left: 118, child: profileIcon("assets/icon/profile.png")),
                  Positioned(
                      child: RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                          text: "Ardian          ,kamu\ntelah melakukan\n",
                          style: TextStyle(
                              fontFamily: 'Plus Jakarta',
                              fontWeight: FontWeight.w400,
                              fontSize: 36,
                              color: ColorNeutral.black)),
                      TextSpan(
                          text: "40 penugasan\n",
                          style: TextStyle(
                              fontFamily: 'Plus Jakarta',
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              color: ColorNeutral.black)),
                      TextSpan(
                          text: "dalam",
                          style: TextStyle(
                              fontFamily: 'Plus Jakarta',
                              fontWeight: FontWeight.w400,
                              fontSize: 36,
                              color: ColorNeutral.black)),
                      TextSpan(
                          text: " setahun ini",
                          style: TextStyle(
                              fontFamily: 'Plus Jakarta',
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              color: ColorNeutral.black)),
                    ]),
                  )),
                ],
              ),
              TextButton.icon(
                onPressed: () => {},
                style: const ButtonStyle(
                    shadowColor: WidgetStatePropertyAll(ColorNeutral.gray),
                    padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                label: const Text(
                  "Ketuk untuk melihat lebih detail",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: ColorNeutral.black),
                ),
                icon: SizedBox(
                  width: 40,
                  height: 40,
                  child: iconButtonCustom("assets/icon/arrow-45.svg",
                      backgroundColor: ColorNeutral.black),
                ),
                iconAlignment: IconAlignment.end,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              crumbs("🧑‍🏫 Pemateri",
                  colorBackground: ColorNeutral.background),
              crumbs("⚖️ Juri", colorBackground: ColorNeutral.background),
              crumbs("🤖 AI", colorBackground: ColorNeutral.background)
            ],
          ),
        ),
      ],
    ),
  );
}

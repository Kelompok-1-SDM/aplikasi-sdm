import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

IconButton profileIcon(String asset) {
  return IconButton(
      onPressed: () {
        // Handle button press
      },
      padding: EdgeInsets.zero,
      icon: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorPrimary.green,
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
        width: 50,
        child: SizedBox(
          child: ClipOval(
            child: Image.asset(
              asset,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ));
}

SizedBox homeAppbar() {
  return SizedBox(
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        iconButtonCustom("assets/icon/notification.svg"),
        const SizedBox(
          width: 16,
        ),
        profileIcon("assets/icon/profile.png")
      ],
    ),
  );
}

Container navbar() {
  return Container(
    height: 114,
    width: double.infinity,
    color: Colors.transparent,
    child: Row(
      children: [Text("asdsadasdsadasd")],
    ),
  );
}

IconButton iconButtonCustom(String assetLocation,
    {Color backgroundColor = ColorNeutral.white,
    EdgeInsetsGeometry padding = const EdgeInsets.all(12)}) {
  var iconColor = backgroundColor == ColorNeutral.black ||
          backgroundColor == ColorNeutral.gray
      ? ColorNeutral.white
      : ColorNeutral.black;

  SvgPicture svg = SvgPicture.asset(assetLocation,
      semanticsLabel: 'Icon',
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn));

  return IconButton(
    padding: padding,
    style:
        ButtonStyle(backgroundColor: WidgetStateProperty.all(backgroundColor)),
    icon: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle, // Rounded corners
        ),
        child: SizedBox(
          child: svg,
        )),
    onPressed: () {},
  );
}

Wrap genericCard() {
  return const Wrap();
}

Container crumbs(String title, {Color colorBackground = ColorNeutral.white}) {
  Color textColor;
  switch (colorBackground) {
    case ColorNeutral.white:
      textColor = ColorNeutral.gray;
      break;

    case ColorNeutral.background:
      textColor = ColorNeutral.black;
      break;

    default:
      textColor = ColorNeutral.white;
  }
  return Container(
    margin: const EdgeInsets.only(right: 7),
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
    decoration: ShapeDecoration(
      color: colorBackground,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 13,
        ),
      ),
    ),
    child: Text(
      title,
      style: TextStyle(
          color: textColor, fontWeight: FontWeight.w600, fontSize: 16),
    ),
  );
}

SizedBox cardHeader(
    {required Widget cardTitle, required List<Widget> cardOption}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        Positioned(child: cardTitle),
        Positioned(
            right: 0,
            child: Wrap(
              spacing: 12,
              children: cardOption,
            ))
      ],
    ),
  );
}

Container taskTawaranCard(
    {required String title,
    required String tanggal,
    required String lokasi,
    required List<String> tags,
    required Color backgroundColor}) {
  List<Widget> cr = tags.map((element) {
    return crumbs(element, colorBackground: ColorNeutral.black);
  }).toList();

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 24),
    decoration: ShapeDecoration(
      color: backgroundColor,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 40,
          cornerSmoothing: 0.6,
        ),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cardHeader(
            cardTitle: const Text(
              "Kamu mendapat tawaran penugasan",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
            ),
            cardOption: [
              iconButtonCustom("assets/icon/arrow-45.svg",
                  backgroundColor: ColorNeutral.black)
            ]),
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 32,
              overflow: TextOverflow.ellipsis),
        ),
        TextButton.icon(
            onPressed: () => {},
            style: const ButtonStyle(
                shadowColor: WidgetStatePropertyAll(ColorNeutral.gray),
                padding: WidgetStatePropertyAll(EdgeInsets.zero)),
            label: Text(tanggal,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: ColorNeutral.black)),
            icon: SvgPicture.asset(
              "assets/icon/calendar-small.svg",
              semanticsLabel: 'Calendar',
              colorFilter:
                  const ColorFilter.mode(ColorNeutral.gray, BlendMode.srcIn),
            )),
        TextButton.icon(
            onPressed: () => {},
            style: const ButtonStyle(
                shadowColor: WidgetStatePropertyAll(ColorNeutral.gray),
                padding: WidgetStatePropertyAll(EdgeInsets.zero)),
            label: Text(lokasi,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: ColorNeutral.black)),
            icon: SvgPicture.asset(
              "assets/icon/location.svg",
              semanticsLabel: 'Location',
              colorFilter:
                  const ColorFilter.mode(ColorNeutral.gray, BlendMode.srcIn),
            )),
        SizedBox(
          width: double.infinity,
          child:
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: cr),
        )
      ],
    ),
  );
}

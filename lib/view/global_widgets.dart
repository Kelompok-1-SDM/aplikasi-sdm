import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileIcon extends StatelessWidget {
  final String assetLocation;
  final double imageSize;
  final Color borderColor;
  final VoidCallback? onPressed;

  const ProfileIcon(this.assetLocation,
      {super.key,
      this.imageSize = 48,
      this.borderColor = ColorPrimary.green,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    // was sized box
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: borderColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ClipOval(
            child: Image.asset(
              assetLocation,
              fit: BoxFit.cover,
              width: imageSize,
              height: imageSize,
            ),
          ),
        ),
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  final BuildContext context;
  const HomeAppBar(this.context, {super.key});

  @override
  Widget build(BuildContext _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Wrap(
          children: [
            CustomIconButton(
              context,
              "assets/icon/notification.svg",
              colorBackground: ColorNeutral.white,
              size: IconSize.medium,
            ),
            SizedBox(
              width: 16,
            ),
            ProfileIcon("assets/icon/profile.png")
          ],
        ),
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final BuildContext context;
  final String? text;
  final double size;
  final String assetLocation;
  final Color? iconColorCustom;
  final Color colorBackground;
  final bool wasTextInRight;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressed;
  final bool isSelected;

  const CustomIconButton(this.context, this.assetLocation,
      {super.key,
      required this.colorBackground,
      this.padding = const EdgeInsets.all(12),
      this.isSelected = true,
      this.size = IconSize.small,
      this.onPressed,
      this.text,
      this.wasTextInRight = true,
      this.iconColorCustom});

  @override
  Widget build(BuildContext _) {
    Color iconColor;

    if (colorBackground == ColorNeutral.black ||
        colorBackground == ColorNeutral.gray) {
      iconColor = ColorNeutral.white;
    } else {
      iconColor = ColorNeutral.black;
    }

    if (iconColorCustom != null) {
      iconColor = iconColorCustom!;
    }

    SvgPicture svg = SvgPicture.asset(
      assetLocation,
      height: size,
      width: size,
      semanticsLabel: 'Icon',
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    );

    if (text == null) {
      return IconButton(
        padding: padding,
        isSelected: isSelected,
        selectedIcon: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: SizedBox(height: size, width: size, child: svg),
        ),
        icon: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            height: size,
            width: size,
            child: SvgPicture.asset(
              assetLocation,
              height: size,
              width: size,
              semanticsLabel: 'Icon',
              colorFilter: ColorFilter.mode(
                ColorNeutral.gray,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorBackground),
        ),
      );
    }
    return TextButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(colorBackground),
      ),
      iconAlignment: wasTextInRight ? IconAlignment.start : IconAlignment.end,
      label: Text(
        text!,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),
        maxLines: 1,
      ),
      icon: SizedBox(
        height: size,
        width: size,
        child: svg,
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final BuildContext context;
  final List<Widget> header;
  final String? title;
  final String? description;
  final Color colorBackground;
  final List<Widget>? actionIcon;
  final List<Widget>? iconText;
  final List<Widget>? descIcon;
  final List<String>? crumbs;
  final List<Widget>? otherWidget;

  const CustomCard(
    this.context, {
    super.key,
    required this.header,
    this.title,
    this.description,
    this.colorBackground = ColorNeutral.white,
    this.actionIcon,
    this.descIcon,
    this.crumbs,
    this.iconText,
    this.otherWidget,
  });

  @override
  Widget build(BuildContext _) {
    // Check if crumbs are null before using them
    List<Widget> crumbsWidget =
        crumbs?.map((it) => _crumbWidget(it)).toList() ?? [];
    double maxWidth = MediaQuery.of(context).size.width - 70;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 40,
          cornerSmoothing: 0.6,
        ),
      ),
      color: colorBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            spacing: 8,
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.start,
            // clipBehavior: Clip.,
            children: [
              SizedBox(
                width: maxWidth,
                height: 50,
                child: _cardHeader(),
              ),
              if (title != null)
                SizedBox(
                  width: maxWidth,
                  child: Text(
                    title!,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: 32,
                        ),
                    maxLines: 2,
                  ),
                ),
              if (descIcon != null) ...descIcon!,
              if (otherWidget != null)
                ...otherWidget!.map(
                  (it) => SizedBox(
                    width: maxWidth,
                    child: it,
                  ),
                ),
              Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                spacing: 7,
                children: crumbsWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack _cardHeader() {
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.centerLeft,
      children: [
        Wrap(
          children: header, // Left-aligned header content
        ),
        if (actionIcon != null)
          Positioned(
            right: 0,
            child: Wrap(
              children: actionIcon!, // Right-aligned action icons
            ),
          )
      ],
    );
  }

  Container _crumbWidget(String title) {
    Color textColor = ColorNeutral.black, crumbsBackground;
    switch (colorBackground) {
      case ColorNeutral.white:
        crumbsBackground = ColorNeutral.background;
        break;

      case const Color(0xFF40DDB3):
        crumbsBackground = ColorNeutral.white;
        break;

      default:
        crumbsBackground = ColorNeutral.black;
        textColor = ColorNeutral.white;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: ShapeDecoration(
        color: crumbsBackground,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 13,
          ),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 16,
              color: textColor,
            ),
      ),
    );
  }
}

class LiveChatButton extends StatelessWidget {
  final BuildContext context;
  const LiveChatButton(this.context, {super.key});

  @override
  Widget build(BuildContext _) {
    return Card(
      elevation: 0,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 45,
          cornerSmoothing: 0.6,
        ),
      ),
      color: ColorNeutral.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 133,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(child: ProfileIcon("assets/icon/profile-1.png")),
                  Positioned(
                      left: 40,
                      child: ProfileIcon("assets/icon/profile-2.png")),
                  Positioned(
                      left: 80,
                      child: ProfileIcon("assets/icon/profile-3.png")),
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
            CustomIconButton(
              context,
              "assets/icon/chat.svg",
              size: IconSize.large,
              // padding: EdgeInsets.all(12),
              colorBackground: ColorNeutral.gray,
              onPressed: () => {},
            )
          ],
        ),
      ),
    );
  }
}

CustomCard taskTawaranCard(BuildContext context,
    {required String title,
    required String tanggal,
    required String lokasi,
    required List<String> tags,
    required Color backgroundColor}) {
  return CustomCard(
    context,
    header: [
      Text(
        "Kamu mendapat tawaran penugasan",
        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
      ),
    ],
    actionIcon: [
      CustomIconButton(
        context,
        "assets/icon/arrow-45.svg",
        size: IconSize.medium,
        padding: EdgeInsets.zero,
        colorBackground: ColorNeutral.black,
      )
    ],
    colorBackground: backgroundColor,
    title: title,
    descIcon: [
      CustomIconButton(
        context,
        "assets/icon/calendar.svg",
        colorBackground: Colors.transparent,
        iconColorCustom: ColorNeutral.gray,
        text: tanggal,
      ),
      CustomIconButton(
        context,
        "assets/icon/location.svg",
        colorBackground: Colors.transparent,
        iconColorCustom: ColorNeutral.gray,
        text: lokasi,
      )
    ],
    crumbs: tags,
  );
}

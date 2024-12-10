import 'dart:math';
import 'dart:ui';

import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/services/home/home_model.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ProfileIcon extends StatelessWidget {
  final String assetLocation;
  final double imageSize;
  final Color borderColor;
  final VoidCallback? onPressed;

  const ProfileIcon(
    this.assetLocation, {
    super.key,
    this.imageSize = 50,
    this.borderColor =
        ColorPrimary.green, // Replace with your ColorPrimary.green
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Check if assetLocation is a valid URL or asset path
    bool isUrl = Uri.tryParse(assetLocation)?.hasAbsolutePath ?? false;

    return InkWell(
      borderRadius: BorderRadius.circular(imageSize / 2),
      onTap: onPressed,
      child: Container(
        width: imageSize,
        height: imageSize,
        padding: const EdgeInsets.all(2), // Padding for the border outline
        decoration: BoxDecoration(
          color: borderColor, // The border color (outline)
          shape: BoxShape.circle, // Makes the outline circular
        ),
        child: ClipOval(
          clipBehavior: Clip.hardEdge,
          child: isUrl
              ? Image.network(
                  assetLocation,
                  fit: BoxFit.cover, // Ensures the image fits within the circle
                  width: imageSize,
                  height: imageSize,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_profile.png', // Default image in case of error
                      fit: BoxFit.cover,
                      width: imageSize,
                      height: imageSize,
                    );
                  },
                )
              : Image.asset(
                  assetLocation,
                  fit: BoxFit.cover, // Ensures the image fits within the circle
                  width: imageSize,
                  height: imageSize,
                ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final String? text;
  final double size;
  final dynamic assetLocation;
  final Color? iconColorCustom;
  final Color colorBackground;
  final bool wasTextInRight;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressed;
  final bool isNotSelectable;

  const CustomIconButton(this.assetLocation,
      {super.key,
      required this.colorBackground,
      this.padding = const EdgeInsets.all(12),
      this.isNotSelectable = true,
      this.size = 24.0, // Default icon size for optimization
      this.onPressed,
      this.text,
      this.wasTextInRight = true,
      this.iconColorCustom});

  @override
  Widget build(BuildContext context) {
    // Determine the icon color based on background or custom color
    Color iconColor = iconColorCustom ??
        (colorBackground == ColorNeutral.black ||
                colorBackground == ColorNeutral.gray
            ? ColorNeutral.white
            : ColorNeutral.black);

    // Create the selected and unselected icons
    Widget buildIcon({required Color color, required String semanticsLabel}) {
      return assetLocation is String
          ? SvgPicture.asset(
              assetLocation,
              height: size,
              width: size,
              semanticsLabel: semanticsLabel,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            )
          : Icon(
              assetLocation,
              size: size,
              color: color,
              semanticLabel: semanticsLabel,
            );
    }

    Widget icon = buildIcon(color: iconColor, semanticsLabel: "Icon");
    Widget unSelectedIcon =
        buildIcon(color: ColorNeutral.gray, semanticsLabel: "Icon disabled");

    if (text == null) {
      return IconButton(
        padding: padding,
        iconSize: size,
        isSelected: isNotSelectable,
        selectedIcon: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: size / 2,
          child: icon,
        ),
        icon: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: size / 2,
          child: unSelectedIcon,
        ),
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorBackground),
        ),
      );
    }

    return TextButton.icon(
      onPressed: onPressed,
      iconAlignment: wasTextInRight ? IconAlignment.start : IconAlignment.end,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        backgroundColor: WidgetStateProperty.all(colorBackground),
      ),
      icon: SizedBox(
        height: size,
        width: size,
        child: !isNotSelectable ? unSelectedIcon : icon,
      ),
      label: Text(
        text!,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontSize: 12, color: iconColor),
        maxLines: 1,
      ),
    );
  }
}

class CustomCardContent extends StatelessWidget {
  final List<Widget> header;
  final double? height;
  final String? title;
  final String? description;
  final Color colorBackground;
  final List<CustomIconButton>? actionIcon;
  final List<CustomIconButton>? descIcon;
  final List<String>? crumbs;
  final List<Widget>? otherWidget;
  final VoidCallback? onPressed;

  const CustomCardContent({
    super.key,
    required this.header,
    this.title,
    this.description,
    this.colorBackground = ColorNeutral.white,
    this.actionIcon,
    this.descIcon,
    this.crumbs,
    this.otherWidget,
    this.onPressed,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Check if crumbs are null before using them
    List<Widget> crumbsWidget =
        crumbs?.map((it) => _crumbWidget(it, context)).toList() ?? [];
    double maxWidth = MediaQuery.of(context).size.width - 70;

    return GenericCard(
      backgroundColor: colorBackground,
      onPressed: onPressed,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 25, bottom: 25, left: 20, right: 20),
        child: SizedBox(
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(),
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: SizedBox(
                    width: maxWidth,
                    child: Text(
                      title!,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 32,
                              ),
                      maxLines: 2,
                    ),
                  ),
                ),
              if (description != null)
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      description!,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              if (descIcon != null)
                ...descIcon!.map((it) => Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: it,
                    )),
              if (otherWidget != null)
                ...otherWidget!.map(
                  (it) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: it,
                  ),
                ),
              if (crumbsWidget.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      spacing: 7,
                      runSpacing: 8,
                      children: crumbsWidget,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Row _cardHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 220,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: header,
          ),
        ),
        if (actionIcon != null)
          Wrap(
            spacing: 12,
            children: actionIcon!, // Right-aligned action icons
          ),
      ],
    );
  }

  Container _crumbWidget(String title, BuildContext context) {
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
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 16,
              color: textColor,
            ),
      ),
    );
  }
}

class GenericCard extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final bool wasFromButton;
  final Widget child;
  final bool wasElevated;

  const GenericCard(
      {super.key,
      this.onPressed,
      this.backgroundColor = ColorNeutral.white,
      required this.child,
      this.wasElevated = false,
      this.wasFromButton = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(
        Radius.circular(60),
      ),
      onTap: onPressed,
      child: Card.filled(
        clipBehavior: Clip.antiAlias,
        elevation: wasElevated ? 5 : 0,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 40,
            cornerSmoothing: wasFromButton ? 0 : .6,
          ),
        ),
        color: backgroundColor,
        child: child,
      ),
    );
  }
}

class CustomBigButton extends StatelessWidget {
  final Color buttonColor;
  final String? buttonLabel;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final bool wasIconOnRight;
  final CustomIconButton? icon;
  final double maxWidth;
  final List<Widget>? otherWidget;
  final bool wasElevated;
  final Color? customLabelColor;

  const CustomBigButton({
    super.key,
    this.wasElevated = false,
    this.buttonColor = ColorNeutral.black,
    this.icon,
    this.buttonLabel,
    required this.onPressed,
    this.wasIconOnRight = false,
    this.otherWidget,
    this.padding = const EdgeInsets.all(8),
    this.customLabelColor,
    this.maxWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = customLabelColor ??
        (buttonColor == ColorNeutral.black
            ? ColorNeutral.white
            : ColorNeutral.black);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: GenericCard(
        wasFromButton: true,
        backgroundColor: buttonColor,
        wasElevated: wasElevated,
        onPressed: onPressed,
        child: Padding(
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: otherWidget != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                if (icon != null && !wasIconOnRight) icon!,
                if (buttonLabel == null && otherWidget != null)
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: otherWidget!,
                    ),
                  ),
                if (buttonLabel != null)
                  Text(
                    buttonLabel!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 24,
                          color: textColor,
                        ),
                  ),
                if (icon != null && wasIconOnRight) icon!,
              ],
            )),
      ),
    );
  }
}

// class LiveChatButton extends StatelessWidget {
//   final String idKegiatan;
//   const LiveChatButton({super.key, required this.idKegiatan});

//   @override
//   Widget build(BuildContext context) {
//     return CustomBigButton(
//       wasIconOnRight: true,
//       padding: EdgeInsets.only(top: 8, right: 8, bottom: 8, left: 32),
//       otherWidget: [
//         Text(
//           "Live chat",
//           style: TextStyle(
//               color: ColorNeutral.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 20),
//         )
//       ],
//       onPressed: () =>
//           {Navigator.pushNamed(context, '/livechat', arguments: idKegiatan)},
//       icon: CustomIconButton(
//         "assets/icon/chat.svg",
//         size: IconSize.large,
//         colorBackground: ColorNeutral.gray,
//       ),
//     );
//   }
// }

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final TextInputType inputType;
  final IconData? customIcon;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.inputType = TextInputType.text,
    this.customIcon,
    required this.hint,
    this.controller, // Default icon for password
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller: Use the provided one or create a new one
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // Dispose of the controller if it was created here
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            widget.label,
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14),
          ),
        ),
        SizedBox(height: 8),
        TextField(
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.inputType,
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            hintText: widget.hint,
            hintStyle:
                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 24, // Adjust as needed
                cornerSmoothing: 0.6, // Smoothness level
              ),
              borderSide: BorderSide(
                  color: ColorNeutral.black, width: 1), // Outline color
            ),
            suffixIcon: widget.isPassword || widget.customIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(
                        icon: Icon(
                          widget.customIcon ??
                              (widget.isPassword
                                  ? (_obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility)
                                  : null),
                        ),
                        onPressed: widget.isPassword
                            ? () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              }
                            : null),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class CustomBottomSheet extends StatelessWidget {
  final Widget? child;
  final Text? title;
  final String? desc;
  final List<CustomBigButton>? button;
  final EdgeInsets padding;
  final ScrollController? scrollController;

  const CustomBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.desc,
    this.button,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 29),
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final content = [
      if (title != null) ...[
        title!,
        SizedBox(height: 12),
      ],
      if (desc != null) ...[
        Text(
          desc!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14,
              ),
        ),
        SizedBox(height: 20),
      ],
      if (child != null) ...[
        child!,
        SizedBox(height: 56),
      ],
      if (button != null)
        ...button!.map(
          (it) => Padding(
            padding: EdgeInsets.only(top: 10),
            child: it,
          ),
        ),
    ];

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: ShapeDecoration(
        color: ColorNeutral.white,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.only(
            topLeft: SmoothRadius(cornerRadius: 40, cornerSmoothing: 0.6),
            topRight: SmoothRadius(cornerRadius: 40, cornerSmoothing: 0.6),
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 62,
            height: 7,
            decoration: BoxDecoration(
              color: ColorNeutral.background,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          SizedBox(height: 21),
          Expanded(
            child: ListView(
              controller: scrollController,
              shrinkWrap: true,
              children: content,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageLoader extends StatelessWidget {
  final String imageUrl;
  final bool showCaption;
  final String caption;
  final String author;
  final String authorUrl;

  const ImageLoader({
    super.key,
    required this.imageUrl,
    this.showCaption = true,
    required this.caption,
    required this.author,
    required this.authorUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image container with squircle shape
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: Container(
            decoration: ShapeDecoration(
              color: ColorNeutral.background.withOpacity(0.5),
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 16,
                  cornerSmoothing: 0.6,
                ),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: !imageUrl.startsWith("http")
                ? Image.asset(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        // Conditionally showing the caption
        if (showCaption)
          Positioned(
            bottom: 16,
            left: 16,
            child: _buildCaption(caption, author),
          ),
      ],
    );
  }

  // Function to build caption container with blurred background
  Widget _buildCaption(String caption, String author) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(24), // Ensures the blur stays within bounds
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Apply blur effect
        child: Container(
          decoration: ShapeDecoration(
            color: ColorNeutral.background.withOpacity(0.5),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 24,
                cornerSmoothing: 0.6,
              ),
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Avatar placeholder (replace with actual avatar if needed)
              ProfileIcon(
                authorUrl,
                imageSize: 40,
              ),
              const SizedBox(width: 8),
              // Caption and author text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caption,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'oleh $author',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatisticChart extends StatefulWidget {
  final Color color;
  final Statistik stats;

  const StatisticChart({super.key, required this.color, required this.stats});

  @override
  State<StatisticChart> createState() => _StatisticChartState();
}

class _StatisticChartState extends State<StatisticChart> {
  int _selectedYear = DateTime.now().year; // Default to the current year
  late List<JumlahKegiatan> _filteredKegiatan;

  @override
  void initState() {
    super.initState();
    _filterDataByYear();
  }

  void _filterDataByYear() {
    setState(() {
      _filteredKegiatan = widget.stats.jumlahKegiatan
              ?.where((kegiatan) => kegiatan.year == _selectedYear)
              .toList() ??
          [];
    });
  }

  List<FlSpot> _generateChartData() {
    List<FlSpot> spots = [];
    for (int i = 1; i <= 12; i++) {
      final kegiatan = _filteredKegiatan.firstWhere(
        (item) => item.month == i,
        orElse: () => JumlahKegiatan(month: i, jumlahKegiatan: 0),
      );
      spots.add(
          FlSpot(i.toDouble() - 1, (kegiatan.jumlahKegiatan ?? 0).toDouble()));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Statistik $_selectedYear",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                      ),
                ),
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: ShapeDecoration(
                      color: ColorNeutral.black,
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 20,
                          cornerSmoothing: .6,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<int>(
                          value: _selectedYear,
                          dropdownColor: ColorNeutral.black,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: ColorNeutral
                                .white, // Adjust the color to match the theme
                          ),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: ColorNeutral.white,
                                  ),
                          items: _getDropdownItems(context),
                          onChanged: (year) {
                            if (year != null) {
                              setState(() {
                                _selectedYear = year;
                                _filterDataByYear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  drawHorizontalLine: true,
                  horizontalInterval: 2,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        const monthNames = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'Mei',
                          'Jun',
                          'Jul',
                          'Agu',
                          'Sep',
                          'Okt',
                          'Nov',
                          'Des'
                        ];
                        final monthIndex = value.toInt();
                        final hasData = _filteredKegiatan
                            .any((item) => item.month == monthIndex + 1);
                        return Padding(
                          padding: const EdgeInsets.all(0),
                          child: Transform.rotate(
                            angle: -0.785398, // 45 degrees in radians
                            child: Text(
                              monthNames[monthIndex],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 10,
                                    color: hasData
                                        ? ColorNeutral.black
                                        : ColorNeutral.background,
                                  ),
                            ),
                          ),
                        );
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, _) {
                        return Text(
                          value.toInt().toString(),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontSize: 14,
                              ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: false), // Remove right Y-axis numbers
                  ),
                  topTitles: AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: false), // No numbers on the top
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: widget.color,
                    dotData: FlDotData(show: false),
                    spots: _generateChartData(),
                    isStepLineChart: false,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> _getDropdownItems(BuildContext context) {
    final years = widget.stats.jumlahKegiatan
            ?.map((item) => item.year)
            .toSet()
            .toList()
            .whereType<int>()
            .toList() ??
        [];
    years.sort();
    return years
        .map((year) => DropdownMenuItem<int>(
              value: year,
              child: Text(
                year.toString(),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontSize: 14, color: ColorNeutral.white),
              ),
            ))
        .toList();
  }
}

CustomCardContent tawaranTugasCard(
  BuildContext context, {
  required String kegiatanId,
  required String title,
  required DateTime tanggal,
  required String lokasi,
  required Color backgroundColor,
}) {
  String formattedDate =
      DateFormat.yMMMd().add_jm().format(tanggal); // format to local string
  return CustomCardContent(
    header: [
      Text(
        "Kamu akan menghadiri",
        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
      ),
    ],
    actionIcon: [
      CustomIconButton(
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
        "assets/icon/calendar.svg",
        colorBackground: Colors.transparent,
        iconColorCustom: ColorNeutral.gray,
        text: formattedDate,
      ),
      CustomIconButton(
        "assets/icon/location.svg",
        colorBackground: Colors.transparent,
        iconColorCustom: ColorNeutral.gray,
        text: lokasi,
      )
    ],
    onPressed: () => {
      Navigator.pushNamed(
        context,
        "/detail_kegiatan",
        arguments: kegiatanId,
      )
    },
  );
}

void callBottomSheet(
  BuildContext context, {
  Widget? child,
  required Text title,
  required List<CustomBigButton> button,
  String? description,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final isContentMinimal = constraints.maxHeight < 860;

          return AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: DraggableScrollableSheet(
              initialChildSize: isContentMinimal ? 0.5 : 0.6,
              minChildSize: isContentMinimal ? 0.5 : 0.6,
              maxChildSize: isContentMinimal ? 0.8 : 1.0,
              expand: false,
              builder: (context, scrollController) {
                return CustomBottomSheet(
                  title: title,
                  desc: description,
                  button: button,
                  child: child,
                  scrollController: scrollController,
                );
              },
            ),
          );
        },
      );
    },
  );
}

CustomCardContent kegiatanCard(BuildContext context,
    {required KegiatanResponse kegiatan,
    bool isFromDetail = false,
    bool isFromHistori = false}) {
  Color color;
  String title;
  DateTime normalizedDay = DateTime(
    kegiatan.tanggalMulai!.year,
    kegiatan.tanggalMulai!.month,
    kegiatan.tanggalMulai!.day,
  );
  DateTime now = DateTime.now();
  DateTime nowNormalized = DateTime(now.year, now.month, now.day);

  if (normalizedDay.isBefore(nowNormalized) && kegiatan.isDone!) {
    title = "Kamu telah melaksanakan kegiatan";
    color = ColorCard.done;
  } else if (normalizedDay.isAfter(nowNormalized)) {
    title = "Kamu akan menghadiri kegiatan";
    List<Color> colors = [ColorCard.tasked1, ColorCard.tasked2];
    Random random = Random();
    int randomIndex = random.nextInt(colors.length);
    color = colors[randomIndex];
  } else {
    title = "Kamu sedang melaksanakan";
    color = ColorCard.working;
  }
  return CustomCardContent(
    header: [Text(title)],
    title: kegiatan.judul,
    actionIcon: [
      if (!isFromDetail)
        CustomIconButton(
          isFromHistori
              ? "assets/icon/category.svg"
              : "assets/icon/arrow-45.svg",
          colorBackground: ColorNeutral.black,
        )
    ],
    colorBackground: color,
    descIcon: [
      CustomIconButton(
        "assets/icon/calendar.svg",
        colorBackground: Colors.transparent,
        text: DateFormat.yMMMd().add_jm().format(kegiatan.tanggalMulai!),
      ),
      CustomIconButton(
        "assets/icon/location.svg",
        colorBackground: Colors.transparent,
        text: kegiatan.lokasi,
      ),
    ],
    onPressed: !isFromDetail
        ? () => {
              Navigator.pushNamed(
                context,
                "/detail_kegiatan",
                arguments: kegiatan.kegiatanId,
              )
            }
        : null,
  );
}

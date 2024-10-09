import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfileIcon extends StatelessWidget {
  final String assetLocation;
  final double imageSize;
  final Color borderColor;
  final VoidCallback? onPressed;

  const ProfileIcon(
    this.assetLocation, {
    super.key,
    this.imageSize = 44,
    this.borderColor =
        ColorPrimary.green, // Replace with your ColorPrimary.green
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(imageSize / 2), // Ensure it's circular
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: borderColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
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
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        CustomIconButton(
          "assets/icon/notification.svg",
          colorBackground: ColorNeutral.white,
          onPressed: () => {},
          size: IconSize.medium,
        ),
        ProfileIcon(
          "assets/icon/profile.png",
          onPressed: () => {Navigator.pushNamed(context, "/profile")},
        )
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final String? text;
  final double size;
  final String assetLocation;
  final Color? iconColorCustom;
  final Color colorBackground;
  final bool wasTextInRight;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressed;
  final bool isSelected;

  const CustomIconButton(this.assetLocation,
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
  Widget build(BuildContext context) {
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
      return IconButton.filled(
        padding: padding,
        isSelected: isSelected,
        iconSize: size,
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
        iconSize: WidgetStateProperty.all(size),
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

class CustomCardContent extends StatelessWidget {
  final List<Widget> header;
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
        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            spacing: 8,
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.start,
            clipBehavior: Clip.antiAlias,
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
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 7,
                  runSpacing: 8,
                  children: crumbsWidget,
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
        Wrap(
          children: header, // Left-aligned header content
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
  final Widget child;
  final bool wasElevated;

  const GenericCard(
      {super.key,
      this.onPressed,
      this.backgroundColor = ColorNeutral.white,
      required this.child,
      this.wasElevated = false});

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
            cornerSmoothing: 0.6,
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
  final List<Widget> otherWidget;
  final bool wasElevated;

  const CustomBigButton({
    super.key,
    this.wasElevated = false,
    this.buttonColor = ColorNeutral.black,
    this.icon,
    this.buttonLabel,
    required this.onPressed,
    this.wasIconOnRight = false,
    required this.otherWidget,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      backgroundColor: buttonColor,
      wasElevated: wasElevated,
      onPressed: onPressed,
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (icon != null && !wasIconOnRight) icon!,
            if (buttonLabel == null) ...otherWidget,
            if (buttonLabel != null)
              Text(
                buttonLabel!,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontSize: 24),
              ),
            if (icon != null && wasIconOnRight) icon!,
          ],
        ),
      ),
    );
  }
}

class LiveChatButton extends StatelessWidget {
  const LiveChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBigButton(
      wasIconOnRight: true,
      otherWidget: [
        SizedBox(
          width: 134,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                child: ProfileIcon(
                  "assets/icon/profile-1.png",
                  imageSize: 50,
                ),
              ),
              Positioned(
                left: 40,
                child: ProfileIcon(
                  "assets/icon/profile-2.png",
                  imageSize: 50,
                ),
              ),
              Positioned(
                left: 80,
                child: ProfileIcon(
                  "assets/icon/profile-3.png",
                  imageSize: 50,
                ),
              ),
            ],
          ),
        ),
        const Text(
          "Live chat",
          style: TextStyle(
              color: ColorNeutral.white,
              fontWeight: FontWeight.w700,
              fontSize: 20),
        )
      ],
      onPressed: () => {},
      icon: CustomIconButton(
        "assets/icon/chat.svg",
        size: IconSize.large,
        colorBackground: ColorNeutral.gray,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final TextInputType inputType;
  final IconData customIcon;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.inputType = TextInputType.text,
    this.customIcon = Icons.visibility_off,
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
                cornerRadius: 28, // Adjust as needed
                cornerSmoothing: 0.6, // Smoothness level
              ),
              borderSide: BorderSide(
                  color: ColorNeutral.black, width: 1), // Outline color
            ),
            suffixIcon: widget.isPassword
                ? Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(
                      icon: Icon(
                        _obscureText ? widget.customIcon : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

// Custom TableCalendar class
class CustomTableCalendar extends StatefulWidget {
  final Map<DateTime, List<Event>> events;

  const CustomTableCalendar({super.key, required this.events});

  @override
  _CustomTableCalendarState createState() => _CustomTableCalendarState();
}

class _CustomTableCalendarState extends State<CustomTableCalendar>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now(); // To control focused month
  DateTime _currentDay = DateTime.now(); // To track the current day
  late AnimationController _controller; // For animations
  bool _showButton = false; // To control button visibility

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      child: Column(
        children: [
          // The TableCalendar widget
          TableCalendar(
            locale: 'id_ID',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay =
                    focusedDay; // Update focused day to prevent month jump
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay =
                    focusedDay; // Update focused day when changing month
                _showButton = _focusedDay.month != _currentDay.month ||
                    _focusedDay.year != _currentDay.year;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: Icon(Icons.chevron_left),
              rightChevronIcon: Icon(Icons.chevron_right),
              titleTextStyle:
                  Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 20,
                      ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14),
              weekendStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: ColorNeutral.black,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: ColorNeutral.black,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: ColorNeutral.black,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
              markerSizeScale: 0.3,
              outsideDaysVisible: false,
              defaultTextStyle:
                  Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 18,
                      ),
            ),
            eventLoader: (day) => widget.events[day] ?? [],
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  final event = events.first as Event;
                  return _buildEventMarker(event.type);
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 16),
          // Footer explaining colors
          _buildFooter(),
        ],
      ),
    );
  }

  // Method to build the event markers
  Widget _buildEventMarker(String eventType) {
    switch (eventType) {
      case 'upcoming':
        return _eventCircleMarker(ColorPrimary.green);
      case 'completed':
        return _eventCircleMarker(ColorPrimary.blue);
      case 'missed':
        return _eventCircleMarker(ColorPrimary.orange);
      default:
        return SizedBox.shrink();
    }
  }

  // Helper method to build event circle marker
  Widget _eventCircleMarker(Color color) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 1.5),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: 8.0,
      height: 8.0,
    );
  }

  // Footer explaining event color meanings
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, bottom: 24, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColorIndicator(ColorPrimary.green, 'Acara yang mendatang'),
              _buildColorIndicator(
                  ColorPrimary.blue, 'Acara yang sudah dilaksanakan'),
              _buildColorIndicator(
                  ColorPrimary.orange, 'Acara yang tidak dihadiri'),
            ],
          ),
          if (_showButton)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: _showButton
                  ? 0
                  : 100, // Adjust left position based on visibility
              child: ElevatedButton(
                onPressed: _goToCurrentDate,
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                  backgroundColor: ColorNeutral.black,
                ),
                child: Text(
                  '${_currentDay.day}',
                  style: TextStyle(color: ColorNeutral.white, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build the color explanation
  Widget _buildColorIndicator(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  // Method to navigate to the current date
  void _goToCurrentDate() {
    setState(() {
      _focusedDay = _currentDay; // Set focused day to current day
      _selectedDay = _currentDay; // Update selected day
      _showButton = false; // Hide button after navigating to current date
    });
  }
}

// Event class to represent each event
class Event {
  final String type;
  Event(this.type);
}

class CustomBottomSheet extends StatelessWidget {
  final Widget? child;
  final Text? title;
  final String? desc;
  final List<CustomBigButton>? button;

  const CustomBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.desc,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 29),
      decoration: ShapeDecoration(
        color: ColorNeutral.white,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.only(
            topLeft: SmoothRadius(cornerRadius: 40, cornerSmoothing: 0.6),
            topRight: SmoothRadius(cornerRadius: 40, cornerSmoothing: 0.6),
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: IntrinsicHeight(
              // Makes the container shrink to fit its content
              child: Column(
                children: [
                  // Pull handle at the top of the BottomSheet
                  Container(
                    width: 62,
                    height: 7,
                    decoration: BoxDecoration(
                      color: ColorNeutral.background,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 21,
                      left: 29,
                      right: 29,
                      bottom: 62,
                    ),
                    child: Column(
                      children: [
                        if (title != null) title!,
                        SizedBox(
                          height: 12,
                        ),
                        if (desc != null)
                          Text(
                            desc!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                ),
                          ),
                        SizedBox(height: 20),
                        if (child != null) child!,
                        SizedBox(
                          height: 56,
                        ),
                        if (button != null)
                          ...button!.map(
                            (it) => Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: it,
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

CustomCardContent tawaranTugasCard(
  ThemeData theme, {
  required String title,
  required String tanggal,
  required String lokasi,
  required List<String> tags,
  required Color backgroundColor,
}) {
  return CustomCardContent(
    header: [
      Text(
        "Kamu mendapat tawaran penugasan",
        style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
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
        text: tanggal,
      ),
      CustomIconButton(
        "assets/icon/location.svg",
        colorBackground: Colors.transparent,
        iconColorCustom: ColorNeutral.gray,
        text: lokasi,
      )
    ],
    crumbs: tags,
  );
}

void callBottomSheet(
  BuildContext context, {
  child,
  required title,
  required List<CustomBigButton> button,
  String? description,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor:
        Colors.transparent, // Transparent background for custom shape
    builder: (context) {
      return CustomBottomSheet(
        child: child,
        title: title,
        desc: description,
        button: button,
      ); // Content defined below
    },
    isScrollControlled: true, // Allows control over the BottomSheet's height
  );
}

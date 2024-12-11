  import 'dart:math';

import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventData {
  final bool isDone;
  final DateTime tanggalMulai;
  final DateTime tanggalAkhir;

  EventData({
    required this.isDone,
    required this.tanggalMulai,
    required this.tanggalAkhir,
  });
}

// Custom TableCalendar class
class CustomTableCalendar extends StatefulWidget {
  final Map<DateTime, EventData> events;
  final Function(DateTime) onDateSelected; // Added callback

  const CustomTableCalendar({
    super.key,
    required this.events,
    required this.onDateSelected, // Required callback parameter
  });

  @override
  _CustomTableCalendarState createState() => _CustomTableCalendarState();
}

class _CustomTableCalendarState extends State<CustomTableCalendar>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final DateTime _currentDay = DateTime.now();
  late AnimationController _controller;
  bool _showButton = false;

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
                _focusedDay = focusedDay;
              });
              // Call the callback to notify parent state
              widget.onDateSelected(selectedDay);
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
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
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: ColorNeutral.black,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                border: Border.all(
                  color: ColorNeutral.black,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
              markerSizeScale: 0.3,
              outsideDaysVisible: false,
              selectedTextStyle: TextStyle(color: ColorNeutral.black),
            ),
            eventLoader: (day) {
              // Normalize the day parameter to midnight
              DateTime normalizedDay = DateTime(day.year, day.month, day.day);

              // Retrieve events using the normalized key
              if (widget.events.containsKey(normalizedDay)) {
                return [widget.events[normalizedDay]!];
              }
              return [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                // Print to debug the contents of events and check if normalization works
                if (events.isNotEmpty) {
                  final eventData = events.first as EventData;
                  return _buildEventMarker(eventData);
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 16),
          _buildFooter(),
        ],
      ),
    );
  }

  // Build marker based on event type and date
  Widget _buildEventMarker(EventData eventData) {
    if (!eventData.isDone) {
      return _eventCircleMarker(ColorPrimary.green); // Upcoming event
    } else if (eventData.isDone) {
      return _eventCircleMarker(ColorPrimary.blue); // Completed event
    } else {
      return SizedBox.shrink();
    }
  }

  // Helper method to build event circle marker
  Widget _eventCircleMarker(Color color) {
    return Container(
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
    return SizedBox(
      height: 76,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, bottom: 24, right: 30),
        child: Stack(
          children: [
            // Color indicators
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildColorIndicator(
                    ColorPrimary.green,
                    'Acara yang mendatang/belum selesai',
                  ),
                  _buildColorIndicator(
                    ColorPrimary.blue,
                    'Acara yang sudah selesai',
                  ),
                ],
              ),
            ),
            // Floating button
            if (_showButton)
              Positioned(
                bottom: 0,
                right: 0,
                child: ElevatedButton(
                  onPressed: _goToCurrentDate,
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                    backgroundColor: ColorNeutral.black,
                  ),
                  child: Text(
                    '${_currentDay.day}',
                    style: TextStyle(color: ColorNeutral.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the color explanation
  Widget _buildColorIndicator(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  // Method to navigate to the current date
  void _goToCurrentDate() {
    setState(() {
      _focusedDay = _currentDay;
      _selectedDay = _currentDay;
      _showButton = false;
    });
  }
}

// Seminar card widget
CustomCardContent seminarCard(
    {required BuildContext context, required KegiatanResponse kegiatan}) {
  List<Color> colors = [ColorCard.tasked1, ColorCard.tasked2];
  Random random = Random();
  int randomIndex = random.nextInt(colors.length);

  Color color = colors[randomIndex];
  return CustomCardContent(
    colorBackground: kegiatan.tanggalMulai!.isAfter(DateTime.now()) && !kegiatan.isDone!
        ? color
        : kegiatan.tanggalAkhir!.isBefore(DateTime.now()) && kegiatan.isDone!
            ? ColorCard.done
            : ColorCard.working,
    header: [
      Text(kegiatan.tanggalMulai!.isAfter(DateTime.now()) && !kegiatan.isDone!
          ? "Kegiatan yang akan datang"
          : kegiatan.tanggalAkhir!.isBefore(DateTime.now()) && kegiatan.isDone!
              ? "Kegiatan yang sudah dilaksanakan"
              : "Kegiatan yang sedang berlangsung")
    ],
    actionIcon: [
      CustomIconButton(
        "assets/icon/category.svg",
        colorBackground: ColorNeutral.black,
      )
    ],
    title: kegiatan.judul,
    descIcon: [
      CustomIconButton(
        "assets/icon/location.svg",
        colorBackground: Colors.transparent,
        text: kegiatan.lokasi,
      ),
    ],
    // otherWidget: [
    //   // Add the LiveChatButton here
    //   LiveChatButton(
    //     idKegiatan: kegiatan.kegiatanId!,
    //   ),
    // ],
    onPressed: () => {
      Navigator.pushNamed(
        context,
        "/detail_kegiatan",
        arguments: kegiatan.kegiatanId,
      )
    },
  );
}

class CalendarBottomSheet extends StatelessWidget {
  final Widget? child;
  final Text? title;
  final String? desc;
  final List<CustomBigButton>? button;
  final EdgeInsets padding;

  const CalendarBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.desc,
    this.button,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 29),
  });

  @override
  Widget build(BuildContext context) {
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
        mainAxisSize: MainAxisSize.min,
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
              bottom: 62,
            ),
            child: Column(
              children: [
                if (title != null)
                  Column(
                    children: [
                      title!,
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                if (desc != null)
                  Column(
                    children: [
                      Text(
                        desc!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                if (child != null)
                  Column(
                    children: [
                      child!,
                      SizedBox(
                        height: 56,
                      ),
                    ],
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
    );
  }
}

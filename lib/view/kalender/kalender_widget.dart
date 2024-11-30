import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../services/kegiatan/kegiatan_model.dart';

// Custom TableCalendar class
class CustomTableCalendar extends StatefulWidget {
  final Map<DateTime, String> events;
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
              return widget.events.containsKey(normalizedDay)
                  ? [widget.events[normalizedDay]!]
                  : [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                // Print to debug the contents of events and check if normalization works
                if (events.isNotEmpty) {
                  final eventStatus = events.first as String;
                  return _buildEventMarker(date, eventStatus);
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
  Widget _buildEventMarker(DateTime eventDate, String eventType) {
    if (eventType == 'ditugaskan' && eventDate.isBefore(_currentDay)) {
      return _eventCircleMarker(ColorPrimary.orange); // Missed event indicator
    } else if (eventType == 'ditugaskan') {
      return _eventCircleMarker(ColorPrimary.green); // Upcoming event
    } else if (eventType == 'selesai') {
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
              _buildColorIndicator(ColorPrimary.orange, 'Acara yang terlewat'),
            ],
          ),
          if (_showButton)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: _showButton ? 0 : 100,
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

class TimelineCalendar extends StatelessWidget {
  final DateTime taskStart; // Start time of the event
  final DateTime taskEnd; // End time of the event

  const TimelineCalendar({super.key, required this.taskStart, required this.taskEnd});

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress(taskStart, taskEnd);

    return SizedBox(
      width: 50, // Fixed width for the timeline
      child: Column(
        children: [
          // Top time label (start time)
          Text(
            DateFormat('HH:mm').format(taskStart),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),

          // Timeline vertical progress indicator
          Expanded(
            child: Stack(
              children: [
                // Background for the progress bar
                Container(
                  width: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // The orange progress bar based on the percentage of time passed
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: progress, // This sets the fill height
                    child: Container(
                      width: 8,
                      decoration: BoxDecoration(
                        color: Colors.orange, // Progress bar color
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Bottom time label (end time)
          Text(
            DateFormat('HH:mm').format(taskEnd),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  // Function to calculate progress (returns a value between 0 and 1)
  double calculateProgress(DateTime taskStart, DateTime taskEnd) {
    final totalDuration = taskEnd.difference(taskStart).inMinutes.toDouble();
    final timePassed =
        DateTime.now().difference(taskStart).inMinutes.toDouble();
    return (timePassed / totalDuration).clamp(0.0, 1.0);
  }
}

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
        isNotSelectable: true,
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
      ImageLoader(
        author: "Andika",
        imageUrl: "assets/icon/event.jpg",
        caption: 'Masih sepi nihh',
        authorUrl: 'assets/icon/profile-1.png',
      ),
      LiveChatButton(
        withText: false,
      ),
    ],
  );
}

// Seminar card widget
CustomCardContent seminarCard(ThemeData theme, Kegiatan apa) {
  return CustomCardContent(
    colorBackground: ColorPrimary.orange,
    header: [
      CustomIconButton(
        "assets/icon/category.svg",
        colorBackground: ColorNeutral.black,
      )
    ],
    otherWidget: [
      Text(
        "Tugas yang sedang berlangsung",
        style: theme.textTheme.bodyMedium!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        apa.judulKegiatan!,
        style: theme.textTheme.bodyMedium!.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Icon(Icons.location_on, color: ColorNeutral.black),
          const SizedBox(width: 4),
          Text(
            apa.lokasi!,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      const SizedBox(height: 16),
      // ImageLoader(
      //   author: "Andika",
      //   imageUrl: "assets/icon/event.jpg",
      //   caption: 'Masih sepi nihh',
      //   authorUrl: 'assets/icon/profile-1.png',
      // ),
      const SizedBox(height: 16),
      // Add the LiveChatButton here
      LiveChatButton(
        withText: false,
      ),
    ],
  );
}

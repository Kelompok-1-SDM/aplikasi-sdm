import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/home/homepage_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/kalender/kalender_widget.dart';
import 'package:flutter/material.dart';

class Kalender extends StatefulWidget {
  const Kalender({super.key});

  @override
  State<Kalender> createState() => _KalenderState();
}

class _KalenderState extends State<Kalender> {
  final Map<DateTime, List<Event>> _events = {
    DateTime.utc(2024, 9, 3): [Event('completed')],
    DateTime.utc(2024, 9, 10): [Event('completed')],
    DateTime.utc(2024, 9, 12): [Event('missed')],
    DateTime.utc(2024, 9, 16): [Event('upcoming')],
    DateTime.utc(2024, 9, 19): [Event('missed')],
    DateTime.utc(2024, 9, 30): [Event('upcoming')],
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return RefreshIndicator(
      color: ColorNeutral.black,
      onRefresh: () async {
        // Do something when refreshed
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 61),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    HomeAppBar(),
                    SizedBox(
                      height: 24,
                    ),
                    CustomTableCalendar(
                      events: _events,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            CustomBottomSheet(
              maxHeight: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  seminarCard(Theme.of(context)),
                  SizedBox(height: 200,)
                ],
              )),
          ],
        ),
      ),
    );
  }
}

import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/home/homepage_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/kalender/kalender.dart';
import 'package:aplikasi_manajemen_sdm/view/tugas/daftar_tugas.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(), // Your current home screen content
    Kalender(),
    DaftarTugas(),
  ];

  bool _isForward = true;
  void _onItemTapped(int index) {
    setState(() {
      _isForward = index > _selectedIndex; // Determines the slide direction
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Navbar(
        context,
        state: NavbarState.values[_selectedIndex],
        onItemSelected:
            _onItemTapped, // Pass the function to handle tab selection
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final slideAnimation = Tween<Offset>(
                begin: _isForward
                    ? const Offset(1.0, 0.0)
                    : const Offset(
                        -1.0, 0.0), // Right-to-left or left-to-right slide
                end: Offset.zero,
              ).animate(animation);

              return SlideTransition(
                position: slideAnimation,
                child: child,
              );
            },
            child: IndexedStack(
              key: ValueKey<int>(
                  _selectedIndex), // Important for AnimatedSwitcher to work correctly
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ColorNeutral.black,
      onRefresh: () async {
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 61),
        child: Column(
          children: [
            HomeAppBar(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 13,
                direction: Axis.vertical,
                children: [
                  // HomeAppBar(context),
                  const SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 7),
                        Text(
                          "Halo 👋 Ardian",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 20),
                        ),
                        Text(
                          "Mulai hari dengan\nmenjadi lebih produktif!",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            homeCard(context),
            const SizedBox(
              height: 13,
            ),
            currentTask(context),
            const SizedBox(
              height: 13,
            ),
            taskTawaranCard(context,
                title: "Pengawasan ujian masuk maba",
                tanggal: "12 Januari 2025, 08:00-12:00",
                lokasi: "Online",
                tags: ['pengawas', 'ujian', 'online'],
                backgroundColor: const Color(0xFFFFEB69)),
            const SizedBox(
              height: 13,
            ),
            taskTawaranCard(context,
                title: "Pemateri Seminar",
                tanggal: "30 September, 09:00-13:00",
                lokasi: "Aula Pertamina",
                tags: ['pemateri', 'iot'],
                backgroundColor: const Color(0xFF7C94FF)),
            const SizedBox(
              height: 13,
            ),
            statsCard(context),
            const SizedBox(
              height: 13,
            ),
            const Text(
              "Kamu sudah terkini",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                  color: ColorNeutral.gray),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}

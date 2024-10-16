import 'package:animations/animations.dart';
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
  int _selectedIndex = 1;
  final List<Widget> _pages = [
    const Kalender(key: ValueKey('kalender')),
    const HomeScreen(key: ValueKey('home')),
    const DaftarTugasDitugaskan(key: ValueKey('tasks-1')),
    const DaftarTugasHistori(key: ValueKey('tasks-2')),
  ];

  bool _isForward = true;

  void _onItemTapped(int index) {
    setState(() {
      _isForward = index > _selectedIndex;
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Navbar(
        state: NavbarState.values[_selectedIndex],
        onItemSelected:
            _onItemTapped, // Pass the function to handle tab selection
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 500),
        reverse: !_isForward, // Reverse animation when going backward
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: _pages[_selectedIndex],
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
        // Do something when refreshed
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 61),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [HomeAppBar(), headline(Theme.of(context))],
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            homeCard(
              Theme.of(context),
            ),
            const SizedBox(
              height: 13,
            ),
            currentTask(
              Theme.of(context),
            ),
            const SizedBox(
              height: 13,
            ),
            tawaranTugasCard(Theme.of(context),
                title: "Pengawasan ujian masuk maba",
                tanggal: "12 Januari 2025, 08:00-12:00",
                lokasi: "Online",
                tags: ['pengawas', 'ujian', 'online'],
                backgroundColor: const Color(0xFFFFEB69)),
            const SizedBox(
              height: 13,
            ),
            tawaranTugasCard(Theme.of(context),
                title: "Pemateri Seminar",
                tanggal: "30 September, 09:00-13:00",
                lokasi: "Aula Pertamina",
                tags: ['pemateri', 'iot'],
                backgroundColor: const Color(0xFF7C94FF)),
            const SizedBox(
              height: 13,
            ),
            statsCard(Theme.of(context)),
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

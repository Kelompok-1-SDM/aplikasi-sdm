import 'package:animations/animations.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/home/home_model.dart';
import 'package:aplikasi_manajemen_sdm/services/home/home_service.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
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
  bool _isForward = true;
  UserData? userdat;
  List<Widget>? _pages; // Nullable until data is loaded

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data on init
  }

  Future<void> fetchUserData() async {
    try {
      userdat = await Storage.getMyInfo();

      if (userdat == null) {
        throw Exception("User data not found");
      }

      setState(() {
        _pages = [
          Kalender(key: ValueKey('kalender'), userData: userdat!),
          HomeScreen(
            key: ValueKey('home'),
            onItemTapped: _onItemTapped, // Pass navigation function
            userData: userdat!, // Pass user data to HomeScreen
          ),
          DaftarTugasDitugaskan(key: ValueKey('tasks-1'), userData: userdat!),
          DaftarTugasHistori(key: ValueKey('tasks-2'), userData: userdat!),
        ];
      });
    } catch (e) {
      print("Error loading user data: $e");
      // Optionally handle errors, e.g., show error dialog
    }
  }

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
        onItemSelected: _onItemTapped, // Pass function to handle tab selection
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _pages == null
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : PageTransitionSwitcher(
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
              child: _pages![_selectedIndex], // Use loaded pages
            ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(int) onItemTapped;
  final UserData userData;

  const HomeScreen(
      {super.key, required this.onItemTapped, required this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeResponse? data;
  bool isLoading = true;
  final HomeService _homeService = HomeService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>(); // Key to trigger the RefreshIndicator

  @override
  void initState() {
    super.initState();
    // Trigger refresh when the page first loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show(); // Show the refresh indicator
      fetchData();
    });
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Show loading indicator during initial fetch
    });

    try {
      // Fetch home data from the API
      final BaseResponse<HomeResponse> response =
          await _homeService.fetchDataHome();

      if (response.success && response.data != null) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            data = response.data;
          });
        }
        print("Data fetched successfully");
      } else {
        if (mounted) {
          _showErrorDialog(context, "Fetch Failed",
              response.message); // Pass the current valid context
        }
      }
    } catch (e) {
      print("Error during data fetch: $e");
      if (mounted) {
        _showErrorDialog(context, "Error",
            "An error occurred while fetching data: $e"); // Pass the current valid context
      }
    } finally {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await fetchData(); // Refresh data using the existing fetchData method
  }

  void _showErrorDialog(
      BuildContext dialogContext, String title, String message) {
    showDialog(
      context: dialogContext, // Use the passed-in parent context
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key:
          _refreshIndicatorKey, // Key to trigger the indicator programmatically
      color: ColorNeutral.black,
      onRefresh: _refreshData,
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
                  children: [
                    HomeAppBar(
                      userdat: widget.userData,
                    ),
                    headline(
                        Theme.of(context), widget.userData.nama.split(' ')[0])
                  ],
                ),
              ),
            ),
            const SizedBox(height: 13),
            if (isLoading)
              // No need for loading indicator, RefreshIndicator is already shown
              SizedBox.shrink()
            else
              Column(
                children: [
                  homeCard(Theme.of(context), data?.jumlahTugasBulanSekarang,
                      widget.onItemTapped // Display home card with data
                      ),
                  const SizedBox(height: 13),
                  if (data?.tugasBerlangsung != null)
                    currentTask(
                      Theme.of(context),
                      data!.tugasBerlangsung, // Only show if data is available
                    ),
                  const SizedBox(height: 13),
                  if (data !=
                      null) // Check if data is not null before accessing it
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        data!.duaTugasTerbaru.length,
                        (index) => Column(
                          children: [
                            tawaranTugasCard(
                              Theme.of(context),
                              title: data!.duaTugasTerbaru[index].judulKegiatan,
                              tanggal: data!.duaTugasTerbaru[index].tanggal,
                              lokasi: data!.duaTugasTerbaru[index].lokasi,
                              tags: data!.duaTugasTerbaru[index].kompetensi.take(5).toList(),
                              backgroundColor: ColorRandom.getRandomColor(),
                            ),
                            const SizedBox(height: 13),
                          ],
                        ),
                      ),
                    ),
                  statsCard(Theme.of(context), data?.statistik,
                      widget.userData), // Always show stats card
                  const SizedBox(height: 13),
                  const Text(
                    "Kamu sudah terkini",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      fontSize: 20,
                      color: ColorNeutral.gray,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

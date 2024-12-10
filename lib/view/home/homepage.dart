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
import 'package:aplikasi_manajemen_sdm/view/kegiatan/daftar_kegiatan.dart';
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
  List<Widget>? _pages;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data on initial load
  }

  // Fetch user data and update the pages
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true; // Show loading indicator while fetching
    });

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
            onItemTapped: _onItemTapped,
            userData: userdat!,
          ),
          DaftarKegiatan(
            key: ValueKey('tasks-1'),
            userData: userdat!,
            isHistori: false,
          ),
          DaftarKegiatan(
            key: ValueKey('tasks-2'),
            userData: userdat!,
            isHistori: true,
          ),
        ];
      });
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
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
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async =>
          {await _fetchUserData()},
      child: Scaffold(
        floatingActionButton: Navbar(
          state: NavbarState.values[_selectedIndex],
          onItemSelected: _onItemTapped,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator()) // Show loading indicator
            : _pages == null
                ? Center(child: Text("No pages available")) // Error fallback
                : PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 500),
                    reverse: !_isForward,
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
                    child: _pages![_selectedIndex],
                  ),
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
  double avg = 0;
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
      double? apa = await Storage.getAvg();

      if (response.success && response.data != null) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            data = response.data;
            avg = apa!;
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
                  homeCard(
                      context,
                      data?.jumlahTugasBulanSekarang ??
                          JumlahTugasBulanSekarang(count: 0),
                      widget.onItemTapped // Display home card with data
                      ),
                  const SizedBox(height: 13),
                  if (data?.tugasBerlangsung != null)
                    Column(
                      children: [
                        currentTask(
                          Theme.of(context),
                          data!
                              .tugasBerlangsung, // Only show if data is available
                        ),
                        const SizedBox(height: 13),
                      ],
                    ),
                  if (data?.duaTugasTerbaru !=
                      null) // Check if data is not null before accessing it
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        data!.duaTugasTerbaru!.length,
                        (index) => Column(
                          children: [
                            kegiatanCard(context,
                                kegiatan: data!.duaTugasTerbaru![index]),
                            const SizedBox(height: 13),
                          ],
                        ),
                      ),
                    ),
                  statsCard(context, data?.statistik, widget.userData,
                      avg), // Always show stats card
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

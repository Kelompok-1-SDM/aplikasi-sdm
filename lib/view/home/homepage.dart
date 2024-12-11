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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Kalender(key: const ValueKey('kalender')),
      HomeScreen(
        key: const ValueKey('home'),
        onItemTapped: _onItemTapped,
      ),
      DaftarKegiatan(
        key: const ValueKey('tasks-1'),
        isHistori: false,
      ),
      DaftarKegiatan(
        key: const ValueKey('tasks-2'),
        isHistori: true,
      ),
    ];

    return Scaffold(
      floatingActionButton: Navbar(
        state: NavbarState.values[_selectedIndex],
        onItemSelected: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return pages[index];
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(int) onItemTapped;

  const HomeScreen({super.key, required this.onItemTapped});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeResponse? data;
  UserData? dataUser;

  bool isLoading = true;
  double avg = 0;
  final HomeService _homeService = HomeService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>(); // Key to trigger the RefreshIndicator
  final GlobalKey _homeCard = GlobalKey();
  final GlobalKey _statsCard = GlobalKey();

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
      final UserData? user = await Storage.getMyInfo();
      final BaseResponse<HomeResponse> response =
          await _homeService.fetchDataHome();
      double? apa = await Storage.getAvg();

      if (response.success && response.data != null) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            dataUser = user;
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
            if (isLoading)
              SizedBox.shrink()
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      HomeAppBar(
                        userdat: dataUser,
                      ),
                      headline(Theme.of(context), dataUser!.nama.split(' ')[0])
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
                  RepaintBoundary(
                    key: _homeCard,
                    child: homeCard(
                      context,
                      data?.jumlahTugasBulanSekarang ??
                          JumlahTugasBulanSekarang(count: 0),
                      widget.onItemTapped, // Display home card with data
                      () async {
                        await shareCardImage(_homeCard,
                            "Penugasan ${dataUser!.nama} pada bulan ini");
                      },
                    ),
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
                  RepaintBoundary(
                    key: _statsCard,
                    child: statsCard(
                      context,
                      data?.statistik,
                      dataUser!,
                      avg,
                      () async {
                        await shareCardImage(_statsCard, "Statistik ${dataUser!.nama} pada tahun ini");
                      },
                    ),
                  ), // Always show stats card
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

import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';

class DaftarTugasDitugaskan extends StatelessWidget {
  const DaftarTugasDitugaskan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tawaran Penugasan'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://example.com/profile_pic.jpg',
              ),
            ),
            CustomCardContent(
              header: [Text("Kamu sedang menghadiri")],
              title: "Pemateri Seminar Teknologi Informasi",
              actionIcon: [
                CustomIconButton(
                  "assets/icon/arrow-45.svg",
                  colorBackground: ColorNeutral.black,
                )
              ],
              colorBackground: ColorPrimary.orange,
              descIcon: [
                CustomIconButton(
                  "assets/icon/calendar.svg",
                  colorBackground: Colors.transparent,
                  text: "12 Januari, 08:00-12:00",
                ),
                CustomIconButton(
                  "assets/icon/location.svg",
                  colorBackground: Colors.transparent,
                  text: "Auditorium Lt.8, Teknik Sipil",
                ),
              ],
              crumbs: ['ujicoba'],
            ),
            CustomCardContent(
              header: [Text("Kamu akan menghadiri acara ini")],
              title: "Pengawas ujian masuk maba",
              actionIcon: [
                CustomIconButton(
                  "assets/icon/arrow-45.svg",
                  colorBackground: ColorNeutral.black,
                )
              ],
              colorBackground: const Color(0xFFFFEB69),
              descIcon: [
                CustomIconButton(
                  "assets/icon/calendar.svg",
                  colorBackground: Colors.transparent,
                  text: "12 Januari 2025, 08:00-12:00",
                ),
                CustomIconButton(
                  "assets/icon/location.svg",
                  colorBackground: Colors.transparent,
                  text: "Online",
                ),
              ],
              crumbs: ['pengawas', 'ujian', 'online'],
            ),
            CustomCardContent(
              header: [Text("Kamu akan menghadiri acara ini")],
              title: "Bantu dekorasi ruang studio",
              actionIcon: [
                CustomIconButton(
                  "assets/icon/arrow-45.svg",
                  colorBackground: ColorNeutral.black,
                )
              ],
              colorBackground: ColorPrimary.green,
              descIcon: [
                CustomIconButton(
                  "assets/icon/calendar.svg",
                  colorBackground: Colors.transparent,
                  text: "12 Januari 2025, 08:00-12:00",
                ),
                CustomIconButton(
                  "assets/icon/location.svg",
                  colorBackground: Colors.transparent,
                  text: "Ruang studio, Lt.8, Gedung Teknik Sipil",
                ),
              ],
              crumbs: ['dekorasi'],
            ),
            const Text(
              "Belum ada penawaran baru",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                  color: ColorNeutral.gray),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      label: Text('Tawaran'),
                      selected: selectedIndex == 0,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      selectedColor: Colors.white,
                      backgroundColor: Colors.black,
                      labelStyle: TextStyle(
                        color: selectedIndex == 0 ? Colors.black : Colors.white,
                      ),
                    ),
                    ChoiceChip(
                      label: Text('Ditugaskan'),
                      selected: selectedIndex == 1,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      selectedColor: Colors.white,
                      backgroundColor: Colors.black,
                      labelStyle: TextStyle(
                        color: selectedIndex == 1 ? Colors.black : Colors.white,
                      ),
                    ),
                    ChoiceChip(
                      label: Text('Histori'),
                      selected: selectedIndex == 2,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedIndex = 2;
                        });
                      },
                      selectedColor: Colors.white,
                      backgroundColor: Colors.black,
                      labelStyle: TextStyle(
                        color: selectedIndex == 2 ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Navigation Bar section
          Container(
            height: 60,
            width: double.infinity, // Expand to full width of the screen
            child: Center(
              child: Container(
                width: 300, // Fixed width for the bottom navigation bar
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25), // Rounded edges
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today, color: Colors.grey[600]),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, color: Colors.grey[600]),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.apps, color: Colors.white),
                      label: '',
                    ),
                  ],
                  currentIndex: selectedIndex,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.grey[600],
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index; // Handle bottom navigation tap
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DaftarTugasHistori extends StatelessWidget {
  const DaftarTugasHistori({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            HomeAppBar(),
            CustomBigButton(
              buttonLabel: "Ke Detail tugas",
              buttonColor: ColorNeutral.black,
              onPressed: () => {Navigator.pushNamed(context, "/detail_tugas")},
              otherWidget: [],
            ),
            CustomCardContent(
              header: [Text("Kamu telah menghadiri acara ini")],
              title: "Seminar di Auper",
              actionIcon: [
                CustomIconButton(
                  "assets/icon/category.svg",
                  colorBackground: ColorNeutral.black,
                )
              ],
              colorBackground: ColorPrimary.blue,
              descIcon: [
                CustomIconButton(
                  "assets/icon/calendar.svg",
                  colorBackground: Colors.transparent,
                  text: "12 Januari, 08:00-12:00",
                ),
                CustomIconButton(
                  "assets/icon/location.svg",
                  colorBackground: Colors.transparent,
                  text: "Aula Pertamina",
                ),
              ],
              crumbs: ['pengawas', 'ujian', 'online'],
            ),
            CustomCardContent(
              header: [Text("Kamu telah menghadiri acara ini")],
              title: "Juri lomba aplikasi",
              actionIcon: [
                CustomIconButton(
                  "assets/icon/category.svg",
                  colorBackground: ColorNeutral.black,
                )
              ],
              colorBackground: ColorPrimary.blue,
              descIcon: [
                CustomIconButton(
                  "assets/icon/calendar.svg",
                  colorBackground: Colors.transparent,
                  text: "12 Juli, Sampai selesai",
                ),
                CustomIconButton(
                  "assets/icon/location.svg",
                  colorBackground: Colors.transparent,
                  text: " Gedung Teknik Sipil",
                ),
              ],
              crumbs: ['juri'],
            ),
            const Text(
              "Hanya itu yang kami temukan",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                  color: ColorNeutral.gray),
            ),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}

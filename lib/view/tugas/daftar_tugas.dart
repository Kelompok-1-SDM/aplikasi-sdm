import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            "2024",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TaskCard(
            title: 'Uji coba bandwith Gedung Teksip',
            date: '12 Desember, Sampai selesai',
            location: 'Gedung Teknik Sipil',
            tag: 'ujicoba',
            color: Colors.orange,
          ),
          Text(
            "2025",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TaskCard(
            title: 'Pengawasan ujian masuk maba',
            date: '12 Januari 2025, 08:00 - 12:00',
            location: 'Online',
            tag: 'pengawas',
            color: Colors.yellow,
          ),
          TaskCard(
            title: 'Bantu dekorasi ruang studio',
            date: '12 Januari 2025, 08:00 - 12:00',
            location: 'Ruang studio Lt.1, Gedung Teknik Sipil',
            tag: 'dekorasi',
            color: Colors.green,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Belum ada penawaran baru",
                style: TextStyle(color: Colors.grey),
              ),
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

class TaskCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String tag;
  final Color color;

  TaskCard({
    required this.title,
    required this.date,
    required this.location,
    required this.tag,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.black),
              SizedBox(width: 4),
              Text(date, style: TextStyle(color: Colors.black)),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.black),
              SizedBox(width: 4),
              Text(location, style: TextStyle(color: Colors.black)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Chip(
                label: Text(tag),
                backgroundColor: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
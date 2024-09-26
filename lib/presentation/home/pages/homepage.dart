import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/presentation/global_components.dart';
import 'package:aplikasi_manajemen_sdm/presentation/home/widgets/components.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: navbar(),
      body: RefreshIndicator(
        color: ColorNeutral.black,
        onRefresh: () async {
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 61),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Column(
                  children: [
                    homeAppbar(),
                    const SizedBox(
                      height: 13,
                    ),
                    const SizedBox(
                      width: double.infinity,
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
              homeCard(),
              const SizedBox(
                height: 13,
              ),
              currentTask(),
              const SizedBox(
                height: 13,
              ),
              taskTawaranCard(
                  title: "Pengawasan ujian\nmasuk maba",
                  tanggal: "12 Januari 2025, 08:00-12:00",
                  lokasi: "Online",
                  tags: ['pengawas', 'ujian', 'online'],
                  backgroundColor: const Color(0xFFFFEB69)),
              const SizedBox(
                height: 13,
              ),
              taskTawaranCard(
                  title: "Pemateri Seminar",
                  tanggal: "30 September, 09:00-13:00",
                  lokasi: "Aula Pertamina",
                  tags: ['pemateri', 'iot'],
                  backgroundColor: const Color(0xFF7C94FF)),
              const SizedBox(
                height: 13,
              ),
              statsCard(),
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
            ],
          ),
        ),
      ),
    );
  }
}

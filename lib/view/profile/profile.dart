import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            GenericCard(child: Column(children: [Text("sadasdkasdhk")],),)
          ],
        ),
      ),
    );
  }
}

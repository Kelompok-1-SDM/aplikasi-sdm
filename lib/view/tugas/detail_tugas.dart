import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';

class DetailTugas extends StatefulWidget {
  const DetailTugas({super.key});

  @override
  State<DetailTugas> createState() => _DetailTugasState();
}

class _DetailTugasState extends State<DetailTugas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: ColorNeutral.black,
        onRefresh: () async {
          // Do something when refreshed
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 61),
          child: Column(
            children: [
              CustomBigButton(
                  buttonLabel: "Ke Livechat",
                  buttonColor: ColorNeutral.black,
                  onPressed: () =>
                      {Navigator.pushNamed(context, "/livechat")},
                  otherWidget: [])
            ],
          ),
        ),
      ),
    );
  }
}

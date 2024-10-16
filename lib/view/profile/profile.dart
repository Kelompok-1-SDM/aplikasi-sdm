import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/home/homepage_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/profile/profile_widgets.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 61),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    CustomIconButton(
                      Icons.chevron_left_rounded,
                      colorBackground: ColorNeutral.white,
                      size: IconSize.medium,
                      onPressed: () => {Navigator.pop(context)},
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  ProfileIcon(
                    "assets/icon/profile.png",
                    imageSize: 130,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CustomIconButton(Icons.edit_outlined,
                        size: IconSize.small,
                        colorBackground: ColorNeutral.white),
                  )
                ],
              ),
              SizedBox(
                height: 13,
              ),
              profileCard(
                Theme.of(context),
              ),
              statsCardProfile(Theme.of(context)),
              CustomBigButton(
                wasIconOnRight: true,
                onPressed: () => {Navigator.pushNamed(context, "/profile")},
                otherWidget: [],
                icon: CustomIconButton("assets/icon/lock.svg", colorBackground: Colors.white,),
                buttonColor: ColorNeutral.black,
                buttonLabel: "Ubah Password",
              ),
              CustomBigButton(
                maxWidth: 240,
                wasElevated: true,
                padding: EdgeInsets.only(
                  left: 34,
                  top: 8,
                  bottom: 8,
                  right: 6,
                ),
                wasIconOnRight: true,
                onPressed: () => {Navigator.pushNamed(context, "/auth")},
                otherWidget: [],
                icon: CustomIconButton("assets/icon/logout.svg", colorBackground: Colors.white, iconColorCustom: ColorPrimary.orange,),
                buttonColor: ColorPrimary.orange,
                customLabelColor: Colors.white,
                buttonLabel: "Logout",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

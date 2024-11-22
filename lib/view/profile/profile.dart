import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:aplikasi_manajemen_sdm/services/user/user_model.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/profile/profile_widgets.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserData userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      UserData apa = (await Storage.getMyInfo())!;
      setState(() {
        userData = apa;
      });
    } catch (e) {
      print("Error loading user data: $e");
      // Optionally handle errors, e.g., show error dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    print(userData.kompetensi);
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
                  if (userData != null)
                    ProfileIcon(
                      userData.profileImage,
                      imageSize: 130,
                    )
                  else
                    const SizedBox.shrink(),
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
               if (userData != null)
                CustomCardContent(
                  description:
                      "Kompetensi berdasarkan penugasan yang telah dilakukan",
                  crumbs: userData.kompetensi,
                  header: [
                    Text("Kompetensi yang dikuasai",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ]),
              CustomBigButton(
                wasIconOnRight: true,
                onPressed: () => {
                  callBottomSheet(
                    context,
                    title: Text(
                      "Ubah Password",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    button: [
                      CustomBigButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        onPressed: () => {Navigator.pop(context)},
                        otherWidget: [],
                        buttonColor: ColorNeutral.black,
                        customLabelColor: Colors.white,
                        buttonLabel: "Batal",
                      ),
                      CustomBigButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        onPressed: () => {
                          callBottomSheet(context,
                              title: Text(
                                "Apakah anda yakin mengubah password anda?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              button: [
                                CustomBigButton(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  onPressed: () => {Navigator.pop(context)},
                                  otherWidget: [],
                                  buttonColor: ColorNeutral.black,
                                  customLabelColor: Colors.white,
                                  buttonLabel: "Tidak",
                                ),
                                CustomBigButton(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  onPressed: () => {
                                    callBottomSheet(
                                      context,
                                      title: Text(
                                        "Password anda berhasil diperbarui",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                      button: [
                                        CustomBigButton(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 20),
                                          onPressed: () => {
                                            // Navigator.pushNamed(
                                            // context, "/profile"),
                                            Navigator.pop(context),
                                            Navigator.pop(context),
                                            Navigator.pop(context),
                                          },
                                          otherWidget: [],
                                          buttonColor: ColorNeutral.black,
                                          customLabelColor: Colors.white,
                                          buttonLabel: "Kembali ke profil",
                                        )
                                      ],
                                    )
                                  },
                                  otherWidget: [],
                                  buttonColor: ColorPrimary.orange,
                                  customLabelColor: Colors.white,
                                  buttonLabel: "Ya",
                                ),
                              ],
                              description:
                                  "Harap cek kembali password anda sebelum konfirmasi")
                        },
                        otherWidget: [],
                        buttonColor: ColorPrimary.orange,
                        customLabelColor: Colors.white,
                        buttonLabel: "Ubah",
                      ),
                    ],
                    child: Column(
                      children: [
                        CustomTextField(
                            label: "Password lama", hint: "password lama"),
                        CustomTextField(
                            label: "Password baru", hint: "password baru"),
                        CustomTextField(
                            label: "Konfirmasi password baru",
                            hint: "Konfirmasi password"),
                      ],
                    ),
                  )
                },
                otherWidget: [],
                icon: CustomIconButton(
                  "assets/icon/lock.svg",
                  colorBackground: Colors.white,
                ),
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
                onPressed: () async => {
                  await Storage.clearToken(),
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/auth', (route) => false)
                },
                otherWidget: [],
                icon: CustomIconButton(
                  "assets/icon/logout.svg",
                  colorBackground: Colors.white,
                  iconColorCustom: ColorPrimary.orange,
                ),
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

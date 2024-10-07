import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/auth/auth_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // Replace this with your actual authentication logic
    // if (nip == 'admin' && password == 'password') {
    // Navigate to the home page or dashboard
    Navigator.pushReplacementNamed(
      context,
      '/home',
    );
  }

  @override
  void dispose() {
    // Dispose of the controller when the page is removed
    _nipController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _belumPunyaAkun() {
    callBottomSheet(
      context,
      button: [
        CustomBigButton(
          onPressed: () => {
            Navigator.pop(context)
          },
          padding: EdgeInsets.symmetric(
            vertical: 24,
          ),
          buttonColor: ColorPrimary.orange,
          otherWidget: [
            Text(
              "Oke",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontSize: 24, color: ColorNeutral.white),
            )
          ],
        )
      ],
      title: Text(
        "Belum punya akun",
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 20,
            ),
      ),
      description:
          "Untuk saat ini, pembuatan akun hanya bisa dilakukan pada admin.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/icon/logo.png',
                  isAntiAlias: true,
                  height: 86,
                  width: 262,
                ),
                SizedBox(
                  height: 30,
                ),
                authCard(
                    Theme.of(context), _nipController, _passwordController),
                SizedBox(height: 10),
                loginButton(Theme.of(context), _login, _belumPunyaAkun),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

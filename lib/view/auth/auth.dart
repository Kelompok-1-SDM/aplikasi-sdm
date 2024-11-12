import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/services/auth/auth_model.dart';
import 'package:aplikasi_manajemen_sdm/services/auth/auth_service.dart';
import 'package:aplikasi_manajemen_sdm/services/dio_client.dart';
import 'package:aplikasi_manajemen_sdm/services/shared_prefrences.dart';
import 'package:aplikasi_manajemen_sdm/view/auth/auth_widgets.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotNipController = TextEditingController();
  // Controller for forgot NIP//memungkinkan UI untuk berubah
  final AuthService _authService = AuthService(); // Instantiate AuthService

  @override
  void initState() {
    _checkToken();
    super.initState();
  }

  void _checkToken() async {
    final token = await Storage.getToken();

    if (token != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _login_callback() async {
    final nip = _nipController.text.trim();
    final password = _passwordController.text.trim();

    if (nip.isEmpty || password.isEmpty) {
      _showErrorDialog("Validation Error", "NIP and Password cannot be empty");
      return;
    }

    try {
      final BaseResponse<LoginResponse> response =
          await _authService.login(nip, password);

      if (response.success) {
        Fluttertoast.showToast(msg: "Anda berhasil login");
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        _showErrorDialog("Login failed", response.message ?? "Unknown error");
      }
    } catch (e) {
      print("Error during login: $e");
      _showErrorDialog("Error", "An error occurred during login: $e");
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
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
  void dispose() {
    // Dispose of the controller when the page is removed
    _nipController.dispose();
    _passwordController.dispose();
    _forgotNipController.dispose(); // Dispose forgot NIP controller
    super.dispose();
  }

  void _belumPunyaAkun() {
    callBottomSheet(
      context,
      button: [
        CustomBigButton(
          onPressed: () => {Navigator.pop(context)},
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

  void lupapassword() {
    callBottomSheet(
      context,
      button: [
        CustomBigButton(
          onPressed: () => {Cekemail()},
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
        "Lupa password",
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 20,
            ),
      ),
      child: Column(
        children: [
          Text(
            "Silahkan masukkan data NIP anda",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 10),
          TextField(
            controller: _forgotNipController,
            decoration: InputDecoration(
              labelText: 'NIP',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  void Cekemail() {
    callBottomSheet(
      context,
      button: [
        CustomBigButton(
          onPressed: () => {Navigator.pop(context)},
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
        "Lupa Password",
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 20,
            ),
      ),
      description: "Cek email anda untuk mengubah password anda",
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
                authCard(Theme.of(context), _nipController, _passwordController,
                    lupapassword),
                SizedBox(height: 10),
                loginButton(
                    Theme.of(context), _login_callback, _belumPunyaAkun),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

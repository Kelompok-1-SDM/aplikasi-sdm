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
  final AuthService _authService = AuthService();

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

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

  Future<void> _loginCallback() async {
    final nip = _nipController.text.trim();
    final password = _passwordController.text.trim();

    if (nip.isEmpty || password.isEmpty) {
      _showErrorDialog("Validation Error", "All fields must be filled.");
      return;
    }
    if (nip.length < 18) {
      _showErrorDialog("Validation Error", "NIP must be at least 18 digits.");
      return;
    }
    if (password.length < 4) {
      _showErrorDialog("Validation Error", "Password must be at least 4 characters.");
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
        _showErrorDialog("Login failed", response.message);
      }
    } catch (e) {
      _showErrorDialog("Error", "An error occurred during login: $e");
    }
  }

  Future<void> _onRefresh() async {
    // Simulate a "refresh" action triggering login
    await _loginCallback();
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
    _nipController.dispose();
    _passwordController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: Center(
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
                  SizedBox(height: 30),
                  authCard(
                      Theme.of(context), _nipController, _passwordController, () {}),
                  SizedBox(height: 10),
                  loginButton(
                      Theme.of(context), () async {
                        await _refreshKey.currentState?.show();
                      }, _belumPunyaAkun),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

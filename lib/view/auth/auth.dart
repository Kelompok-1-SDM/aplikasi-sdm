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
  final TextEditingController _nipLupaController = TextEditingController();
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
      _showErrorDialog(
          context, "Validation Error", "All fields must be filled.");
      return;
    }
    if (nip.length < 18) {
      _showErrorDialog(
          context, "Validation Error", "NIP must be at least 18 digits.");
      return;
    }
    if (password.length < 4) {
      _showErrorDialog(context, "Validation Error",
          "Password must be at least 4 characters.");
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
        _showErrorDialog(context, "Login failed", response.message);
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "An error occurred during login: $e");
    }
  }

  Future<void> _resetCallback() async {
    final nip = _nipLupaController.text.trim();

    if (nip.isEmpty) {
      _showErrorDialog(
          context, "Validation Error", "All fields must be filled.");
      return;
    }
    if (nip.length < 18) {
      _showErrorDialog(
          context, "Validation Error", "NIP must be at least 18 digits.");
      return;
    }
    try {
      final BaseResponse<LoginResponse> response =
          await _authService.resetPassword(nip);

      if (response.success) {
        _afterReset();
      } else {
        _showErrorDialog(context, "Reset failed", response.message);
      }
    } catch (e) {
      _showErrorDialog(
          context, "Error", "An error occurred during forgot password: $e");
    }
  }

  Future<void> _onRefresh() async {
    // Simulate a "refresh" action triggering login
    await _loginCallback();
  }

  void _showErrorDialog(
      BuildContext dialogContext, String title, String message) {
    showDialog(
      context: dialogContext,
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
          padding: EdgeInsets.all(
            24,
          ),
          buttonColor: ColorPrimary.orange,
          buttonLabel: "Oke",
          customLabelColor: ColorNeutral.white,
        )
      ],
      title: Text(
        "Belum punya akun",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 20,
            ),
      ),
      description:
          "Untuk saat ini, pembuatan akun hanya bisa dilakukan pada admin.",
    );
  }

  void _resetPassword() {
    callBottomSheet(
      context,
      button: [
        CustomBigButton(
          onPressed: () => {_resetCallback()},
          padding: EdgeInsets.all(
            24,
          ),
          buttonColor: ColorPrimary.orange,
          buttonLabel: "Lupa Password",
          customLabelColor: ColorNeutral.white,
        )
      ],
      child: Column(
        children: [
          CustomTextField(
            label: "NIP",
            controller: _nipLupaController,
            hint: "2241760089",
            isPassword: false, // or true for password fields
            inputType: TextInputType.number, // For numeric input
          ),
        ],
      ),
      title: Text(
        "Lupa Password",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 20,
            ),
      ),
      description: "Silahkan masukkan data NIP anda.",
    );
  }

  void _afterReset() {
    callBottomSheet(
      context,
      button: [
        CustomBigButton(
          onPressed: () => {Navigator.pop(context), Navigator.pop(context)},
          padding: EdgeInsets.all(
            24,
          ),
          buttonColor: ColorPrimary.orange,
          buttonLabel: "Oke",
          customLabelColor: ColorNeutral.white,
        )
      ],
      title: Text(
        "Lupa Password",
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 20,
            ),
      ),
      description:
          "Silakan cek email yang terdaftar untuk mengubah password anda",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        color: ColorNeutral.black,
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
                  authCard(Theme.of(context), _nipController,
                      _passwordController, _resetPassword),
                  SizedBox(height: 10),
                  loginButton(Theme.of(context), () async {
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

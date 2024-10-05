import 'package:aplikasi_manajemen_sdm/view/home/homepage.dart';
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
    String nip = _nipController.text;
    String password = _passwordController.text;

    // Replace this with your actual authentication logic
    // if (nip == 'admin' && password == 'password') {
      // Navigate to the home page or dashboard
      Navigator.pushNamed(
        context,
        '',
      );
    // } else {
    //   // Show an error message
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: Text('Login Failed'),
    //       content: Text('Invalid NIP or Password'),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.pop(context),
    //           child: Text('OK'),
    //         ),
    //       ],
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/icon/logo.png',
              height: 300,
            ),
            SizedBox(height: 20),
            Text(
              'SISTEM INFORMASI MANAJEMEN',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              'Jurusan Teknologi Informasi',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 40),
            TextField(
              controller: _nipController,
              decoration: InputDecoration(
                labelText: 'NIP',
                labelStyle:
                    TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.person,
                    color: const Color.fromARGB(255, 0, 0, 0)),
              ),
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle:
                    TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon:
                    Icon(Icons.lock, color: const Color.fromARGB(255, 0, 0, 0)),
              ),
              obscureText: true,
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Masuk'),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Lupa password',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
            ),
            SizedBox(height: 20),
            Text(
              'Belum punya akun?',
              textAlign: TextAlign.center,
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
          ],
        ),
      ),
    );
    ;
  }
}

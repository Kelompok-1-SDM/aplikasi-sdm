import 'package:aplikasi_manajemen_sdm/view/auth/auth.dart';
import 'package:aplikasi_manajemen_sdm/view/home/homepage.dart';
import 'package:aplikasi_manajemen_sdm/view/livechat/livechat.dart';
import 'package:aplikasi_manajemen_sdm/view/profile/profile.dart';
import 'package:aplikasi_manajemen_sdm/view/kegiatan/detail_kegiatan.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return _materialRoute(HomePage());

      case '/auth':
        return _materialRoute(AuthPage());

      case '/profile':
        return _materialRoute(ProfilePage());

      case '/detail_kegiatan':

        /// Butuh parameter tugas
        final idKegiatan = settings.arguments as String;
        return _materialRoute(DetailKegiatan(
          idKegiatan: idKegiatan,
        ));

      case '/livechat':

        /// Butuh parameter tugas
        final idKegiatan = settings.arguments as String;
        return _materialRoute(LiveChat(
          idKegiatan: idKegiatan,
        ));

      default:
        return _materialRoute(HomePage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}

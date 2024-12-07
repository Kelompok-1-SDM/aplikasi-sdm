import 'package:aplikasi_manajemen_sdm/services/kegiatan/kegiatan_model.dart';

class HomeResponse {
  final JumlahTugasBulanSekarang? jumlahTugasBulanSekarang;
  final List<KegiatanResponse>? duaTugasTerbaru;
  final KegiatanResponse? tugasBerlangsung;
  final Statistik? statistik;

  HomeResponse({
    this.jumlahTugasBulanSekarang,
    this.duaTugasTerbaru,
    this.tugasBerlangsung,
    this.statistik,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      jumlahTugasBulanSekarang: json['jumlahTugasBulanSekarang'] != null
          ? JumlahTugasBulanSekarang.fromJson(json['jumlahTugasBulanSekarang'])
          : null,
      duaTugasTerbaru: json['duaTugasTerbaru'] != null
          ? (json['duaTugasTerbaru'] as List)
              .map((item) => KegiatanResponse.fromJson(item))
              .toList()
          : null,
      tugasBerlangsung: json['tugasBerlangsung'] != null
          ? KegiatanResponse.fromJson(json['tugasBerlangsung'])
          : null,
      statistik: json['statistik'] != null
          ? Statistik.fromJson(json['statistik'])
          : null,
    );
  }
}

class JumlahTugasBulanSekarang {
  final int? count;

  JumlahTugasBulanSekarang({
    this.count,
  });

  factory JumlahTugasBulanSekarang.fromJson(Map<String, dynamic> json) {
    return JumlahTugasBulanSekarang(
      count: json['count'],
    );
  }
}


class Statistik {
  final String? firstName;
  final int? totalDalamSetahun;
  final List<JumlahKegiatan>? jumlahKegiatan;

  Statistik({
    this.firstName,
    this.totalDalamSetahun,
    this.jumlahKegiatan,
  });

  factory Statistik.fromJson(Map<String, dynamic> json) {
    return Statistik(
      firstName: json['firstName'],
      totalDalamSetahun: json['totalDalamSetahun'],
      jumlahKegiatan: (json['jumlahKegiatan'] as List?)
          ?.map((item) => JumlahKegiatan.fromJson(item))
          .toList(),
    );
  }
}

class JumlahKegiatan {
  final int? jumlahKegiatan;
  final int? year;
  final int? month;

  JumlahKegiatan({this.year, this.month,  this.jumlahKegiatan});

  factory JumlahKegiatan.fromJson(Map<String, dynamic> json) {
    return JumlahKegiatan(
      jumlahKegiatan: json['jumlahKegiatan'],
      year: json['year'],
      month: json['month'],
    );
  }
}

class HomeResponse {
  final JumlahTugasBulanSekarang jumlahTugasBulanSekarang;
  final List<DuaTugasTerbaru> duaTugasTerbaru;
  final TugasBerlangsung? tugasBerlangsung;
  final Statistik statistik;

  HomeResponse({
    required this.jumlahTugasBulanSekarang,
    required this.duaTugasTerbaru,
    this.tugasBerlangsung,
    required this.statistik,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      jumlahTugasBulanSekarang: JumlahTugasBulanSekarang.fromJson(json['jumlahTugasBulanSekarang']),
      duaTugasTerbaru: (json['duaTugasTerbaru'] as List)
          .map((item) => DuaTugasTerbaru.fromJson(item))
          .toList(),
      tugasBerlangsung: json['tugasBerlangsung'] != null
          ? TugasBerlangsung.fromJson(json['tugasBerlangsung'])
          : null,
      statistik: Statistik.fromJson(json['statistik']),
    );
  }
}

class JumlahTugasBulanSekarang {
  final int count;
  final List<String> kompetensiList;

  JumlahTugasBulanSekarang({
    required this.count,
    required this.kompetensiList,
  });

  factory JumlahTugasBulanSekarang.fromJson(Map<String, dynamic> json) {
    return JumlahTugasBulanSekarang(
      count: json['count'],
      kompetensiList: List<String>.from(json['kompetensiList'] ?? []),
    );
  }
}

class DuaTugasTerbaru {
  final String kegiatanId;
  final String judulKegiatan;
  final DateTime tanggal;
  final String tipeKegiatan;
  final String lokasi;
  final String deskripsi;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String status;
  final String role;
  final List<String> kompetensi;

  DuaTugasTerbaru({
    required this.kegiatanId,
    required this.judulKegiatan,
    required this.tanggal,
    required this.tipeKegiatan,
    required this.lokasi,
    required this.deskripsi,
    required this.updatedAt,
    required this.createdAt,
    required this.status,
    required this.role,
    required this.kompetensi,
  });

  factory DuaTugasTerbaru.fromJson(Map<String, dynamic> json) {
    return DuaTugasTerbaru(
      kegiatanId: json['kegiatanId'],
      judulKegiatan: json['judulKegiatan'],
      tanggal: DateTime.parse(json['tanggal']),
      tipeKegiatan: json['tipeKegiatan'],
      lokasi: json['lokasi'],
      deskripsi: json['deskripsi'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
      role: json['role'],
      kompetensi: List<String>.from(json['kompetensi'] ?? []),
    );
  }
}

class TugasBerlangsung {
  final String? kegiatanId;
  final String? judulKegiatan;
  final DateTime? tanggal;
  final String? tipeKegiatan;
  final String? lokasi;
  final String? deskripsi;
  final String? status;

  TugasBerlangsung({
    this.kegiatanId,
    this.judulKegiatan,
    this.tanggal,
    this.tipeKegiatan,
    this.lokasi,
    this.deskripsi,
    this.status,
  });

  factory TugasBerlangsung.fromJson(Map<String, dynamic> json) {
    return TugasBerlangsung(
      kegiatanId: json['kegiatanId'],
      judulKegiatan: json['judulKegiatan'],
      tanggal: json['tanggal'] != null ? DateTime.parse(json['tanggal']) : null,
      tipeKegiatan: json['tipeKegiatan'],
      lokasi: json['lokasi'],
      deskripsi: json['deskripsi'],
      status: json['status'],
    );
  }
}

class Statistik {
  final String firstName;
  final int totalDalamSetahun;
  final List<JumlahKegiatan> jumlahKegiatan;

  Statistik({
    required this.firstName,
    required this.totalDalamSetahun,
    required this.jumlahKegiatan,
  });

  factory Statistik.fromJson(Map<String, dynamic> json) {
    return Statistik(
      firstName: json['firstName'],
      totalDalamSetahun: json['totalDalamSetahun'],
      jumlahKegiatan: (json['jumlahKegiatan'] as List)
          .map((item) => JumlahKegiatan.fromJson(item))
          .toList(),
    );
  }
}

class JumlahKegiatan {
  final int year;
  final int month;
  final int jumlahKegiatan;

  JumlahKegiatan({
    required this.year,
    required this.month,
    required this.jumlahKegiatan,
  });

  factory JumlahKegiatan.fromJson(Map<String, dynamic> json) {
    return JumlahKegiatan(
      year: json['year'],
      month: json['month'],
      jumlahKegiatan: json['jumlahKegiatan'],
    );
  }
}

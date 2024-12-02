class HomeResponse {
  final JumlahTugasBulanSekarang? jumlahTugasBulanSekarang;
  final List<DuaTugasTerbaru>? duaTugasTerbaru;
  final TugasBerlangsung? tugasBerlangsung;
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
              .map((item) => DuaTugasTerbaru.fromJson(item))
              .toList()
          : null,
      tugasBerlangsung: json['tugasBerlangsung'] != null
          ? TugasBerlangsung.fromJson(json['tugasBerlangsung'])
          : null,
      statistik: json['statistik'] != null
          ? Statistik.fromJson(json['statistik'])
          : null,
    );
  }
}

class JumlahTugasBulanSekarang {
  final int? count;
  final List<String>? kompetensiList;

  JumlahTugasBulanSekarang({
    this.count,
    this.kompetensiList,
  });

  factory JumlahTugasBulanSekarang.fromJson(Map<String, dynamic> json) {
    return JumlahTugasBulanSekarang(
      count: json['count'],
      kompetensiList:
          (json['kompetensiList'] as List?)?.map((e) => e as String).toList(),
    );
  }
}

class DuaTugasTerbaru {
  final String? kegiatanId;
  final String? judul;
  final DateTime? tanggalMulai;
  final DateTime? tanggalAkhir;
  final String? tipeKegiatan;
  final String? lokasi;
  final String? deskripsi;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? status;
  final String? role;
  final bool? isPic;
  final List<String>? kompetensi;

  DuaTugasTerbaru({
    this.kegiatanId,
    this.judul,
    this.tanggalMulai,
    this.tanggalAkhir,
    this.tipeKegiatan,
    this.lokasi,
    this.deskripsi,
    this.updatedAt,
    this.createdAt,
    this.status,
    this.role,
    this.isPic,
    this.kompetensi,
  });

  factory DuaTugasTerbaru.fromJson(Map<String, dynamic> json) {
    return DuaTugasTerbaru(
      kegiatanId: json['kegiatanId'],
      judul: json['judul'],
      tanggalMulai: json['tanggalMulai'] != null
          ? DateTime.parse(json['tanggalMulai'])
          : null,
      tanggalAkhir: json['tanggalAkhir'] != null
          ? DateTime.parse(json['tanggalAkhir'])
          : null,
      tipeKegiatan: json['tipeKegiatan'],
      lokasi: json['lokasi'],
      deskripsi: json['deskripsi'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      status: json['status'],
      role: json['role'],
      isPic: json['isPic'],
      kompetensi:
          (json['kompetensi'] as List?)?.map((e) => e as String).toList(),
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

class KegiatanResponse {
  final String? kegiatanId;
  final String? judul;
  final DateTime? tanggalMulai;
  final DateTime? tanggalAkhir;
  final String? tipeKegiatan;
  final bool? isDone;
  final String? lokasi;
  final String? deskripsi;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? jabatan;
  final bool? isPic;
  final List<Kompetensi>? kompetensi;

  KegiatanResponse({
    this.kegiatanId,
    this.judul,
    this.tanggalMulai,
    this.tanggalAkhir,
    this.tipeKegiatan,
    this.isDone,
    this.lokasi,
    this.deskripsi,
    this.updatedAt,
    this.createdAt,
    this.jabatan,
    this.isPic,
    this.kompetensi,
  });

  factory KegiatanResponse.fromJson(Map<String, dynamic> json) {
    return KegiatanResponse(
      kegiatanId: json['kegiatanId'],
      judul: json['judul'],
      tanggalMulai: json['tanggalMulai'] != null
          ? DateTime.parse(json['tanggalMulai'])
          : null,
      tanggalAkhir: json['tanggalAkhir'] != null
          ? DateTime.parse(json['tanggalAkhir'])
          : null,
      tipeKegiatan: json['tipeKegiatan'],
      isDone: json['isDone'],
      lokasi: json['lokasi'],
      deskripsi: json['deskripsi'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      jabatan: json['jabatan'],
      isPic: json['isPic'],
      kompetensi: (json['kompetensi'] as List<dynamic>?)
          ?.map((item) => Kompetensi.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kegiatanId': kegiatanId,
      'judul': judul,
      'tanggalMulai': tanggalMulai?.toIso8601String(),
      'tanggalAkhir': tanggalAkhir?.toIso8601String(),
      'tipeKegiatan': tipeKegiatan,
      'isDone': isDone,
      'lokasi': lokasi,
      'deskripsi': deskripsi,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'jabatan': jabatan,
      'isPic': isPic,
      'kompetensi': kompetensi?.map((item) => item.toJson()).toList(),
    };
  }
}

class Kompetensi {
  final String? kompetensiId;
  final String? namaKompetensi;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  Kompetensi({
    this.kompetensiId,
    this.namaKompetensi,
    this.updatedAt,
    this.createdAt,
  });

  factory Kompetensi.fromJson(Map<String, dynamic> json) {
    return Kompetensi(
      kompetensiId: json['kompetensiId'],
      namaKompetensi: json['namaKompetensi'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kompetensiId': kompetensiId,
      'namaKompetensi': namaKompetensi,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

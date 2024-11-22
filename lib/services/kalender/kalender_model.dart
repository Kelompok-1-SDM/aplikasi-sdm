class KalenderResponse{
  final String? userId;
  final String? nip;
  final String? nama;
  final String? email;
  final String? role;
  final String? profileImage;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final List<Kegiatan>? kegiatan;

  KalenderResponse({
    this.userId,
    this.nip,
    this.nama,
    this.email,
    this.role,
    this.profileImage,
    this.updatedAt,
    this.createdAt,
    this.kegiatan,
  });

  factory KalenderResponse.fromJson(Map<String, dynamic> json) {
    return KalenderResponse(
      userId: json['userId'],
      nip: json['nip'],
      nama: json['nama'],
      email: json['email'],
      role: json['role'],
      profileImage: json['profileImage'],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      kegiatan: (json['kegiatan'] as List<dynamic>?)
          ?.map((item) => Kegiatan.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nip': nip,
      'nama': nama,
      'email': email,
      'role': role,
      'profileImage': profileImage,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'kegiatan': kegiatan?.map((item) => item.toJson()).toList(),
    };
  }
}

class Kegiatan {
  final String? kegiatanId;
  final String? judulKegiatan;
  final DateTime? tanggal;
  final String? tipeKegiatan;
  final String? lokasi;
  final String? deskripsi;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? status;
  final String? role;
  final List<String>? kompetensi;

  Kegiatan({
    this.kegiatanId,
    this.judulKegiatan,
    this.tanggal,
    this.tipeKegiatan,
    this.lokasi,
    this.deskripsi,
    this.updatedAt,
    this.createdAt,
    this.status,
    this.role,
    this.kompetensi,
  });

  factory Kegiatan.fromJson(Map<String, dynamic> json) {
    return Kegiatan(
      kegiatanId: json['kegiatanId'],
      judulKegiatan: json['judulKegiatan'],
      tanggal: json['tanggal'] != null
          ? DateTime.parse(json['tanggal'])
          : null,
      tipeKegiatan: json['tipeKegiatan'],
      lokasi: json['lokasi'],
      deskripsi: json['deskripsi'],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      status: json['status'],
      role: json['role'],
      kompetensi: (json['kompetensi'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kegiatanId': kegiatanId,
      'judulKegiatan': judulKegiatan,
      'tanggal': tanggal?.toIso8601String(),
      'tipeKegiatan': tipeKegiatan,
      'lokasi': lokasi,
      'deskripsi': deskripsi,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'status': status,
      'role': role,
      'kompetensi': kompetensi,
    };
  }
}

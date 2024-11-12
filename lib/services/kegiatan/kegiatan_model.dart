class KompetensiResponse {
  final String id;
  final String namaKompetensi;

  KompetensiResponse({
    required this.id,
    required this.namaKompetensi,
  });

  factory KompetensiResponse.fromJson(Map<String, dynamic> json) {
    return KompetensiResponse(
      id: json['id'],
      namaKompetensi: json['namaKompetensi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaKompetensi': namaKompetensi,
    };
  }
}

class ListKegiatan {
  final String userId;
  final String nip;
  final String nama;
  final String email;
  final String role;
  final String profileImage;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<Kegiatan> kegiatan;

  ListKegiatan({
    required this.userId,
    required this.nip,
    required this.nama,
    required this.email,
    required this.role,
    required this.profileImage,
    required this.createdAt,
    this.updatedAt,
    required this.kegiatan,
  });

  factory ListKegiatan.fromJson(Map<String, dynamic> json) {
    return ListKegiatan(
      userId: json['userId'],
      nip: json['nip'],
      nama: json['nama'],
      email: json['email'],
      role: json['role'],
      profileImage: json['profileImage'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      kegiatan: (json['kegiatan'] as List)
          .map((item) => Kegiatan.fromJson(item))
          .toList(),
    );
  }
}

class Kegiatan {
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

  Kegiatan({
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

  factory Kegiatan.fromJson(Map<String, dynamic> json) {
    return Kegiatan(
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

class Kompetensi {
  final String kompetensiId;
  final String namaKompetensi;
  final String updatedAt;
  final String createdAt;

  Kompetensi({
    required this.kompetensiId,
    required this.namaKompetensi,
    required this.updatedAt,
    required this.createdAt,
  });

  // Method to convert Kompetensi to JSON
  Map<String, dynamic> toJson() {
    return {
      'kompetensiId': kompetensiId,
      'namaKompetensi': namaKompetensi,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }

  factory Kompetensi.fromJson(Map<String, dynamic> json) {
    return Kompetensi(
      kompetensiId: json['kompetensiId'],
      namaKompetensi: json['namaKompetensi'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
    );
  }
}

class UserData {
  final String userId;
  final String nip;
  final String nama;
  final String email;
  final String role;
  final String profileImage;
  final String? updatedAt;
  final String createdAt;
  final List<Kompetensi>
      kompetensi; // Updated to store list of Kompetensi objects

  UserData({
    required this.userId,
    required this.nip,
    required this.nama,
    required this.email,
    required this.role,
    required this.profileImage,
    this.updatedAt,
    required this.createdAt,
    required this.kompetensi,
  });

  // Method to convert UserData to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nip': nip,
      'nama': nama,
      'email': email,
      'role': role,
      'profileImage': profileImage,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'kompetensi': kompetensi
          .map((kompetensi) => kompetensi.toJson())
          .toList(), // Convert list of Kompetensi objects to JSON
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'],
      nip: json['nip'],
      nama: json['nama'],
      email: json['email'],
      role: json['role'],
      profileImage: json['profileImage'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
      kompetensi: (json['kompetensi'] as List)
          .map((kompetensiJson) => Kompetensi.fromJson(kompetensiJson))
          .toList(), // Convert each kompetensi item to a Kompetensi object
    );
  }
}

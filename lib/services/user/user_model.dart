class UserData {
  final String userId;
  final String nip;
  final String nama;
  final String email;
  final String role;
  final String profileImage;
  final String? updatedAt;
  final String createdAt;
  final List<String> kompetensi; // Changed to List<String> since the data is a list of strings

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
      'kompetensi': kompetensi, // Directly returns the list of strings
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
      kompetensi: List<String>.from(json['kompetensi']), // Parses the kompetensi as a list of strings
    );
  }
}

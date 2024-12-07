class UserData {
  final String userId;
  final String nip;
  final String nama;
  final String email;
  final String role;
  final String profileImage;
  final String? updatedAt;
  final String createdAt;

  UserData({
    required this.userId,
    required this.nip,
    required this.nama,
    required this.email,
    required this.role,
    required this.profileImage,
    this.updatedAt,
    required this.createdAt,
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
      'createdAt': createdAt
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
      createdAt: json['createdAt']
    );
  }
}

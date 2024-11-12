class LoginResponse {
  final String? userId;
  final String? nip;
  final String? nama;
  final String? email;
  final String? role;
  final String? profileImage;
  final String? token;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  LoginResponse({
    this.userId,
    this.nip,
    this.nama,
    this.email,
    this.role,
    this.profileImage,
    this.token,
    this.updatedAt,
    this.createdAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'],
      nip: json['nip'],
      nama: json['nama'],
      email: json['email'],
      role: json['role'],
      profileImage: json['profileImage'],
      token: json['token'],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
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
      'token': token,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

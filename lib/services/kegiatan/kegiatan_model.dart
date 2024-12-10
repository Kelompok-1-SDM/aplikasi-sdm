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
  final List<Lampiran>? lampiran;
  final List<Agenda>? agenda;
  final List<User>? users;

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
    this.lampiran,
    this.agenda,
    this.users,
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
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        lampiran: (json['lampiran'] as List<dynamic>?)
            ?.map((item) => Lampiran.fromJson(item))
            .toList(),
        agenda: (json['agenda'] as List<dynamic>?)
            ?.map((item) => Agenda.fromJson(item))
            .toList(),
        users: (json['users'] as List<dynamic>?)
            ?.map((item) => User.fromJson(item))
            .toList());
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
      'lampiran': lampiran?.map((item) => item.toJson()).toList(),
      'agenda': agenda?.map((item) => item.toJson()).toList(),
      'users': users?.map((item) => item.toJson()).toList()
    };
  }
}

class Lampiran {
  final String? lampiranId;
  final String? kegiatanId;
  final String? nama;
  final String? url;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  Lampiran({
    this.lampiranId,
    this.kegiatanId,
    this.nama,
    this.url,
    this.updatedAt,
    this.createdAt,
  });

  factory Lampiran.fromJson(Map<String, dynamic> json) {
    return Lampiran(
      lampiranId: json['lampiranId'],
      kegiatanId: json['kegiatanId'],
      nama: json['nama'],
      url: json['url'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lampiranId': lampiranId,
      'kegiatanId': kegiatanId,
      'nama': nama,
      'url': url,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class Agenda {
  final String? agendaId;
  final String? kegiatanId;
  final DateTime? jadwalAgenda;
  final String? namaAgenda;
  final String? deskripsiAgenda;
  final bool? isDone;
  final bool? wasMePic; // Updated from bool to String
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final List<Progress>? progress; // New field
  final List<User>? users;

  Agenda({
    this.agendaId,
    this.kegiatanId,
    this.jadwalAgenda,
    this.namaAgenda,
    this.deskripsiAgenda,
    this.isDone,
    this.wasMePic,
    this.updatedAt,
    this.createdAt,
    this.progress,
    this.users,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      agendaId: json['agendaId'],
      kegiatanId: json['kegiatanId'],
      jadwalAgenda: json['jadwalAgenda'] != null
          ? DateTime.parse(json['jadwalAgenda'])
          : null,
      namaAgenda: json['namaAgenda'],
      deskripsiAgenda: json['deskripsiAgenda'],
      isDone: json['isDone'],
      wasMePic: json['wasMePic'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      progress: (json['progress'] as List<dynamic>?)
          ?.map((item) => Progress.fromJson(item))
          .toList(),
      users: (json['users'] as List<dynamic>?)
          ?.map((item) => User.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'agendaId': agendaId,
      'kegiatanId': kegiatanId,
      'jadwalAgenda': jadwalAgenda?.toIso8601String(),
      'namaAgenda': namaAgenda,
      'deskripsiAgenda': deskripsiAgenda,
      'isDone': isDone,
      'wasMePic': wasMePic,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'progress': progress?.map((item) => item.toJson()).toList(),
      'users': users?.map((item) => item.toJson()).toList(),
    };
  }
}

class Progress {
  final String? progressId;
  final String? agendaId;
  final String? deskripsiProgress;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final List<Attachment>? attachments;

  Progress({
    this.progressId,
    this.agendaId,
    this.deskripsiProgress,
    this.updatedAt,
    this.createdAt,
    this.attachments,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      progressId: json['progressId'],
      agendaId: json['agendaId'],
      deskripsiProgress: json['deskripsiProgress'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((item) => Attachment.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'progressId': progressId,
      'agendaId': agendaId,
      'deskripsiProgress': deskripsiProgress,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'attachments': attachments?.map((item) => item.toJson()).toList(),
    };
  }
}

class Attachment {
  final String? progressId;
  final String? attachmentId;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  Attachment({
    this.progressId,
    this.attachmentId,
    this.updatedAt,
    this.createdAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      progressId: json['progressId'],
      attachmentId: json['attachmentId'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'progressId': progressId,
      'attachmentId': attachmentId,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class User {
  final String? userId;
  final String? nip;
  final String? nama;
  final String? email;
  final String? role;
  final String? profileImage;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? namaJabatan;
  final bool? isPic;

  User(
      {this.userId,
      this.nip,
      this.nama,
      this.email,
      this.role,
      this.profileImage,
      this.updatedAt,
      this.createdAt,
      this.namaJabatan,
      this.isPic});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
        namaJabatan: json['namaJabatan'],
        isPic: json['isPic']);
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
      'namaJabatan': namaJabatan,
      'isPic': isPic
    };
  }
}

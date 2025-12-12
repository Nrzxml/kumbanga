class Child {
  String id;
  String name;
  DateTime birthDate;
  String gender;
  List<Map<String, dynamic>> growthHistory;

  Child({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    this.growthHistory = const [],
  });

  // Untuk simpan ke lokal (map biasa)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'growthHistory': growthHistory,
    };
  }

  // Untuk ambil dari lokal (map biasa)
  factory Child.fromMap(Map<String, dynamic> map) {
    return Child(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      birthDate: DateTime.tryParse(map['birthDate'] ?? '') ?? DateTime.now(),
      gender: map['gender'] ?? '',
      growthHistory:
          List<Map<String, dynamic>>.from(map['growthHistory'] ?? []),
    );
  }

  // 🔹 Untuk parsing dari API (HTTP JSON)
  factory Child.fromJson(Map<String, dynamic> json) {
    final birthStr = json['birth_date'] ?? json['birthDate'];
    return Child(
      id: (json['id'] ?? json['child_id']).toString(),
      name: json['name'] ?? '',
      birthDate: DateTime.tryParse(birthStr ?? '') ?? DateTime.now(),
      gender: json['gender'] ?? '',
      growthHistory:
          List<Map<String, dynamic>>.from(json['growth_history'] ?? []),
    );
  }

  // 🔹 Untuk dikirim ke API (HTTP POST)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birth_date': birthDate.toIso8601String().split('T').first,
      'gender': gender,
      'growth_history': growthHistory,
    };
  }

  int getAgeInMonths() {
    final now = DateTime.now();
    return (now.difference(birthDate).inDays / 30).floor();
  }
}

class GrowthData {
  DateTime date;
  double weight;
  double height;
  double headCircumference;
  String notes;

  GrowthData({
    required this.date,
    required this.weight,
    required this.height,
    required this.headCircumference,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'weight': weight,
      'height': height,
      'headCircumference': headCircumference,
      'notes': notes,
    };
  }

  factory GrowthData.fromMap(Map<String, dynamic> map) {
    return GrowthData(
      date: DateTime.parse(map['date']),
      weight: map['weight'].toDouble(),
      height: map['height'].toDouble(),
      headCircumference: map['headCircumference'].toDouble(),
      notes: map['notes'] ?? '',
    );
  }
}

// =====================================================================
//               DEVELOPMENT TARGET — VERSI FINAL (NO ERROR)
// =====================================================================

class DevelopmentTarget {
  int ageInMonths;

  /// Target teks
  String physicalTarget;
  String cognitiveTarget;
  String socialTarget;

  /// Checkbox status
  bool physicalDone;
  bool cognitiveDone;
  bool socialDone;

  /// Untuk menghubungkan ke anak
  String? childId;

  DevelopmentTarget({
    required this.ageInMonths,
    required this.physicalTarget,
    required this.cognitiveTarget,
    required this.socialTarget,
    this.physicalDone = false,
    this.cognitiveDone = false,
    this.socialDone = false,
    this.childId,
  });

  /// True bila semua centang selesai
  bool get isCompleted => physicalDone && cognitiveDone && socialDone;

  /// Convert data dari backend (JSON -> Model)
  factory DevelopmentTarget.fromJson(Map<String, dynamic> json) {
    return DevelopmentTarget(
      ageInMonths: int.tryParse(json['age']?.toString() ?? '0') ?? 0,
      physicalTarget: json['physical_target'] ?? '',
      cognitiveTarget: json['cognitive_target'] ?? '',
      socialTarget: json['social_target'] ?? '',
      physicalDone: json['physical_done'] == 1,
      cognitiveDone: json['cognitive_done'] == 1,
      socialDone: json['social_done'] == 1,
      childId: json['child_id']?.toString(),
    );
  }

  /// Convert data untuk dikirim ke backend (Model -> JSON)
  Map<String, dynamic> toJson() {
    return {
      "age": ageInMonths,
      "physical_target": physicalTarget,
      "cognitive_target": cognitiveTarget,
      "social_target": socialTarget,
      "physical_done": physicalDone ? 1 : 0,
      "cognitive_done": cognitiveDone ? 1 : 0,
      "social_done": socialDone ? 1 : 0,
      "child_id": childId,
    };
  }
}

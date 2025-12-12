class GrowthData {
  DateTime date;
  double weight; // kg
  double height; // cm
  double headCircumference; // cm
  String notes;

  GrowthData({
    required this.date,
    required this.weight,
    required this.height,
    required this.headCircumference,
    this.notes = '',
  });

  // Untuk simpan ke lokal
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
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      weight: double.tryParse(map['weight']?.toString() ?? '') ?? 0.0,
      height: double.tryParse(map['height']?.toString() ?? '') ?? 0.0,
      headCircumference:
          double.tryParse(map['headCircumference']?.toString() ?? '') ?? 0.0,
      notes: map['notes'] ?? '',
    );
  }

  // Untuk parsing dari API
  factory GrowthData.fromJson(Map<String, dynamic> json) {
    return GrowthData(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      weight: double.tryParse(json['weight']?.toString() ?? '') ?? 0.0,
      height: double.tryParse(json['height']?.toString() ?? '') ?? 0.0,
      headCircumference:
          double.tryParse(json['head_circumference']?.toString() ?? '') ?? 0.0,
      notes: json['notes'] ?? '',
    );
  }

  // Untuk dikirim ke API
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T').first,
      'weight': weight,
      'height': height,
      'head_circumference': headCircumference,
      'notes': notes,
    };
  }
}

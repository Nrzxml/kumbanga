class DevelopmentTarget {
  final int ageInMonths;

  final String physicalTarget;
  final String cognitiveTarget;
  final String socialTarget;

  bool physicalDone;
  bool cognitiveDone;
  bool socialDone;

  DevelopmentTarget({
    required this.ageInMonths,
    required this.physicalTarget,
    required this.cognitiveTarget,
    required this.socialTarget,
    this.physicalDone = false,
    this.cognitiveDone = false,
    this.socialDone = false,
  });

  // ================== STATUS GETTERS ==================

  /// 🟢 SEMUA SELESAI
  bool get isAllDone => physicalDone && cognitiveDone && socialDone;

  /// 🟡 SEBAGIAN TERISI (MINIMAL 1)
  bool get isPartiallyDone => physicalDone || cognitiveDone || socialDone;

  /// ⚪ BELUM ADA YANG DICENTANG
  bool get isEmpty => !physicalDone && !cognitiveDone && !socialDone;

  // ================== FROM MAP ==================

  /// Robust map parser: terima beberapa variasi nama field dari API
  factory DevelopmentTarget.fromMap(Map<String, dynamic> map) {
    int age = 0;

    if (map.containsKey('age_in_months')) {
      age = _toInt(map['age_in_months']);
    } else if (map.containsKey('ageInMonths')) {
      age = _toInt(map['ageInMonths']);
    } else if (map.containsKey('age')) {
      age = _toInt(map['age']);
    } else if (map.containsKey('age_months')) {
      age = _toInt(map['age_months']);
    }

    bool pDone =
        _toBool(map['physical'] ?? map['physicalDone'] ?? map['physical_done']);
    bool cDone = _toBool(
        map['cognitive'] ?? map['cognitiveDone'] ?? map['cognitive_done']);
    bool sDone =
        _toBool(map['social'] ?? map['socialDone'] ?? map['social_done']);

    return DevelopmentTarget(
      ageInMonths: age,
      physicalTarget: map['physicalTarget']?.toString() ??
          map['physical_target']?.toString() ??
          '',
      cognitiveTarget: map['cognitiveTarget']?.toString() ??
          map['cognitive_target']?.toString() ??
          '',
      socialTarget: map['socialTarget']?.toString() ??
          map['social_target']?.toString() ??
          '',
      physicalDone: pDone,
      cognitiveDone: cDone,
      socialDone: sDone,
    );
  }

  // ================== TO MAP ==================

  Map<String, dynamic> toMap() {
    return {
      'age_in_months': ageInMonths,
      'physical': physicalDone ? 1 : 0,
      'cognitive': cognitiveDone ? 1 : 0,
      'social': socialDone ? 1 : 0,
      'physicalTarget': physicalTarget,
      'cognitiveTarget': cognitiveTarget,
      'socialTarget': socialTarget,
    };
  }

  // ================== HELPERS ==================

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static bool _toBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v != 0;
    if (v is String) {
      final s = v.trim().toLowerCase();
      return s == '1' || s == 'true';
    }
    return false;
  }
}

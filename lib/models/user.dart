class User {
  String id;
  String fullName;
  String email;
  String phone;
  String role;
  List<String> childrenIds;
  DateTime createdAt;
  int checkInCount;
  DateTime lastCheckIn;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.childrenIds = const [],
    required this.createdAt,
    this.checkInCount = 0,
    required this.lastCheckIn,
  });

  User copyWith({
    String? fullName,
    String? email,
    String? phone,
  }) {
    return User(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role,
      createdAt: createdAt,
      lastCheckIn: lastCheckIn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'childrenIds': childrenIds,
      'createdAt': createdAt.toIso8601String(),
      'checkInCount': checkInCount,
      'lastCheckIn': lastCheckIn.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'],
      childrenIds: List<String>.from(map['childrenIds']),
      createdAt: DateTime.parse(map['createdAt']),
      checkInCount: map['checkInCount'],
      lastCheckIn: DateTime.parse(map['lastCheckIn']),
    );
  }
}

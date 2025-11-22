class ChildProfile {
  final String id;
  final String name;
  final String avatarUrl;
  final int age;
  final bool isPremium;
  final DateTime createdAt;
  final List<String> preferences;
  
  ChildProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.age,
    this.isPremium = false,
    required this.createdAt,
    this.preferences = const [],
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'age': age,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
      'preferences': preferences,
    };
  }
  
  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      age: json['age'],
      isPremium: json['isPremium'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      preferences: List<String>.from(json['preferences'] ?? []),
    );
  }
  
  ChildProfile copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    int? age,
    bool? isPremium,
    DateTime? createdAt,
    List<String>? preferences,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      age: age ?? this.age,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      preferences: preferences ?? this.preferences,
    );
  }
}
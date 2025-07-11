class Holiday {
  final int id;
  final String name;
  final String date;
  final String type;
  final bool recurring;
  final String region;
  final String? country;
  final int? countryId; 
  // final int country;
  final int createdBy;
  final String createdAt;
  final String updatedAt;

  Holiday({
    required this.id,
    required this.name,
    required this.date,
    required this.type,
    required this.recurring,
    required this.region,
    required this.country,
    this.countryId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      type: json['type'],
      recurring: json['recurring'],
      region: json['region'] ?? '',
      country: json['country_name'],
      countryId: json['country'],
      createdBy: json['created_by'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'name': name,
      'date': date,
      'type': type,
      'recurring': recurring,
      'region': region,
      'country': countryId,
      //'country_name': country,
      'created_by': createdBy,
      // 'created_at': createdAt,
      // 'updated_at': updatedAt,
    };
  }
}

class Country {
  final int id;
  final String countryCode;
  final String countryName;

  const Country({
    required this.id,
    required this.countryCode,
    required this.countryName,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      countryCode: json['country_code'],
      countryName: json['country_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'country_code': countryCode, 'country_name': countryName};
  }
}

//User
class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String role;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }
}

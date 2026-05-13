enum InstituteType { school, coaching }

extension InstituteTypeLabel on InstituteType {
  String get label =>
      this == InstituteType.school ? 'School' : 'Coaching Institute';

  String get icon => this == InstituteType.school ? 'apartment' : 'school';
}

class InstituteModel {
  final String instituteName;
  final InstituteType instituteType;
  final String phone;
  final String address;

  const InstituteModel({
    required this.instituteName,
    required this.instituteType,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toMap() => {
        'instituteName': instituteName,
        'instituteType': instituteType.name,
        'phone': phone,
        'address': address,
      };

  factory InstituteModel.fromMap(Map<String, dynamic> map) => InstituteModel(
        instituteName: map['instituteName'] as String,
        instituteType: InstituteType.values.firstWhere(
          (t) => t.name == map['instituteType'],
          orElse: () => InstituteType.coaching,
        ),
        phone: map['phone'] as String? ?? '',
        address: map['address'] as String? ?? '',
      );

  InstituteModel copyWith({
    String? instituteName,
    InstituteType? instituteType,
    String? phone,
    String? address,
  }) =>
      InstituteModel(
        instituteName: instituteName ?? this.instituteName,
        instituteType: instituteType ?? this.instituteType,
        phone: phone ?? this.phone,
        address: address ?? this.address,
      );
}

class StudentModel {
  final String id;
  final String name;
  final String batch;
  final String phone;

  StudentModel({
    required this.id,
    required this.name,
    required this.batch,
    required this.phone,
  });

  StudentModel copyWith({
    String? id,
    String? name,
    String? batch,
    String? phone,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      batch: batch ?? this.batch,
      phone: phone ?? this.phone,
    );
  }
}

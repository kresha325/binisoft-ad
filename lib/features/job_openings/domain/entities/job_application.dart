import 'package:equatable/equatable.dart';

class JobApplication extends Equatable {
  const JobApplication({
    required this.id,
    required this.jobOpeningId,
    required this.name,
    required this.phone,
    this.email,
    this.note,
    required this.createdAt,
  });

  final String id;
  final String jobOpeningId;
  final String name;
  final String phone;
  final String? email;
  final String? note;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, jobOpeningId, name, phone, email, note, createdAt];
}

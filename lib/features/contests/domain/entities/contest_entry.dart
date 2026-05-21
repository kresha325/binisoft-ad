import 'package:equatable/equatable.dart';

class ContestEntry extends Equatable {
  const ContestEntry({
    required this.id,
    required this.contestId,
    required this.name,
    required this.phone,
    this.email,
    this.note,
    required this.createdAt,
  });

  final String id;
  final String contestId;
  final String name;
  final String phone;
  final String? email;
  final String? note;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, contestId, name, phone, email, note, createdAt];
}

import 'package:equatable/equatable.dart';

import '../../../core/constants/user_roles.dart';

class TeamMember extends Equatable {
  const TeamMember({
    required this.id,
    required this.email,
    required this.role,
    this.displayName = '',
  });

  final String id;
  final String email;
  final UserRole role;
  final String displayName;

  @override
  List<Object?> get props => [id, email, role, displayName];
}

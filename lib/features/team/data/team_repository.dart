import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/user_roles.dart';
import '../../../core/firestore/tenant_paths.dart';
import '../domain/team_member.dart';

class TeamRepository {
  TeamRepository({FirebaseFirestore? firestore})
      : _paths = TenantPaths(firestore ?? FirebaseFirestore.instance);

  final TenantPaths _paths;

  Stream<List<TeamMember>> watchMembers(String businessId) {
    return _paths
        .businessSub(businessId, FirestoreCollections.members)
        .orderBy('joinedAt', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) {
            final data = doc.data();
            return TeamMember(
              id: doc.id,
              email: data['email'] as String? ?? '',
              role: UserRole.fromString(data['role'] as String? ?? 'employee'),
              displayName: data['displayName'] as String? ?? '',
            );
          }).toList(),
        );
  }
}

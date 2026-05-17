import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/notification_type.dart';
import '../providers/notification_providers.dart';

class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationsCountProvider);
    final colors = context.appColors;

    return IconButton(
      tooltip: 'Notifications',
      onPressed: () => _openPanel(context, ref),
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text(unread > 9 ? '9+' : '$unread'),
        child: Icon(
          unread > 0 ? Icons.notifications : Icons.notifications_outlined,
          size: 22,
          color: colors.textPrimary,
        ),
      ),
    );
  }

  void _openPanel(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _NotificationSheet(),
    );
  }
}

class _NotificationSheet extends ConsumerWidget {
  const _NotificationSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final async = ref.watch(notificationsProvider);
    final uid = ref.watch(authStateProvider).valueOrNull?.id;

    final sheetHeight = MediaQuery.sizeOf(context).height * 0.85;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.cardBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Row(
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (uid != null)
                  TextButton(
                    onPressed: () async {
                      await ref
                          .read(notificationRepositoryProvider)
                          .markAllAsRead(uid);
                    },
                    child: const Text('Mark all read'),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load notifications: $e',
                  style: GoogleFonts.inter(color: colors.textMuted),
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_none,
                            size: 48, color: colors.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          'No notifications yet',
                          style: GoogleFonts.inter(color: colors.textMuted),
                        ),
                      ],
                    ),
                  );
                }
                if (uid == null) {
                  return const SizedBox.shrink();
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _NotificationTile(
                      notification: items[index],
                      userId: uid,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({
    required this.notification,
    required this.userId,
  });

  final AppNotification notification;
  final String userId;

  IconData _iconFor(NotificationType type) => switch (type) {
        NotificationType.welcome => Icons.waving_hand_outlined,
        NotificationType.businessCreated => Icons.business_outlined,
        NotificationType.businessSwitched => Icons.swap_horiz,
        NotificationType.planUpdated => Icons.card_membership_outlined,
        NotificationType.platformUserRegistered => Icons.person_add_outlined,
        NotificationType.platformBusinessCreated => Icons.store_outlined,
        NotificationType.system => Icons.info_outline,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final n = notification;
    final accent = context.isDarkMode ? AppColors.accentTeal : AppColors.navy;
    final time = DateFormat('MMM d, HH:mm').format(n.createdAt);

    return Material(
      color: n.read ? colors.surface : colors.chipBg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          final actionRoute = n.actionRoute;
          if (!n.read) {
            await ref.read(notificationRepositoryProvider).markAsRead(
                  userId: userId,
                  notificationId: n.id,
                );
          }
          if (!context.mounted) return;

          // Close sheet on root navigator only — avoid popping go_router pages.
          final rootNav = Navigator.of(context, rootNavigator: true);
          if (rootNav.canPop()) {
            rootNav.pop();
          }

          if (actionRoute != null && actionRoute.isNotEmpty) {
            context.go(actionRoute);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_iconFor(n.type), size: 22, color: accent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            n.title,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        if (!n.read)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      n.body,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: colors.textMuted,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

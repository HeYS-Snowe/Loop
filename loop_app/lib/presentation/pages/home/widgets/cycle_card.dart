import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/l10n/generated/app_localizations.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../data/database/app_database.dart';
import '../../../../data/extensions/model_extensions.dart';
import '../../../widgets/common/glass_card.dart';

class CycleCard extends StatelessWidget {
  final Cycle cycle;
  final bool compact;

  const CycleCard({
    super.key,
    required this.cycle,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactCard(context);
    }
    return _buildFullCard(context);
  }

  Widget _buildCompactCard(BuildContext context) {
    return GlassCard(
      onTap: () => context.go(RouteConstants.tasks),
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surface.withValues(alpha: 0.7),
          AppColors.card.withValues(alpha: 0.5),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.accent.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.loop_rounded,
              size: 22,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cycle.name,
                  style: TextStyles.heading4,
                ),
                const SizedBox(height: 3),
                Text(
                  S.of(context)!.daysRemaining(cycle.remainingDays),
                  style: TextStyles.body2,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: cycle.isActive
                  ? AppColors.successMuted
                  : AppColors.primaryMuted,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              cycle.isActive ? S.of(context)!.inProgress : S.of(context)!.completed,
              style: TextStyles.caption.copyWith(
                color: cycle.isActive ? AppColors.success : AppColors.primary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullCard(BuildContext context) {
    return GlassCard(
      onTap: () => context.go(RouteConstants.tasks),
      borderRadius: 24,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surface.withValues(alpha: 0.8),
          AppColors.card.withValues(alpha: 0.6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  cycle.name,
                  style: TextStyles.heading4,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cycle.isActive)
                    GestureDetector(
                      onTap: () => context.go(
                        RouteConstants.editCycle,
                        extra: cycle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: cycle.isActive
                          ? AppColors.successMuted
                          : AppColors.primaryMuted,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cycle.isActive ? S.of(context)!.inProgress : S.of(context)!.completed,
                      style: TextStyles.caption.copyWith(
                        color: cycle.isActive
                            ? AppColors.success
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (cycle.description != null) ...[
            const SizedBox(height: 8),
            Text(
              cycle.description!,
              style: TextStyles.body2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: cycle.progressPercentage),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.progressGradient,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(cycle.progressPercentage * 100).round()}% ${S.of(context)!.completed}',
                style: TextStyles.body2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                S.of(context)!.daysRemaining(cycle.remainingDays),
                style: TextStyles.body2,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 8),
              Text(
                '${_formatDate(cycle.startDate)} - ${_formatDate(cycle.endDate)}',
                style: TextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}

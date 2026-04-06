import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../providers/settings_provider.dart';
import '../../providers/cycle_provider.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/gradient_decorations.dart';
import '../../widgets/common/animated_widgets.dart';
import '../../widgets/common/loop_time_picker.dart';
import '../../../l10n/generated/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final s = S.of(context)!;

    return settingsAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: Text(s.settings, style: TextStyles.heading3)),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: Text(s.settings, style: TextStyles.heading3)),
        body: Center(child: Text(error.toString())),
      ),
      data: (settings) => _buildSettingsContent(context, ref, settings, s),
    );
  }

  Widget _buildSettingsContent(
      BuildContext context, WidgetRef ref, SettingsState settings, S s) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(s.settings, style: TextStyles.heading3),
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: GradientDecoration(
              style: GradientStyle.diagonalHalf,
              color: AppColors.accent,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  AnimatedPageWrapper(
                    index: 0,
                    child: _buildSectionHeader(s.general),
                  ),
                  const SizedBox(height: 8),
                  AnimatedPageWrapper(
                    index: 1,
                    child: GlassCard(
                      borderRadius: 20,
                      padding: EdgeInsets.zero,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.surface.withValues(alpha: 0.75),
                          AppColors.card.withValues(alpha: 0.55),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.language_rounded,
                            iconColor: AppColors.primary,
                            title: s.language,
                            subtitle: _getLanguageName(settings.locale, s),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textTertiary,
                              size: 20,
                            ),
                            onTap: () => _showLanguagePicker(context, ref, settings.locale),
                          ),
                          const Divider(height: 1, indent: 20, endIndent: 20),
                          _buildSettingsTile(
                            icon: Icons.notifications_rounded,
                            iconColor: AppColors.warmAccent,
                            title: s.notificationReminder,
                            subtitle: s.dailyCheckInReminder,
                            trailing: Switch(
                              value: settings.enableNotifications,
                              onChanged: (value) {
                                ref
                                    .read(settingsProvider.notifier)
                                    .updateNotifications(value);
                              },
                            ),
                          ),
                          const Divider(height: 1, indent: 20, endIndent: 20),
                          _buildSettingsTile(
                            icon: Icons.schedule_rounded,
                            iconColor: AppColors.accent,
                            title: s.reminderTime,
                            subtitle: settings.notificationTime.format(context),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textTertiary,
                              size: 20,
                            ),
                            onTap: () async {
                              final time = await LoopTimePicker.show(
                                context,
                                initialTime: settings.notificationTime,
                              );
                              if (time != null) {
                                ref
                                    .read(settingsProvider.notifier)
                                    .updateReminderTime(time);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedPageWrapper(
                    index: 2,
                    child: _buildSectionHeader(s.cycleSection),
                  ),
                  const SizedBox(height: 8),
                  AnimatedPageWrapper(
                    index: 3,
                    child: GlassCard(
                      borderRadius: 20,
                      padding: EdgeInsets.zero,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.surface.withValues(alpha: 0.75),
                          AppColors.card.withValues(alpha: 0.55),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.loop_rounded,
                            iconColor: AppColors.primary,
                            title: s.defaultCycleDays,
                            subtitle: '${settings.defaultCycleDays} ${s.dayUnit}',
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textTertiary,
                              size: 20,
                            ),
                            onTap: () => _showCycleDaysPicker(
                                context, ref, settings.defaultCycleDays),
                          ),
                          const Divider(height: 1, indent: 20, endIndent: 20),
                          _buildSettingsTile(
                            icon: Icons.auto_awesome_rounded,
                            iconColor: AppColors.gold,
                            title: s.autoContinueCycle,
                            subtitle: settings.autoExtendCycle ? s.turnedOn : s.turnedOff,
                            trailing: Switch(
                              value: settings.autoExtendCycle,
                              onChanged: (value) {
                                ref
                                    .read(settingsProvider.notifier)
                                    .updateAutoExtend(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedPageWrapper(
                    index: 4,
                    child: _buildSectionHeader(s.timetableManagement),
                  ),
                  const SizedBox(height: 8),
                  AnimatedPageWrapper(
                    index: 5,
                    child: GlassCard(
                      borderRadius: 20,
                      padding: EdgeInsets.zero,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.surface.withValues(alpha: 0.75),
                          AppColors.card.withValues(alpha: 0.55),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.schedule_rounded,
                            iconColor: AppColors.accent,
                            title: s.timetableList,
                            subtitle: s.importFromHtmlDesc,
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textTertiary,
                              size: 20,
                            ),
                            onTap: () => context.push(RouteConstants.timetables),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedPageWrapper(
                    index: 4,
                    child: _buildSectionHeader(s.categoryManagement),
                  ),
                  const SizedBox(height: 8),
                  AnimatedPageWrapper(
                    index: 5,
                    child: _buildCategorySection(context, ref),
                  ),
                  const SizedBox(height: 24),
                  AnimatedPageWrapper(
                    index: 6,
                    child: _buildSectionHeader(s.dataSection),
                  ),
                  const SizedBox(height: 8),
                  AnimatedPageWrapper(
                    index: 5,
                    child: GlassCard(
                      borderRadius: 20,
                      padding: EdgeInsets.zero,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.surface.withValues(alpha: 0.75),
                          AppColors.card.withValues(alpha: 0.55),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingsTile(
                            icon: Icons.cloud_upload_rounded,
                            iconColor: AppColors.accent,
                            title: s.exportData,
                            subtitle: s.exportDataDesc,
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textTertiary,
                              size: 20,
                            ),
                            onTap: () {},
                          ),
                          const Divider(height: 1, indent: 20, endIndent: 20),
                          _buildSettingsTile(
                            icon: Icons.delete_outline_rounded,
                            iconColor: AppColors.error,
                            title: s.clearAllData,
                            subtitle: s.clearDataWarning,
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textTertiary,
                              size: 20,
                            ),
                            onTap: () {
                              _showDeleteConfirmation(context, ref);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AnimatedPageWrapper(
                    index: 6,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Loop v1.0.0',
                            style: TextStyles.caption.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            s.cyclePlanManagement,
                            style: TextStyles.caption.copyWith(
                              color: AppColors.textTertiary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(Locale? locale, S s) {
    if (locale == null) return s.languageZh;
    switch (locale.languageCode) {
      case 'zh':
        return s.languageZh;
      case 'en':
        return s.languageEn;
      default:
        return s.languageZh;
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyles.overline,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: TextStyles.body1),
      subtitle: Text(subtitle, style: TextStyles.body2),
      trailing: trailing,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final s = S.of(context)!;

    return categoriesAsync.when(
      data: (categories) {
        return GlassCard(
          borderRadius: 20,
          padding: const EdgeInsets.all(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface.withValues(alpha: 0.75),
              AppColors.card.withValues(alpha: 0.55),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s.taskCategory, style: TextStyles.body1),
                  GestureDetector(
                    onTap: () => _showAddCategoryDialog(context, ref),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add_rounded,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(s.add,
                              style: TextStyles.body2
                                  .copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (categories.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      s.noCategory,
                      style: TextStyles.body2
                          .copyWith(color: AppColors.textTertiary),
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((category) {
                    final color = Color(category.color);
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: color.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category.name,
                            style: TextStyles.body2.copyWith(color: color),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () async {
                              final repository =
                                  ref.read(categoryRepositoryProvider);
                              await repository.deleteCategory(category.id);
                              ref.invalidate(categoriesProvider);
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: color.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child:
            CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, Locale? currentLocale) {
    final s = S.of(context)!;
    final effectiveLocale = currentLocale ?? const Locale('zh');
    final options = [
      const Locale('zh'),
      const Locale('en'),
    ];
    final labels = [s.languageZh, s.languageEn];

    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(s.language, style: TextStyles.heading4),
        children: List.generate(options.length, (index) {
          final isSelected = options[index].languageCode == effectiveLocale.languageCode;
          return SimpleDialogOption(
            onPressed: () {
              ref.read(settingsProvider.notifier).updateLocale(options[index]);
              Navigator.of(dialogContext).pop();
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    labels[index],
                    style: TextStyles.body1.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_rounded, size: 18, color: AppColors.primary),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    Color selectedColor = AppColors.primary;
    final s = S.of(context)!;

    final presetColors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.success,
      AppColors.warmAccent,
      AppColors.gold,
      AppColors.error,
      const Color(0xFF9C27B0),
      const Color(0xFF00BCD4),
      const Color(0xFF795548),
      const Color(0xFF607D8B),
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(s.addCategory, style: TextStyles.heading4),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    style: TextStyles.body1,
                    decoration: InputDecoration(
                      labelText: s.categoryName,
                      hintText: s.categoryExample,
                      hintStyle:
                          TextStyles.body1.copyWith(color: AppColors.textHint),
                    ),
                    maxLength: 20,
                  ),
                  const SizedBox(height: 16),
                  Text(s.selectColor, style: TextStyles.label),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: presetColors.map((color) {
                      final isSelected = color == selectedColor;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.textPrimary,
                                    width: 2.5,
                                  )
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded,
                                  size: 18, color: AppColors.backgroundDeep)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    s.cancel,
                    style: TextStyles.body1
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    final repository = ref.read(categoryRepositoryProvider);
                    await repository.createCategory(
                      name: name,
                      color: selectedColor,
                    );
                    ref.invalidate(categoriesProvider);
                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: Text(
                    s.add,
                    style: TextStyles.body1.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.confirmDelete, style: TextStyles.heading4),
        content: Text(
          s.clearDataConfirm,
          style: TextStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              s.cancel,
              style: TextStyles.body1.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final db = ref.read(databaseProvider);
              await db.clearAllData();
              ref.invalidate(cyclesProvider);
              ref.invalidate(activeCycleProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(s.allDataCleared),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(
              s.delete,
              style: TextStyles.body1.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showCycleDaysPicker(
      BuildContext context, WidgetRef ref, int currentDays) {
    final s = S.of(context)!;
    final options = [7, 14, 21, 30, 60, 90];
    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(s.defaultCycleDays, style: TextStyles.heading4),
        children: options.map((days) {
          return SimpleDialogOption(
            onPressed: () {
              ref.read(settingsProvider.notifier).updateDefaultCycleDays(days);
              Navigator.of(dialogContext).pop();
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$days ${s.dayUnit}',
                    style: TextStyles.body1.copyWith(
                      color: days == currentDays
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight: days == currentDays
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (days == currentDays)
                  const Icon(Icons.check_rounded,
                      size: 18, color: AppColors.primary),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

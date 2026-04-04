import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/gradient_decorations.dart';
import '../../widgets/common/animated_widgets.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('设置', style: TextStyles.heading3),
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
                    child: _buildSectionHeader('通用'),
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
                            icon: Icons.notifications_rounded,
                            iconColor: AppColors.warmAccent,
                            title: '通知提醒',
                            subtitle: '每日打卡提醒',
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
                            title: '提醒时间',
                            subtitle: settings.notificationTime.format(context),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textTertiary,
                              size: 20,
                            ),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
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
                    child: _buildSectionHeader('周期'),
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
                            title: '默认周期天数',
                            subtitle: '${settings.defaultCycleDays} 天',
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textTertiary,
                              size: 20,
                            ),
                            onTap: () {},
                          ),
                          const Divider(height: 1, indent: 20, endIndent: 20),
                          _buildSettingsTile(
                            icon: Icons.auto_awesome_rounded,
                            iconColor: AppColors.gold,
                            title: '自动延续周期',
                            subtitle: settings.autoExtendCycle ? '已开启' : '已关闭',
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
                    child: _buildSectionHeader('数据'),
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
                            title: '导出数据',
                            subtitle: '备份周期和打卡记录',
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
                            title: '清除所有数据',
                            subtitle: '此操作不可撤销',
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textTertiary,
                              size: 20,
                            ),
                            onTap: () {
                              _showDeleteConfirmation(context);
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
                            '周期计划管理',
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
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认删除', style: TextStyles.heading4),
        content: Text(
          '确定要清除所有数据吗？此操作不可撤销。',
          style: TextStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '取消',
              style: TextStyles.body1.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              '删除',
              style: TextStyles.body1.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

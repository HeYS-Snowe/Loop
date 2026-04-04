import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop/core/theme/colors.dart';
import 'package:loop/core/theme/text_styles.dart';
import 'package:loop/presentation/widgets/common/glass_card.dart';
import 'package:loop/presentation/widgets/common/animated_widgets.dart';
import 'package:loop/presentation/providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('设置', style: TextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: StaggeredList(
          children: [
            _buildSectionTitle('通用'),
            _buildGeneralSection(context, ref, settings),
            const SizedBox(height: 20),
            _buildSectionTitle('分类管理'),
            _buildCategorySection(context),
            const SizedBox(height: 20),
            _buildSectionTitle('数据'),
            _buildDataSection(context),
            const SizedBox(height: 20),
            _buildSectionTitle('关于'),
            _buildAboutSection(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: TextStyles.labelSmall.copyWith(color: AppColors.textTertiary),
      ),
    );
  }

  Widget _buildGeneralSection(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      margin: EdgeInsets.zero,
      borderRadius: 14,
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: '每日打卡提醒',
            subtitle: settings.notificationsEnabled ? '已开启' : '已关闭',
            value: settings.notificationsEnabled,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .setNotificationsEnabled(value);
            },
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.access_time,
            title: '提醒时间',
            subtitle: '${settings.reminderMinutesBefore} 分钟前',
            onTap: () {
              _showReminderTimeDialog(
                  context, ref, settings.reminderMinutesBefore);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      margin: EdgeInsets.zero,
      borderRadius: 14,
      child: _buildNavigationTile(
        icon: Icons.category_outlined,
        title: '管理分类',
        subtitle: '添加、编辑或删除任务分类',
        onTap: () {},
      ),
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      margin: EdgeInsets.zero,
      borderRadius: 14,
      child: Column(
        children: [
          _buildNavigationTile(
            icon: Icons.file_download_outlined,
            title: '导出数据',
            subtitle: '备份周期和打卡记录',
            onTap: () => _showExportDialog(context),
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.delete_outline,
            title: '清除所有数据',
            subtitle: '此操作不可撤销',
            titleColor: AppColors.error,
            iconColor: AppColors.error,
            iconBgColor: AppColors.errorMuted,
            onTap: () => _showClearDataDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      margin: EdgeInsets.zero,
      borderRadius: 14,
      child: Column(
        children: [
          _buildNavigationTile(
            icon: Icons.info_outline,
            title: '版本',
            subtitle: 'v1.0.0',
            onTap: null,
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.code,
            title: '开源许可',
            subtitle: '',
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Loop',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.dividerLight,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildIconContainer(icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.body1),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyles.body3),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? titleColor,
    Color? iconColor,
    Color? iconBgColor,
    VoidCallback? onTap,
  }) {
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveIconBg = iconBgColor ?? AppColors.primaryMuted;

    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enableTapScale: onTap != null,
      borderRadius: 14,
      tintColor: const Color(0),
      boxShadow: const [],
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Row(
          children: [
            _buildIconContainer(icon,
                color: effectiveIconColor, bgColor: effectiveIconBg),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.body1.copyWith(color: titleColor),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyles.body3),
                  ],
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textTertiary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon,
      {Color? color, Color? bgColor}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.primaryMuted,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 22,
        color: color ?? AppColors.primary,
      ),
    );
  }

  void _showReminderTimeDialog(
      BuildContext context, WidgetRef ref, int currentValue) {
    final options = [5, 10, 15, 30, 60];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('提醒时间', style: TextStyles.heading4),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((minutes) {
              return RadioListTile<int>(
                title: Text('$minutes 分钟前', style: TextStyles.body2),
                value: minutes,
                groupValue: currentValue,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(settingsProvider.notifier)
                        .setReminderMinutesBefore(value);
                  }
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('导出数据', style: TextStyles.heading4),
          content: Text(
            '确定要导出所有数据吗？导出文件将保存到应用目录。',
            style: TextStyles.body2,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消',
                  style:
                      TextStyles.label.copyWith(color: AppColors.textTertiary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('数据导出成功', style: TextStyles.body2),
                    backgroundColor: AppColors.surfaceLight,
                  ),
                );
              },
              child: Text('导出', style: TextStyles.buttonSmall),
            ),
          ],
        );
      },
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('确认删除', style: TextStyles.heading4),
          content: Text(
            '确定要清除所有数据吗？此操作不可撤销。',
            style: TextStyles.body2,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消',
                  style:
                      TextStyles.label.copyWith(color: AppColors.textTertiary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('所有数据已清除', style: TextStyles.body2),
                    backgroundColor: AppColors.surfaceLight,
                  ),
                );
              },
              child: Text('删除',
                  style: TextStyles.buttonSmall.copyWith(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

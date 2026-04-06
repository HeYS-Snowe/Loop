import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/core/constants/route_constants.dart';
import 'package:loop_app/core/theme/colors.dart';
import 'package:loop_app/core/theme/text_styles.dart';
import 'package:loop_app/l10n/generated/app_localizations.dart';
import 'package:loop_app/presentation/providers/timetable_provider.dart';
import 'package:loop_app/presentation/widgets/common/glass_card.dart';
import 'package:loop_app/presentation/widgets/common/gradient_decorations.dart';
import 'package:loop_app/presentation/widgets/common/animated_widgets.dart';

enum _ImportMode { folder, file }

class TimetableImportPage extends ConsumerStatefulWidget {
  const TimetableImportPage({super.key});

  @override
  ConsumerState<TimetableImportPage> createState() =>
      _TimetableImportPageState();
}

class _TimetableImportPageState extends ConsumerState<TimetableImportPage> {
  _ImportMode _mode = _ImportMode.folder;
  bool _isImporting = false;
  String? _selectedFileName;
  String? _selectedFilePath;
  String? _selectedFolderName;
  String? _selectedFolderPath;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(s.importFromHtml, style: TextStyles.heading3),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedPageWrapper(
                      index: 0,
                      child: _buildInstructions(s),
                    ),
                    const SizedBox(height: 24),
                    AnimatedPageWrapper(
                      index: 1,
                      child: _buildModeSelector(s),
                    ),
                    const SizedBox(height: 24),
                    AnimatedPageWrapper(
                      index: 2,
                      child: _mode == _ImportMode.folder
                          ? _buildFolderPicker(s)
                          : _buildFilePicker(s),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedFileName != null ||
                        _selectedFolderName != null)
                      AnimatedPageWrapper(
                        index: 3,
                        child: _buildSelectedItem(s),
                      ),
                    if (_errorMessage != null)
                      AnimatedPageWrapper(
                        index: 4,
                        child: _buildErrorMessage(s),
                      ),
                    const SizedBox(height: 24),
                    AnimatedPageWrapper(
                      index: 5,
                      child: _buildImportButton(s),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(S s) {
    return GlassCard(
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.accent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(s.importFromHtml, style: TextStyles.heading4),
            ],
          ),
          const SizedBox(height: 16),
          _buildStep('1', s.importFromHtmlDesc, AppColors.primary),
          const SizedBox(height: 8),
          _buildStep('2', s.selectHtmlFile, AppColors.accent),
          const SizedBox(height: 8),
          _buildStep(
            '3',
            s.selectFolderDesc,
            AppColors.warmAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(text, style: TextStyles.body2),
          ),
        ),
      ],
    );
  }

  Widget _buildModeSelector(S s) {
    return GlassCard(
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.importMode, style: TextStyles.heading4),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildModeOption(
                  icon: Icons.folder_outlined,
                  label: s.folderMode,
                  desc: s.selectFolderDesc,
                  isSelected: _mode == _ImportMode.folder,
                  onTap: () => _switchMode(_ImportMode.folder),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeOption(
                  icon: Icons.description_outlined,
                  label: s.fileMode,
                  desc: s.selectFileDesc,
                  isSelected: _mode == _ImportMode.file,
                  onTap: () => _switchMode(_ImportMode.file),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeOption({
    required IconData icon,
    required String label,
    required String desc,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textTertiary.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyles.body2.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: TextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _switchMode(_ImportMode newMode) {
    if (_mode == newMode) return;
    setState(() {
      _mode = newMode;
      _selectedFileName = null;
      _selectedFilePath = null;
      _selectedFolderName = null;
      _selectedFolderPath = null;
      _errorMessage = null;
    });
  }

  Widget _buildFolderPicker(S s) {
    return GlassCard(
      onTap: _isImporting ? null : _pickFolder,
      borderRadius: 16,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.3),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.folder_open_rounded,
                color: AppColors.accent,
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              s.selectFolder,
              style: TextStyles.body1.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(s.selectFolderDesc, style: TextStyles.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePicker(S s) {
    return GlassCard(
      onTap: _isImporting ? null : _pickHtmlFile,
      borderRadius: 16,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.3),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.upload_file_rounded,
                color: AppColors.accent,
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              s.selectFile,
              style: TextStyles.body1.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text('.html / .htm', style: TextStyles.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedItem(S s) {
    final isFolder = _selectedFolderName != null;
    final displayName = isFolder ? _selectedFolderName! : _selectedFileName!;
    final subtitle = isFolder ? s.selectedFolder : 'HTML';

    return GlassCard(
      borderRadius: 14,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isFolder ? Icons.folder_rounded : Icons.description_rounded,
              color: AppColors.success,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyles.body1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyles.caption),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedFileName = null;
                _selectedFilePath = null;
                _selectedFolderName = null;
                _selectedFolderPath = null;
                _errorMessage = null;
              });
            },
            child: Icon(
              Icons.close_rounded,
              size: 18,
              color: AppColors.textTertiary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(S s) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage ?? '',
              style: TextStyles.body2.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportButton(S s) {
    final hasSelection =
        _selectedFileName != null || _selectedFolderName != null;
    final isEnabled = hasSelection && !_isImporting;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isEnabled ? () => _importFile(s) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? AppColors.primary : AppColors.textHint,
          foregroundColor: AppColors.backgroundDeep,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isImporting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.backgroundDeep,
                  strokeWidth: 2,
                ),
              )
            : Text(s.importFromHtml, style: TextStyles.button),
      ),
    );
  }

  Future<void> _pickHtmlFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['html', 'htm'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
        _selectedFilePath = result.files.single.path;
        _selectedFolderName = null;
        _selectedFolderPath = null;
        _errorMessage = null;
      });
    }
  }

  Future<void> _pickFolder() async {
    try {
      final folderPath = await FilePicker.getDirectoryPath(
        dialogTitle: S.of(context)?.selectFolder ?? 'Select Folder',
      );
      if (folderPath == null) return;

      final dir = Directory(folderPath);
      final hasHtml = await _dirContainsHtml(dir);
      if (!hasHtml) {
        setState(() {
          _errorMessage =
              S.of(context)?.noHtmlInFolder ?? 'No HTML files found';
        });
        return;
      }

      setState(() {
        _selectedFolderName = folderPath.split(Platform.pathSeparator).last;
        _selectedFolderPath = folderPath;
        _selectedFileName = null;
        _selectedFilePath = null;
        _errorMessage = null;
      });
    } on UnimplementedError {
      setState(() {
        _mode = _ImportMode.file;
        _errorMessage = S.of(context)?.folderModeNotSupported ??
            'Folder mode not supported on this platform, please use file mode';
      });
    }
  }

  Future<bool> _dirContainsHtml(Directory dir) async {
    try {
      await for (final entity in dir.list()) {
        if (entity is File) {
          final name = entity.path.toLowerCase();
          if (name.endsWith('.html') || name.endsWith('.htm')) {
            return true;
          }
        }
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  Future<void> _importFile(S s) async {
    setState(() {
      _isImporting = true;
      _errorMessage = null;
    });

    try {
      if (_mode == _ImportMode.folder && _selectedFolderPath != null) {
        final timetableName = _selectedFolderName ?? 'Timetable';
        final timetable = await ref
            .read(timetableCourseNotifierProvider.notifier)
            .importFromFolder(_selectedFolderPath!, timetableName);

        ref.invalidate(allTimetablesProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(s.importSuccess),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.go(
            '${RouteConstants.timetableDetail}?id=${timetable.id}',
          );
        }
      } else if (_mode == _ImportMode.file && _selectedFilePath != null) {
        final file = File(_selectedFilePath!);
        final htmlContent = await file.readAsString();

        final timetableName = _selectedFileName?.replaceAll(
              RegExp(r'\.(html|htm)$'),
              '',
            ) ??
            'Timetable';

        final timetable = await ref
            .read(timetableCourseNotifierProvider.notifier)
            .importFromHtml(htmlContent, timetableName);

        ref.invalidate(allTimetablesProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(s.importSuccess),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.go(
            '${RouteConstants.timetableDetail}?id=${timetable.id}',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = _getErrorMessage(e.toString(), s);
        setState(() {
          _errorMessage = errorMsg;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  String _getErrorMessage(String error, S s) {
    if (error.contains('noHtmlInFolder')) {
      return s.noHtmlInFolder;
    }
    if (error.contains('noCourseData')) {
      return s.noCourseData;
    }
    return s.importFailedDesc;
  }
}

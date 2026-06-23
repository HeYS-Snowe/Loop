import 'dart:io';
import 'package:uuid/uuid.dart';
import '../../data/database/app_database.dart';

class ParsedTimetable {
  final int academicYear;
  final int semester;
  final DateTime firstWeekMonday;
  final int totalWeeks;
  final List<ParsedCourse> courses;

  ParsedTimetable({
    required this.academicYear,
    required this.semester,
    required this.firstWeekMonday,
    required this.totalWeeks,
    required this.courses,
  });
}

class ParsedCourse {
  final String courseName;
  final String? teacherName;
  final String? location;
  final int weekday;
  final int startPeriod;
  final int endPeriod;
  final String weekRanges;

  ParsedCourse({
    required this.courseName,
    this.teacherName,
    this.location,
    required this.weekday,
    required this.startPeriod,
    required this.endPeriod,
    required this.weekRanges,
  });
}

class TimetableHtmlParser {
  static const _uuid = Uuid();

  static ParsedTimetable parse(String htmlContent) {
    final academicYear = _extractValueCascade(htmlContent, [
      () => _extractInt(htmlContent, 'id="xnm_hide"'),
      () => _extractIntFromHidden(htmlContent, 'xnm'),
      () => _extractInt(htmlContent, 'name="xnm"'),
    ], defaultValue: 2025);

    final semester = _extractValueCascade(htmlContent, [
      () => _extractInt(htmlContent, 'id="xqm_hide"'),
      () => _extractIntFromHidden(htmlContent, 'xqm'),
      () => _extractInt(htmlContent, 'name="xqm"'),
    ], defaultValue: 12);
    final firstWeekMonday = _extractFirstWeekMonday(htmlContent);
    final totalWeeks = _extractTotalWeeks(htmlContent);
    final courses = _extractCourses(htmlContent);

    return ParsedTimetable(
      academicYear: academicYear,
      semester: semester,
      firstWeekMonday: firstWeekMonday,
      totalWeeks: totalWeeks,
      courses: courses,
    );
  }

  static (ParsedTimetable, bool) parseWithValidation(String htmlContent) {
    final parsed = parse(htmlContent);
    final hasData = parsed.courses.isNotEmpty;
    return (parsed, hasData);
  }

  static Future<ParsedTimetable> parseFromFolder(String folderPath) async {
    final dir = Directory(folderPath);
    if (!await dir.exists()) {
      throw Exception('Folder not found: $folderPath');
    }

    String? htmlContent;
    await for (final entity in dir.list()) {
      if (entity is File) {
        final name = entity.path.toLowerCase();
        if (name.endsWith('.html') || name.endsWith('.htm')) {
          htmlContent = await entity.readAsString();
          break;
        }
      }
    }

    if (htmlContent == null) {
      final subDirs = <FileSystemEntity>[];
      await for (final entity in dir.list()) {
        if (entity is Directory) {
          subDirs.add(entity);
        }
      }

      if (subDirs.isEmpty) {
        throw Exception('noHtmlInFolder');
      }

      for (final subDir in subDirs) {
        if (subDir is Directory) {
          await for (final entity in subDir.list()) {
            if (entity is File) {
              final name = entity.path.toLowerCase();
              if (name.endsWith('.html') || name.endsWith('.htm')) {
                htmlContent = await entity.readAsString();
                break;
              }
            }
          }
          if (htmlContent != null) break;
        }
      }
    }

    if (htmlContent == null) {
      throw Exception('noHtmlInFolder');
    }

    final (parsed, hasData) = parseWithValidation(htmlContent);
    if (!hasData) {
      throw Exception('noCourseData');
    }

    return parsed;
  }

  static int _extractInt(String html, String idPattern, {int defaultValue = 0}) {
    final regex = RegExp(idPattern + r'[^>]*value="(\d+)"');
    final match = regex.firstMatch(html);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '') ?? defaultValue;
    }
    return defaultValue;
  }

  static int _extractValueCascade(
      String html, List<int Function()> extractors, {required int defaultValue}) {
    for (final extractor in extractors) {
      final value = extractor();
      if (value > 0) return value;
    }
    return defaultValue;
  }

  static int _extractIntFromHidden(String html, String name, {int defaultValue = 0}) {
    final patterns = [
      RegExp('<input[^>]*name="$name"[^>]*value="(\\d+)"'),
      RegExp('<input[^>]*value="(\\d+)"[^>]*name="$name"'),
      RegExp('<input[^>]*id="${name}_hide"[^>]*value="(\\d+)"'),
      RegExp('<input[^>]*value="(\\d+)"[^>]*id="${name}_hide"'),
    ];

    for (final regex in patterns) {
      final match = regex.firstMatch(html);
      if (match != null) {
        return int.tryParse(match.group(1) ?? '') ?? defaultValue;
      }
    }
    return defaultValue;
  }

  static DateTime _extractFirstWeekMonday(String html) {
    final regex = RegExp(r'<option\s+value="1"[^>]*>(.*?)</option>');
    final match = regex.firstMatch(html);
    if (match != null) {
      final text = match.group(1) ?? '';
      final dateRegex = RegExp(r'(\d{4}-\d{2}-\d{2})');
      final dateMatch = dateRegex.firstMatch(text);
      if (dateMatch != null) {
        return DateTime.parse(dateMatch.group(1)!);
      }
    }

    final weekDateRegex = RegExp(r'(\d{4}-\d{2}-\d{2})\s*~\s*\d{4}-\d{2}-\d{2}');
    final weekDateMatch = weekDateRegex.firstMatch(html);
    if (weekDateMatch != null) {
      return DateTime.parse(weekDateMatch.group(1)!);
    }

    return DateTime(2026, 3, 2);
  }

  static int _extractTotalWeeks(String html) {
    final regex = RegExp(r'<option\s+value="(\d+)"');
    final matches = regex.allMatches(html);
    int maxWeek = 0;
    for (final match in matches) {
      final week = int.tryParse(match.group(1) ?? '0') ?? 0;
      if (week > maxWeek) maxWeek = week;
    }
    return maxWeek > 0 ? maxWeek : 20;
  }

  static List<ParsedCourse> _extractCourses(String html) {
    var courses = _extractCoursesFromLessonDivs(html);
    if (courses.isNotEmpty) return courses;

    courses = _extractCoursesFromTdCells(html);
    if (courses.isNotEmpty) return courses;

    return _extractCoursesFromTable(html);
  }

  static List<ParsedCourse> _extractCoursesFromLessonDivs(String html) {
    final courses = <ParsedCourse>[];
    final lessonRegex = RegExp(
      r'<div\s+class="lesson"(.*?)</table></div>',
      dotAll: true,
    );

    for (final match in lessonRegex.allMatches(html)) {
      final divContent = match.group(1) ?? '';

      final kcmc = _getDataAttr(divContent, 'data-kcmc');
      final jsxm = _getDataAttr(divContent, 'data-jsxm');
      final cdmc = _getDataAttr(divContent, 'data-cdmc');
      final xqj = _getDataAttr(divContent, 'data-xqj');
      final jcor = _getDataAttr(divContent, 'data-jcor');
      final zcd = _getDataAttr(divContent, 'data-zcd');

      if (kcmc == null || xqj == null || jcor == null || zcd == null) continue;

      final weekday = int.tryParse(xqj) ?? 1;
      final periodRange = _parsePeriodRange(jcor);
      final weekRanges = _normalizeWeekRanges(zcd);

      courses.add(ParsedCourse(
        courseName: kcmc,
        teacherName: jsxm,
        location: cdmc,
        weekday: weekday,
        startPeriod: periodRange.$1,
        endPeriod: periodRange.$2,
        weekRanges: weekRanges,
      ));
    }

    return courses;
  }

  static List<ParsedCourse> _extractCoursesFromTdCells(String html) {
    final courses = <ParsedCourse>[];
    final tdRegex = RegExp(
      r'<td[^>]*id="td_(\d+)-(\d+)"[^>]*>(.*?)</td>',
      dotAll: true,
    );

    for (final match in tdRegex.allMatches(html)) {
      final xqj = match.group(1);
      final firstPeriod = match.group(2);
      final tdContent = match.group(3) ?? '';

      if (!tdContent.contains('weui-grid__label') &&
          !tdContent.contains('课程') &&
          !tdContent.contains('lesson')) {
        continue;
      }

      final rowspanMatch = RegExp(r'rowspan="(\d+)"').firstMatch(tdContent);
      final rowspan = rowspanMatch != null
          ? int.tryParse(rowspanMatch.group(1) ?? '1') ?? 1
          : 1;

      final labels = <String>[];
      final labelRegex = RegExp(
        r'<p[^>]*class="weui-grid__label"[^>]*>(.*?)</p>',
        dotAll: true,
      );
      for (final labelMatch in labelRegex.allMatches(tdContent)) {
        final text = labelMatch.group(1)?.trim() ?? '';
        if (text.isNotEmpty) labels.add(text);
      }

      if (labels.isEmpty) continue;

      // 智能识别各字段（课程名、课程编号、地点、老师、周次）
      final courseName = labels[0];
      String? teacherName;
      String? location;
      String weekRanges = '1-20';

      for (int i = 1; i < labels.length; i++) {
        final text = labels[i].trim();
        if (text.isEmpty) continue;

        // 周次行：包含"周"字，或纯数字范围格式（如 2-5,7-9）
        if (text.contains('周') || RegExp(r'^\d+-\d+(,\s*\d+-\d+)*$').hasMatch(text)) {
          weekRanges = _normalizeWeekRanges(text);
        }
        // 课程编号行：以课程名开头且含"-编号"后缀
        else if (text.length > courseName.length &&
            text.startsWith(courseName) &&
            RegExp(r'-[A-Za-z0-9]+$').hasMatch(text)) {
          // 课程编号，跳过
        }
        // 地点行：包含地点关键词
        else if (text.contains('校区') ||
            text.contains('楼') ||
            text.contains('教室') ||
            text.contains('室') ||
            text.contains('馆') ||
            text.contains('场')) {
          location = text;
        }
        // 其余作为老师名
        else {
          teacherName = text;
        }
      }

      final startP = int.tryParse(firstPeriod ?? '1') ?? 1;

      courses.add(ParsedCourse(
        courseName: courseName,
        teacherName: teacherName,
        location: location,
        weekday: int.tryParse(xqj ?? '1') ?? 1,
        startPeriod: startP,
        endPeriod: startP + rowspan - 1,
        weekRanges: weekRanges,
      ));
    }

    return courses;
  }

  static List<ParsedCourse> _extractCoursesFromTable(String html) {
    final courses = <ParsedCourse>[];
    final textContent = html.replaceAll(RegExp(r'<[^>]+'), ' ').replaceAll(RegExp(r'\s+'), ' ');

    final coursePatterns = [
      RegExp(r'([\u4e00-\u9fa5A-Za-z]+(?:程序设计|基础|原理|导论|概论|数学|英语|体育|物理|化学|力学|实验|实践|实习|设计))'),
    ];

    for (final pattern in coursePatterns) {
      for (final match in pattern.allMatches(textContent)) {
        final name = match.group(1);
        if (name != null && name.length >= 2) {
          bool exists = courses.any((c) => c.courseName == name);
          if (!exists) {
            courses.add(ParsedCourse(
              courseName: name,
              weekday: 1,
              startPeriod: 1,
              endPeriod: 2,
              weekRanges: '1-20',
            ));
          }
        }
      }
    }

    return courses;
  }

  static String? _getDataAttr(String content, String attrName) {
    final regex = RegExp(attrName + r'="([^"]*)"');
    final match = regex.firstMatch(content);
    return match?.group(1);
  }

  static (int, int) _parsePeriodRange(String jcor) {
    final parts = jcor.split('-');
    if (parts.length == 2) {
      return (
        int.tryParse(parts[0]) ?? 1,
        int.tryParse(parts[1]) ?? 2,
      );
    }
    final single = int.tryParse(jcor);
    if (single != null) {
      return (single, single);
    }
    return (1, 2);
  }

  static String _normalizeWeekRanges(String zcd) {
    return zcd.replaceAll(RegExp(r'周'), '').trim();
  }

  static List<TimetableCourse> toTimetableCourses(
      String timetableId, List<ParsedCourse> parsedCourses) {
    final now = DateTime.now();
    return parsedCourses.map((c) {
      return TimetableCourse(
        id: _uuid.v4(),
        timetableId: timetableId,
        courseName: c.courseName,
        teacherName: c.teacherName,
        location: c.location,
        weekday: c.weekday,
        startPeriod: c.startPeriod,
        endPeriod: c.endPeriod,
        weekRanges: c.weekRanges,
        colorHex: null,
        createdAt: now,
        updatedAt: now,
      );
    }).toList();
  }
}

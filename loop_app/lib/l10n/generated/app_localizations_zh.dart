// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class SZh extends S {
  SZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Loop';

  @override
  String get home => '首页';

  @override
  String get dailyPlan => '日计划';

  @override
  String get statistics => '统计';

  @override
  String get settings => '设置';

  @override
  String get todayPlan => '今日计划';

  @override
  String get viewAll => '查看全部';

  @override
  String get currentCycle => '当前周期';

  @override
  String get historyCycle => '历史周期';

  @override
  String get createCycle => '创建新周期';

  @override
  String get startFirstCycle => '开始你的第一个周期计划';

  @override
  String get noHistoryCycle => '暂无历史周期';

  @override
  String get createTodayPlan => '创建今日计划';

  @override
  String get startPlanDay => '开始规划你的一天';

  @override
  String get completed => '已完成';

  @override
  String get inProgress => '进行中';

  @override
  String get total => '总计';

  @override
  String loadFailed(String error) {
    return '加载失败: $error';
  }

  @override
  String get unknownPlan => '未知计划';

  @override
  String get dailyCheckIn => '每日打卡';

  @override
  String get checkedInToday => '今日已打卡';

  @override
  String get notCheckedInToday => '今日未打卡';

  @override
  String get dayUnit => '天';

  @override
  String get checkInNow => '立即打卡';

  @override
  String daysRemaining(int count) {
    return '$count 天剩余';
  }

  @override
  String get streakCheckIn => '连续打卡';

  @override
  String get maxRecord => '最长记录';

  @override
  String get totalCheckIn => '累计打卡';

  @override
  String get checkIn => '打卡';

  @override
  String get checkInCalendar => '打卡日历';

  @override
  String get clickToCheckIn => '点击打卡';

  @override
  String streakDays(int count) {
    return '已连续 $count 天';
  }

  @override
  String get pageNotFound => '页面不存在';

  @override
  String get backToHome => '返回首页';

  @override
  String dateYearMonthDay(int year, int month, int day) {
    return '$year年$month月$day日';
  }

  @override
  String get dailyReminder => '每日提醒';

  @override
  String get dailyReminderBody => '每日任务提醒通知';

  @override
  String get editPlan => '编辑计划';

  @override
  String get createPlan => '创建计划';

  @override
  String get basicInfo => '基本信息';

  @override
  String get planName => '计划名称';

  @override
  String get planNameHint => '例如: 背英语单词';

  @override
  String get descriptionOptional => '描述(可选)';

  @override
  String get descriptionHint => '计划的详细说明';

  @override
  String get quantityTarget => '数量目标';

  @override
  String get dailyTarget => '每日目标';

  @override
  String get unit => '单位';

  @override
  String get unitHint => '个/分钟';

  @override
  String get enableQuantityValidation => '启用数量验证';

  @override
  String get enableQuantityValidationDesc => '开启后需输入完成数量';

  @override
  String get timeSlot => '时间段';

  @override
  String get timeSlotDesc => '设置计划在课程表中的显示时间';

  @override
  String get timeConflictWarning => '时间段与课程冲突';

  @override
  String timeConflictDesc(String courses) {
    return '当前设置的时间段与以下课程存在时间重叠：$courses';
  }

  @override
  String get timeConflictConfirm => '仍要保存';

  @override
  String get startTime => '开始时间';

  @override
  String get endTime => '结束时间';

  @override
  String get tapToEdit => '点击修改';

  @override
  String get selectStartTime => '选择开始时间';

  @override
  String get selectEndTime => '选择结束时间';

  @override
  String get cardColor => '卡片颜色';

  @override
  String get cardColorDesc => '选择在课程表中的显示颜色';

  @override
  String get repeatRule => '重复规则';

  @override
  String get noRepeat => '不重复';

  @override
  String get repeatDaily => '每天';

  @override
  String get repeatWeekly => '每周';

  @override
  String get repeatMonthly => '每月';

  @override
  String get repeatInterval => '自定义间隔';

  @override
  String get every => '每';

  @override
  String get repeatEveryDay => '天重复一次';

  @override
  String get activeDate => '活动日期';

  @override
  String get executeDaily => '每天执行';

  @override
  String get selectWeekdays => '选择要执行计划的星期';

  @override
  String get weekday => '星期';

  @override
  String get everyday => '每天';

  @override
  String get weekend => '周末';

  @override
  String get timeRange => '时间范围';

  @override
  String get startDate => '开始日期';

  @override
  String get endDate => '结束日期';

  @override
  String get unlimited => '不限';

  @override
  String get saveChanges => '保存修改';

  @override
  String pleaseEnter(String label) {
    return '请输入$label';
  }

  @override
  String get pleaseSelectActiveDate => '请至少选择一个活动日期';

  @override
  String get planUpdated => '计划已更新';

  @override
  String get planCreated => '计划已创建';

  @override
  String operationFailed(String error) {
    return '操作失败: $error';
  }

  @override
  String get timePickerDefaultTitle => '选择提醒时间';

  @override
  String get timePicker24Hour => '24小时制';

  @override
  String get hourUnit => '时';

  @override
  String get minuteUnit => '分';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get taskList => '任务列表';

  @override
  String get noActiveCycle => '暂无活动周期';

  @override
  String get pleaseCreateCycleFirst => '请先创建一个周期计划';

  @override
  String get createCycleBtn => '创建周期';

  @override
  String get noTask => '暂无任务';

  @override
  String get addTaskHint => '点击右下角按钮添加任务';

  @override
  String inProgressCount(int count) {
    return '进行中 ($count)';
  }

  @override
  String completedCount(int count) {
    return '已完成 ($count)';
  }

  @override
  String get taskDetail => '任务详情';

  @override
  String get taskNotExist => '任务不存在';

  @override
  String get progress => '进度';

  @override
  String get updateProgress => '更新进度';

  @override
  String get addTask => '添加任务';

  @override
  String get taskName => '任务名称';

  @override
  String get descOptional => '描述（可选）';

  @override
  String get targetAmount => '目标数量';

  @override
  String get unitOptional => '单位（可选）';

  @override
  String get repeatable => '可重复';

  @override
  String get repeatableDesc => '在新周期中自动创建';

  @override
  String get add => '添加';

  @override
  String get taskCreatedSuccess => '任务创建成功';

  @override
  String get editTask => '编辑任务';

  @override
  String get save => '保存';

  @override
  String get taskUpdated => '任务已更新';

  @override
  String updateFailed(String error) {
    return '更新失败: $error';
  }

  @override
  String get editCycle => '编辑周期';

  @override
  String get cycleName => '周期名称';

  @override
  String get cycleNameHint => '例如：第一周学习计划';

  @override
  String get cycleDescHint => '为这个周期添加备注';

  @override
  String get cycleTime => '周期时间';

  @override
  String totalDays(int count) {
    return '共 $count 天';
  }

  @override
  String get quickSelectCycle => '快速选择周期';

  @override
  String get oneWeek => '1周';

  @override
  String get twoWeeks => '2周';

  @override
  String get threeWeeks => '3周';

  @override
  String get oneMonth => '1个月';

  @override
  String get twoMonths => '2个月';

  @override
  String get threeMonths => '3个月';

  @override
  String get cycleUpdated => '周期已更新';

  @override
  String get cycleCreatedSuccess => '周期创建成功';

  @override
  String get mon => '一';

  @override
  String get tue => '二';

  @override
  String get wed => '三';

  @override
  String get thu => '四';

  @override
  String get fri => '五';

  @override
  String get sat => '六';

  @override
  String get sun => '日';

  @override
  String get monday => '周一';

  @override
  String get tuesday => '周二';

  @override
  String get wednesday => '周三';

  @override
  String get thursday => '周四';

  @override
  String get friday => '周五';

  @override
  String get saturday => '周六';

  @override
  String get sunday => '周日';

  @override
  String get schedule => '行程表';

  @override
  String get loadFailedShort => '加载失败';

  @override
  String get thisWeek => '本周';

  @override
  String get lastWeek => '上周';

  @override
  String get nextWeek => '下周';

  @override
  String get weekAgo => '周前';

  @override
  String get weekLater => '周后';

  @override
  String get session => '节次';

  @override
  String get noCyclePlan => '暂无周期计划';

  @override
  String get createCycleScheduleHint => '创建一个周期计划后\n行程表将自动展示你的任务安排';

  @override
  String get noCycleData => '暂无周期数据';

  @override
  String get cycleStats => '周期统计';

  @override
  String avgCompletionRate(int rate) {
    return '平均完成率 $rate%';
  }

  @override
  String get weeklyPlanStats => '本周计划统计';

  @override
  String get noWeeklyPlanData => '本周暂无计划数据';

  @override
  String get createPlanWeeklyHint => '创建计划后这里会显示每周统计';

  @override
  String get completionRate => '完成率';

  @override
  String get completedAmount => '已完成';

  @override
  String get totalAmount => '总数量';

  @override
  String get dailyCompletion => '每日完成量';

  @override
  String get target => '目标';

  @override
  String get finish => '完成';

  @override
  String get general => '通用';

  @override
  String get notificationReminder => '通知提醒';

  @override
  String get dailyCheckInReminder => '每日打卡提醒';

  @override
  String get reminderTime => '提醒时间';

  @override
  String get cycleSection => '周期';

  @override
  String get defaultCycleDays => '默认周期天数';

  @override
  String get autoContinueCycle => '自动延续周期';

  @override
  String get turnedOn => '已开启';

  @override
  String get turnedOff => '已关闭';

  @override
  String get categoryManagement => '分类管理';

  @override
  String get dataSection => '数据';

  @override
  String get exportData => '导出数据';

  @override
  String get exportDataDesc => '备份周期和打卡记录';

  @override
  String get clearAllData => '清除所有数据';

  @override
  String get clearDataWarning => '此操作不可撤销';

  @override
  String get cyclePlanManagement => '周期计划管理';

  @override
  String get taskCategory => '任务分类';

  @override
  String get addCategory => '添加分类';

  @override
  String get categoryName => '分类名称';

  @override
  String get categoryExample => '例如：学习、运动';

  @override
  String get selectColor => '选择颜色';

  @override
  String get noCategory => '暂无分类，点击添加';

  @override
  String get confirmDelete => '确认删除';

  @override
  String get clearDataConfirm => '确定要清除所有数据吗？此操作不可撤销。';

  @override
  String get allDataCleared => '所有数据已清除';

  @override
  String get delete => '删除';

  @override
  String get time => '时间';

  @override
  String get completedAmountLabel => '完成量:';

  @override
  String get generalSettings => '通用设置';

  @override
  String get language => '语言';

  @override
  String get languageZh => '中文';

  @override
  String get languageEn => 'English';

  @override
  String get languageJa => '日本語';

  @override
  String get languageKo => '한국어';

  @override
  String get languageFr => 'Français';

  @override
  String get languageDe => 'Deutsch';

  @override
  String get taskNameRequired => '请输入任务名称';

  @override
  String get taskNameTooLong => '任务名称不能超过50字符';

  @override
  String get targetMustBePositive => '目标量必须大于0';

  @override
  String get cycleNameRequired => '请输入周期名称';

  @override
  String get cycleNameTooLong => '周期名称不能超过30字符';

  @override
  String get selectDateRange => '请选择开始和结束日期';

  @override
  String get endDateBeforeStart => '结束日期不能早于开始日期';

  @override
  String get categoryNameRequired => '请输入分类名称';

  @override
  String get categoryNameTooLong => '分类名称不能超过20字符';

  @override
  String get timetableManagement => '课表管理';

  @override
  String get timetableList => '课表列表';

  @override
  String get noTimetable => '暂无课表';

  @override
  String get importFromHtml => '从HTML导入';

  @override
  String get importFromHtmlDesc => '从教务系统导出的HTML文件导入课表';

  @override
  String get createTimetable => '手动创建课表';

  @override
  String get timetableName => '课表名称';

  @override
  String get timetableNameHint => '例如: 2025-2026学年第二学期';

  @override
  String get academicYear => '学年';

  @override
  String get semester => '学期';

  @override
  String get firstSemester => '第一学期';

  @override
  String get secondSemester => '第二学期';

  @override
  String get thirdSemester => '第三学期';

  @override
  String get firstWeekMonday => '第一周周一日期';

  @override
  String get totalWeeks => '总周数';

  @override
  String get currentWeek => '当前周次';

  @override
  String courseCount(int count) {
    return '课程数: $count';
  }

  @override
  String get timetableDetail => '课表详情';

  @override
  String get courseManagement => '课程管理';

  @override
  String get addCourse => '添加课程';

  @override
  String get courseName => '课程名称';

  @override
  String get courseNameHint => '例如: 高等数学';

  @override
  String get teacherName => '教师姓名';

  @override
  String get teacherNameHint => '例如: 张三';

  @override
  String get location => '上课地点';

  @override
  String get locationHint => '例如: 教学楼A-301';

  @override
  String get periodRange => '节次范围';

  @override
  String get startPeriod => '开始节次';

  @override
  String get endPeriod => '结束节次';

  @override
  String get weekRanges => '上课周次';

  @override
  String get weekRangesHint => '例如: 1-16周';

  @override
  String get courseColor => '课程颜色';

  @override
  String get courseCreated => '课程已添加';

  @override
  String get courseDeleted => '课程已删除';

  @override
  String get timetableCreated => '课表已创建';

  @override
  String get timetableDeleted => '课表已删除';

  @override
  String get importSuccess => '导入成功';

  @override
  String importSuccessDesc(int count) {
    return '成功导入 $count 门课程';
  }

  @override
  String get selectHtmlFile => '选择HTML文件';

  @override
  String get importing => '正在导入...';

  @override
  String get importFailed => '导入失败';

  @override
  String get importFailedDesc => '无法解析HTML文件，请检查文件格式';

  @override
  String get timetableNameRequired => '请输入课表名称';

  @override
  String get courseNameRequired => '请输入课程名称';

  @override
  String get weekdayRequired => '请选择星期';

  @override
  String get periodRequired => '请选择节次范围';

  @override
  String get weekRangesRequired => '请输入上课周次';

  @override
  String weekFormat(int week) {
    return '第$week周';
  }

  @override
  String weekFormatNotCurrent(int week) {
    return '第$week周（非本周）';
  }

  @override
  String periodFormat(int start, int end) {
    return '第$start-$end节';
  }

  @override
  String semesterFormat(String year, int semester) {
    return '$year学年 第$semester学期';
  }

  @override
  String timetableSource(String source) {
    return '来源: $source';
  }

  @override
  String get sourceHtml => 'HTML导入';

  @override
  String get sourceManual => '手动创建';

  @override
  String get confirmDeleteTimetable => '确定要删除此课表吗？所有课程数据将被清除。';

  @override
  String get confirmDeleteCourse => '确定要删除此课程吗？';

  @override
  String get editCourse => '编辑课程';

  @override
  String get courseUpdated => '课程已更新';

  @override
  String get todayCourse => '今日课程';

  @override
  String get noCourseToday => '今天没有课';

  @override
  String get selectFolder => '选择文件夹';

  @override
  String get selectFolderDesc => '选择浏览器保存完整网页时生成的文件夹';

  @override
  String get selectFile => '选择HTML文件';

  @override
  String get selectFileDesc => '直接选择单个 .html 文件';

  @override
  String get importMode => '导入方式';

  @override
  String get importModeHint => '请选择导入方式';

  @override
  String get folderMode => '文件夹模式';

  @override
  String get fileMode => '单文件模式';

  @override
  String get noHtmlInFolder => '所选文件夹中未找到HTML文件';

  @override
  String get noCourseData => '未在HTML文件中找到课表数据，请确保保存网页时选择\"完整网页\"模式';

  @override
  String get importFolderSuccess => '从文件夹导入成功';

  @override
  String get selectedFolder => '已选择文件夹';

  @override
  String htmlFilesFound(int count) {
    return '找到 $count 个HTML文件';
  }

  @override
  String get folderModeNotSupported => '当前平台不支持文件夹选择，已切换为文件模式';

  @override
  String get selectMonthDays => '选择每月执行的日期';

  @override
  String get monthStart => '月初';

  @override
  String get monthMid => '月中';

  @override
  String get monthEnd => '月末';

  @override
  String get planDate => '计划日期';

  @override
  String get timeRangeDescNone => '选择计划执行的日期';

  @override
  String get timeRangeDescDaily => '在此时间范围内每天执行';

  @override
  String get timeRangeDescWeekly => '在此时间范围内按选定的星期执行';

  @override
  String get timeRangeDescMonthly => '在此时间范围内按选定的日期执行';

  @override
  String get timeRangeDescInterval => '在此时间范围内按间隔天数执行';

  @override
  String get enableTimeSlot => '启用时间段';

  @override
  String get enableTimeSlotDesc => '关闭后计划将不受时间约束';

  @override
  String get allDayEvents => '全天计划';

  @override
  String monthFormat(int month) {
    return '第$month月';
  }

  @override
  String monthFormatNotCurrent(int month) {
    return '第$month月（非本月）';
  }

  @override
  String get confirmSemesterStart => '确认学期起始日期';

  @override
  String get confirmSemesterStartDesc => '检测到学期第一周周一为以下日期，请确认或调整：';

  @override
  String get editPlanInstance => '编辑计划';

  @override
  String get selectEditScope => '选择修改范围';

  @override
  String get editScopeThisOnly => '仅修改本次';

  @override
  String get editScopeThisOnlyDesc => '只修改当前这一条计划';

  @override
  String get editScopeFuture => '修改以后计划';

  @override
  String get editScopeFutureDesc => '修改当前及之后的所有计划';

  @override
  String get editScopePast => '修改以前计划';

  @override
  String get editScopePastDesc => '修改当前及之前的所有计划';

  @override
  String get editScopeAll => '修改全部计划';

  @override
  String get editScopeAllDesc => '修改所有关联的计划';

  @override
  String get planInstanceUpdated => '计划已更新';

  @override
  String get confirmDeletePlan => '确定要删除此计划吗？所有相关记录将被清除。';

  @override
  String get planDeleted => '计划已删除';

  @override
  String get exportSuccess => '数据已导出';

  @override
  String get exportFailed => '导出失败';

  @override
  String get filterTasks => '筛选任务';

  @override
  String get storagePermissionDenied => '需要\"所有文件访问\"权限才能扫描文件夹，请在设置中授予权限';

  @override
  String folderAccessError(String error) {
    return '无法访问文件夹: $error';
  }
}

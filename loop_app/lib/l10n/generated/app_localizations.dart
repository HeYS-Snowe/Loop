import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh')
  ];

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'Loop'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In zh, this message translates to:
  /// **'首页'**
  String get home;

  /// No description provided for @dailyPlan.
  ///
  /// In zh, this message translates to:
  /// **'日计划'**
  String get dailyPlan;

  /// No description provided for @statistics.
  ///
  /// In zh, this message translates to:
  /// **'统计'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @todayPlan.
  ///
  /// In zh, this message translates to:
  /// **'今日计划'**
  String get todayPlan;

  /// No description provided for @viewAll.
  ///
  /// In zh, this message translates to:
  /// **'查看全部'**
  String get viewAll;

  /// No description provided for @currentCycle.
  ///
  /// In zh, this message translates to:
  /// **'当前周期'**
  String get currentCycle;

  /// No description provided for @historyCycle.
  ///
  /// In zh, this message translates to:
  /// **'历史周期'**
  String get historyCycle;

  /// No description provided for @createCycle.
  ///
  /// In zh, this message translates to:
  /// **'创建新周期'**
  String get createCycle;

  /// No description provided for @startFirstCycle.
  ///
  /// In zh, this message translates to:
  /// **'开始你的第一个周期计划'**
  String get startFirstCycle;

  /// No description provided for @noHistoryCycle.
  ///
  /// In zh, this message translates to:
  /// **'暂无历史周期'**
  String get noHistoryCycle;

  /// No description provided for @createTodayPlan.
  ///
  /// In zh, this message translates to:
  /// **'创建今日计划'**
  String get createTodayPlan;

  /// No description provided for @startPlanDay.
  ///
  /// In zh, this message translates to:
  /// **'开始规划你的一天'**
  String get startPlanDay;

  /// No description provided for @completed.
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get completed;

  /// No description provided for @inProgress.
  ///
  /// In zh, this message translates to:
  /// **'进行中'**
  String get inProgress;

  /// No description provided for @total.
  ///
  /// In zh, this message translates to:
  /// **'总计'**
  String get total;

  /// No description provided for @loadFailed.
  ///
  /// In zh, this message translates to:
  /// **'加载失败: {error}'**
  String loadFailed(String error);

  /// No description provided for @unknownPlan.
  ///
  /// In zh, this message translates to:
  /// **'未知计划'**
  String get unknownPlan;

  /// No description provided for @dailyCheckIn.
  ///
  /// In zh, this message translates to:
  /// **'每日打卡'**
  String get dailyCheckIn;

  /// No description provided for @checkedInToday.
  ///
  /// In zh, this message translates to:
  /// **'今日已打卡'**
  String get checkedInToday;

  /// No description provided for @notCheckedInToday.
  ///
  /// In zh, this message translates to:
  /// **'今日未打卡'**
  String get notCheckedInToday;

  /// No description provided for @dayUnit.
  ///
  /// In zh, this message translates to:
  /// **'天'**
  String get dayUnit;

  /// No description provided for @checkInNow.
  ///
  /// In zh, this message translates to:
  /// **'立即打卡'**
  String get checkInNow;

  /// No description provided for @daysRemaining.
  ///
  /// In zh, this message translates to:
  /// **'{count} 天剩余'**
  String daysRemaining(int count);

  /// No description provided for @streakCheckIn.
  ///
  /// In zh, this message translates to:
  /// **'连续打卡'**
  String get streakCheckIn;

  /// No description provided for @maxRecord.
  ///
  /// In zh, this message translates to:
  /// **'最长记录'**
  String get maxRecord;

  /// No description provided for @totalCheckIn.
  ///
  /// In zh, this message translates to:
  /// **'累计打卡'**
  String get totalCheckIn;

  /// No description provided for @checkIn.
  ///
  /// In zh, this message translates to:
  /// **'打卡'**
  String get checkIn;

  /// No description provided for @checkInCalendar.
  ///
  /// In zh, this message translates to:
  /// **'打卡日历'**
  String get checkInCalendar;

  /// No description provided for @clickToCheckIn.
  ///
  /// In zh, this message translates to:
  /// **'点击打卡'**
  String get clickToCheckIn;

  /// No description provided for @streakDays.
  ///
  /// In zh, this message translates to:
  /// **'已连续 {count} 天'**
  String streakDays(int count);

  /// No description provided for @pageNotFound.
  ///
  /// In zh, this message translates to:
  /// **'页面不存在'**
  String get pageNotFound;

  /// No description provided for @backToHome.
  ///
  /// In zh, this message translates to:
  /// **'返回首页'**
  String get backToHome;

  /// No description provided for @dateYearMonthDay.
  ///
  /// In zh, this message translates to:
  /// **'{year}年{month}月{day}日'**
  String dateYearMonthDay(int year, int month, int day);

  /// No description provided for @dailyReminder.
  ///
  /// In zh, this message translates to:
  /// **'每日提醒'**
  String get dailyReminder;

  /// No description provided for @dailyReminderBody.
  ///
  /// In zh, this message translates to:
  /// **'每日任务提醒通知'**
  String get dailyReminderBody;

  /// No description provided for @editPlan.
  ///
  /// In zh, this message translates to:
  /// **'编辑计划'**
  String get editPlan;

  /// No description provided for @createPlan.
  ///
  /// In zh, this message translates to:
  /// **'创建计划'**
  String get createPlan;

  /// No description provided for @basicInfo.
  ///
  /// In zh, this message translates to:
  /// **'基本信息'**
  String get basicInfo;

  /// No description provided for @planName.
  ///
  /// In zh, this message translates to:
  /// **'计划名称'**
  String get planName;

  /// No description provided for @planNameHint.
  ///
  /// In zh, this message translates to:
  /// **'例如: 背英语单词'**
  String get planNameHint;

  /// No description provided for @descriptionOptional.
  ///
  /// In zh, this message translates to:
  /// **'描述(可选)'**
  String get descriptionOptional;

  /// No description provided for @descriptionHint.
  ///
  /// In zh, this message translates to:
  /// **'计划的详细说明'**
  String get descriptionHint;

  /// No description provided for @quantityTarget.
  ///
  /// In zh, this message translates to:
  /// **'数量目标'**
  String get quantityTarget;

  /// No description provided for @dailyTarget.
  ///
  /// In zh, this message translates to:
  /// **'每日目标'**
  String get dailyTarget;

  /// No description provided for @unit.
  ///
  /// In zh, this message translates to:
  /// **'单位'**
  String get unit;

  /// No description provided for @unitHint.
  ///
  /// In zh, this message translates to:
  /// **'个/分钟'**
  String get unitHint;

  /// No description provided for @enableQuantityValidation.
  ///
  /// In zh, this message translates to:
  /// **'启用数量验证'**
  String get enableQuantityValidation;

  /// No description provided for @enableQuantityValidationDesc.
  ///
  /// In zh, this message translates to:
  /// **'开启后需输入完成数量'**
  String get enableQuantityValidationDesc;

  /// No description provided for @timeSlot.
  ///
  /// In zh, this message translates to:
  /// **'时间段'**
  String get timeSlot;

  /// No description provided for @timeSlotDesc.
  ///
  /// In zh, this message translates to:
  /// **'设置计划在课程表中的显示时间'**
  String get timeSlotDesc;

  /// No description provided for @timeConflictWarning.
  ///
  /// In zh, this message translates to:
  /// **'时间段与课程冲突'**
  String get timeConflictWarning;

  /// No description provided for @timeConflictDesc.
  ///
  /// In zh, this message translates to:
  /// **'当前设置的时间段与以下课程存在时间重叠：{courses}'**
  String timeConflictDesc(String courses);

  /// No description provided for @timeConflictConfirm.
  ///
  /// In zh, this message translates to:
  /// **'仍要保存'**
  String get timeConflictConfirm;

  /// No description provided for @startTime.
  ///
  /// In zh, this message translates to:
  /// **'开始时间'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In zh, this message translates to:
  /// **'结束时间'**
  String get endTime;

  /// No description provided for @tapToEdit.
  ///
  /// In zh, this message translates to:
  /// **'点击修改'**
  String get tapToEdit;

  /// No description provided for @selectStartTime.
  ///
  /// In zh, this message translates to:
  /// **'选择开始时间'**
  String get selectStartTime;

  /// No description provided for @selectEndTime.
  ///
  /// In zh, this message translates to:
  /// **'选择结束时间'**
  String get selectEndTime;

  /// No description provided for @cardColor.
  ///
  /// In zh, this message translates to:
  /// **'卡片颜色'**
  String get cardColor;

  /// No description provided for @cardColorDesc.
  ///
  /// In zh, this message translates to:
  /// **'选择在课程表中的显示颜色'**
  String get cardColorDesc;

  /// No description provided for @repeatRule.
  ///
  /// In zh, this message translates to:
  /// **'重复规则'**
  String get repeatRule;

  /// No description provided for @noRepeat.
  ///
  /// In zh, this message translates to:
  /// **'不重复'**
  String get noRepeat;

  /// No description provided for @repeatDaily.
  ///
  /// In zh, this message translates to:
  /// **'每天'**
  String get repeatDaily;

  /// No description provided for @repeatWeekly.
  ///
  /// In zh, this message translates to:
  /// **'每周'**
  String get repeatWeekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In zh, this message translates to:
  /// **'每月'**
  String get repeatMonthly;

  /// No description provided for @repeatInterval.
  ///
  /// In zh, this message translates to:
  /// **'自定义间隔'**
  String get repeatInterval;

  /// No description provided for @every.
  ///
  /// In zh, this message translates to:
  /// **'每'**
  String get every;

  /// No description provided for @repeatEveryDay.
  ///
  /// In zh, this message translates to:
  /// **'天重复一次'**
  String get repeatEveryDay;

  /// No description provided for @activeDate.
  ///
  /// In zh, this message translates to:
  /// **'活动日期'**
  String get activeDate;

  /// No description provided for @executeDaily.
  ///
  /// In zh, this message translates to:
  /// **'每天执行'**
  String get executeDaily;

  /// No description provided for @selectWeekdays.
  ///
  /// In zh, this message translates to:
  /// **'选择要执行计划的星期'**
  String get selectWeekdays;

  /// No description provided for @weekday.
  ///
  /// In zh, this message translates to:
  /// **'星期'**
  String get weekday;

  /// No description provided for @everyday.
  ///
  /// In zh, this message translates to:
  /// **'每天'**
  String get everyday;

  /// No description provided for @weekend.
  ///
  /// In zh, this message translates to:
  /// **'周末'**
  String get weekend;

  /// No description provided for @timeRange.
  ///
  /// In zh, this message translates to:
  /// **'时间范围'**
  String get timeRange;

  /// No description provided for @startDate.
  ///
  /// In zh, this message translates to:
  /// **'开始日期'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In zh, this message translates to:
  /// **'结束日期'**
  String get endDate;

  /// No description provided for @unlimited.
  ///
  /// In zh, this message translates to:
  /// **'不限'**
  String get unlimited;

  /// No description provided for @saveChanges.
  ///
  /// In zh, this message translates to:
  /// **'保存修改'**
  String get saveChanges;

  /// No description provided for @pleaseEnter.
  ///
  /// In zh, this message translates to:
  /// **'请输入{label}'**
  String pleaseEnter(String label);

  /// No description provided for @pleaseSelectActiveDate.
  ///
  /// In zh, this message translates to:
  /// **'请至少选择一个活动日期'**
  String get pleaseSelectActiveDate;

  /// No description provided for @planUpdated.
  ///
  /// In zh, this message translates to:
  /// **'计划已更新'**
  String get planUpdated;

  /// No description provided for @planCreated.
  ///
  /// In zh, this message translates to:
  /// **'计划已创建'**
  String get planCreated;

  /// No description provided for @operationFailed.
  ///
  /// In zh, this message translates to:
  /// **'操作失败: {error}'**
  String operationFailed(String error);

  /// No description provided for @timePickerDefaultTitle.
  ///
  /// In zh, this message translates to:
  /// **'选择提醒时间'**
  String get timePickerDefaultTitle;

  /// No description provided for @timePicker24Hour.
  ///
  /// In zh, this message translates to:
  /// **'24小时制'**
  String get timePicker24Hour;

  /// No description provided for @hourUnit.
  ///
  /// In zh, this message translates to:
  /// **'时'**
  String get hourUnit;

  /// No description provided for @minuteUnit.
  ///
  /// In zh, this message translates to:
  /// **'分'**
  String get minuteUnit;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get confirm;

  /// No description provided for @taskList.
  ///
  /// In zh, this message translates to:
  /// **'任务列表'**
  String get taskList;

  /// No description provided for @noActiveCycle.
  ///
  /// In zh, this message translates to:
  /// **'暂无活动周期'**
  String get noActiveCycle;

  /// No description provided for @pleaseCreateCycleFirst.
  ///
  /// In zh, this message translates to:
  /// **'请先创建一个周期计划'**
  String get pleaseCreateCycleFirst;

  /// No description provided for @createCycleBtn.
  ///
  /// In zh, this message translates to:
  /// **'创建周期'**
  String get createCycleBtn;

  /// No description provided for @noTask.
  ///
  /// In zh, this message translates to:
  /// **'暂无任务'**
  String get noTask;

  /// No description provided for @addTaskHint.
  ///
  /// In zh, this message translates to:
  /// **'点击右下角按钮添加任务'**
  String get addTaskHint;

  /// No description provided for @inProgressCount.
  ///
  /// In zh, this message translates to:
  /// **'进行中 ({count})'**
  String inProgressCount(int count);

  /// No description provided for @completedCount.
  ///
  /// In zh, this message translates to:
  /// **'已完成 ({count})'**
  String completedCount(int count);

  /// No description provided for @taskDetail.
  ///
  /// In zh, this message translates to:
  /// **'任务详情'**
  String get taskDetail;

  /// No description provided for @taskNotExist.
  ///
  /// In zh, this message translates to:
  /// **'任务不存在'**
  String get taskNotExist;

  /// No description provided for @progress.
  ///
  /// In zh, this message translates to:
  /// **'进度'**
  String get progress;

  /// No description provided for @updateProgress.
  ///
  /// In zh, this message translates to:
  /// **'更新进度'**
  String get updateProgress;

  /// No description provided for @addTask.
  ///
  /// In zh, this message translates to:
  /// **'添加任务'**
  String get addTask;

  /// No description provided for @taskName.
  ///
  /// In zh, this message translates to:
  /// **'任务名称'**
  String get taskName;

  /// No description provided for @descOptional.
  ///
  /// In zh, this message translates to:
  /// **'描述（可选）'**
  String get descOptional;

  /// No description provided for @targetAmount.
  ///
  /// In zh, this message translates to:
  /// **'目标数量'**
  String get targetAmount;

  /// No description provided for @unitOptional.
  ///
  /// In zh, this message translates to:
  /// **'单位（可选）'**
  String get unitOptional;

  /// No description provided for @repeatable.
  ///
  /// In zh, this message translates to:
  /// **'可重复'**
  String get repeatable;

  /// No description provided for @repeatableDesc.
  ///
  /// In zh, this message translates to:
  /// **'在新周期中自动创建'**
  String get repeatableDesc;

  /// No description provided for @add.
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get add;

  /// No description provided for @taskCreatedSuccess.
  ///
  /// In zh, this message translates to:
  /// **'任务创建成功'**
  String get taskCreatedSuccess;

  /// No description provided for @editTask.
  ///
  /// In zh, this message translates to:
  /// **'编辑任务'**
  String get editTask;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @taskUpdated.
  ///
  /// In zh, this message translates to:
  /// **'任务已更新'**
  String get taskUpdated;

  /// No description provided for @updateFailed.
  ///
  /// In zh, this message translates to:
  /// **'更新失败: {error}'**
  String updateFailed(String error);

  /// No description provided for @editCycle.
  ///
  /// In zh, this message translates to:
  /// **'编辑周期'**
  String get editCycle;

  /// No description provided for @cycleName.
  ///
  /// In zh, this message translates to:
  /// **'周期名称'**
  String get cycleName;

  /// No description provided for @cycleNameHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：第一周学习计划'**
  String get cycleNameHint;

  /// No description provided for @cycleDescHint.
  ///
  /// In zh, this message translates to:
  /// **'为这个周期添加备注'**
  String get cycleDescHint;

  /// No description provided for @cycleTime.
  ///
  /// In zh, this message translates to:
  /// **'周期时间'**
  String get cycleTime;

  /// No description provided for @totalDays.
  ///
  /// In zh, this message translates to:
  /// **'共 {count} 天'**
  String totalDays(int count);

  /// No description provided for @quickSelectCycle.
  ///
  /// In zh, this message translates to:
  /// **'快速选择周期'**
  String get quickSelectCycle;

  /// No description provided for @oneWeek.
  ///
  /// In zh, this message translates to:
  /// **'1周'**
  String get oneWeek;

  /// No description provided for @twoWeeks.
  ///
  /// In zh, this message translates to:
  /// **'2周'**
  String get twoWeeks;

  /// No description provided for @threeWeeks.
  ///
  /// In zh, this message translates to:
  /// **'3周'**
  String get threeWeeks;

  /// No description provided for @oneMonth.
  ///
  /// In zh, this message translates to:
  /// **'1个月'**
  String get oneMonth;

  /// No description provided for @twoMonths.
  ///
  /// In zh, this message translates to:
  /// **'2个月'**
  String get twoMonths;

  /// No description provided for @threeMonths.
  ///
  /// In zh, this message translates to:
  /// **'3个月'**
  String get threeMonths;

  /// No description provided for @cycleUpdated.
  ///
  /// In zh, this message translates to:
  /// **'周期已更新'**
  String get cycleUpdated;

  /// No description provided for @cycleCreatedSuccess.
  ///
  /// In zh, this message translates to:
  /// **'周期创建成功'**
  String get cycleCreatedSuccess;

  /// No description provided for @mon.
  ///
  /// In zh, this message translates to:
  /// **'一'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In zh, this message translates to:
  /// **'二'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In zh, this message translates to:
  /// **'三'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In zh, this message translates to:
  /// **'四'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In zh, this message translates to:
  /// **'五'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In zh, this message translates to:
  /// **'六'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In zh, this message translates to:
  /// **'日'**
  String get sun;

  /// No description provided for @monday.
  ///
  /// In zh, this message translates to:
  /// **'周一'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In zh, this message translates to:
  /// **'周二'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In zh, this message translates to:
  /// **'周三'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In zh, this message translates to:
  /// **'周四'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In zh, this message translates to:
  /// **'周五'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In zh, this message translates to:
  /// **'周六'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In zh, this message translates to:
  /// **'周日'**
  String get sunday;

  /// No description provided for @schedule.
  ///
  /// In zh, this message translates to:
  /// **'行程表'**
  String get schedule;

  /// No description provided for @loadFailedShort.
  ///
  /// In zh, this message translates to:
  /// **'加载失败'**
  String get loadFailedShort;

  /// No description provided for @thisWeek.
  ///
  /// In zh, this message translates to:
  /// **'本周'**
  String get thisWeek;

  /// No description provided for @lastWeek.
  ///
  /// In zh, this message translates to:
  /// **'上周'**
  String get lastWeek;

  /// No description provided for @nextWeek.
  ///
  /// In zh, this message translates to:
  /// **'下周'**
  String get nextWeek;

  /// No description provided for @weekAgo.
  ///
  /// In zh, this message translates to:
  /// **'周前'**
  String get weekAgo;

  /// No description provided for @weekLater.
  ///
  /// In zh, this message translates to:
  /// **'周后'**
  String get weekLater;

  /// No description provided for @session.
  ///
  /// In zh, this message translates to:
  /// **'节次'**
  String get session;

  /// No description provided for @noCyclePlan.
  ///
  /// In zh, this message translates to:
  /// **'暂无周期计划'**
  String get noCyclePlan;

  /// No description provided for @createCycleScheduleHint.
  ///
  /// In zh, this message translates to:
  /// **'创建一个周期计划后\n行程表将自动展示你的任务安排'**
  String get createCycleScheduleHint;

  /// No description provided for @noCycleData.
  ///
  /// In zh, this message translates to:
  /// **'暂无周期数据'**
  String get noCycleData;

  /// No description provided for @cycleStats.
  ///
  /// In zh, this message translates to:
  /// **'周期统计'**
  String get cycleStats;

  /// No description provided for @avgCompletionRate.
  ///
  /// In zh, this message translates to:
  /// **'平均完成率 {rate}%'**
  String avgCompletionRate(int rate);

  /// No description provided for @weeklyPlanStats.
  ///
  /// In zh, this message translates to:
  /// **'本周计划统计'**
  String get weeklyPlanStats;

  /// No description provided for @noWeeklyPlanData.
  ///
  /// In zh, this message translates to:
  /// **'本周暂无计划数据'**
  String get noWeeklyPlanData;

  /// No description provided for @createPlanWeeklyHint.
  ///
  /// In zh, this message translates to:
  /// **'创建计划后这里会显示每周统计'**
  String get createPlanWeeklyHint;

  /// No description provided for @completionRate.
  ///
  /// In zh, this message translates to:
  /// **'完成率'**
  String get completionRate;

  /// No description provided for @completedAmount.
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get completedAmount;

  /// No description provided for @totalAmount.
  ///
  /// In zh, this message translates to:
  /// **'总数量'**
  String get totalAmount;

  /// No description provided for @dailyCompletion.
  ///
  /// In zh, this message translates to:
  /// **'每日完成量'**
  String get dailyCompletion;

  /// No description provided for @target.
  ///
  /// In zh, this message translates to:
  /// **'目标'**
  String get target;

  /// No description provided for @finish.
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get finish;

  /// No description provided for @general.
  ///
  /// In zh, this message translates to:
  /// **'通用'**
  String get general;

  /// No description provided for @notificationReminder.
  ///
  /// In zh, this message translates to:
  /// **'通知提醒'**
  String get notificationReminder;

  /// No description provided for @dailyCheckInReminder.
  ///
  /// In zh, this message translates to:
  /// **'每日打卡提醒'**
  String get dailyCheckInReminder;

  /// No description provided for @reminderTime.
  ///
  /// In zh, this message translates to:
  /// **'提醒时间'**
  String get reminderTime;

  /// No description provided for @cycleSection.
  ///
  /// In zh, this message translates to:
  /// **'周期'**
  String get cycleSection;

  /// No description provided for @defaultCycleDays.
  ///
  /// In zh, this message translates to:
  /// **'默认周期天数'**
  String get defaultCycleDays;

  /// No description provided for @autoContinueCycle.
  ///
  /// In zh, this message translates to:
  /// **'自动延续周期'**
  String get autoContinueCycle;

  /// No description provided for @turnedOn.
  ///
  /// In zh, this message translates to:
  /// **'已开启'**
  String get turnedOn;

  /// No description provided for @turnedOff.
  ///
  /// In zh, this message translates to:
  /// **'已关闭'**
  String get turnedOff;

  /// No description provided for @categoryManagement.
  ///
  /// In zh, this message translates to:
  /// **'分类管理'**
  String get categoryManagement;

  /// No description provided for @dataSection.
  ///
  /// In zh, this message translates to:
  /// **'数据'**
  String get dataSection;

  /// No description provided for @exportData.
  ///
  /// In zh, this message translates to:
  /// **'导出数据'**
  String get exportData;

  /// No description provided for @exportDataDesc.
  ///
  /// In zh, this message translates to:
  /// **'备份周期和打卡记录'**
  String get exportDataDesc;

  /// No description provided for @clearAllData.
  ///
  /// In zh, this message translates to:
  /// **'清除所有数据'**
  String get clearAllData;

  /// No description provided for @clearDataWarning.
  ///
  /// In zh, this message translates to:
  /// **'此操作不可撤销'**
  String get clearDataWarning;

  /// No description provided for @cyclePlanManagement.
  ///
  /// In zh, this message translates to:
  /// **'周期计划管理'**
  String get cyclePlanManagement;

  /// No description provided for @taskCategory.
  ///
  /// In zh, this message translates to:
  /// **'任务分类'**
  String get taskCategory;

  /// No description provided for @addCategory.
  ///
  /// In zh, this message translates to:
  /// **'添加分类'**
  String get addCategory;

  /// No description provided for @categoryName.
  ///
  /// In zh, this message translates to:
  /// **'分类名称'**
  String get categoryName;

  /// No description provided for @categoryExample.
  ///
  /// In zh, this message translates to:
  /// **'例如：学习、运动'**
  String get categoryExample;

  /// No description provided for @selectColor.
  ///
  /// In zh, this message translates to:
  /// **'选择颜色'**
  String get selectColor;

  /// No description provided for @noCategory.
  ///
  /// In zh, this message translates to:
  /// **'暂无分类，点击添加'**
  String get noCategory;

  /// No description provided for @confirmDelete.
  ///
  /// In zh, this message translates to:
  /// **'确认删除'**
  String get confirmDelete;

  /// No description provided for @clearDataConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要清除所有数据吗？此操作不可撤销。'**
  String get clearDataConfirm;

  /// No description provided for @allDataCleared.
  ///
  /// In zh, this message translates to:
  /// **'所有数据已清除'**
  String get allDataCleared;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @time.
  ///
  /// In zh, this message translates to:
  /// **'时间'**
  String get time;

  /// No description provided for @completedAmountLabel.
  ///
  /// In zh, this message translates to:
  /// **'完成量:'**
  String get completedAmountLabel;

  /// No description provided for @generalSettings.
  ///
  /// In zh, this message translates to:
  /// **'通用设置'**
  String get generalSettings;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @languageZh.
  ///
  /// In zh, this message translates to:
  /// **'中文'**
  String get languageZh;

  /// No description provided for @languageEn.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageJa.
  ///
  /// In zh, this message translates to:
  /// **'日本語'**
  String get languageJa;

  /// No description provided for @languageKo.
  ///
  /// In zh, this message translates to:
  /// **'한국어'**
  String get languageKo;

  /// No description provided for @languageFr.
  ///
  /// In zh, this message translates to:
  /// **'Français'**
  String get languageFr;

  /// No description provided for @languageDe.
  ///
  /// In zh, this message translates to:
  /// **'Deutsch'**
  String get languageDe;

  /// No description provided for @taskNameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入任务名称'**
  String get taskNameRequired;

  /// No description provided for @taskNameTooLong.
  ///
  /// In zh, this message translates to:
  /// **'任务名称不能超过50字符'**
  String get taskNameTooLong;

  /// No description provided for @targetMustBePositive.
  ///
  /// In zh, this message translates to:
  /// **'目标量必须大于0'**
  String get targetMustBePositive;

  /// No description provided for @cycleNameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入周期名称'**
  String get cycleNameRequired;

  /// No description provided for @cycleNameTooLong.
  ///
  /// In zh, this message translates to:
  /// **'周期名称不能超过30字符'**
  String get cycleNameTooLong;

  /// No description provided for @selectDateRange.
  ///
  /// In zh, this message translates to:
  /// **'请选择开始和结束日期'**
  String get selectDateRange;

  /// No description provided for @endDateBeforeStart.
  ///
  /// In zh, this message translates to:
  /// **'结束日期不能早于开始日期'**
  String get endDateBeforeStart;

  /// No description provided for @categoryNameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入分类名称'**
  String get categoryNameRequired;

  /// No description provided for @categoryNameTooLong.
  ///
  /// In zh, this message translates to:
  /// **'分类名称不能超过20字符'**
  String get categoryNameTooLong;

  /// No description provided for @timetableManagement.
  ///
  /// In zh, this message translates to:
  /// **'课表管理'**
  String get timetableManagement;

  /// No description provided for @timetableList.
  ///
  /// In zh, this message translates to:
  /// **'课表列表'**
  String get timetableList;

  /// No description provided for @noTimetable.
  ///
  /// In zh, this message translates to:
  /// **'暂无课表'**
  String get noTimetable;

  /// No description provided for @importFromHtml.
  ///
  /// In zh, this message translates to:
  /// **'从HTML导入'**
  String get importFromHtml;

  /// No description provided for @importFromHtmlDesc.
  ///
  /// In zh, this message translates to:
  /// **'从教务系统导出的HTML文件导入课表'**
  String get importFromHtmlDesc;

  /// No description provided for @createTimetable.
  ///
  /// In zh, this message translates to:
  /// **'手动创建课表'**
  String get createTimetable;

  /// No description provided for @timetableName.
  ///
  /// In zh, this message translates to:
  /// **'课表名称'**
  String get timetableName;

  /// No description provided for @timetableNameHint.
  ///
  /// In zh, this message translates to:
  /// **'例如: 2025-2026学年第二学期'**
  String get timetableNameHint;

  /// No description provided for @academicYear.
  ///
  /// In zh, this message translates to:
  /// **'学年'**
  String get academicYear;

  /// No description provided for @semester.
  ///
  /// In zh, this message translates to:
  /// **'学期'**
  String get semester;

  /// No description provided for @firstSemester.
  ///
  /// In zh, this message translates to:
  /// **'第一学期'**
  String get firstSemester;

  /// No description provided for @secondSemester.
  ///
  /// In zh, this message translates to:
  /// **'第二学期'**
  String get secondSemester;

  /// No description provided for @thirdSemester.
  ///
  /// In zh, this message translates to:
  /// **'第三学期'**
  String get thirdSemester;

  /// No description provided for @firstWeekMonday.
  ///
  /// In zh, this message translates to:
  /// **'第一周周一日期'**
  String get firstWeekMonday;

  /// No description provided for @totalWeeks.
  ///
  /// In zh, this message translates to:
  /// **'总周数'**
  String get totalWeeks;

  /// No description provided for @currentWeek.
  ///
  /// In zh, this message translates to:
  /// **'当前周次'**
  String get currentWeek;

  /// No description provided for @courseCount.
  ///
  /// In zh, this message translates to:
  /// **'课程数: {count}'**
  String courseCount(int count);

  /// No description provided for @timetableDetail.
  ///
  /// In zh, this message translates to:
  /// **'课表详情'**
  String get timetableDetail;

  /// No description provided for @courseManagement.
  ///
  /// In zh, this message translates to:
  /// **'课程管理'**
  String get courseManagement;

  /// No description provided for @addCourse.
  ///
  /// In zh, this message translates to:
  /// **'添加课程'**
  String get addCourse;

  /// No description provided for @courseName.
  ///
  /// In zh, this message translates to:
  /// **'课程名称'**
  String get courseName;

  /// No description provided for @courseNameHint.
  ///
  /// In zh, this message translates to:
  /// **'例如: 高等数学'**
  String get courseNameHint;

  /// No description provided for @teacherName.
  ///
  /// In zh, this message translates to:
  /// **'教师姓名'**
  String get teacherName;

  /// No description provided for @teacherNameHint.
  ///
  /// In zh, this message translates to:
  /// **'例如: 张三'**
  String get teacherNameHint;

  /// No description provided for @location.
  ///
  /// In zh, this message translates to:
  /// **'上课地点'**
  String get location;

  /// No description provided for @locationHint.
  ///
  /// In zh, this message translates to:
  /// **'例如: 教学楼A-301'**
  String get locationHint;

  /// No description provided for @periodRange.
  ///
  /// In zh, this message translates to:
  /// **'节次范围'**
  String get periodRange;

  /// No description provided for @startPeriod.
  ///
  /// In zh, this message translates to:
  /// **'开始节次'**
  String get startPeriod;

  /// No description provided for @endPeriod.
  ///
  /// In zh, this message translates to:
  /// **'结束节次'**
  String get endPeriod;

  /// No description provided for @weekRanges.
  ///
  /// In zh, this message translates to:
  /// **'上课周次'**
  String get weekRanges;

  /// No description provided for @weekRangesHint.
  ///
  /// In zh, this message translates to:
  /// **'例如: 1-16周'**
  String get weekRangesHint;

  /// No description provided for @courseColor.
  ///
  /// In zh, this message translates to:
  /// **'课程颜色'**
  String get courseColor;

  /// No description provided for @courseCreated.
  ///
  /// In zh, this message translates to:
  /// **'课程已添加'**
  String get courseCreated;

  /// No description provided for @courseDeleted.
  ///
  /// In zh, this message translates to:
  /// **'课程已删除'**
  String get courseDeleted;

  /// No description provided for @timetableCreated.
  ///
  /// In zh, this message translates to:
  /// **'课表已创建'**
  String get timetableCreated;

  /// No description provided for @timetableDeleted.
  ///
  /// In zh, this message translates to:
  /// **'课表已删除'**
  String get timetableDeleted;

  /// No description provided for @importSuccess.
  ///
  /// In zh, this message translates to:
  /// **'导入成功'**
  String get importSuccess;

  /// No description provided for @importSuccessDesc.
  ///
  /// In zh, this message translates to:
  /// **'成功导入 {count} 门课程'**
  String importSuccessDesc(int count);

  /// No description provided for @selectHtmlFile.
  ///
  /// In zh, this message translates to:
  /// **'选择HTML文件'**
  String get selectHtmlFile;

  /// No description provided for @importing.
  ///
  /// In zh, this message translates to:
  /// **'正在导入...'**
  String get importing;

  /// No description provided for @importFailed.
  ///
  /// In zh, this message translates to:
  /// **'导入失败'**
  String get importFailed;

  /// No description provided for @importFailedDesc.
  ///
  /// In zh, this message translates to:
  /// **'无法解析HTML文件，请检查文件格式'**
  String get importFailedDesc;

  /// No description provided for @timetableNameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入课表名称'**
  String get timetableNameRequired;

  /// No description provided for @courseNameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入课程名称'**
  String get courseNameRequired;

  /// No description provided for @weekdayRequired.
  ///
  /// In zh, this message translates to:
  /// **'请选择星期'**
  String get weekdayRequired;

  /// No description provided for @periodRequired.
  ///
  /// In zh, this message translates to:
  /// **'请选择节次范围'**
  String get periodRequired;

  /// No description provided for @weekRangesRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入上课周次'**
  String get weekRangesRequired;

  /// No description provided for @weekFormat.
  ///
  /// In zh, this message translates to:
  /// **'第{week}周'**
  String weekFormat(int week);

  /// No description provided for @weekFormatNotCurrent.
  ///
  /// In zh, this message translates to:
  /// **'第{week}周（非本周）'**
  String weekFormatNotCurrent(int week);

  /// No description provided for @periodFormat.
  ///
  /// In zh, this message translates to:
  /// **'第{start}-{end}节'**
  String periodFormat(int start, int end);

  /// No description provided for @semesterFormat.
  ///
  /// In zh, this message translates to:
  /// **'{year}学年 第{semester}学期'**
  String semesterFormat(String year, int semester);

  /// No description provided for @timetableSource.
  ///
  /// In zh, this message translates to:
  /// **'来源: {source}'**
  String timetableSource(String source);

  /// No description provided for @sourceHtml.
  ///
  /// In zh, this message translates to:
  /// **'HTML导入'**
  String get sourceHtml;

  /// No description provided for @sourceManual.
  ///
  /// In zh, this message translates to:
  /// **'手动创建'**
  String get sourceManual;

  /// No description provided for @confirmDeleteTimetable.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除此课表吗？所有课程数据将被清除。'**
  String get confirmDeleteTimetable;

  /// No description provided for @confirmDeleteCourse.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除此课程吗？'**
  String get confirmDeleteCourse;

  /// No description provided for @editCourse.
  ///
  /// In zh, this message translates to:
  /// **'编辑课程'**
  String get editCourse;

  /// No description provided for @courseUpdated.
  ///
  /// In zh, this message translates to:
  /// **'课程已更新'**
  String get courseUpdated;

  /// No description provided for @todayCourse.
  ///
  /// In zh, this message translates to:
  /// **'今日课程'**
  String get todayCourse;

  /// No description provided for @noCourseToday.
  ///
  /// In zh, this message translates to:
  /// **'今天没有课'**
  String get noCourseToday;

  /// No description provided for @selectFolder.
  ///
  /// In zh, this message translates to:
  /// **'选择文件夹'**
  String get selectFolder;

  /// No description provided for @selectFolderDesc.
  ///
  /// In zh, this message translates to:
  /// **'选择浏览器保存完整网页时生成的文件夹'**
  String get selectFolderDesc;

  /// No description provided for @selectFile.
  ///
  /// In zh, this message translates to:
  /// **'选择HTML文件'**
  String get selectFile;

  /// No description provided for @selectFileDesc.
  ///
  /// In zh, this message translates to:
  /// **'直接选择单个 .html 文件'**
  String get selectFileDesc;

  /// No description provided for @importMode.
  ///
  /// In zh, this message translates to:
  /// **'导入方式'**
  String get importMode;

  /// No description provided for @importModeHint.
  ///
  /// In zh, this message translates to:
  /// **'请选择导入方式'**
  String get importModeHint;

  /// No description provided for @folderMode.
  ///
  /// In zh, this message translates to:
  /// **'文件夹模式'**
  String get folderMode;

  /// No description provided for @fileMode.
  ///
  /// In zh, this message translates to:
  /// **'单文件模式'**
  String get fileMode;

  /// No description provided for @noHtmlInFolder.
  ///
  /// In zh, this message translates to:
  /// **'所选文件夹中未找到HTML文件'**
  String get noHtmlInFolder;

  /// No description provided for @noCourseData.
  ///
  /// In zh, this message translates to:
  /// **'未在HTML文件中找到课表数据，请确保保存网页时选择\"完整网页\"模式'**
  String get noCourseData;

  /// No description provided for @importFolderSuccess.
  ///
  /// In zh, this message translates to:
  /// **'从文件夹导入成功'**
  String get importFolderSuccess;

  /// No description provided for @selectedFolder.
  ///
  /// In zh, this message translates to:
  /// **'已选择文件夹'**
  String get selectedFolder;

  /// No description provided for @htmlFilesFound.
  ///
  /// In zh, this message translates to:
  /// **'找到 {count} 个HTML文件'**
  String htmlFilesFound(int count);

  /// No description provided for @folderModeNotSupported.
  ///
  /// In zh, this message translates to:
  /// **'当前平台不支持文件夹选择，已切换为文件模式'**
  String get folderModeNotSupported;

  /// No description provided for @selectMonthDays.
  ///
  /// In zh, this message translates to:
  /// **'选择每月执行的日期'**
  String get selectMonthDays;

  /// No description provided for @monthStart.
  ///
  /// In zh, this message translates to:
  /// **'月初'**
  String get monthStart;

  /// No description provided for @monthMid.
  ///
  /// In zh, this message translates to:
  /// **'月中'**
  String get monthMid;

  /// No description provided for @monthEnd.
  ///
  /// In zh, this message translates to:
  /// **'月末'**
  String get monthEnd;

  /// No description provided for @planDate.
  ///
  /// In zh, this message translates to:
  /// **'计划日期'**
  String get planDate;

  /// No description provided for @timeRangeDescNone.
  ///
  /// In zh, this message translates to:
  /// **'选择计划执行的日期'**
  String get timeRangeDescNone;

  /// No description provided for @timeRangeDescDaily.
  ///
  /// In zh, this message translates to:
  /// **'在此时间范围内每天执行'**
  String get timeRangeDescDaily;

  /// No description provided for @timeRangeDescWeekly.
  ///
  /// In zh, this message translates to:
  /// **'在此时间范围内按选定的星期执行'**
  String get timeRangeDescWeekly;

  /// No description provided for @timeRangeDescMonthly.
  ///
  /// In zh, this message translates to:
  /// **'在此时间范围内按选定的日期执行'**
  String get timeRangeDescMonthly;

  /// No description provided for @timeRangeDescInterval.
  ///
  /// In zh, this message translates to:
  /// **'在此时间范围内按间隔天数执行'**
  String get timeRangeDescInterval;

  /// No description provided for @enableTimeSlot.
  ///
  /// In zh, this message translates to:
  /// **'启用时间段'**
  String get enableTimeSlot;

  /// No description provided for @enableTimeSlotDesc.
  ///
  /// In zh, this message translates to:
  /// **'关闭后计划将不受时间约束'**
  String get enableTimeSlotDesc;

  /// No description provided for @allDayEvents.
  ///
  /// In zh, this message translates to:
  /// **'全天计划'**
  String get allDayEvents;

  /// No description provided for @monthFormat.
  ///
  /// In zh, this message translates to:
  /// **'第{month}月'**
  String monthFormat(int month);

  /// No description provided for @monthFormatNotCurrent.
  ///
  /// In zh, this message translates to:
  /// **'第{month}月（非本月）'**
  String monthFormatNotCurrent(int month);

  /// No description provided for @confirmSemesterStart.
  ///
  /// In zh, this message translates to:
  /// **'确认学期起始日期'**
  String get confirmSemesterStart;

  /// No description provided for @confirmSemesterStartDesc.
  ///
  /// In zh, this message translates to:
  /// **'检测到学期第一周周一为以下日期，请确认或调整：'**
  String get confirmSemesterStartDesc;

  /// No description provided for @editPlanInstance.
  ///
  /// In zh, this message translates to:
  /// **'编辑计划'**
  String get editPlanInstance;

  /// No description provided for @selectEditScope.
  ///
  /// In zh, this message translates to:
  /// **'选择修改范围'**
  String get selectEditScope;

  /// No description provided for @editScopeThisOnly.
  ///
  /// In zh, this message translates to:
  /// **'仅修改本次'**
  String get editScopeThisOnly;

  /// No description provided for @editScopeThisOnlyDesc.
  ///
  /// In zh, this message translates to:
  /// **'只修改当前这一条计划'**
  String get editScopeThisOnlyDesc;

  /// No description provided for @editScopeFuture.
  ///
  /// In zh, this message translates to:
  /// **'修改以后计划'**
  String get editScopeFuture;

  /// No description provided for @editScopeFutureDesc.
  ///
  /// In zh, this message translates to:
  /// **'修改当前及之后的所有计划'**
  String get editScopeFutureDesc;

  /// No description provided for @editScopePast.
  ///
  /// In zh, this message translates to:
  /// **'修改以前计划'**
  String get editScopePast;

  /// No description provided for @editScopePastDesc.
  ///
  /// In zh, this message translates to:
  /// **'修改当前及之前的所有计划'**
  String get editScopePastDesc;

  /// No description provided for @editScopeAll.
  ///
  /// In zh, this message translates to:
  /// **'修改全部计划'**
  String get editScopeAll;

  /// No description provided for @editScopeAllDesc.
  ///
  /// In zh, this message translates to:
  /// **'修改所有关联的计划'**
  String get editScopeAllDesc;

  /// No description provided for @planInstanceUpdated.
  ///
  /// In zh, this message translates to:
  /// **'计划已更新'**
  String get planInstanceUpdated;

  /// No description provided for @confirmDeletePlan.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除此计划吗？所有相关记录将被清除。'**
  String get confirmDeletePlan;

  /// No description provided for @planDeleted.
  ///
  /// In zh, this message translates to:
  /// **'计划已删除'**
  String get planDeleted;

  /// No description provided for @exportSuccess.
  ///
  /// In zh, this message translates to:
  /// **'数据已导出'**
  String get exportSuccess;

  /// No description provided for @exportFailed.
  ///
  /// In zh, this message translates to:
  /// **'导出失败'**
  String get exportFailed;

  /// No description provided for @filterTasks.
  ///
  /// In zh, this message translates to:
  /// **'筛选任务'**
  String get filterTasks;

  /// No description provided for @storagePermissionDenied.
  ///
  /// In zh, this message translates to:
  /// **'需要\"所有文件访问\"权限才能扫描文件夹，请在设置中授予权限'**
  String get storagePermissionDenied;

  /// No description provided for @folderAccessError.
  ///
  /// In zh, this message translates to:
  /// **'无法访问文件夹: {error}'**
  String folderAccessError(String error);
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'fr',
        'ja',
        'ko',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return SDe();
    case 'en':
      return SEn();
    case 'fr':
      return SFr();
    case 'ja':
      return SJa();
    case 'ko':
      return SKo();
    case 'zh':
      return SZh();
  }

  throw FlutterError(
      'S.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

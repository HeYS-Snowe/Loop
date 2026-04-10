// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Loop';

  @override
  String get home => 'Home';

  @override
  String get dailyPlan => 'Daily Plan';

  @override
  String get statistics => 'Statistics';

  @override
  String get settings => 'Settings';

  @override
  String get todayPlan => 'Today\'s Plan';

  @override
  String get viewAll => 'View All';

  @override
  String get currentCycle => 'Current Cycle';

  @override
  String get historyCycle => 'History';

  @override
  String get createCycle => 'Create New Cycle';

  @override
  String get startFirstCycle => 'Start your first cycle plan';

  @override
  String get noHistoryCycle => 'No history cycles';

  @override
  String get createTodayPlan => 'Create Today\'s Plan';

  @override
  String get startPlanDay => 'Start planning your day';

  @override
  String get completed => 'Completed';

  @override
  String get inProgress => 'In Progress';

  @override
  String get total => 'Total';

  @override
  String loadFailed(String error) {
    return 'Load failed: $error';
  }

  @override
  String get unknownPlan => 'Unknown Plan';

  @override
  String get dailyCheckIn => 'Daily Check-in';

  @override
  String get checkedInToday => 'Checked in today';

  @override
  String get notCheckedInToday => 'Not checked in today';

  @override
  String get dayUnit => 'days';

  @override
  String get checkInNow => 'Check In Now';

  @override
  String daysRemaining(int count) {
    return '$count days left';
  }

  @override
  String get streakCheckIn => 'Streak';

  @override
  String get maxRecord => 'Max Record';

  @override
  String get totalCheckIn => 'Total';

  @override
  String get checkIn => 'Check In';

  @override
  String get checkInCalendar => 'Check-in Calendar';

  @override
  String get clickToCheckIn => 'Tap to check in';

  @override
  String streakDays(int count) {
    return '$count day streak';
  }

  @override
  String get pageNotFound => 'Page Not Found';

  @override
  String get backToHome => 'Back to Home';

  @override
  String dateYearMonthDay(int year, int month, int day) {
    return '$month/$day/$year';
  }

  @override
  String get dailyReminder => 'Daily Reminder';

  @override
  String get dailyReminderBody => 'Daily task reminder notification';

  @override
  String get editPlan => 'Edit Plan';

  @override
  String get createPlan => 'Create Plan';

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get planName => 'Plan Name';

  @override
  String get planNameHint => 'e.g., Learn English vocabulary';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get descriptionHint => 'Detailed description of the plan';

  @override
  String get quantityTarget => 'Quantity Target';

  @override
  String get dailyTarget => 'Daily Target';

  @override
  String get unit => 'Unit';

  @override
  String get unitHint => 'items/minutes';

  @override
  String get enableQuantityValidation => 'Enable Quantity Validation';

  @override
  String get enableQuantityValidationDesc =>
      'Require entering completion amount';

  @override
  String get timeSlot => 'Time Slot';

  @override
  String get timeSlotDesc => 'Set display time in schedule';

  @override
  String get timeConflictWarning => 'Time Conflict with Course';

  @override
  String timeConflictDesc(String courses) {
    return 'Current time slot overlaps with the following course(s): $courses';
  }

  @override
  String get timeConflictConfirm => 'Save Anyway';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get tapToEdit => 'Tap to edit';

  @override
  String get selectStartTime => 'Select Start Time';

  @override
  String get selectEndTime => 'Select End Time';

  @override
  String get cardColor => 'Card Color';

  @override
  String get cardColorDesc => 'Choose display color in schedule';

  @override
  String get repeatRule => 'Repeat Rule';

  @override
  String get noRepeat => 'No Repeat';

  @override
  String get repeatDaily => 'Daily';

  @override
  String get repeatWeekly => 'Weekly';

  @override
  String get repeatMonthly => 'Monthly';

  @override
  String get repeatInterval => 'Custom Interval';

  @override
  String get every => 'Every';

  @override
  String get repeatEveryDay => 'days';

  @override
  String get activeDate => 'Active Days';

  @override
  String get executeDaily => 'Executes daily';

  @override
  String get selectWeekdays => 'Select weekdays for the plan';

  @override
  String get weekday => 'Weekday';

  @override
  String get everyday => 'Every Day';

  @override
  String get weekend => 'Weekend';

  @override
  String get timeRange => 'Time Range';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String pleaseEnter(String label) {
    return 'Please enter $label';
  }

  @override
  String get pleaseSelectActiveDate => 'Please select at least one active day';

  @override
  String get planUpdated => 'Plan updated';

  @override
  String get planCreated => 'Plan created';

  @override
  String operationFailed(String error) {
    return 'Operation failed: $error';
  }

  @override
  String get timePickerDefaultTitle => 'Set Reminder Time';

  @override
  String get timePicker24Hour => '24-hour format';

  @override
  String get hourUnit => 'H';

  @override
  String get minuteUnit => 'M';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get taskList => 'Task List';

  @override
  String get noActiveCycle => 'No Active Cycle';

  @override
  String get pleaseCreateCycleFirst => 'Please create a cycle plan first';

  @override
  String get createCycleBtn => 'Create Cycle';

  @override
  String get noTask => 'No Tasks';

  @override
  String get addTaskHint => 'Tap the button below to add a task';

  @override
  String inProgressCount(int count) {
    return 'In Progress ($count)';
  }

  @override
  String completedCount(int count) {
    return 'Completed ($count)';
  }

  @override
  String get taskDetail => 'Task Detail';

  @override
  String get taskNotExist => 'Task does not exist';

  @override
  String get progress => 'Progress';

  @override
  String get updateProgress => 'Update Progress';

  @override
  String get addTask => 'Add Task';

  @override
  String get taskName => 'Task Name';

  @override
  String get descOptional => 'Description (optional)';

  @override
  String get targetAmount => 'Target Amount';

  @override
  String get unitOptional => 'Unit (optional)';

  @override
  String get repeatable => 'Repeatable';

  @override
  String get repeatableDesc => 'Auto-create in new cycles';

  @override
  String get add => 'Add';

  @override
  String get taskCreatedSuccess => 'Task created successfully';

  @override
  String get editTask => 'Edit Task';

  @override
  String get save => 'Save';

  @override
  String get taskUpdated => 'Task updated';

  @override
  String updateFailed(String error) {
    return 'Update failed: $error';
  }

  @override
  String get editCycle => 'Edit Cycle';

  @override
  String get cycleName => 'Cycle Name';

  @override
  String get cycleNameHint => 'e.g., Week 1 Study Plan';

  @override
  String get cycleDescHint => 'Add notes for this cycle';

  @override
  String get cycleTime => 'Cycle Time';

  @override
  String totalDays(int count) {
    return '$count days total';
  }

  @override
  String get quickSelectCycle => 'Quick Select';

  @override
  String get oneWeek => '1 Week';

  @override
  String get twoWeeks => '2 Weeks';

  @override
  String get threeWeeks => '3 Weeks';

  @override
  String get oneMonth => '1 Month';

  @override
  String get twoMonths => '2 Months';

  @override
  String get threeMonths => '3 Months';

  @override
  String get cycleUpdated => 'Cycle updated';

  @override
  String get cycleCreatedSuccess => 'Cycle created successfully';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get schedule => 'Schedule';

  @override
  String get loadFailedShort => 'Load failed';

  @override
  String get thisWeek => 'This Week';

  @override
  String get lastWeek => 'Last Week';

  @override
  String get nextWeek => 'Next Week';

  @override
  String get weekAgo => 'w ago';

  @override
  String get weekLater => 'w later';

  @override
  String get session => 'Session';

  @override
  String get noCyclePlan => 'No Cycle Plans';

  @override
  String get createCycleScheduleHint =>
      'Create a cycle plan to see\nyour schedule here';

  @override
  String get noCycleData => 'No cycle data';

  @override
  String get cycleStats => 'Cycle Statistics';

  @override
  String avgCompletionRate(int rate) {
    return 'Avg completion $rate%';
  }

  @override
  String get weeklyPlanStats => 'Weekly Plan Stats';

  @override
  String get noWeeklyPlanData => 'No plan data this week';

  @override
  String get createPlanWeeklyHint => 'Create plans to see weekly stats here';

  @override
  String get completionRate => 'Rate';

  @override
  String get completedAmount => 'Done';

  @override
  String get totalAmount => 'Total';

  @override
  String get dailyCompletion => 'Daily Completion';

  @override
  String get target => 'Target';

  @override
  String get finish => 'Done';

  @override
  String get general => 'General';

  @override
  String get notificationReminder => 'Notifications';

  @override
  String get dailyCheckInReminder => 'Daily Check-in Reminder';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get cycleSection => 'Cycle';

  @override
  String get defaultCycleDays => 'Default Cycle Days';

  @override
  String get autoContinueCycle => 'Auto Continue Cycle';

  @override
  String get turnedOn => 'On';

  @override
  String get turnedOff => 'Off';

  @override
  String get categoryManagement => 'Categories';

  @override
  String get dataSection => 'Data';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportDataDesc => 'Backup cycles and check-in records';

  @override
  String get clearAllData => 'Clear All Data';

  @override
  String get clearDataWarning => 'This action cannot be undone';

  @override
  String get cyclePlanManagement => 'Cycle Plan Management';

  @override
  String get taskCategory => 'Task Categories';

  @override
  String get addCategory => 'Add Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get categoryExample => 'e.g., Study, Exercise';

  @override
  String get selectColor => 'Select Color';

  @override
  String get noCategory => 'No categories, tap to add';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get clearDataConfirm =>
      'Are you sure you want to clear all data? This cannot be undone.';

  @override
  String get allDataCleared => 'All data cleared';

  @override
  String get delete => 'Delete';

  @override
  String get time => 'Time';

  @override
  String get completedAmountLabel => 'Done:';

  @override
  String get generalSettings => 'General';

  @override
  String get language => 'Language';

  @override
  String get languageZh => '中文';

  @override
  String get languageEn => 'English';

  @override
  String get taskNameRequired => 'Please enter task name';

  @override
  String get taskNameTooLong => 'Task name must be under 50 characters';

  @override
  String get targetMustBePositive => 'Target must be greater than 0';

  @override
  String get cycleNameRequired => 'Please enter cycle name';

  @override
  String get cycleNameTooLong => 'Cycle name must be under 30 characters';

  @override
  String get selectDateRange => 'Please select start and end dates';

  @override
  String get endDateBeforeStart => 'End date cannot be before start date';

  @override
  String get categoryNameRequired => 'Please enter category name';

  @override
  String get categoryNameTooLong => 'Category name must be under 20 characters';

  @override
  String get timetableManagement => 'Timetable';

  @override
  String get timetableList => 'Timetables';

  @override
  String get noTimetable => 'No timetables';

  @override
  String get importFromHtml => 'Import from HTML';

  @override
  String get importFromHtmlDesc =>
      'Import timetable from HTML exported by academic system';

  @override
  String get createTimetable => 'Create Timetable';

  @override
  String get timetableName => 'Timetable Name';

  @override
  String get timetableNameHint => 'e.g., 2025-2026 Spring Semester';

  @override
  String get academicYear => 'Academic Year';

  @override
  String get semester => '学期';

  @override
  String get firstSemester => '1st Semester';

  @override
  String get secondSemester => '2nd Semester';

  @override
  String get thirdSemester => '3rd Semester';

  @override
  String get firstWeekMonday => 'First Week Monday';

  @override
  String get totalWeeks => 'Total Weeks';

  @override
  String get currentWeek => 'Current Week';

  @override
  String courseCount(int count) {
    return 'Courses: $count';
  }

  @override
  String get timetableDetail => 'Timetable Detail';

  @override
  String get courseManagement => 'Course Management';

  @override
  String get addCourse => 'Add Course';

  @override
  String get courseName => 'Course Name';

  @override
  String get courseNameHint => 'e.g., Advanced Mathematics';

  @override
  String get teacherName => 'Teacher';

  @override
  String get teacherNameHint => 'e.g., John Smith';

  @override
  String get location => 'Location';

  @override
  String get locationHint => 'e.g., Building A-301';

  @override
  String get periodRange => 'Period Range';

  @override
  String get startPeriod => 'Start Period';

  @override
  String get endPeriod => 'End Period';

  @override
  String get weekRanges => 'Week Ranges';

  @override
  String get weekRangesHint => 'e.g., 1-16';

  @override
  String get courseColor => 'Course Color';

  @override
  String get courseCreated => 'Course added';

  @override
  String get courseDeleted => 'Course deleted';

  @override
  String get timetableCreated => 'Timetable created';

  @override
  String get timetableDeleted => 'Timetable deleted';

  @override
  String get importSuccess => 'Import Success';

  @override
  String importSuccessDesc(int count) {
    return 'Successfully imported $count courses';
  }

  @override
  String get selectHtmlFile => 'Select HTML File';

  @override
  String get importing => 'Importing...';

  @override
  String get importFailed => 'Import Failed';

  @override
  String get importFailedDesc => 'Cannot parse HTML file, please check format';

  @override
  String get timetableNameRequired => 'Please enter timetable name';

  @override
  String get courseNameRequired => 'Please enter course name';

  @override
  String get weekdayRequired => 'Please select weekday';

  @override
  String get periodRequired => 'Please select period range';

  @override
  String get weekRangesRequired => 'Please enter week ranges';

  @override
  String weekFormat(int week) {
    return 'Week $week';
  }

  @override
  String weekFormatNotCurrent(int week) {
    return 'Week $week (Not Current)';
  }

  @override
  String periodFormat(int start, int end) {
    return 'Period $start-$end';
  }

  @override
  String semesterFormat(String year, int semester) {
    return '$year Semester $semester';
  }

  @override
  String timetableSource(String source) {
    return 'Source: $source';
  }

  @override
  String get sourceHtml => 'HTML Import';

  @override
  String get sourceManual => 'Manual';

  @override
  String get confirmDeleteTimetable =>
      'Delete this timetable? All courses will be removed.';

  @override
  String get confirmDeleteCourse => 'Delete this course?';

  @override
  String get editCourse => 'Edit Course';

  @override
  String get courseUpdated => 'Course updated';

  @override
  String get todayCourse => 'Today\'s Courses';

  @override
  String get noCourseToday => 'No classes today';

  @override
  String get selectFolder => 'Select Folder';

  @override
  String get selectFolderDesc =>
      'Select the folder generated when saving a complete webpage';

  @override
  String get selectFile => 'Select HTML File';

  @override
  String get selectFileDesc => 'Select a single .html file directly';

  @override
  String get importMode => 'Import Mode';

  @override
  String get importModeHint => 'Please select import mode';

  @override
  String get folderMode => 'Folder Mode';

  @override
  String get fileMode => 'Single File Mode';

  @override
  String get noHtmlInFolder => 'No HTML files found in the selected folder';

  @override
  String get noCourseData =>
      'No course data found in the HTML file. Please save the webpage in \"complete\" mode.';

  @override
  String get importFolderSuccess => 'Imported from folder successfully';

  @override
  String get selectedFolder => 'Selected folder';

  @override
  String htmlFilesFound(int count) {
    return 'Found $count HTML file(s)';
  }

  @override
  String get folderModeNotSupported =>
      'Folder mode not supported on this platform, switched to file mode';

  @override
  String get editPlanInstance => 'Edit Plan';

  @override
  String get selectEditScope => 'Select Edit Scope';

  @override
  String get editScopeThisOnly => 'This Only';

  @override
  String get editScopeThisOnlyDesc => 'Only modify this plan instance';

  @override
  String get editScopeFuture => 'Future Plans';

  @override
  String get editScopeFutureDesc => 'Modify this and all future plans';

  @override
  String get editScopePast => 'Past Plans';

  @override
  String get editScopePastDesc => 'Modify this and all past plans';

  @override
  String get editScopeAll => 'All Plans';

  @override
  String get editScopeAllDesc => 'Modify all associated plans';

  @override
  String get planInstanceUpdated => 'Plan updated';
}

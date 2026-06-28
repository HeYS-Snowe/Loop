// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class SJa extends S {
  SJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Loop';

  @override
  String get home => 'ホーム';

  @override
  String get dailyPlan => 'デイリープラン';

  @override
  String get statistics => '統計';

  @override
  String get settings => '設定';

  @override
  String get todayPlan => '今日のプラン';

  @override
  String get viewAll => 'すべて表示';

  @override
  String get currentCycle => '現在のサイクル';

  @override
  String get historyCycle => '履歴';

  @override
  String get createCycle => '新しいサイクルを作成';

  @override
  String get startFirstCycle => '最初のサイクルプランを始めましょう';

  @override
  String get noHistoryCycle => '履歴にサイクルがありません';

  @override
  String get createTodayPlan => '今日のプランを作成';

  @override
  String get startPlanDay => '一日の計画を始めましょう';

  @override
  String get completed => '完了';

  @override
  String get inProgress => '進行中';

  @override
  String get total => '合計';

  @override
  String loadFailed(String error) {
    return '読み込みに失敗しました: $error';
  }

  @override
  String get unknownPlan => '不明なプラン';

  @override
  String get dailyCheckIn => 'デイリーチェックイン';

  @override
  String get checkedInToday => '今日チェックイン済み';

  @override
  String get notCheckedInToday => '今日はチェックインしていません';

  @override
  String get dayUnit => '日';

  @override
  String get checkInNow => '今すぐチェックイン';

  @override
  String daysRemaining(int count) {
    return '残り $count 日';
  }

  @override
  String get streakCheckIn => '連続';

  @override
  String get maxRecord => '最長記録';

  @override
  String get totalCheckIn => '合計';

  @override
  String get checkIn => 'チェックイン';

  @override
  String get checkInCalendar => 'チェックインカレンダー';

  @override
  String get clickToCheckIn => 'タップしてチェックイン';

  @override
  String streakDays(int count) {
    return '$count 日連続';
  }

  @override
  String get pageNotFound => 'ページが見つかりません';

  @override
  String get backToHome => 'ホームに戻る';

  @override
  String dateYearMonthDay(int year, int month, int day) {
    return '$year年$month月$day日';
  }

  @override
  String get dailyReminder => '毎日のリマインダー';

  @override
  String get dailyReminderBody => '毎日のタスクリマインダー通知';

  @override
  String get editPlan => 'プランを編集';

  @override
  String get createPlan => 'プランを作成';

  @override
  String get basicInfo => '基本情報';

  @override
  String get planName => 'プラン名';

  @override
  String get planNameHint => '例：英単語を覚える';

  @override
  String get descriptionOptional => '説明（任意）';

  @override
  String get descriptionHint => 'プランの詳細な説明';

  @override
  String get quantityTarget => '数量目標';

  @override
  String get dailyTarget => '一日の目標';

  @override
  String get unit => '単位';

  @override
  String get unitHint => '個/分';

  @override
  String get enableQuantityValidation => '数量入力を有効化';

  @override
  String get enableQuantityValidationDesc => '完了数量の入力を必須にする';

  @override
  String get timeSlot => '時間枠';

  @override
  String get timeSlotDesc => 'スケジュールに表示する時間を設定';

  @override
  String get timeConflictWarning => '授業と時間が重複しています';

  @override
  String timeConflictDesc(String courses) {
    return '現在の時間枠は以下の授業と重複しています：$courses';
  }

  @override
  String get timeConflictConfirm => 'そのまま保存';

  @override
  String get startTime => '開始時刻';

  @override
  String get endTime => '終了時刻';

  @override
  String get tapToEdit => 'タップして編集';

  @override
  String get selectStartTime => '開始時刻を選択';

  @override
  String get selectEndTime => '終了時刻を選択';

  @override
  String get cardColor => 'カードの色';

  @override
  String get cardColorDesc => 'スケジュールに表示する色を選択';

  @override
  String get repeatRule => '繰り返しルール';

  @override
  String get noRepeat => '繰り返しなし';

  @override
  String get repeatDaily => '毎日';

  @override
  String get repeatWeekly => '毎週';

  @override
  String get repeatMonthly => '毎月';

  @override
  String get repeatInterval => 'カスタム間隔';

  @override
  String get every => '毎';

  @override
  String get repeatEveryDay => '日ごと';

  @override
  String get activeDate => '実施日';

  @override
  String get executeDaily => '毎日実行';

  @override
  String get selectWeekdays => 'プランを実施する曜日を選択';

  @override
  String get weekday => '曜日';

  @override
  String get everyday => '毎日';

  @override
  String get weekend => '週末';

  @override
  String get timeRange => '時間範囲';

  @override
  String get startDate => '開始日';

  @override
  String get endDate => '終了日';

  @override
  String get unlimited => '無期限';

  @override
  String get saveChanges => '変更を保存';

  @override
  String pleaseEnter(String label) {
    return '$labelを入力してください';
  }

  @override
  String get pleaseSelectActiveDate => '少なくとも1つの実施日を選択してください';

  @override
  String get planUpdated => 'プランが更新されました';

  @override
  String get planCreated => 'プランが作成されました';

  @override
  String operationFailed(String error) {
    return '操作に失敗しました: $error';
  }

  @override
  String get timePickerDefaultTitle => 'リマインダー時刻を設定';

  @override
  String get timePicker24Hour => '24時間表示';

  @override
  String get hourUnit => '時';

  @override
  String get minuteUnit => '分';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get taskList => 'タスクリスト';

  @override
  String get noActiveCycle => 'アクティブなサイクルがありません';

  @override
  String get pleaseCreateCycleFirst => '先にサイクルプランを作成してください';

  @override
  String get createCycleBtn => 'サイクルを作成';

  @override
  String get noTask => 'タスクがありません';

  @override
  String get addTaskHint => '右下のボタンをタップしてタスクを追加';

  @override
  String inProgressCount(int count) {
    return '進行中 ($count)';
  }

  @override
  String completedCount(int count) {
    return '完了 ($count)';
  }

  @override
  String get taskDetail => 'タスク詳細';

  @override
  String get taskNotExist => 'タスクが存在しません';

  @override
  String get progress => '進捗';

  @override
  String get updateProgress => '進捗を更新';

  @override
  String get addTask => 'タスクを追加';

  @override
  String get taskName => 'タスク名';

  @override
  String get descOptional => '説明（任意）';

  @override
  String get targetAmount => '目標数量';

  @override
  String get unitOptional => '単位（任意）';

  @override
  String get repeatable => '繰り返し可能';

  @override
  String get repeatableDesc => '新しいサイクルに自動作成';

  @override
  String get add => '追加';

  @override
  String get taskCreatedSuccess => 'タスクが作成されました';

  @override
  String get editTask => 'タスクを編集';

  @override
  String get save => '保存';

  @override
  String get taskUpdated => 'タスクが更新されました';

  @override
  String updateFailed(String error) {
    return '更新に失敗しました: $error';
  }

  @override
  String get editCycle => 'サイクルを編集';

  @override
  String get cycleName => 'サイクル名';

  @override
  String get cycleNameHint => '例：第1週の学習計画';

  @override
  String get cycleDescHint => 'このサイクルのメモを追加';

  @override
  String get cycleTime => 'サイクル期間';

  @override
  String totalDays(int count) {
    return '合計 $count 日';
  }

  @override
  String get quickSelectCycle => 'クイック選択';

  @override
  String get oneWeek => '1週間';

  @override
  String get twoWeeks => '2週間';

  @override
  String get threeWeeks => '3週間';

  @override
  String get oneMonth => '1か月';

  @override
  String get twoMonths => '2か月';

  @override
  String get threeMonths => '3か月';

  @override
  String get cycleUpdated => 'サイクルが更新されました';

  @override
  String get cycleCreatedSuccess => 'サイクルが作成されました';

  @override
  String get mon => '月';

  @override
  String get tue => '火';

  @override
  String get wed => '水';

  @override
  String get thu => '木';

  @override
  String get fri => '金';

  @override
  String get sat => '土';

  @override
  String get sun => '日';

  @override
  String get monday => '月曜日';

  @override
  String get tuesday => '火曜日';

  @override
  String get wednesday => '水曜日';

  @override
  String get thursday => '木曜日';

  @override
  String get friday => '金曜日';

  @override
  String get saturday => '土曜日';

  @override
  String get sunday => '日曜日';

  @override
  String get schedule => 'スケジュール';

  @override
  String get loadFailedShort => '読み込み失敗';

  @override
  String get thisWeek => '今週';

  @override
  String get lastWeek => '先週';

  @override
  String get nextWeek => '来週';

  @override
  String get weekAgo => '週前';

  @override
  String get weekLater => '週後';

  @override
  String get session => 'コマ';

  @override
  String get noCyclePlan => 'サイクルプランがありません';

  @override
  String get createCycleScheduleHint => 'サイクルプランを作成すると\nここにスケジュールが表示されます';

  @override
  String get noCycleData => 'サイクルデータがありません';

  @override
  String get cycleStats => 'サイクル統計';

  @override
  String avgCompletionRate(int rate) {
    return '平均達成率 $rate%';
  }

  @override
  String get weeklyPlanStats => '週間プラン統計';

  @override
  String get noWeeklyPlanData => '今週のプランデータがありません';

  @override
  String get createPlanWeeklyHint => 'プランを作成すると週間統計がここに表示されます';

  @override
  String get completionRate => '達成率';

  @override
  String get completedAmount => '完了';

  @override
  String get totalAmount => '合計';

  @override
  String get dailyCompletion => '一日の達成量';

  @override
  String get target => '目標';

  @override
  String get finish => '完了';

  @override
  String get general => '一般';

  @override
  String get notificationReminder => '通知';

  @override
  String get dailyCheckInReminder => '毎日のチェックインリマインダー';

  @override
  String get reminderTime => 'リマインダー時刻';

  @override
  String get cycleSection => 'サイクル';

  @override
  String get defaultCycleDays => 'デフォルトのサイクル日数';

  @override
  String get autoContinueCycle => 'サイクルを自動継続';

  @override
  String get turnedOn => 'オン';

  @override
  String get turnedOff => 'オフ';

  @override
  String get categoryManagement => 'カテゴリ';

  @override
  String get dataSection => 'データ';

  @override
  String get exportData => 'データをエクスポート';

  @override
  String get exportDataDesc => 'サイクルとチェックイン記録をバックアップ';

  @override
  String get clearAllData => 'すべてのデータを消去';

  @override
  String get clearDataWarning => 'この操作は取り消せません';

  @override
  String get cyclePlanManagement => 'サイクルプラン管理';

  @override
  String get taskCategory => 'タスクカテゴリ';

  @override
  String get addCategory => 'カテゴリを追加';

  @override
  String get categoryName => 'カテゴリ名';

  @override
  String get categoryExample => '例：勉強、運動';

  @override
  String get selectColor => '色を選択';

  @override
  String get noCategory => 'カテゴリがありません、タップして追加';

  @override
  String get confirmDelete => '削除の確認';

  @override
  String get clearDataConfirm => '本当にすべてのデータを消去しますか？この操作は取り消せません。';

  @override
  String get allDataCleared => 'すべてのデータが消去されました';

  @override
  String get delete => '削除';

  @override
  String get time => '時間';

  @override
  String get completedAmountLabel => '完了:';

  @override
  String get generalSettings => '一般';

  @override
  String get language => '言語';

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
  String get taskNameRequired => 'タスク名を入力してください';

  @override
  String get taskNameTooLong => 'タスク名は50文字以内にしてください';

  @override
  String get targetMustBePositive => '目標は0より大きい必要があります';

  @override
  String get cycleNameRequired => 'サイクル名を入力してください';

  @override
  String get cycleNameTooLong => 'サイクル名は30文字以内にしてください';

  @override
  String get selectDateRange => '開始日と終了日を選択してください';

  @override
  String get endDateBeforeStart => '終了日は開始日より前にできません';

  @override
  String get categoryNameRequired => 'カテゴリ名を入力してください';

  @override
  String get categoryNameTooLong => 'カテゴリ名は20文字以内にしてください';

  @override
  String get timetableManagement => '時間割';

  @override
  String get timetableList => '時間割リスト';

  @override
  String get noTimetable => '時間割がありません';

  @override
  String get importFromHtml => 'HTMLからインポート';

  @override
  String get importFromHtmlDesc => '教務システムからエクスポートしたHTMLファイルから時間割をインポート';

  @override
  String get createTimetable => '時間割を作成';

  @override
  String get timetableName => '時間割名';

  @override
  String get timetableNameHint => '例：2025-2026 春学期';

  @override
  String get academicYear => '学年';

  @override
  String get semester => '学期';

  @override
  String get firstSemester => '第1学期';

  @override
  String get secondSemester => '第2学期';

  @override
  String get thirdSemester => '第3学期';

  @override
  String get firstWeekMonday => '第1週の月曜日';

  @override
  String get totalWeeks => '総週数';

  @override
  String get currentWeek => '現在の週';

  @override
  String courseCount(int count) {
    return '授業数: $count';
  }

  @override
  String get timetableDetail => '時間割詳細';

  @override
  String get courseManagement => '授業管理';

  @override
  String get addCourse => '授業を追加';

  @override
  String get courseName => '授業名';

  @override
  String get courseNameHint => '例：高等数学';

  @override
  String get teacherName => '担当教員';

  @override
  String get teacherNameHint => '例：山田 太郎';

  @override
  String get location => '教室';

  @override
  String get locationHint => '例：A館-301';

  @override
  String get periodRange => 'コマ範囲';

  @override
  String get startPeriod => '開始コマ';

  @override
  String get endPeriod => '終了コマ';

  @override
  String get weekRanges => '授業週';

  @override
  String get weekRangesHint => '例：1-16週';

  @override
  String get courseColor => '授業の色';

  @override
  String get courseCreated => '授業が追加されました';

  @override
  String get courseDeleted => '授業が削除されました';

  @override
  String get timetableCreated => '時間割が作成されました';

  @override
  String get timetableDeleted => '時間割が削除されました';

  @override
  String get importSuccess => 'インポート成功';

  @override
  String importSuccessDesc(int count) {
    return '$count 件の授業をインポートしました';
  }

  @override
  String get selectHtmlFile => 'HTMLファイルを選択';

  @override
  String get importing => 'インポート中...';

  @override
  String get importFailed => 'インポート失敗';

  @override
  String get importFailedDesc => 'HTMLファイルを解析できません、ファイル形式を確認してください';

  @override
  String get timetableNameRequired => '時間割名を入力してください';

  @override
  String get courseNameRequired => '授業名を入力してください';

  @override
  String get weekdayRequired => '曜日を選択してください';

  @override
  String get periodRequired => 'コマ範囲を選択してください';

  @override
  String get weekRangesRequired => '授業週を入力してください';

  @override
  String weekFormat(int week) {
    return '第$week週';
  }

  @override
  String weekFormatNotCurrent(int week) {
    return '第$week週（現在ではない）';
  }

  @override
  String periodFormat(int start, int end) {
    return '第$start-$endコマ';
  }

  @override
  String semesterFormat(String year, int semester) {
    return '$year年度 第$semester学期';
  }

  @override
  String timetableSource(String source) {
    return '出典: $source';
  }

  @override
  String get sourceHtml => 'HTMLインポート';

  @override
  String get sourceManual => '手動作成';

  @override
  String get confirmDeleteTimetable => 'この時間割を削除しますか？すべての授業データが削除されます。';

  @override
  String get confirmDeleteCourse => 'この授業を削除しますか？';

  @override
  String get editCourse => '授業を編集';

  @override
  String get courseUpdated => '授業が更新されました';

  @override
  String get todayCourse => '今日の授業';

  @override
  String get noCourseToday => '今日は授業がありません';

  @override
  String get selectFolder => 'フォルダを選択';

  @override
  String get selectFolderDesc => '完全なウェブページとして保存した際に生成されたフォルダを選択';

  @override
  String get selectFile => 'HTMLファイルを選択';

  @override
  String get selectFileDesc => '単一の .html ファイルを直接選択';

  @override
  String get importMode => 'インポート方式';

  @override
  String get importModeHint => 'インポート方式を選択してください';

  @override
  String get folderMode => 'フォルダモード';

  @override
  String get fileMode => '単一ファイルモード';

  @override
  String get noHtmlInFolder => '選択したフォルダにHTMLファイルが見つかりません';

  @override
  String get noCourseData => 'HTMLファイルに時間割データが見つかりません。ウェブページを「完全」モードで保存してください。';

  @override
  String get importFolderSuccess => 'フォルダからのインポートに成功しました';

  @override
  String get selectedFolder => '選択済みフォルダ';

  @override
  String htmlFilesFound(int count) {
    return '$count 個のHTMLファイルが見つかりました';
  }

  @override
  String get folderModeNotSupported =>
      'このプラットフォームではフォルダモードがサポートされていないため、ファイルモードに切り替えました';

  @override
  String get selectMonthDays => '毎月実施する日を選択';

  @override
  String get monthStart => '月初';

  @override
  String get monthMid => '月中';

  @override
  String get monthEnd => '月末';

  @override
  String get planDate => 'プラン日付';

  @override
  String get timeRangeDescNone => 'このプランを実施する日付を選択';

  @override
  String get timeRangeDescDaily => 'この期間内で毎日実施';

  @override
  String get timeRangeDescWeekly => 'この期間内で選択した曜日に実施';

  @override
  String get timeRangeDescMonthly => 'この期間内で選択した日に実施';

  @override
  String get timeRangeDescInterval => 'この期間内で指定間隔ごとに実施';

  @override
  String get enableTimeSlot => '時間枠を有効化';

  @override
  String get enableTimeSlotDesc => '無効にするとプランは時間に縛られません';

  @override
  String get allDayEvents => '終日プラン';

  @override
  String monthFormat(int month) {
    return '第$month月';
  }

  @override
  String monthFormatNotCurrent(int month) {
    return '第$month月（現在ではない）';
  }

  @override
  String get confirmSemesterStart => '学期開始日を確認';

  @override
  String get confirmSemesterStartDesc =>
      '学期の第1週の月曜日が以下の日付として検出されました。確認または調整してください：';

  @override
  String get editPlanInstance => 'プランを編集';

  @override
  String get selectEditScope => '編集範囲を選択';

  @override
  String get editScopeThisOnly => '今回のみ';

  @override
  String get editScopeThisOnlyDesc => 'このプランインスタンスのみを変更';

  @override
  String get editScopeFuture => '以降のプラン';

  @override
  String get editScopeFutureDesc => 'このプラン以降のすべてを変更';

  @override
  String get editScopePast => '以前のプラン';

  @override
  String get editScopePastDesc => 'このプラン以前のすべてを変更';

  @override
  String get editScopeAll => 'すべてのプラン';

  @override
  String get editScopeAllDesc => '関連するすべてのプランを変更';

  @override
  String get planInstanceUpdated => 'プランが更新されました';

  @override
  String get confirmDeletePlan => 'このプランを削除しますか？関連するすべての記録が削除されます。';

  @override
  String get planDeleted => 'プランが削除されました';
}

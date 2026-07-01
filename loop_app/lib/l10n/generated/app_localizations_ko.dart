// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class SKo extends S {
  SKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'Loop';

  @override
  String get home => '홈';

  @override
  String get dailyPlan => '일일 계획';

  @override
  String get statistics => '통계';

  @override
  String get settings => '설정';

  @override
  String get todayPlan => '오늘의 계획';

  @override
  String get viewAll => '전체 보기';

  @override
  String get currentCycle => '현재 사이클';

  @override
  String get historyCycle => '기록';

  @override
  String get createCycle => '새 사이클 만들기';

  @override
  String get startFirstCycle => '첫 번째 사이클 계획을 시작하세요';

  @override
  String get noHistoryCycle => '기록된 사이클이 없습니다';

  @override
  String get createTodayPlan => '오늘의 계획 만들기';

  @override
  String get startPlanDay => '하루를 계획적으로 시작하세요';

  @override
  String get completed => '완료';

  @override
  String get inProgress => '진행 중';

  @override
  String get total => '전체';

  @override
  String loadFailed(String error) {
    return '불러오기 실패: $error';
  }

  @override
  String get unknownPlan => '알 수 없는 계획';

  @override
  String get dailyCheckIn => '매일 체크인';

  @override
  String get checkedInToday => '오늘 체크인 완료';

  @override
  String get notCheckedInToday => '오늘 체크인 미완료';

  @override
  String get dayUnit => '일';

  @override
  String get checkInNow => '지금 체크인';

  @override
  String daysRemaining(int count) {
    return '$count일 남음';
  }

  @override
  String get streakCheckIn => '연속';

  @override
  String get maxRecord => '최고 기록';

  @override
  String get totalCheckIn => '전체';

  @override
  String get checkIn => '체크인';

  @override
  String get checkInCalendar => '체크인 캘린더';

  @override
  String get clickToCheckIn => '탭하여 체크인';

  @override
  String streakDays(int count) {
    return '$count일 연속';
  }

  @override
  String get pageNotFound => '페이지를 찾을 수 없습니다';

  @override
  String get backToHome => '홈으로 돌아가기';

  @override
  String dateYearMonthDay(int year, int month, int day) {
    return '$year. $month. $day.';
  }

  @override
  String get dailyReminder => '일일 알림';

  @override
  String get dailyReminderBody => '일일 작업 알림';

  @override
  String get editPlan => '계획 편집';

  @override
  String get createPlan => '계획 만들기';

  @override
  String get basicInfo => '기본 정보';

  @override
  String get planName => '계획 이름';

  @override
  String get planNameHint => '예: 영어 단어 학습';

  @override
  String get descriptionOptional => '설명 (선택)';

  @override
  String get descriptionHint => '계획에 대한 상세 설명';

  @override
  String get quantityTarget => '수량 목표';

  @override
  String get dailyTarget => '일일 목표';

  @override
  String get unit => '단위';

  @override
  String get unitHint => '개/분';

  @override
  String get enableQuantityValidation => '수량 검증 활성화';

  @override
  String get enableQuantityValidationDesc => '완료 수량 입력 요구';

  @override
  String get timeSlot => '시간대';

  @override
  String get timeSlotDesc => '일정에 표시할 시간 설정';

  @override
  String get timeConflictWarning => '수업과 시간 겹침';

  @override
  String timeConflictDesc(String courses) {
    return '현재 시간대가 다음 수업과 겹칩니다: $courses';
  }

  @override
  String get timeConflictConfirm => '그래도 저장';

  @override
  String get startTime => '시작 시간';

  @override
  String get endTime => '종료 시간';

  @override
  String get tapToEdit => '탭하여 편집';

  @override
  String get selectStartTime => '시작 시간 선택';

  @override
  String get selectEndTime => '종료 시간 선택';

  @override
  String get cardColor => '카드 색상';

  @override
  String get cardColorDesc => '일정에 표시할 색상 선택';

  @override
  String get repeatRule => '반복 규칙';

  @override
  String get noRepeat => '반복 없음';

  @override
  String get repeatDaily => '매일';

  @override
  String get repeatWeekly => '매주';

  @override
  String get repeatMonthly => '매월';

  @override
  String get repeatInterval => '사용자 지정 간격';

  @override
  String get every => '매';

  @override
  String get repeatEveryDay => '일마다';

  @override
  String get activeDate => '활성 요일';

  @override
  String get executeDaily => '매일 실행';

  @override
  String get selectWeekdays => '계획을 실행할 요일 선택';

  @override
  String get weekday => '요일';

  @override
  String get everyday => '매일';

  @override
  String get weekend => '주말';

  @override
  String get timeRange => '시간 범위';

  @override
  String get startDate => '시작일';

  @override
  String get endDate => '종료일';

  @override
  String get unlimited => '제한 없음';

  @override
  String get saveChanges => '변경 사항 저장';

  @override
  String pleaseEnter(String label) {
    return '$label을(를) 입력하세요';
  }

  @override
  String get pleaseSelectActiveDate => '최소한 하나의 활성 요일을 선택하세요';

  @override
  String get planUpdated => '계획이 수정되었습니다';

  @override
  String get planCreated => '계획이 생성되었습니다';

  @override
  String operationFailed(String error) {
    return '작업 실패: $error';
  }

  @override
  String get timePickerDefaultTitle => '알림 시간 설정';

  @override
  String get timePicker24Hour => '24시간 형식';

  @override
  String get hourUnit => '시';

  @override
  String get minuteUnit => '분';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get taskList => '작업 목록';

  @override
  String get noActiveCycle => '활성 사이클 없음';

  @override
  String get pleaseCreateCycleFirst => '먼저 사이클 계획을 생성하세요';

  @override
  String get createCycleBtn => '사이클 만들기';

  @override
  String get noTask => '작업 없음';

  @override
  String get addTaskHint => '아래 버튼을 눌러 작업을 추가하세요';

  @override
  String inProgressCount(int count) {
    return '진행 중 ($count)';
  }

  @override
  String completedCount(int count) {
    return '완료 ($count)';
  }

  @override
  String get taskDetail => '작업 상세';

  @override
  String get taskNotExist => '작업이 존재하지 않습니다';

  @override
  String get progress => '진행률';

  @override
  String get updateProgress => '진행률 업데이트';

  @override
  String get addTask => '작업 추가';

  @override
  String get taskName => '작업 이름';

  @override
  String get descOptional => '설명 (선택)';

  @override
  String get targetAmount => '목표 수량';

  @override
  String get unitOptional => '단위 (선택)';

  @override
  String get repeatable => '반복 가능';

  @override
  String get repeatableDesc => '새 사이클에 자동 생성';

  @override
  String get add => '추가';

  @override
  String get taskCreatedSuccess => '작업이 생성되었습니다';

  @override
  String get editTask => '작업 편집';

  @override
  String get save => '저장';

  @override
  String get taskUpdated => '작업이 수정되었습니다';

  @override
  String updateFailed(String error) {
    return '수정 실패: $error';
  }

  @override
  String get editCycle => '사이클 편집';

  @override
  String get cycleName => '사이클 이름';

  @override
  String get cycleNameHint => '예: 1주차 학습 계획';

  @override
  String get cycleDescHint => '이 사이클에 대한 메모 추가';

  @override
  String get cycleTime => '사이클 기간';

  @override
  String totalDays(int count) {
    return '총 $count일';
  }

  @override
  String get quickSelectCycle => '빠른 선택';

  @override
  String get oneWeek => '1주';

  @override
  String get twoWeeks => '2주';

  @override
  String get threeWeeks => '3주';

  @override
  String get oneMonth => '1개월';

  @override
  String get twoMonths => '2개월';

  @override
  String get threeMonths => '3개월';

  @override
  String get cycleUpdated => '사이클이 수정되었습니다';

  @override
  String get cycleCreatedSuccess => '사이클이 생성되었습니다';

  @override
  String get mon => '월';

  @override
  String get tue => '화';

  @override
  String get wed => '수';

  @override
  String get thu => '목';

  @override
  String get fri => '금';

  @override
  String get sat => '토';

  @override
  String get sun => '일';

  @override
  String get monday => '월요일';

  @override
  String get tuesday => '화요일';

  @override
  String get wednesday => '수요일';

  @override
  String get thursday => '목요일';

  @override
  String get friday => '금요일';

  @override
  String get saturday => '토요일';

  @override
  String get sunday => '일요일';

  @override
  String get schedule => '일정';

  @override
  String get loadFailedShort => '불러오기 실패';

  @override
  String get thisWeek => '이번 주';

  @override
  String get lastWeek => '지난주';

  @override
  String get nextWeek => '다음 주';

  @override
  String get weekAgo => '주 전';

  @override
  String get weekLater => '주 후';

  @override
  String get session => '차시';

  @override
  String get noCyclePlan => '사이클 계획 없음';

  @override
  String get createCycleScheduleHint => '사이클 계획을 생성하여\n일정을 확인하세요';

  @override
  String get noCycleData => '사이클 데이터 없음';

  @override
  String get cycleStats => '사이클 통계';

  @override
  String avgCompletionRate(int rate) {
    return '평균 완료율 $rate%';
  }

  @override
  String get weeklyPlanStats => '주간 계획 통계';

  @override
  String get noWeeklyPlanData => '이번 주 계획 데이터 없음';

  @override
  String get createPlanWeeklyHint => '주간 통계를 보려면 계획을 생성하세요';

  @override
  String get completionRate => '완료율';

  @override
  String get completedAmount => '완료';

  @override
  String get totalAmount => '전체';

  @override
  String get dailyCompletion => '일일 완료';

  @override
  String get target => '목표';

  @override
  String get finish => '완료';

  @override
  String get general => '일반';

  @override
  String get notificationReminder => '알림';

  @override
  String get dailyCheckInReminder => '일일 체크인 알림';

  @override
  String get reminderTime => '알림 시간';

  @override
  String get cycleSection => '사이클';

  @override
  String get defaultCycleDays => '기본 사이클 일수';

  @override
  String get autoContinueCycle => '사이클 자동 연장';

  @override
  String get turnedOn => '켜짐';

  @override
  String get turnedOff => '꺼짐';

  @override
  String get categoryManagement => '카테고리';

  @override
  String get dataSection => '데이터';

  @override
  String get exportData => '데이터 내보내기';

  @override
  String get exportDataDesc => '사이클과 체크인 기록 백업';

  @override
  String get clearAllData => '모든 데이터 삭제';

  @override
  String get clearDataWarning => '이 작업은 되돌릴 수 없습니다';

  @override
  String get cyclePlanManagement => '사이클 계획 관리';

  @override
  String get taskCategory => '작업 카테고리';

  @override
  String get addCategory => '카테고리 추가';

  @override
  String get categoryName => '카테고리 이름';

  @override
  String get categoryExample => '예: 학습, 운동';

  @override
  String get selectColor => '색상 선택';

  @override
  String get noCategory => '카테고리 없음, 탭하여 추가';

  @override
  String get confirmDelete => '삭제 확인';

  @override
  String get clearDataConfirm => '모든 데이터를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get allDataCleared => '모든 데이터가 삭제되었습니다';

  @override
  String get delete => '삭제';

  @override
  String get time => '시간';

  @override
  String get completedAmountLabel => '완료:';

  @override
  String get generalSettings => '일반';

  @override
  String get language => '언어';

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
  String get taskNameRequired => '작업 이름을 입력하세요';

  @override
  String get taskNameTooLong => '작업 이름은 50자 이하여야 합니다';

  @override
  String get targetMustBePositive => '목표는 0보다 커야 합니다';

  @override
  String get cycleNameRequired => '사이클 이름을 입력하세요';

  @override
  String get cycleNameTooLong => '사이클 이름은 30자 이하여야 합니다';

  @override
  String get selectDateRange => '시작일과 종료일을 선택하세요';

  @override
  String get endDateBeforeStart => '종료일은 시작일보다 빠를 수 없습니다';

  @override
  String get categoryNameRequired => '카테고리 이름을 입력하세요';

  @override
  String get categoryNameTooLong => '카테고리 이름은 20자 이하여야 합니다';

  @override
  String get timetableManagement => '시간표';

  @override
  String get timetableList => '시간표';

  @override
  String get noTimetable => '시간표 없음';

  @override
  String get importFromHtml => 'HTML에서 가져오기';

  @override
  String get importFromHtmlDesc => '학사 시스템에서 내보낸 HTML에서 시간표 가져오기';

  @override
  String get createTimetable => '시간표 만들기';

  @override
  String get timetableName => '시간표 이름';

  @override
  String get timetableNameHint => '예: 2025-2026 봄 학기';

  @override
  String get academicYear => '학년도';

  @override
  String get semester => '학기';

  @override
  String get firstSemester => '1학기';

  @override
  String get secondSemester => '2학기';

  @override
  String get thirdSemester => '3학기';

  @override
  String get firstWeekMonday => '첫 주 월요일';

  @override
  String get totalWeeks => '전체 주차';

  @override
  String get currentWeek => '현재 주차';

  @override
  String courseCount(int count) {
    return '강의: $count';
  }

  @override
  String get timetableDetail => '시간표 상세';

  @override
  String get courseManagement => '강의 관리';

  @override
  String get addCourse => '강의 추가';

  @override
  String get courseName => '강의명';

  @override
  String get courseNameHint => '예: 고등수학';

  @override
  String get teacherName => '교수님';

  @override
  String get teacherNameHint => '예: 홍길동';

  @override
  String get location => '장소';

  @override
  String get locationHint => '예: A동 301호';

  @override
  String get periodRange => '교시 범위';

  @override
  String get startPeriod => '시작 교시';

  @override
  String get endPeriod => '종료 교시';

  @override
  String get weekRanges => '주차 범위';

  @override
  String get weekRangesHint => '예: 1-16';

  @override
  String get courseColor => '강의 색상';

  @override
  String get courseCreated => '강의가 추가되었습니다';

  @override
  String get courseDeleted => '강의가 삭제되었습니다';

  @override
  String get timetableCreated => '시간표가 생성되었습니다';

  @override
  String get timetableDeleted => '시간표가 삭제되었습니다';

  @override
  String get importSuccess => '가져오기 성공';

  @override
  String importSuccessDesc(int count) {
    return '$count개의 강의를 성공적으로 가져왔습니다';
  }

  @override
  String get selectHtmlFile => 'HTML 파일 선택';

  @override
  String get importing => '가져오는 중...';

  @override
  String get importFailed => '가져오기 실패';

  @override
  String get importFailedDesc => 'HTML 파일을 분석할 수 없습니다. 형식을 확인하세요.';

  @override
  String get timetableNameRequired => '시간표 이름을 입력하세요';

  @override
  String get courseNameRequired => '강의명을 입력하세요';

  @override
  String get weekdayRequired => '요일을 선택하세요';

  @override
  String get periodRequired => '교시 범위를 선택하세요';

  @override
  String get weekRangesRequired => '주차 범위를 입력하세요';

  @override
  String weekFormat(int week) {
    return '$week주차';
  }

  @override
  String weekFormatNotCurrent(int week) {
    return '$week주차 (현재 아님)';
  }

  @override
  String periodFormat(int start, int end) {
    return '$start-$end교시';
  }

  @override
  String semesterFormat(String year, int semester) {
    return '$year학년도 $semester학기';
  }

  @override
  String timetableSource(String source) {
    return '출처: $source';
  }

  @override
  String get sourceHtml => 'HTML 가져오기';

  @override
  String get sourceManual => '수동';

  @override
  String get confirmDeleteTimetable => '이 시간표를 삭제하시겠습니까? 모든 강의가 삭제됩니다.';

  @override
  String get confirmDeleteCourse => '이 강의를 삭제하시겠습니까?';

  @override
  String get editCourse => '강의 편집';

  @override
  String get courseUpdated => '강의가 수정되었습니다';

  @override
  String get todayCourse => '오늘의 강의';

  @override
  String get noCourseToday => '오늘 강의가 없습니다';

  @override
  String get selectFolder => '폴더 선택';

  @override
  String get selectFolderDesc => '전체 웹페이지로 저장할 때 생성된 폴더를 선택하세요';

  @override
  String get selectFile => 'HTML 파일 선택';

  @override
  String get selectFileDesc => '단일 .html 파일을 직접 선택하세요';

  @override
  String get importMode => '가져오기 모드';

  @override
  String get importModeHint => '가져오기 모드를 선택하세요';

  @override
  String get folderMode => '폴더 모드';

  @override
  String get fileMode => '단일 파일 모드';

  @override
  String get noHtmlInFolder => '선택한 폴더에서 HTML 파일을 찾을 수 없습니다';

  @override
  String get noCourseData =>
      'HTML 파일에서 강의 데이터를 찾을 수 없습니다. 웹페이지를 \"전체\" 모드로 저장하세요.';

  @override
  String get importFolderSuccess => '폴더에서 성공적으로 가져왔습니다';

  @override
  String get selectedFolder => '선택한 폴더';

  @override
  String htmlFilesFound(int count) {
    return '$count개의 HTML 파일을 찾았습니다';
  }

  @override
  String get folderModeNotSupported => '이 플랫폼에서는 폴더 모드가 지원되지 않아 파일 모드로 전환됩니다';

  @override
  String get selectMonthDays => '실행할 날짜를 선택하세요';

  @override
  String get monthStart => '월초';

  @override
  String get monthMid => '월중';

  @override
  String get monthEnd => '월말';

  @override
  String get planDate => '계획 날짜';

  @override
  String get timeRangeDescNone => '이 계획을 실행할 날짜 선택';

  @override
  String get timeRangeDescDaily => '이 범위 내에서 매일 실행';

  @override
  String get timeRangeDescWeekly => '이 범위 내에서 선택한 요일에 실행';

  @override
  String get timeRangeDescMonthly => '이 범위 내에서 선택한 날짜에 실행';

  @override
  String get timeRangeDescInterval => '이 범위 내에서 간격마다 실행';

  @override
  String get enableTimeSlot => '시간대 활성화';

  @override
  String get enableTimeSlotDesc => '비활성화 시 계획이 시간 제한을 받지 않습니다';

  @override
  String get allDayEvents => '종일 계획';

  @override
  String monthFormat(int month) {
    return '$month월';
  }

  @override
  String monthFormatNotCurrent(int month) {
    return '$month월 (현재 아님)';
  }

  @override
  String get confirmSemesterStart => '학기 시작일 확인';

  @override
  String get confirmSemesterStartDesc =>
      '학기의 첫 번째 월요일이 다음과 같이 감지되었습니다. 확인하거나 조정하세요:';

  @override
  String get editPlanInstance => '계획 편집';

  @override
  String get selectEditScope => '편집 범위 선택';

  @override
  String get editScopeThisOnly => '이번만';

  @override
  String get editScopeThisOnlyDesc => '이 계획 인스턴스만 수정';

  @override
  String get editScopeFuture => '향후 계획';

  @override
  String get editScopeFutureDesc => '이 계획과 모든 향후 계획 수정';

  @override
  String get editScopePast => '과거 계획';

  @override
  String get editScopePastDesc => '이 계획과 모든 과거 계획 수정';

  @override
  String get editScopeAll => '전체 계획';

  @override
  String get editScopeAllDesc => '모든 관련 계획 수정';

  @override
  String get planInstanceUpdated => '계획이 수정되었습니다';

  @override
  String get confirmDeletePlan => '이 계획을 삭제하시겠습니까? 모든 관련 기록이 삭제됩니다.';

  @override
  String get planDeleted => '계획이 삭제되었습니다';

  @override
  String get exportSuccess => '데이터를 내보냈습니다';

  @override
  String get exportFailed => '내보내기 실패';

  @override
  String get filterTasks => '작업 필터';

  @override
  String get storagePermissionDenied =>
      '폴더를 스캔하려면 저장소 접근 권한이 필요합니다. 설정에서 권한을 부여해 주세요.';

  @override
  String folderAccessError(String error) {
    return '폴더에 접근할 수 없습니다: $error';
  }
}

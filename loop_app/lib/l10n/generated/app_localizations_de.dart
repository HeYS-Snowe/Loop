// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class SDe extends S {
  SDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Loop';

  @override
  String get home => 'Startseite';

  @override
  String get dailyPlan => 'Tagesplan';

  @override
  String get statistics => 'Statistiken';

  @override
  String get settings => 'Einstellungen';

  @override
  String get todayPlan => 'Heutiger Plan';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String get currentCycle => 'Aktueller Zyklus';

  @override
  String get historyCycle => 'Verlauf';

  @override
  String get createCycle => 'Neuen Zyklus erstellen';

  @override
  String get startFirstCycle => 'Starten Sie Ihren ersten Zyklusplan';

  @override
  String get noHistoryCycle => 'Keine vergangenen Zyklen';

  @override
  String get createTodayPlan => 'Tagesplan erstellen';

  @override
  String get startPlanDay => 'Beginnen Sie mit der Tagesplanung';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get inProgress => 'In Bearbeitung';

  @override
  String get total => 'Gesamt';

  @override
  String loadFailed(String error) {
    return 'Laden fehlgeschlagen: $error';
  }

  @override
  String get unknownPlan => 'Unbekannter Plan';

  @override
  String get dailyCheckIn => 'Täglicher Check-in';

  @override
  String get checkedInToday => 'Heute eingecheckt';

  @override
  String get notCheckedInToday => 'Heute nicht eingecheckt';

  @override
  String get dayUnit => 'Tage';

  @override
  String get checkInNow => 'Jetzt einchecken';

  @override
  String daysRemaining(int count) {
    return 'Noch $count Tage';
  }

  @override
  String get streakCheckIn => 'Serie';

  @override
  String get maxRecord => 'Max. Rekord';

  @override
  String get totalCheckIn => 'Gesamt';

  @override
  String get checkIn => 'Einchecken';

  @override
  String get checkInCalendar => 'Check-in-Kalender';

  @override
  String get clickToCheckIn => 'Zum Einchecken tippen';

  @override
  String streakDays(int count) {
    return '$count-Tage-Serie';
  }

  @override
  String get pageNotFound => 'Seite nicht gefunden';

  @override
  String get backToHome => 'Zurück zur Startseite';

  @override
  String dateYearMonthDay(int year, int month, int day) {
    return '$day.$month.$year';
  }

  @override
  String get dailyReminder => 'Tägliche Erinnerung';

  @override
  String get dailyReminderBody => 'Erinnerung an tägliche Aufgaben';

  @override
  String get editPlan => 'Plan bearbeiten';

  @override
  String get createPlan => 'Plan erstellen';

  @override
  String get basicInfo => 'Grundinformationen';

  @override
  String get planName => 'Planname';

  @override
  String get planNameHint => 'z. B. Englisch-Vokabeln lernen';

  @override
  String get descriptionOptional => 'Beschreibung (optional)';

  @override
  String get descriptionHint => 'Detaillierte Beschreibung des Plans';

  @override
  String get quantityTarget => 'Mengenziel';

  @override
  String get dailyTarget => 'Tagesziel';

  @override
  String get unit => 'Einheit';

  @override
  String get unitHint => 'Stück/Minuten';

  @override
  String get enableQuantityValidation => 'Mengenvalidierung aktivieren';

  @override
  String get enableQuantityValidationDesc =>
      'Eingabe der Abschlussmenge erforderlich';

  @override
  String get timeSlot => 'Zeitfenster';

  @override
  String get timeSlotDesc => 'Anzeigezeit im Stundenplan festlegen';

  @override
  String get timeConflictWarning => 'Zeitkonflikt mit Kurs';

  @override
  String timeConflictDesc(String courses) {
    return 'Das aktuelle Zeitfenster überschneidet sich mit folgenden Kursen: $courses';
  }

  @override
  String get timeConflictConfirm => 'Trotzdem speichern';

  @override
  String get startTime => 'Startzeit';

  @override
  String get endTime => 'Endzeit';

  @override
  String get tapToEdit => 'Zum Bearbeiten tippen';

  @override
  String get selectStartTime => 'Startzeit wählen';

  @override
  String get selectEndTime => 'Endzeit wählen';

  @override
  String get cardColor => 'Kartenfarbe';

  @override
  String get cardColorDesc => 'Anzeigefarbe im Stundenplan wählen';

  @override
  String get repeatRule => 'Wiederholungsregel';

  @override
  String get noRepeat => 'Keine Wiederholung';

  @override
  String get repeatDaily => 'Täglich';

  @override
  String get repeatWeekly => 'Wöchentlich';

  @override
  String get repeatMonthly => 'Monatlich';

  @override
  String get repeatInterval => 'Benutzerdefiniertes Intervall';

  @override
  String get every => 'Alle';

  @override
  String get repeatEveryDay => 'Tage';

  @override
  String get activeDate => 'Aktive Tage';

  @override
  String get executeDaily => 'Wird täglich ausgeführt';

  @override
  String get selectWeekdays => 'Wochentage für den Plan wählen';

  @override
  String get weekday => 'Wochentag';

  @override
  String get everyday => 'Jeden Tag';

  @override
  String get weekend => 'Wochenende';

  @override
  String get timeRange => 'Zeitraum';

  @override
  String get startDate => 'Startdatum';

  @override
  String get endDate => 'Enddatum';

  @override
  String get unlimited => 'Unbegrenzt';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String pleaseEnter(String label) {
    return 'Bitte $label eingeben';
  }

  @override
  String get pleaseSelectActiveDate =>
      'Bitte mindestens einen aktiven Tag wählen';

  @override
  String get planUpdated => 'Plan aktualisiert';

  @override
  String get planCreated => 'Plan erstellt';

  @override
  String operationFailed(String error) {
    return 'Vorgang fehlgeschlagen: $error';
  }

  @override
  String get timePickerDefaultTitle => 'Erinnerungszeit festlegen';

  @override
  String get timePicker24Hour => '24-Stunden-Format';

  @override
  String get hourUnit => 'Std';

  @override
  String get minuteUnit => 'Min';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get taskList => 'Aufgabenliste';

  @override
  String get noActiveCycle => 'Kein aktiver Zyklus';

  @override
  String get pleaseCreateCycleFirst =>
      'Bitte erstellen Sie zuerst einen Zyklusplan';

  @override
  String get createCycleBtn => 'Zyklus erstellen';

  @override
  String get noTask => 'Keine Aufgaben';

  @override
  String get addTaskHint =>
      'Auf den Button unten tippen, um eine Aufgabe hinzuzufügen';

  @override
  String inProgressCount(int count) {
    return 'In Bearbeitung ($count)';
  }

  @override
  String completedCount(int count) {
    return 'Abgeschlossen ($count)';
  }

  @override
  String get taskDetail => 'Aufgabendetails';

  @override
  String get taskNotExist => 'Aufgabe existiert nicht';

  @override
  String get progress => 'Fortschritt';

  @override
  String get updateProgress => 'Fortschritt aktualisieren';

  @override
  String get addTask => 'Aufgabe hinzufügen';

  @override
  String get taskName => 'Aufgabenname';

  @override
  String get descOptional => 'Beschreibung (optional)';

  @override
  String get targetAmount => 'Zielmenge';

  @override
  String get unitOptional => 'Einheit (optional)';

  @override
  String get repeatable => 'Wiederholbar';

  @override
  String get repeatableDesc => 'In neuen Zyklen automatisch erstellen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get taskCreatedSuccess => 'Aufgabe erfolgreich erstellt';

  @override
  String get editTask => 'Aufgabe bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get taskUpdated => 'Aufgabe aktualisiert';

  @override
  String updateFailed(String error) {
    return 'Aktualisierung fehlgeschlagen: $error';
  }

  @override
  String get editCycle => 'Zyklus bearbeiten';

  @override
  String get cycleName => 'Zyklusname';

  @override
  String get cycleNameHint => 'z. B. Studienplan Woche 1';

  @override
  String get cycleDescHint => 'Notizen für diesen Zyklus hinzufügen';

  @override
  String get cycleTime => 'Zykluszeitraum';

  @override
  String totalDays(int count) {
    return '$count Tage gesamt';
  }

  @override
  String get quickSelectCycle => 'Schnellauswahl';

  @override
  String get oneWeek => '1 Woche';

  @override
  String get twoWeeks => '2 Wochen';

  @override
  String get threeWeeks => '3 Wochen';

  @override
  String get oneMonth => '1 Monat';

  @override
  String get twoMonths => '2 Monate';

  @override
  String get threeMonths => '3 Monate';

  @override
  String get cycleUpdated => 'Zyklus aktualisiert';

  @override
  String get cycleCreatedSuccess => 'Zyklus erfolgreich erstellt';

  @override
  String get mon => 'Mo';

  @override
  String get tue => 'Di';

  @override
  String get wed => 'Mi';

  @override
  String get thu => 'Do';

  @override
  String get fri => 'Fr';

  @override
  String get sat => 'Sa';

  @override
  String get sun => 'So';

  @override
  String get monday => 'Montag';

  @override
  String get tuesday => 'Dienstag';

  @override
  String get wednesday => 'Mittwoch';

  @override
  String get thursday => 'Donnerstag';

  @override
  String get friday => 'Freitag';

  @override
  String get saturday => 'Samstag';

  @override
  String get sunday => 'Sonntag';

  @override
  String get schedule => 'Stundenplan';

  @override
  String get loadFailedShort => 'Laden fehlgeschlagen';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get lastWeek => 'Letzte Woche';

  @override
  String get nextWeek => 'Nächste Woche';

  @override
  String get weekAgo => 'Wo. zuvor';

  @override
  String get weekLater => 'Wo. später';

  @override
  String get session => 'Sitzung';

  @override
  String get noCyclePlan => 'Keine Zykluspläne';

  @override
  String get createCycleScheduleHint =>
      'Erstellen Sie einen Zyklusplan, um Ihren\nStundenplan hier zu sehen';

  @override
  String get noCycleData => 'Keine Zyklusdaten';

  @override
  String get cycleStats => 'Zyklusstatistiken';

  @override
  String avgCompletionRate(int rate) {
    return 'Ø Abschluss $rate%';
  }

  @override
  String get weeklyPlanStats => 'Wochenplan-Statistiken';

  @override
  String get noWeeklyPlanData => 'Diese Woche keine Plandaten';

  @override
  String get createPlanWeeklyHint =>
      'Erstellen Sie Pläne, um hier Wochenstatistiken zu sehen';

  @override
  String get completionRate => 'Rate';

  @override
  String get completedAmount => 'Erledigt';

  @override
  String get totalAmount => 'Gesamt';

  @override
  String get dailyCompletion => 'Täglicher Abschluss';

  @override
  String get target => 'Ziel';

  @override
  String get finish => 'Fertig';

  @override
  String get general => 'Allgemein';

  @override
  String get notificationReminder => 'Benachrichtigungen';

  @override
  String get dailyCheckInReminder => 'Tägliche Check-in-Erinnerung';

  @override
  String get reminderTime => 'Erinnerungszeit';

  @override
  String get cycleSection => 'Zyklus';

  @override
  String get defaultCycleDays => 'Standard-Zyklustage';

  @override
  String get autoContinueCycle => 'Zyklus automatisch fortsetzen';

  @override
  String get turnedOn => 'An';

  @override
  String get turnedOff => 'Aus';

  @override
  String get categoryManagement => 'Kategorien';

  @override
  String get dataSection => 'Daten';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get exportDataDesc => 'Zyklen und Check-in-Datensätze sichern';

  @override
  String get clearAllData => 'Alle Daten löschen';

  @override
  String get clearDataWarning =>
      'Diese Aktion kann nicht rückgängig gemacht werden';

  @override
  String get cyclePlanManagement => 'Zyklusplan-Verwaltung';

  @override
  String get taskCategory => 'Aufgabenkategorien';

  @override
  String get addCategory => 'Kategorie hinzufügen';

  @override
  String get categoryName => 'Kategoriename';

  @override
  String get categoryExample => 'z. B. Studium, Sport';

  @override
  String get selectColor => 'Farbe wählen';

  @override
  String get noCategory => 'Keine Kategorien, zum Hinzufügen tippen';

  @override
  String get confirmDelete => 'Löschen bestätigen';

  @override
  String get clearDataConfirm =>
      'Möchten Sie wirklich alle Daten löschen? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get allDataCleared => 'Alle Daten gelöscht';

  @override
  String get delete => 'Löschen';

  @override
  String get time => 'Zeit';

  @override
  String get completedAmountLabel => 'Erledigt:';

  @override
  String get generalSettings => 'Allgemein';

  @override
  String get language => 'Sprache';

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
  String get taskNameRequired => 'Bitte Aufgabenname eingeben';

  @override
  String get taskNameTooLong =>
      'Aufgabenname darf maximal 50 Zeichen lang sein';

  @override
  String get targetMustBePositive => 'Ziel muss größer als 0 sein';

  @override
  String get cycleNameRequired => 'Bitte Zyklusname eingeben';

  @override
  String get cycleNameTooLong => 'Zyklusname darf maximal 30 Zeichen lang sein';

  @override
  String get selectDateRange => 'Bitte Start- und Enddatum wählen';

  @override
  String get endDateBeforeStart =>
      'Enddatum darf nicht vor dem Startdatum liegen';

  @override
  String get categoryNameRequired => 'Bitte Kategoriename eingeben';

  @override
  String get categoryNameTooLong =>
      'Kategoriename darf maximal 20 Zeichen lang sein';

  @override
  String get timetableManagement => 'Stundenplan';

  @override
  String get timetableList => 'Stundenpläne';

  @override
  String get noTimetable => 'Keine Stundenpläne';

  @override
  String get importFromHtml => 'Aus HTML importieren';

  @override
  String get importFromHtmlDesc =>
      'Stundenplan aus vom Hochschulsystem exportiertem HTML importieren';

  @override
  String get createTimetable => 'Stundenplan erstellen';

  @override
  String get timetableName => 'Stundenplanname';

  @override
  String get timetableNameHint => 'z. B. SS 2025-2026';

  @override
  String get academicYear => 'Studienjahr';

  @override
  String get semester => 'Semester';

  @override
  String get firstSemester => '1. Semester';

  @override
  String get secondSemester => '2. Semester';

  @override
  String get thirdSemester => '3. Semester';

  @override
  String get firstWeekMonday => 'Montag der 1. Woche';

  @override
  String get totalWeeks => 'Gesamtwochen';

  @override
  String get currentWeek => 'Aktuelle Woche';

  @override
  String courseCount(int count) {
    return 'Kurse: $count';
  }

  @override
  String get timetableDetail => 'Stundenplandetails';

  @override
  String get courseManagement => 'Kursverwaltung';

  @override
  String get addCourse => 'Kurs hinzufügen';

  @override
  String get courseName => 'Kursname';

  @override
  String get courseNameHint => 'z. B. Höhere Mathematik';

  @override
  String get teacherName => 'Dozent';

  @override
  String get teacherNameHint => 'z. B. Max Müller';

  @override
  String get location => 'Ort';

  @override
  String get locationHint => 'z. B. Gebäude A-301';

  @override
  String get periodRange => 'Stundenbereich';

  @override
  String get startPeriod => 'Startstunde';

  @override
  String get endPeriod => 'Endstunde';

  @override
  String get weekRanges => 'Wochenbereiche';

  @override
  String get weekRangesHint => 'z. B. 1-16';

  @override
  String get courseColor => 'Kursfarbe';

  @override
  String get courseCreated => 'Kurs hinzugefügt';

  @override
  String get courseDeleted => 'Kurs gelöscht';

  @override
  String get timetableCreated => 'Stundenplan erstellt';

  @override
  String get timetableDeleted => 'Stundenplan gelöscht';

  @override
  String get importSuccess => 'Import erfolgreich';

  @override
  String importSuccessDesc(int count) {
    return 'Erfolgreich $count Kurse importiert';
  }

  @override
  String get selectHtmlFile => 'HTML-Datei wählen';

  @override
  String get importing => 'Wird importiert...';

  @override
  String get importFailed => 'Import fehlgeschlagen';

  @override
  String get importFailedDesc =>
      'HTML-Datei kann nicht analysiert werden, bitte Format prüfen';

  @override
  String get timetableNameRequired => 'Bitte Stundenplanname eingeben';

  @override
  String get courseNameRequired => 'Bitte Kursname eingeben';

  @override
  String get weekdayRequired => 'Bitte Wochentag wählen';

  @override
  String get periodRequired => 'Bitte Stundenbereich wählen';

  @override
  String get weekRangesRequired => 'Bitte Wochenbereiche eingeben';

  @override
  String weekFormat(int week) {
    return 'Woche $week';
  }

  @override
  String weekFormatNotCurrent(int week) {
    return 'Woche $week (Nicht aktuell)';
  }

  @override
  String periodFormat(int start, int end) {
    return 'Stunde $start-$end';
  }

  @override
  String semesterFormat(String year, int semester) {
    return '$year Semester $semester';
  }

  @override
  String timetableSource(String source) {
    return 'Quelle: $source';
  }

  @override
  String get sourceHtml => 'HTML-Import';

  @override
  String get sourceManual => 'Manuell';

  @override
  String get confirmDeleteTimetable =>
      'Diesen Stundenplan löschen? Alle Kurse werden entfernt.';

  @override
  String get confirmDeleteCourse => 'Diesen Kurs löschen?';

  @override
  String get editCourse => 'Kurs bearbeiten';

  @override
  String get courseUpdated => 'Kurs aktualisiert';

  @override
  String get todayCourse => 'Heutige Kurse';

  @override
  String get noCourseToday => 'Heute keine Kurse';

  @override
  String get selectFolder => 'Ordner wählen';

  @override
  String get selectFolderDesc =>
      'Ordner wählen, der beim Speichern einer kompletten Webseite erstellt wurde';

  @override
  String get selectFile => 'HTML-Datei wählen';

  @override
  String get selectFileDesc => 'Eine einzelne .html-Datei direkt wählen';

  @override
  String get importMode => 'Importmodus';

  @override
  String get importModeHint => 'Bitte Importmodus wählen';

  @override
  String get folderMode => 'Ordnermodus';

  @override
  String get fileMode => 'Einzeldatei-Modus';

  @override
  String get noHtmlInFolder =>
      'Keine HTML-Dateien im gewählten Ordner gefunden';

  @override
  String get noCourseData =>
      'Keine Kursdaten in der HTML-Datei gefunden. Bitte Webseite im \"komplett\"-Modus speichern.';

  @override
  String get importFolderSuccess => 'Erfolgreich aus Ordner importiert';

  @override
  String get selectedFolder => 'Gewählter Ordner';

  @override
  String htmlFilesFound(int count) {
    return '$count HTML-Datei(en) gefunden';
  }

  @override
  String get folderModeNotSupported =>
      'Ordnermodus auf dieser Plattform nicht unterstützt, auf Dateimodus umgestellt';

  @override
  String get selectMonthDays => 'Tage des Monats zur Ausführung wählen';

  @override
  String get monthStart => 'Anfang';

  @override
  String get monthMid => 'Mitte';

  @override
  String get monthEnd => 'Ende';

  @override
  String get planDate => 'Plandatum';

  @override
  String get timeRangeDescNone => 'Datum zur Ausführung dieses Plans wählen';

  @override
  String get timeRangeDescDaily => 'Täglich in diesem Zeitraum ausführen';

  @override
  String get timeRangeDescWeekly =>
      'An gewählten Wochentagen in diesem Zeitraum ausführen';

  @override
  String get timeRangeDescMonthly =>
      'An gewählten Tagen in diesem Zeitraum ausführen';

  @override
  String get timeRangeDescInterval =>
      'Im Intervall in diesem Zeitraum ausführen';

  @override
  String get enableTimeSlot => 'Zeitfenster aktivieren';

  @override
  String get enableTimeSlotDesc =>
      'Plan ist ohne Aktivierung nicht zeitgebunden';

  @override
  String get allDayEvents => 'Ganztägige Pläne';

  @override
  String monthFormat(int month) {
    return 'Monat $month';
  }

  @override
  String monthFormatNotCurrent(int month) {
    return 'Monat $month (Nicht aktuell)';
  }

  @override
  String get confirmSemesterStart => 'Semesterstartdatum bestätigen';

  @override
  String get confirmSemesterStartDesc =>
      'Der erste Montag des Semesters wurde wie folgt erkannt. Bitte bestätigen oder anpassen:';

  @override
  String get editPlanInstance => 'Plan bearbeiten';

  @override
  String get selectEditScope => 'Bearbeitungsbereich wählen';

  @override
  String get editScopeThisOnly => 'Nur diese';

  @override
  String get editScopeThisOnlyDesc => 'Nur diese Planinstanz ändern';

  @override
  String get editScopeFuture => 'Zukünftige Pläne';

  @override
  String get editScopeFutureDesc => 'Diesen und alle zukünftigen Pläne ändern';

  @override
  String get editScopePast => 'Vergangene Pläne';

  @override
  String get editScopePastDesc => 'Diesen und alle vergangenen Pläne ändern';

  @override
  String get editScopeAll => 'Alle Pläne';

  @override
  String get editScopeAllDesc => 'Alle verknüpften Pläne ändern';

  @override
  String get planInstanceUpdated => 'Plan aktualisiert';

  @override
  String get confirmDeletePlan =>
      'Diesen Plan löschen? Alle zugehörigen Datensätze werden entfernt.';

  @override
  String get planDeleted => 'Plan gelöscht';
}

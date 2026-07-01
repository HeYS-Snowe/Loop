// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class SFr extends S {
  SFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Loop';

  @override
  String get home => 'Accueil';

  @override
  String get dailyPlan => 'Plan quotidien';

  @override
  String get statistics => 'Statistiques';

  @override
  String get settings => 'Paramètres';

  @override
  String get todayPlan => 'Plan du jour';

  @override
  String get viewAll => 'Tout voir';

  @override
  String get currentCycle => 'Cycle actuel';

  @override
  String get historyCycle => 'Historique';

  @override
  String get createCycle => 'Créer un nouveau cycle';

  @override
  String get startFirstCycle => 'Commencez votre premier plan de cycle';

  @override
  String get noHistoryCycle => 'Aucun cycle dans l\'historique';

  @override
  String get createTodayPlan => 'Créer le plan du jour';

  @override
  String get startPlanDay => 'Commencez à planifier votre journée';

  @override
  String get completed => 'Terminé';

  @override
  String get inProgress => 'En cours';

  @override
  String get total => 'Total';

  @override
  String loadFailed(String error) {
    return 'Échec du chargement : $error';
  }

  @override
  String get unknownPlan => 'Plan inconnu';

  @override
  String get dailyCheckIn => 'Pointage quotidien';

  @override
  String get checkedInToday => 'Pointé aujourd\'hui';

  @override
  String get notCheckedInToday => 'Non pointé aujourd\'hui';

  @override
  String get dayUnit => 'jours';

  @override
  String get checkInNow => 'Pointer maintenant';

  @override
  String daysRemaining(int count) {
    return '$count jours restants';
  }

  @override
  String get streakCheckIn => 'Série';

  @override
  String get maxRecord => 'Record max';

  @override
  String get totalCheckIn => 'Total';

  @override
  String get checkIn => 'Pointer';

  @override
  String get checkInCalendar => 'Calendrier de pointage';

  @override
  String get clickToCheckIn => 'Touchez pour pointer';

  @override
  String streakDays(int count) {
    return 'Série de $count jours';
  }

  @override
  String get pageNotFound => 'Page introuvable';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String dateYearMonthDay(int year, int month, int day) {
    return '$day/$month/$year';
  }

  @override
  String get dailyReminder => 'Rappel quotidien';

  @override
  String get dailyReminderBody =>
      'Notification de rappel des tâches quotidiennes';

  @override
  String get editPlan => 'Modifier le plan';

  @override
  String get createPlan => 'Créer un plan';

  @override
  String get basicInfo => 'Informations de base';

  @override
  String get planName => 'Nom du plan';

  @override
  String get planNameHint => 'ex. Apprendre le vocabulaire anglais';

  @override
  String get descriptionOptional => 'Description (facultatif)';

  @override
  String get descriptionHint => 'Description détaillée du plan';

  @override
  String get quantityTarget => 'Objectif quantitatif';

  @override
  String get dailyTarget => 'Objectif quotidien';

  @override
  String get unit => 'Unité';

  @override
  String get unitHint => 'éléments/minutes';

  @override
  String get enableQuantityValidation => 'Activer la validation quantitative';

  @override
  String get enableQuantityValidationDesc =>
      'Exiger la saisie de la quantité terminée';

  @override
  String get timeSlot => 'Créneau horaire';

  @override
  String get timeSlotDesc => 'Définir l\'heure d\'affichage dans le calendrier';

  @override
  String get timeConflictWarning => 'Conflit horaire avec un cours';

  @override
  String timeConflictDesc(String courses) {
    return 'Le créneau horaire actuel chevauche le(s) cours suivant(s) : $courses';
  }

  @override
  String get timeConflictConfirm => 'Enregistrer quand même';

  @override
  String get startTime => 'Heure de début';

  @override
  String get endTime => 'Heure de fin';

  @override
  String get tapToEdit => 'Touchez pour modifier';

  @override
  String get selectStartTime => 'Sélectionner l\'heure de début';

  @override
  String get selectEndTime => 'Sélectionner l\'heure de fin';

  @override
  String get cardColor => 'Couleur de la carte';

  @override
  String get cardColorDesc =>
      'Choisir la couleur d\'affichage dans le calendrier';

  @override
  String get repeatRule => 'Règle de répétition';

  @override
  String get noRepeat => 'Sans répétition';

  @override
  String get repeatDaily => 'Quotidien';

  @override
  String get repeatWeekly => 'Hebdomadaire';

  @override
  String get repeatMonthly => 'Mensuel';

  @override
  String get repeatInterval => 'Intervalle personnalisé';

  @override
  String get every => 'Tous les';

  @override
  String get repeatEveryDay => 'jours';

  @override
  String get activeDate => 'Jours actifs';

  @override
  String get executeDaily => 'Exécution quotidienne';

  @override
  String get selectWeekdays =>
      'Sélectionnez les jours de la semaine pour le plan';

  @override
  String get weekday => 'Jour de la semaine';

  @override
  String get everyday => 'Tous les jours';

  @override
  String get weekend => 'Week-end';

  @override
  String get timeRange => 'Plage horaire';

  @override
  String get startDate => 'Date de début';

  @override
  String get endDate => 'Date de fin';

  @override
  String get unlimited => 'Illimité';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String pleaseEnter(String label) {
    return 'Veuillez saisir $label';
  }

  @override
  String get pleaseSelectActiveDate =>
      'Veuillez sélectionner au moins un jour actif';

  @override
  String get planUpdated => 'Plan mis à jour';

  @override
  String get planCreated => 'Plan créé';

  @override
  String operationFailed(String error) {
    return 'Échec de l\'opération : $error';
  }

  @override
  String get timePickerDefaultTitle => 'Définir l\'heure de rappel';

  @override
  String get timePicker24Hour => 'Format 24 heures';

  @override
  String get hourUnit => 'H';

  @override
  String get minuteUnit => 'M';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get taskList => 'Liste des tâches';

  @override
  String get noActiveCycle => 'Aucun cycle actif';

  @override
  String get pleaseCreateCycleFirst =>
      'Veuillez d\'abord créer un plan de cycle';

  @override
  String get createCycleBtn => 'Créer un cycle';

  @override
  String get noTask => 'Aucune tâche';

  @override
  String get addTaskHint =>
      'Touchez le bouton ci-dessous pour ajouter une tâche';

  @override
  String inProgressCount(int count) {
    return 'En cours ($count)';
  }

  @override
  String completedCount(int count) {
    return 'Terminé ($count)';
  }

  @override
  String get taskDetail => 'Détail de la tâche';

  @override
  String get taskNotExist => 'La tâche n\'existe pas';

  @override
  String get progress => 'Progression';

  @override
  String get updateProgress => 'Mettre à jour la progression';

  @override
  String get addTask => 'Ajouter une tâche';

  @override
  String get taskName => 'Nom de la tâche';

  @override
  String get descOptional => 'Description (facultatif)';

  @override
  String get targetAmount => 'Quantité cible';

  @override
  String get unitOptional => 'Unité (facultatif)';

  @override
  String get repeatable => 'Répétable';

  @override
  String get repeatableDesc => 'Création automatique dans les nouveaux cycles';

  @override
  String get add => 'Ajouter';

  @override
  String get taskCreatedSuccess => 'Tâche créée avec succès';

  @override
  String get editTask => 'Modifier la tâche';

  @override
  String get save => 'Enregistrer';

  @override
  String get taskUpdated => 'Tâche mise à jour';

  @override
  String updateFailed(String error) {
    return 'Échec de la mise à jour : $error';
  }

  @override
  String get editCycle => 'Modifier le cycle';

  @override
  String get cycleName => 'Nom du cycle';

  @override
  String get cycleNameHint => 'ex. Plan d\'étude semaine 1';

  @override
  String get cycleDescHint => 'Ajouter des notes pour ce cycle';

  @override
  String get cycleTime => 'Durée du cycle';

  @override
  String totalDays(int count) {
    return '$count jours au total';
  }

  @override
  String get quickSelectCycle => 'Sélection rapide';

  @override
  String get oneWeek => '1 semaine';

  @override
  String get twoWeeks => '2 semaines';

  @override
  String get threeWeeks => '3 semaines';

  @override
  String get oneMonth => '1 mois';

  @override
  String get twoMonths => '2 mois';

  @override
  String get threeMonths => '3 mois';

  @override
  String get cycleUpdated => 'Cycle mis à jour';

  @override
  String get cycleCreatedSuccess => 'Cycle créé avec succès';

  @override
  String get mon => 'Lun';

  @override
  String get tue => 'Mar';

  @override
  String get wed => 'Mer';

  @override
  String get thu => 'Jeu';

  @override
  String get fri => 'Ven';

  @override
  String get sat => 'Sam';

  @override
  String get sun => 'Dim';

  @override
  String get monday => 'Lundi';

  @override
  String get tuesday => 'Mardi';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get thursday => 'Jeudi';

  @override
  String get friday => 'Vendredi';

  @override
  String get saturday => 'Samedi';

  @override
  String get sunday => 'Dimanche';

  @override
  String get schedule => 'Calendrier';

  @override
  String get loadFailedShort => 'Échec du chargement';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get lastWeek => 'Semaine dernière';

  @override
  String get nextWeek => 'Semaine prochaine';

  @override
  String get weekAgo => 'sem. avant';

  @override
  String get weekLater => 'sem. après';

  @override
  String get session => 'Session';

  @override
  String get noCyclePlan => 'Aucun plan de cycle';

  @override
  String get createCycleScheduleHint =>
      'Créez un plan de cycle pour voir\nvotre calendrier ici';

  @override
  String get noCycleData => 'Aucune donnée de cycle';

  @override
  String get cycleStats => 'Statistiques du cycle';

  @override
  String avgCompletionRate(int rate) {
    return 'Taux moyen $rate %';
  }

  @override
  String get weeklyPlanStats => 'Statistiques hebdomadaires';

  @override
  String get noWeeklyPlanData => 'Aucune donnée cette semaine';

  @override
  String get createPlanWeeklyHint =>
      'Créez des plans pour voir les statistiques hebdomadaires';

  @override
  String get completionRate => 'Taux';

  @override
  String get completedAmount => 'Terminé';

  @override
  String get totalAmount => 'Total';

  @override
  String get dailyCompletion => 'Achèvement quotidien';

  @override
  String get target => 'Objectif';

  @override
  String get finish => 'Terminé';

  @override
  String get general => 'Général';

  @override
  String get notificationReminder => 'Notifications';

  @override
  String get dailyCheckInReminder => 'Rappel de pointage quotidien';

  @override
  String get reminderTime => 'Heure de rappel';

  @override
  String get cycleSection => 'Cycle';

  @override
  String get defaultCycleDays => 'Durée par défaut du cycle';

  @override
  String get autoContinueCycle => 'Cycle en continuation auto';

  @override
  String get turnedOn => 'Activé';

  @override
  String get turnedOff => 'Désactivé';

  @override
  String get categoryManagement => 'Catégories';

  @override
  String get dataSection => 'Données';

  @override
  String get exportData => 'Exporter les données';

  @override
  String get exportDataDesc => 'Sauvegarder les cycles et les pointages';

  @override
  String get clearAllData => 'Effacer toutes les données';

  @override
  String get clearDataWarning => 'Cette action est irréversible';

  @override
  String get cyclePlanManagement => 'Gestion des plans de cycle';

  @override
  String get taskCategory => 'Catégories de tâches';

  @override
  String get addCategory => 'Ajouter une catégorie';

  @override
  String get categoryName => 'Nom de la catégorie';

  @override
  String get categoryExample => 'ex. Étude, Exercice';

  @override
  String get selectColor => 'Choisir une couleur';

  @override
  String get noCategory => 'Aucune catégorie, touchez pour ajouter';

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String get clearDataConfirm =>
      'Voulez-vous vraiment effacer toutes les données ? Cette action est irréversible.';

  @override
  String get allDataCleared => 'Toutes les données ont été effacées';

  @override
  String get delete => 'Supprimer';

  @override
  String get time => 'Heure';

  @override
  String get completedAmountLabel => 'Terminé :';

  @override
  String get generalSettings => 'Général';

  @override
  String get language => 'Langue';

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
  String get taskNameRequired => 'Veuillez saisir le nom de la tâche';

  @override
  String get taskNameTooLong =>
      'Le nom de la tâche doit contenir moins de 50 caractères';

  @override
  String get targetMustBePositive => 'L\'objectif doit être supérieur à 0';

  @override
  String get cycleNameRequired => 'Veuillez saisir le nom du cycle';

  @override
  String get cycleNameTooLong =>
      'Le nom du cycle doit contenir moins de 30 caractères';

  @override
  String get selectDateRange =>
      'Veuillez sélectionner les dates de début et de fin';

  @override
  String get endDateBeforeStart =>
      'La date de fin ne peut pas être antérieure à la date de début';

  @override
  String get categoryNameRequired => 'Veuillez saisir le nom de la catégorie';

  @override
  String get categoryNameTooLong =>
      'Le nom de la catégorie doit contenir moins de 20 caractères';

  @override
  String get timetableManagement => 'Emploi du temps';

  @override
  String get timetableList => 'Emplois du temps';

  @override
  String get noTimetable => 'Aucun emploi du temps';

  @override
  String get importFromHtml => 'Importer depuis HTML';

  @override
  String get importFromHtmlDesc =>
      'Importer l\'emploi du temps depuis un fichier HTML exporté du système scolaire';

  @override
  String get createTimetable => 'Créer un emploi du temps';

  @override
  String get timetableName => 'Nom de l\'emploi du temps';

  @override
  String get timetableNameHint => 'ex. 2025-2026 Semestre de printemps';

  @override
  String get academicYear => 'Année scolaire';

  @override
  String get semester => 'Semestre';

  @override
  String get firstSemester => '1er semestre';

  @override
  String get secondSemester => '2e semestre';

  @override
  String get thirdSemester => '3e semestre';

  @override
  String get firstWeekMonday => 'Lundi de la première semaine';

  @override
  String get totalWeeks => 'Nombre total de semaines';

  @override
  String get currentWeek => 'Semaine actuelle';

  @override
  String courseCount(int count) {
    return 'Cours : $count';
  }

  @override
  String get timetableDetail => 'Détail de l\'emploi du temps';

  @override
  String get courseManagement => 'Gestion des cours';

  @override
  String get addCourse => 'Ajouter un cours';

  @override
  String get courseName => 'Nom du cours';

  @override
  String get courseNameHint => 'ex. Mathématiques avancées';

  @override
  String get teacherName => 'Enseignant';

  @override
  String get teacherNameHint => 'ex. Jean Dupont';

  @override
  String get location => 'Emplacement';

  @override
  String get locationHint => 'ex. Bâtiment A-301';

  @override
  String get periodRange => 'Plage de périodes';

  @override
  String get startPeriod => 'Période de début';

  @override
  String get endPeriod => 'Période de fin';

  @override
  String get weekRanges => 'Plages de semaines';

  @override
  String get weekRangesHint => 'ex. 1-16';

  @override
  String get courseColor => 'Couleur du cours';

  @override
  String get courseCreated => 'Cours ajouté';

  @override
  String get courseDeleted => 'Cours supprimé';

  @override
  String get timetableCreated => 'Emploi du temps créé';

  @override
  String get timetableDeleted => 'Emploi du temps supprimé';

  @override
  String get importSuccess => 'Importation réussie';

  @override
  String importSuccessDesc(int count) {
    return '$count cours importés avec succès';
  }

  @override
  String get selectHtmlFile => 'Sélectionner un fichier HTML';

  @override
  String get importing => 'Importation...';

  @override
  String get importFailed => 'Échec de l\'importation';

  @override
  String get importFailedDesc =>
      'Impossible d\'analyser le fichier HTML, veuillez vérifier le format';

  @override
  String get timetableNameRequired =>
      'Veuillez saisir le nom de l\'emploi du temps';

  @override
  String get courseNameRequired => 'Veuillez saisir le nom du cours';

  @override
  String get weekdayRequired => 'Veuillez sélectionner le jour';

  @override
  String get periodRequired => 'Veuillez sélectionner la plage de périodes';

  @override
  String get weekRangesRequired => 'Veuillez saisir les plages de semaines';

  @override
  String weekFormat(int week) {
    return 'Semaine $week';
  }

  @override
  String weekFormatNotCurrent(int week) {
    return 'Semaine $week (non actuelle)';
  }

  @override
  String periodFormat(int start, int end) {
    return 'Période $start-$end';
  }

  @override
  String semesterFormat(String year, int semester) {
    return '$year Semestre $semester';
  }

  @override
  String timetableSource(String source) {
    return 'Source : $source';
  }

  @override
  String get sourceHtml => 'Importation HTML';

  @override
  String get sourceManual => 'Manuel';

  @override
  String get confirmDeleteTimetable =>
      'Supprimer cet emploi du temps ? Tous les cours seront supprimés.';

  @override
  String get confirmDeleteCourse => 'Supprimer ce cours ?';

  @override
  String get editCourse => 'Modifier le cours';

  @override
  String get courseUpdated => 'Cours mis à jour';

  @override
  String get todayCourse => 'Cours du jour';

  @override
  String get noCourseToday => 'Pas de cours aujourd\'hui';

  @override
  String get selectFolder => 'Sélectionner un dossier';

  @override
  String get selectFolderDesc =>
      'Sélectionnez le dossier généré lors de l\'enregistrement d\'une page web complète';

  @override
  String get selectFile => 'Sélectionner un fichier HTML';

  @override
  String get selectFileDesc => 'Sélectionnez directement un fichier .html';

  @override
  String get importMode => 'Mode d\'importation';

  @override
  String get importModeHint => 'Veuillez sélectionner le mode d\'importation';

  @override
  String get folderMode => 'Mode dossier';

  @override
  String get fileMode => 'Mode fichier unique';

  @override
  String get noHtmlInFolder =>
      'Aucun fichier HTML trouvé dans le dossier sélectionné';

  @override
  String get noCourseData =>
      'Aucune donnée de cours trouvée dans le fichier HTML. Veuillez enregistrer la page web en mode « complet ».';

  @override
  String get importFolderSuccess => 'Importation depuis le dossier réussie';

  @override
  String get selectedFolder => 'Dossier sélectionné';

  @override
  String htmlFilesFound(int count) {
    return '$count fichier(s) HTML trouvé(s)';
  }

  @override
  String get folderModeNotSupported =>
      'Mode dossier non pris en charge sur cette plateforme, passage en mode fichier';

  @override
  String get selectMonthDays => 'Sélectionnez les jours du mois à exécuter';

  @override
  String get monthStart => 'Début';

  @override
  String get monthMid => 'Milieu';

  @override
  String get monthEnd => 'Fin';

  @override
  String get planDate => 'Date du plan';

  @override
  String get timeRangeDescNone =>
      'Sélectionnez la date d\'exécution de ce plan';

  @override
  String get timeRangeDescDaily => 'Exécution quotidienne dans cette plage';

  @override
  String get timeRangeDescWeekly =>
      'Exécution les jours sélectionnés dans cette plage';

  @override
  String get timeRangeDescMonthly =>
      'Exécution les jours sélectionnés dans cette plage';

  @override
  String get timeRangeDescInterval =>
      'Exécution par intervalle dans cette plage';

  @override
  String get enableTimeSlot => 'Activer le créneau horaire';

  @override
  String get enableTimeSlotDesc =>
      'Le plan ne sera pas limité dans le temps si désactivé';

  @override
  String get allDayEvents => 'Plans de la journée';

  @override
  String monthFormat(int month) {
    return 'Mois $month';
  }

  @override
  String monthFormatNotCurrent(int month) {
    return 'Mois $month (non actuel)';
  }

  @override
  String get confirmSemesterStart => 'Confirmer la date de début du semestre';

  @override
  String get confirmSemesterStartDesc =>
      'Le premier lundi du semestre a été détecté comme suit. Veuillez confirmer ou ajuster :';

  @override
  String get editPlanInstance => 'Modifier le plan';

  @override
  String get selectEditScope => 'Sélectionner la portée de modification';

  @override
  String get editScopeThisOnly => 'Uniquement celui-ci';

  @override
  String get editScopeThisOnlyDesc =>
      'Modifier uniquement cette instance de plan';

  @override
  String get editScopeFuture => 'Plans futurs';

  @override
  String get editScopeFutureDesc => 'Modifier ce plan et tous les plans futurs';

  @override
  String get editScopePast => 'Plans passés';

  @override
  String get editScopePastDesc => 'Modifier ce plan et tous les plans passés';

  @override
  String get editScopeAll => 'Tous les plans';

  @override
  String get editScopeAllDesc => 'Modifier tous les plans associés';

  @override
  String get planInstanceUpdated => 'Plan mis à jour';

  @override
  String get confirmDeletePlan =>
      'Supprimer ce plan ? Tous les enregistrements associés seront supprimés.';

  @override
  String get planDeleted => 'Plan supprimé';

  @override
  String get exportSuccess => 'Données exportées';

  @override
  String get exportFailed => 'Échec de l\'export';

  @override
  String get filterTasks => 'Filtrer les tâches';

  @override
  String get storagePermissionDenied =>
      'L\'autorisation d\'accès au stockage est requise pour analyser les dossiers. Veuillez accorder l\'autorisation dans les paramètres.';

  @override
  String folderAccessError(String error) {
    return 'Impossible d\'accéder au dossier : $error';
  }
}

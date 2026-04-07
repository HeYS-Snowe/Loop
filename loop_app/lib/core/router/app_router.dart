import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/core/constants/route_constants.dart';
import 'package:loop_app/core/theme/colors.dart';
import 'package:loop_app/l10n/generated/app_localizations.dart';
import 'package:loop_app/presentation/pages/home/home_page.dart';
import 'package:loop_app/presentation/pages/tasks/task_list_page.dart';
import 'package:loop_app/presentation/pages/tasks/task_detail_page.dart';
import 'package:loop_app/presentation/pages/summary/summary_page.dart';
import 'package:loop_app/presentation/pages/settings/settings_page.dart';
import 'package:loop_app/presentation/pages/cycle/cycle_form_page.dart';
import 'package:loop_app/presentation/pages/plan/daily_plan_page.dart';
import 'package:loop_app/presentation/pages/plan/plan_form_page.dart';
import 'package:loop_app/presentation/pages/timetable/timetable_list_page.dart';
import 'package:loop_app/presentation/pages/timetable/timetable_detail_page.dart';
import 'package:loop_app/presentation/pages/timetable/timetable_import_page.dart';
import 'package:loop_app/presentation/pages/timetable/course_form_page.dart';
import 'package:loop_app/presentation/widgets/common/loop_bottom_nav.dart';
import 'package:loop_app/data/database/app_database.dart';

class LoopPageTransition extends CustomTransitionPage<void> {
  LoopPageTransition({
    required super.child,
    super.key,
  }) : super(
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _LoopTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
        );
}

class _LoopTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const _LoopTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    final secondaryCurved = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeInCubic,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.08, 0),
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
        child: Stack(
          children: [
            FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(secondaryCurved),
              child: const SizedBox.expand(),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: RouteConstants.home,
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.home,
              name: 'home',
              pageBuilder: (context, state) => const MaterialPage(
                child: HomePage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.dailyPlan,
              name: 'daily-plan',
              pageBuilder: (context, state) => const MaterialPage(
                child: DailyPlanPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.summary,
              name: 'summary',
              pageBuilder: (context, state) => const MaterialPage(
                child: SummaryPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.settings,
              name: 'settings',
              pageBuilder: (context, state) => const MaterialPage(
                child: SettingsPage(),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouteConstants.tasks,
      name: 'tasks',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => LoopPageTransition(
        child: const TaskListPage(),
      ),
      routes: [
        GoRoute(
          path: RouteConstants.taskDetail,
          name: 'task-detail',
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) {
            final taskId = state.pathParameters['taskId']!;
            return LoopPageTransition(
              child: TaskDetailPage(taskId: taskId),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: RouteConstants.createCycle,
      name: 'create-cycle',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => LoopPageTransition(
        child: const CycleFormPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.editCycle,
      name: 'edit-cycle',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final cycle = state.extra as Cycle;
        return LoopPageTransition(
          child: CycleFormPage(cycle: cycle),
        );
      },
    ),
    GoRoute(
      path: RouteConstants.createPlan,
      name: 'create-plan',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => LoopPageTransition(
        child: const PlanFormPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.editPlan,
      name: 'edit-plan',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final extra = state.extra;
        PlanTemplate template;
        DateTime? currentDate;
        if (extra is PlanTemplate) {
          template = extra;
        } else if (extra is ({PlanTemplate template, DateTime? currentDate})) {
          template = extra.template;
          currentDate = extra.currentDate;
        } else {
          throw ArgumentError('Invalid extra type for edit-plan route');
        }
        return LoopPageTransition(
          child: PlanFormPage(template: template, currentDate: currentDate),
        );
      },
    ),
    GoRoute(
      path: RouteConstants.timetables,
      name: 'timetables',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => LoopPageTransition(
        child: const TimetableListPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.timetableDetail,
      name: 'timetable-detail',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final id = state.uri.queryParameters['id']!;
        return LoopPageTransition(
          child: TimetableDetailPage(timetableId: id),
        );
      },
    ),
    GoRoute(
      path: RouteConstants.timetableImport,
      name: 'timetable-import',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => LoopPageTransition(
        child: const TimetableImportPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.courseForm,
      name: 'course-form',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final timetableId = state.uri.queryParameters['timetableId']!;
        final courseId = state.uri.queryParameters['courseId'];
        return LoopPageTransition(
          child: CourseFormPage(
            timetableId: timetableId,
            courseId: courseId,
          ),
        );
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      title: Text(S.of(context)!.pageNotFound),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(S.of(context)!.pageNotFound),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(RouteConstants.home),
            child: Text(S.of(context)!.backToHome),
          ),
        ],
      ),
    ),
  ),
);

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: LoopBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

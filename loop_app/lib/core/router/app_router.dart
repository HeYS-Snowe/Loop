import 'package:go_router/go_router.dart';
import 'package:loop/presentation/pages/home/home_page.dart';
import 'package:loop/presentation/pages/tasks/task_detail_page.dart';
import 'package:loop/presentation/pages/summary/summary_page.dart';
import 'package:loop/presentation/pages/settings/settings_page.dart';
import 'package:loop/presentation/pages/cycle/cycle_form_page.dart';
import 'package:loop/presentation/pages/plan/daily_plan_page.dart';
import 'package:loop/presentation/pages/plan/plan_form_page.dart';
import 'package:loop/presentation/widgets/common/loop_bottom_nav.dart';
import 'package:loop/core/constants/route_constants.dart';
import 'package:loop/data/database/app_database.dart';

final appRouter = GoRouter(
  initialLocation: RouteConstants.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return LoopBottomNav(child: child);
      },
      routes: [
        GoRoute(
          path: RouteConstants.home,
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: RouteConstants.dailyPlan,
          name: 'daily-plan',
          builder: (context, state) => const DailyPlanPage(),
        ),
        GoRoute(
          path: RouteConstants.summary,
          name: 'summary',
          builder: (context, state) => const SummaryPage(),
        ),
        GoRoute(
          path: RouteConstants.settings,
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
    GoRoute(
      path: RouteConstants.createCycle,
      name: 'create-cycle',
      builder: (context, state) => const CycleFormPage(),
    ),
    GoRoute(
      path: RouteConstants.editCycle,
      name: 'edit-cycle',
      builder: (context, state) {
        final cycle = state.extra as Cycle?;
        return CycleFormPage(cycle: cycle);
      },
    ),
    GoRoute(
      path: RouteConstants.createPlan,
      name: 'create-plan',
      builder: (context, state) => const PlanFormPage(),
    ),
    GoRoute(
      path: RouteConstants.editPlan,
      name: 'edit-plan',
      builder: (context, state) {
        final template = state.extra as PlanTemplate?;
        return PlanFormPage(template: template);
      },
    ),
    GoRoute(
      path: '${RouteConstants.taskDetail}/:taskId',
      name: 'task-detail',
      builder: (context, state) {
        final taskId = state.pathParameters['taskId']!;
        return TaskDetailPage(taskId: taskId);
      },
    ),
  ],
);

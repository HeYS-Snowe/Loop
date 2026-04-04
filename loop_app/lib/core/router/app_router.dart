import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loop_app/core/constants/route_constants.dart';
import 'package:loop_app/core/theme/colors.dart';
import 'package:loop_app/presentation/pages/home/home_page.dart';
import 'package:loop_app/presentation/pages/tasks/task_list_page.dart';
import 'package:loop_app/presentation/pages/tasks/task_detail_page.dart';
import 'package:loop_app/presentation/pages/check_in/check_in_page.dart';
import 'package:loop_app/presentation/pages/summary/summary_page.dart';
import 'package:loop_app/presentation/pages/settings/settings_page.dart';

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

final appRouter = GoRouter(
  initialLocation: RouteConstants.home,
  routes: [
    GoRoute(
      path: RouteConstants.home,
      name: 'home',
      pageBuilder: (context, state) => LoopPageTransition(
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.tasks,
      name: 'tasks',
      pageBuilder: (context, state) => LoopPageTransition(
        child: const TaskListPage(),
      ),
      routes: [
        GoRoute(
          path: RouteConstants.taskDetail,
          name: 'task-detail',
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
      path: RouteConstants.checkIn,
      name: 'check-in',
      pageBuilder: (context, state) => LoopPageTransition(
        child: const CheckInPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.summary,
      name: 'summary',
      pageBuilder: (context, state) => LoopPageTransition(
        child: const SummaryPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.settings,
      name: 'settings',
      pageBuilder: (context, state) => LoopPageTransition(
        child: const SettingsPage(),
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      title: const Text('页面不存在'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('页面不存在'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(RouteConstants.home),
            child: const Text('返回首页'),
          ),
        ],
      ),
    ),
  ),
);

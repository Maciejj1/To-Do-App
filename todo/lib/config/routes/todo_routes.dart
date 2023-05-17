import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/config/bloc/app_bloc.dart';
import 'package:todo/config/bloc/app_bloc.dart';
import 'package:todo/config/helpers/todo-bottomNavBar.dart';
import 'package:todo/config/routes/todo_route_utils.dart';
import 'package:todo/pages/auth/conf/auth_repository.dart';
import 'package:todo/pages/auth/login/cubit/login_cubit.dart';
import 'package:todo/pages/auth/login/login.dart';
import 'package:todo/pages/auth/models/user_model.dart';
import 'package:todo/pages/auth/register/cubit/register_cubit.dart';
import 'package:todo/pages/auth/register/register.dart';
import 'package:todo/pages/dashboard/dashboard.dart';
import 'package:todo/pages/splashscreen/splashscreen.dart';

import '../bloc/app_bloc.dart';

// class AppRouter {
//   static final _rootNavigatorKey = GlobalKey<NavigatorState>();
//   late final User user;
//   static final GoRouter _router = GoRouter(
//     debugLogDiagnostics: true,
//     navigatorKey: _rootNavigatorKey,
//     routes: [
//       GoRoute(
//           path: APP_PAGE.home.toPath,
//           pageBuilder: (context, state) => MaterialPage(
//                 child: BlocBuilder<AppBloc, AppState>(
//                   builder: (context, state) {
//                     if (state.status == AppStatus.authenticated) {
//                       return const Dashboard();
//                     } else {
//                       return const LoginScreen();
//                     }
//                   },
//                 ),
//               ),
//           routes: []),
//       GoRoute(
//           path: APP_PAGE.splash.toPath,
//           builder: (context, state) => const SplashScreen()),
//       GoRoute(
//         path: APP_PAGE.login.toPath,
//         builder: (context, state) => const LoginScreen(),
//       ),
//       GoRoute(
//         path: APP_PAGE.register.toPath,
//         builder: (context, state) => const RegisterScreen(),
//       ),
//     ],
//     redirect: (BuildContext context, GoRouterState state) {
//       // final isRegistered = state.status == AppStatus.authenticated;
//       // final isRegirteingIn = state.location == APP_PAGE.register.toPath;
//       // if (!isRegistered && !isRegirteingIn) return APP_PAGE.register.toPath;
//       // if (isRegistered && isRegirteingIn) return APP_PAGE.home.toPath;
//     },
//   );

//   static GoRouter get router => _router;
// }
List<Page<dynamic>> onGeneratedAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [MainPage.page()];
    case AppStatus.unauthenticated:
      return [
        RegisterScreen.page(),
        LoginScreen.page(),
      ];
  }
}

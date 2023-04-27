import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/config/bloc/app_bloc.dart';
import 'package:todo/pages/auth/login/cubit/login_cubit.dart';
import 'package:todo/pages/auth/login/login.dart';
import 'package:todo/pages/auth/register/cubit/register_cubit.dart';
import 'package:todo/pages/auth/register/register.dart';
import 'package:todo/pages/dashboard/dashboard.dart';
import 'package:todo/pages/splashscreen/splashscreen.dart';

GoRouter routes(AppBloc bloc) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
        routes: <GoRoute>[
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'register',
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: 'home',
            builder: (context, state) => const Dashboard(),
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = bloc.state.status == AppState.authenticated;
      final isLoggingIn = state.location == '/register';
      print(isLoggedIn);
      if (!isLoggedIn && !isLoggingIn) return '/register';
      if (isLoggedIn) return '/home';
      return null;
    },
  );
}

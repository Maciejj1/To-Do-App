import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/config/bloc/app_bloc.dart';
import 'package:todo/pages/auth/register/register.dart';
import 'package:todo/pages/dashboard/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = "/SplashScreen";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        if (kDebugMode) {
          print('Listener: $state');
        }
        Future.delayed(const Duration(seconds: 3), () {
          if (state.status == AppStatus.unauthenticated) {
            GoRouter.of(context).go('/login');

            Navigator.pushNamed(context, RegisterScreen.routeName);
          } else if (state.status == AppStatus.authenticated) {
            //Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          }
        });
      },
      builder: (context, Object? state) {
        if (kDebugMode) {
          print('object: $state');
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Welcome to Musajjal",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Hifz ul Quran Records",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                  color: Colors.blueGrey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

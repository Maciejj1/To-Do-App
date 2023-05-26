import 'package:flutter/material.dart';
import '../auth/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static Page<void> page() => const MaterialPage<void>(child: SplashScreen());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashScreen());
  }

  static const routeName = "/SplashScreen";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome to To-Do")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                // onPressed: () {
                //   context.go(
                //     '/login',
                //   );
                // },
                onPressed: () =>
                    Navigator.of(context).push<void>(LoginScreen.route()),
                child: const Text('Lets start'))
          ],
        ),
      ),
    );
  }
}

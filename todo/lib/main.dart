import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/config/bloc/app_bloc.dart';
import 'package:todo/config/routes/todo_routes.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/pages/auth/conf/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authRepository = AuthRepository();
  runApp(MyApp(
    authRepository: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository;
  MyApp({Key? key, required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) => AppBloc(authRepository: _authRepository),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: routes(AppBloc(authRepository: _authRepository)),
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        ));
  }
}

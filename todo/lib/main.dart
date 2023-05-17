import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/config/bloc/app_bloc.dart';
import 'package:todo/config/routes/todo_routes.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/pages/auth/conf/auth_repository.dart';
import 'package:todo/pages/auth/register/cubit/register_cubit.dart';
import 'package:todo/pages/dashboard/todo-list/cubit/to_do_list_cubit.dart';

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

// class MyApp extends StatelessWidget {
//   final AuthRepository _authRepository;
//   MyApp({Key? key, required AuthRepository authRepository})
//       : _authRepository = authRepository,
//         super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return RepositoryProvider.value(
//         value: _authRepository,
//         child: BlocProvider(
//           create: (_) => AppBloc(authRepository: _authRepository),
//           child: MaterialApp.router(
//             routeInformationParser: AppRouter.router.routeInformationParser,
//             routerDelegate: AppRouter.router.routerDelegate,
//             routeInformationProvider: AppRouter.router.routeInformationProvider,
//             title: 'Go router',
//             theme: ThemeData(
//               primarySwatch: Colors.blue,
//             ),
//           ),
//         ));
//   }
// }
class MyApp extends StatelessWidget {
  final AuthRepository _authRepository;
  MyApp({Key? key, required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(authRepository: _authRepository),
          ),
          BlocProvider(create: (context) => ToDoCubit()..getAllTodo())
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Go router',
      home: FlowBuilder(
        onGeneratePages: onGeneratedAppViewPages,
        state: context.select((AppBloc bloc) => bloc.state.status),
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

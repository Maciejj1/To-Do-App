import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/pages/auth/conf/auth_repository.dart';
import 'package:todo/pages/auth/login/cubit/login_cubit.dart';
import 'package:todo/pages/dashboard/dashboard.dart';
import '../../pages/auth/register/cubit/register_cubit.dart';
import '../../pages/settings/settings.dart';
import '../bloc/app_bloc.dart';

class TodoDrawer extends StatelessWidget {
  const TodoDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(AuthRepository()), // provide LoginCubit instance
      child: BlocProvider(
        create: (context) => RegisterCubit(AuthRepository()),
        child: ToDoDraweContent(),
      ),
    );
  }
}

class ToDoDraweContent extends StatefulWidget {
  ToDoDraweContent({Key? key}) : super(key: key);

  @override
  State<ToDoDraweContent> createState() => _ToDoDraweContentState();
}

class _ToDoDraweContentState extends State<ToDoDraweContent> {
  late User? _user;
  String _email = '';

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _email = _user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, registerState) {
        return BlocBuilder<LoginCubit, LoginState>(
          builder: (context, loginState) {
            return ToDoDraweContentBody(
              contentText: '$_email ${registerState.email} ${loginState.email}',
            );
          },
        );
      },
    );
  }
}

class ToDoDraweContentBody extends StatelessWidget {
  const ToDoDraweContentBody({super.key, required this.contentText});
  final String contentText;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF6200EE),
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Zalogowany jako:"),
            accountEmail: Text(
              contentText,
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://media.istockphoto.com/id/1270987867/photo/close-up-young-smiling-man-in-casual-clothes-posing-isolated-on-blue-wall-background-studio.jpg?b=1&s=612x612&w=0&k=20&c=wvRBkbEWoTWO6b_THlthzFPp15bHQxod7kaEB5LfQ5g="),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF6200EE),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: const Text(
              "Home",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Dashboard()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            title: const Text(
              "Settings",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ToDoSettings()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.redAccent,
            ),
            title: const Text(
              "LogOut",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
            onTap: () {
              context.read<AppBloc>().add(AppLogoutRequested());
            },
          ),
        ],
      ),
    );
  }
}

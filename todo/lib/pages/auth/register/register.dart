import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:todo/pages/auth/login/login.dart';
import 'package:todo/pages/auth/register/cubit/register_cubit.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../config/common/todo_snakcbar.dart';
import '../../../config/helpers/todo-appBar.dart';
import '../conf/auth_repository.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  static Page<void> page() => const MaterialPage<void>(child: RegisterScreen());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const RegisterScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TodoAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: BlocProvider<RegisterCubit>(
                create: (_) => RegisterCubit(
                      AuthRepository(),
                    ),
                child: const RegisterForm()),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    double width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      width = MediaQuery.of(context).size.width * 0.25;
    } else {
      width = MediaQuery.of(context).size.width * 1;
    }
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
            r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
            r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
            r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
            r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
            r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
            r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
        final regex = RegExp(pattern);
        if (state.status == RegisterStatus.succes &&
            state.password.length > 5 &&
            regex.hasMatch(state.email) &&
            state.email.isNotEmpty &&
            state.password.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            CustomTopSnackBar.success(
              message: "Pomyślnie zarejestrowano."
                  "Witaj W To-Do App ${state.email}", //brak
            ),
          );
        }
        if (state.status == RegisterStatus.error) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomTopSnackBar.error(
              message: "Oops... Something went wrong", //brak
            ),
          );
        }
        if (state.status == RegisterStatus.succes &&
            state.password.length < 5 &&
            state.password.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomTopSnackBar.error(
              message: "Wpisałeś za krótkie hasło", //brak
            ),
          );
        }
        if (state.status == RegisterStatus.succes &&
            !regex.hasMatch(state.email) &&
            state.email.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomTopSnackBar.error(
              message: "Wpisałeś zły email", //brak
            ),
          );
        }
        if (state.status == RegisterStatus.succes &&
            state.email.isEmpty &&
            state.password.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomTopSnackBar.error(
              message: "Nie wpisałeś email", //brak
            ),
          );
        }
        if (state.status == RegisterStatus.succes &&
            state.password.isEmpty &&
            state.email.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomTopSnackBar.error(
              message: "Nie wpisałeś password", //brak
            ),
          );
        }
        if (state.status == RegisterStatus.succes &&
            state.email.isEmpty &&
            state.password.isEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomTopSnackBar.error(
              message: "Wypełnij formularz", //brak
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 220,
            child: GradientText(
              'Welcome back in To-Do App',
              style:
                  const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              radius: 2.5,
              colors: const [
                Color(0xFF4151FF),
                Color(0xFF8409FF),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(width: 200, child: Image.asset('assets/images/loginv.png')),
          SizedBox(
            height: 8,
          ),
          RegisterEmailInput(),
          SizedBox(
            height: 8,
          ),
          RegisterPasswordInput(),
          SizedBox(
            height: 50,
          ),
          RegisterButton(),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You  have an account? '),
              TextButton(
                  onPressed: () =>
                      Navigator.of(context).push<void>(LoginScreen.route()),
                  child: Text(
                    'Login here',
                    style: TextStyle(color: Color(0xFF4B49FF)),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}

class RegisterPasswordInput extends StatelessWidget {
  const RegisterPasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Text('Password'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                onChanged: (password) {
                  context.read<RegisterCubit>().passwordChanged(password);
                },
                validator: (password) {
                  if (password == null || password.isEmpty) {}
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Wpisz hasło",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: Color(0xFF4B49FF),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: Color(0xFF4B49FF),
                      )),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class RegisterEmailInput extends StatelessWidget {
  const RegisterEmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Text('Email'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                onChanged: (email) {
                  context.read<RegisterCubit>().emailChanged(email);
                },
                validator: (value) {},
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Wpisz email",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: Color(0xFF4B49FF),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: Color(0xFF4B49FF),
                      )),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return state.status == RegisterStatus.submitting
            ? const CircularProgressIndicator()
            : Container(
                height: 44.0,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                        colors: [Color(0xFF444FFF), Color(0xFF850AFF)])),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent),
                    onPressed: () {
                      context.read<RegisterCubit>().signupFormSubmitted();
                    },
                    child: const Text('Register')),
              );
      },
      buildWhen: (previous, current) => previous.status != current.status,
    );
  }
}

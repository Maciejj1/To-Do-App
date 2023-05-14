import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/pages/auth/login/login.dart';
import 'package:todo/pages/auth/register/cubit/register_cubit.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../config/common/todo_snakcbar.dart';
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
      appBar: AppBar(),
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
            height: 8,
          ),
          SizedBox(
            height: 8,
          ),
          RegisterEmailInput(),
          SizedBox(
            height: 8,
          ),
          RegisterPasswordInput(),
          SizedBox(
            height: 8,
          ),
          RegisterButton(),
          SizedBox(
            height: 8,
          ),
          ElevatedButton(
              // onPressed: () {
              //   context.go(
              //     '/login',
              //   );
              // },
              onPressed: () =>
                  Navigator.of(context).push<void>(LoginScreen.route()),
              child: Text('Go login'))
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
        return TextFormField(
          onChanged: (password) {
            context.read<RegisterCubit>().passwordChanged(password);
          },
          validator: (password) {
            if (password == null || password.isEmpty) {}
          },
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
        return TextFormField(
          onChanged: (email) {
            context.read<RegisterCubit>().emailChanged(email);
          },
          validator: (value) {},
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
            : ElevatedButton(
                onPressed: () {
                  context.read<RegisterCubit>().signupFormSubmitted();
                },
                child: const Text('Register'));
      },
      buildWhen: (previous, current) => previous.status != current.status,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/pages/auth/conf/auth_repository.dart';
import 'package:todo/pages/auth/login/cubit/login_cubit.dart';
import 'package:todo/pages/auth/models/user_model.dart';
import 'package:todo/pages/auth/register/register.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../config/common/todo_snakcbar.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static Page<void> page() => const MaterialPage<void>(child: LoginScreen());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: BlocProvider<LoginCubit>(
            create: (_) => LoginCubit(
              AuthRepository(),
            ),
            child: const LoginForm(),
          ),
        ),
      )),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    double width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      width = MediaQuery.of(context).size.width * 0.25;
    } else {
      width = MediaQuery.of(context).size.width * 1;
    }
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
            r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
            r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
            r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
            r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
            r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
            r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
        final regex = RegExp(pattern);
        if (state.status == LoginStatus.succes &&
            state.password.length > 5 &&
            regex.hasMatch(state.email) &&
            state.email.isNotEmpty &&
            state.password.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            CustomTopSnackBar.success(
              message: "Pomyślnie zalogowano. Witaj ${state.email}", //brak
            ),
          );
        }
        if (state.status == LoginStatus.error) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomTopSnackBar.error(
              message: "Oops... Something went wrong", //brak
            ),
          );
        }
        if (state.status == LoginStatus.succes &&
            state.password.length < 5 &&
            state.password.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomTopSnackBar.error(
              message: "Wpisałeś za krótkie hasło", //brak
            ),
          );
        }
        if (state.status == LoginStatus.succes &&
            !regex.hasMatch(state.email) &&
            state.email.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomTopSnackBar.error(
              message: "Wpisałeś zły email", //brak
            ),
          );
        }
        if (state.status == LoginStatus.succes &&
            state.email.isEmpty &&
            state.password.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomTopSnackBar.error(
              message: "Nie wpisałeś email", //brak
            ),
          );
        }
        if (state.status == LoginStatus.succes &&
            state.password.isEmpty &&
            state.email.isNotEmpty) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomTopSnackBar.error(
              message: "Nie wpisałeś password", //brak
            ),
          );
        }
        if (state.status == LoginStatus.succes &&
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
          LoginEmailInput(),
          SizedBox(
            height: 8,
          ),
          LoginPasswordInput(),
          SizedBox(
            height: 8,
          ),
          LoginButton(),
          SizedBox(
            height: 8,
          ),
          ElevatedButton(
              // onPressed: () {
              //   // context.go(
              //   //   '/register',
              //   // );

              // },
              onPressed: () =>
                  Navigator.of(context).push<void>(RegisterScreen.route()),
              child: Text('Go register')),
        ],
      ),
    );
  }
}

class LoginPasswordInput extends StatelessWidget {
  const LoginPasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          onChanged: (password) {
            context.read<LoginCubit>().passwordChanged(password);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              "Wpisz coś";
            }
          },
        );
      },
    );
  }
}

class LoginEmailInput extends StatelessWidget {
  const LoginEmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          onChanged: (email) {
            context.read<LoginCubit>().emailChanged(email);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              "Wpisz coś";
            }
          },
        );
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (contex, state) {
        return state.status == LoginStatus.submitting
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  context.read<LoginCubit>().signInFormSubmitted();
                },
                child: Text('Login'));
      },
      buildWhen: (previous, current) => previous.status != current.status,
    );
  }
}

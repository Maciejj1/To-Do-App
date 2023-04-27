import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/pages/auth/register/cubit/register_cubit.dart';

import '../conf/auth_repository.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  static const routeName = "/RegisterPage";
  static Page page() => const MaterialPage<void>(child: RegisterScreen());
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const RegisterScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: BlocProvider<RegisterCubit>(
                create: (_) => RegisterCubit(
                      context.read<AuthRepository>(),
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
        if (state.status == RegisterStatus.error) {}
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              "Wpisz cos";
            }
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              "Wpisz cos";
            }
          },
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
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == RegisterStatus.submitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  context.read<RegisterCubit>().signupFormSubmitted();
                },
                child: const Text('Register'));
      },
    );
  }
}

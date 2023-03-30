import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'screens.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late String _email;
    late String _password;

    GlobalKey<FormState> key = GlobalKey<FormState>();

    return Scaffold(
        appBar: const CustomAppBar(title: "LOGIN"),
        body: Form(
          key: key,
          child: ListView(
            padding: const EdgeInsets.all(12.0),
            children: [
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                controller: TextEditingControllers.email,
                labelText: "Email",
                onChanged: (value) => {_email = value},
                keyboardType: TextInputType.emailAddress,
                validator: ValidationBuilder().email().maxLength(50).build(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                controller: TextEditingControllers.password,
                labelText: "Password",
                obscureText: true,
                onChanged: (value) => {_password = value},
                validator:
                    ValidationBuilder().maxLength(15).minLength(6).build(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 40.0,
                child: CustomButton(
                  onPressed: () async => {
                    if (key.currentState?.validate() ?? false)
                      {
                        FirebaseDatabaseService().authenticationUser(
                          context,
                          _email,
                          _password,
                        )
                      }
                  },
                  label: "Log In",
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomInkWellButton(
                    label: "Create an account",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    ),
                  ),
                  CustomInkWellButton(
                    label: "Forget password",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen()),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

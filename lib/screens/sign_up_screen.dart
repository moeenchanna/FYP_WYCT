import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late String _name;
    late String _phone;
    late String _email;
    late String _password;

    GlobalKey<FormState> key = GlobalKey<FormState>();

    return Scaffold(
        appBar: const CustomAppBar(title: "SIGN-UP"),
        body: Form(
          key: key,
          child: ListView(
            padding: const EdgeInsets.all(12.0),
            children: [
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                controller: TextEditingControllers.name,
                labelText: "Your Name",
                onChanged: (value) => {_name = value},
                validator: ValidationBuilder().maxLength(30).build(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                controller: TextEditingControllers.phone,
                labelText: "Phone No",
                onChanged: (value) => {_phone = value},
                keyboardType: TextInputType.phone,
                validator: ValidationBuilder().phone().maxLength(11).build(),
              ),
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
                        {
                          FirebaseDatabaseService().registrationUser(
                            context,
                            _name,
                            _phone,
                            _email,
                            _password,
                          )
                        }
                      }
                  },
                  label: "Create Account",
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ));
  }



}

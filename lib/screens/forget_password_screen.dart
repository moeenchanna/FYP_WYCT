import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late String _email;

    GlobalKey<FormState> key = GlobalKey<FormState>();

    return Scaffold(
        appBar: const CustomAppBar(title: "FORGET PASSWORD"),
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
              SizedBox(
                height: 40.0,
                child: CustomButton(
                  onPressed: () async => {
                    if (key.currentState?.validate() ?? false)
                      {
                        {FirebaseDatabaseService().resetEmail(context, _email)}
                      }
                  },
                  label: "SUBMIT",
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

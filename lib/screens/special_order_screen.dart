import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class SpecialOrderScreen extends StatelessWidget {
  const SpecialOrderScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    late String orderName = '';
    late String orderDetail = '';
    late String orderAddress = '';

    GlobalKey<FormState> key = GlobalKey<FormState>();

    return Scaffold(
        appBar: const CustomAppBar(title: "SPECIAL ORDER"),
        body: Form(
          key: key,
          child: ListView(
            padding: const EdgeInsets.all(12.0),
            children: [
              const SizedBox(
                height: 20.0,
              ),
              const SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Create Your Special Order',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                controller: TextEditingControllers.orderName,
                labelText: "Order Name",
                onChanged: (value) => {orderName = value},
                validator:
                    ValidationBuilder().maxLength(30).minLength(6).build(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                controller: TextEditingControllers.orderDetails,
                labelText: "Order Details",
                minimumLines: 2,
                maximumLines: 3,
                onChanged: (value) => {orderDetail = value},
                validator:
                    ValidationBuilder().maxLength(100).minLength(6).build(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                controller: TextEditingControllers.orderAddress,
                labelText: "Where to deliver",
                minimumLines: 2,
                maximumLines: 3,
                onChanged: (value) => {orderAddress = value},
                validator:
                    ValidationBuilder().maxLength(100).minLength(30).build(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 40.0,
                child: CustomButton(
                  onPressed: () => {
                    if (key.currentState?.validate() ?? false)
                      {
                        Navigator.of(context).pop(),
                      }
                  },
                  label: "Submit",
                ),
              ),
            ],
          ),
        ));
  }
}

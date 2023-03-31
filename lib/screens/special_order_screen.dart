import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class SpecialOrderScreen extends StatelessWidget {
  const SpecialOrderScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    late String _name = '';
    late String _phone = '';
    late String _email = '';
    late String _orderName = '';
    late String _orderDetail = '';
    late String _orderAddress = '';
    late String _noOfPersons = '';

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
                controller: TextEditingControllers.orderName,
                labelText: "Order Name",
                onChanged: (value) => {_orderName = value},
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
                onChanged: (value) => {_orderDetail = value},
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
                onChanged: (value) => {_orderAddress = value},
                validator:
                    ValidationBuilder().maxLength(100).minLength(30).build(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                controller: TextEditingControllers.numberOfPersons,
                labelText: "Number Of Persons",
                keyboardType: TextInputType.phone,
                onChanged: (value) => {_noOfPersons = value},
                validator: ValidationBuilder()
                    .maxLength(2, 'Number of persons must be less than 100')
                    .build(),
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
                        FirebaseDatabaseService().addSpecialOrderToFireStore(
                            context,
                            _name,
                            _phone,
                            _email,
                            _orderName,
                            _orderDetail,
                            _orderAddress,
                            _noOfPersons)
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

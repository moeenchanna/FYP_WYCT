import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    late String productName = '';
    late String productDetail = '';
    late String productPrice = '';
    late String productPicture = '';

    GlobalKey<FormState> key = GlobalKey<FormState>();

    return Scaffold(
        appBar: const CustomAppBar(title: "ADD PRODUCTS"),
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
                    'ADD Your Products',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                controller: TextEditingControllers.productName,
                labelText: "Product Name",
                onChanged: (value) => {productName = value},
                validator:
                    ValidationBuilder().maxLength(30).minLength(6).build(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                controller: TextEditingControllers.productDetails,
                labelText: "Product Details",
                minimumLines: 2,
                maximumLines: 3,
                onChanged: (value) => {productDetail = value},
                validator: ValidationBuilder().minLength(6).build(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                controller: TextEditingControllers.productPrice,
                labelText: "Product Price",
                onChanged: (value) => {productPrice = value},
                validator: ValidationBuilder()
                    .minLength(3, 'Price must be higher than Rs/-99 😟')
                    .maxLength(4, 'Price must be lower than Rs/-1000 😟')
                    .build(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                keyboardType: TextInputType.phone,
                controller: TextEditingControllers.productPicture,
                labelText: "Product Picture URL",
                onChanged: (value) => {productPicture = value},
                validator:null,
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
                        FirebaseDatabaseService().addProductToFireStore(
                            context,
                            productName,
                            productDetail,
                            productPrice,
                            productPicture)
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

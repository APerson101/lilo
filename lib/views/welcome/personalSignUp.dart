import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import 'personalSignUpController.dart';

class PersonalSignUp extends StatelessWidget {
  PersonalSignUp({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController mothers_name = TextEditingController();
//address section
    TextEditingController line_1 = TextEditingController();
    TextEditingController city = TextEditingController();
    TextEditingController stateController = TextEditingController();
    TextEditingController country = TextEditingController();
    TextEditingController zip = TextEditingController();

    TextEditingController line_2 = TextEditingController();
    TextEditingController line_3 = TextEditingController();
    TextEditingController district = TextEditingController();
    TextEditingController canton = TextEditingController();
    //address over

    TextEditingController identification_type = TextEditingController();
    TextEditingController identification_number = TextEditingController();
    TextEditingController date_of_birth = TextEditingController();

    TextEditingController country_contact = TextEditingController();
    TextEditingController gender = TextEditingController();

    TextEditingController house_type = TextEditingController();

    TextEditingController marital_status = TextEditingController();

    TextEditingController nationality = TextEditingController();
    TextEditingController password = TextEditingController();

    PersonalSignUpController controller = Get.find<PersonalSignUpController>();

    return Scaffold(
      body: ListView(
        children: [
          FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'first_name',
                    decoration: InputDecoration(hintText: 'first_name'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: "this field is required"),
                    ]),
                  ),
                  FormBuilderTextField(
                      name: 'last_name',
                      decoration: InputDecoration(hintText: 'last_name'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'email',
                      decoration: InputDecoration(hintText: 'email'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                        FormBuilderValidators.email(context,
                            errorText: 'enter Valid Email')
                      ])),
                  FormBuilderTextField(
                      name: 'password',
                      decoration: InputDecoration(hintText: 'password'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'phone_number',
                      decoration: InputDecoration(hintText: 'phone'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                        FormBuilderValidators.numeric(context,
                            errorText: 'Enter valid number')
                      ])),
                  FormBuilderTextField(
                      name: 'state',
                      decoration: InputDecoration(hintText: 'state'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'country_contact',
                      decoration: InputDecoration(hintText: 'country'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'zip',
                      decoration: InputDecoration(hintText: 'zip'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'line_1',
                      decoration: InputDecoration(hintText: 'line_1'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'city',
                      decoration: InputDecoration(hintText: 'city'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'contact_type',
                      decoration: InputDecoration(hintText: 'contact_type'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'id_type',
                      decoration: InputDecoration(hintText: 'id_type'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'id_num',
                      decoration: InputDecoration(hintText: 'id_num'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'date_of_birth',
                      decoration: InputDecoration(hintText: 'dob'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'country',
                      decoration: InputDecoration(hintText: 'country_contact'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'gender',
                      decoration: InputDecoration(hintText: 'gender'),
                      validator: FormBuilderValidators.compose([])),
                  FormBuilderTextField(
                      name: 'marital_Status',
                      decoration: InputDecoration(hintText: 'marital_Status'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "this field is required"),
                      ])),
                  FormBuilderTextField(
                      name: 'nationality',
                      decoration: InputDecoration(hintText: 'nationality'),
                      validator: FormBuilderValidators.compose([]))
                ],
              )),
          ElevatedButton(
              onPressed: () {
                // var state = _formKey.currentState!.validate();
                // if (state) {
                //   _formKey.currentState!.save();
                controller.signUp(key: _formKey);
                // }
              },
              child: Text('sign up!!')),
        ],
      ),
    );
  }
}

class signUpData {
  String firstName, lastName, email, phoneNumber;
  String? mothers_name;
//address section
  String line_1, city, password;
  String? state, country, zip, line_2, line_3, district, canton;
  //address over

  String? identification_type,
      identification_number,
      date_of_birth,
      country_contact,
      gender,
      house_type,
      marital_status,
      nationality;
  signUpData(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.password,
      this.canton,
      required this.city,
      this.country,
      this.country_contact,
      this.date_of_birth,
      this.district,
      this.gender,
      this.house_type,
      this.identification_number,
      this.identification_type,
      required this.line_1,
      this.line_2,
      this.line_3,
      this.marital_status,
      this.mothers_name,
      this.nationality,
      this.state,
      this.zip});
}

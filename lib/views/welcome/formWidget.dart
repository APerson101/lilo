import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormWidget extends StatelessWidget {
  FormWidget({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(children: [
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
              name: 'phone',
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
              name: 'country',
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
        ]));
  }
}

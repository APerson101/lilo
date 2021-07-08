import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'familysignupcontroller.dart';

class MoreForms extends StatelessWidget {
  MoreForms({Key? key}) : super(key: key);
  final FamController controller = Get.find<FamController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      return Stepper(
          steps: steps(context),
          onStepTapped: (value) => controller.currentStep.value = value,
          currentStep: controller.currentStep.value,
          onStepCancel: () => controller.currentStep.value = 0,
          onStepContinue: () => controller.currentsstep());
    }));
  }

  steps(context) {
    List<Step> steps = [];
    var personalInfo = Step(
      // isActive: true,
      title: Text('Personal Information'),
      content: Row(children: [
        Expanded(
            child: FormBuilderTextField(
          name: 'first_name',
          onChanged: (value) => controller.firstname.value = value!,
          decoration: InputDecoration(hintText: 'first_name'),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context,
                errorText: "this field is required"),
          ]),
        )),
        Expanded(
          child: FormBuilderTextField(
              name: 'last_name',
              onChanged: (value) => controller.last_name.value = value!,
              decoration: InputDecoration(hintText: 'last_name'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context,
                    errorText: "this field is required"),
              ])),
        )
      ]),
    );
    var moreInfoStep = Step(
      title: Text("contact info"),
      content: Row(children: [
        Expanded(
            child: FormBuilderTextField(
                name: 'email',
                onChanged: (value) => controller.email.value = value!,
                decoration: InputDecoration(hintText: 'email'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context,
                      errorText: "this field is required"),
                  FormBuilderValidators.email(context,
                      errorText: 'enter Valid Email')
                ]))),
        Expanded(
            child: FormBuilderTextField(
                name: 'number',
                onChanged: (value) => controller.number.value = value!,
                decoration: InputDecoration(hintText: 'number'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context,
                      errorText: "this field is required"),
                ])))
      ]),
    );
    //age, gender, etc
    var addressInfo = Step(
      title: Text('Address info'),
      content: Column(children: [
        Row(children: [
          Expanded(
            child: FormBuilderTextField(
                name: 'Line 1',
                onChanged: (value) => controller.Line.value = value!,
                decoration: InputDecoration(hintText: 'Line 1'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context,
                      errorText: "this field is required"),
                ])),
          ),
          Expanded(
              child: FormBuilderTextField(
                  name: 'country',
                  onChanged: (value) => controller.country.value = value!,
                  decoration: InputDecoration(hintText: 'country'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: "this field is required"),
                  ])))
        ]),
        Row(children: [
          Expanded(
              child: FormBuilderTextField(
                  name: 'state',
                  onChanged: (value) => controller.state.value = value!,
                  decoration: InputDecoration(hintText: 'state'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: "this field is required"),
                    FormBuilderValidators.email(context,
                        errorText: 'enter Valid Email')
                  ]))),
          Expanded(
              child: FormBuilderTextField(
                  name: 'zip',
                  onChanged: (value) => controller.zip.value = value!,
                  decoration: InputDecoration(hintText: 'zip'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: "this field is required"),
                  ])))
        ])
      ]),
    );
    //
    steps.add(personalInfo);
    steps.add(moreInfoStep);
    steps.add(addressInfo);
    return steps;
  }
}

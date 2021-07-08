import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lilo/bloc/login/bloc/login.dart';
import 'package:lilo/bloc/login/bloc/login_bloc.dart';
import 'package:lilo/views/welcome/familysignup.dart';

import 'personalSignUp.dart';

class WelcomeInfo extends StatelessWidget {
  const WelcomeInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text("Welcome information to be displayed here")));
  }
}

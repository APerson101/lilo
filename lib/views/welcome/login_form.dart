import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lilo/bloc/login/bloc/login.dart';
import 'package:lilo/views/main_home/main_home.dart';
import 'package:lilo/views/welcome/landing_page_Controller.dart';

class LoginForm extends StatelessWidget {
  LandingController _landingController;
  LoginForm(this._landingController);

  setFormField(String label) {
    return Column(children: [
      Text(label),
      SizedBox(
        height: 10.0,
      ),
      Container(
        decoration: BoxDecoration(
            color: Colors.amber[900],
            borderRadius: BorderRadius.circular(100.0)),
        child: TextField(
          onChanged: (value) {
            (label == "Email")
                ? _landingController.setUsername.value = value
                : _landingController.setpassword.value = value;
          },
          decoration: InputDecoration(border: InputBorder.none),
        ),
      ),
    ]).paddingOnly(right: 20);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();
    return Container(
        child: SafeArea(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
          setFormField("Email"),
          SizedBox(height: 20),
          setFormField("password"),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                var og = "ariel-jerde@ohara.biz";
                var trial = "grimes_elwyn@waters.name";
                _landingController.login(email: trial, password: "000000");
              },
              child: Text("personal Login")),
          ElevatedButton(
              onPressed: () {
                _landingController.login(
                    email: "felicity-morar@boyer.info", password: "00000000");
              },
              child: Text("family controller login")),
          ElevatedButton(
              onPressed: () {
                _landingController.login(
                    email: "lessie-homenick@kautzer.us", password: "00000000");
              },
              child: Text("family member login")),
          ElevatedButton(
              onPressed: () => _landingController.signupGmail(),
              child: Text("Sign up")),
        ]))));
    return BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocListener<LoginBloc, LoginState>(listener: (context, state) {
          if (state is LoginFailure) {
            var msg = state.failureCode.toString();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: Colors.red,
              ),
            );
          }
        }, child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          if (state is LoginSucess) {
            //go home
            //routing
            // context.read<AuthBloc>().add(LoggedIn());
            return Container(child: Text('login success'));
          }
          return Container(
              color: Colors.amber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(controller: username),
                  TextFormField(controller: password),
                  ElevatedButton(
                      onPressed: () =>
                          submit('nabil@gmail.com', '00000000', context),
                      child: Text('Login Nabil')),
                  ElevatedButton(
                      onPressed: () =>
                          submit('busayo@gmail.com', '00000000', context),
                      child: Text('Login Busayo')),
                  ElevatedButton(
                      onPressed: () => submit(
                          'abdulhadih48@gmail.com', 'd345ftgn349Q', context),
                      child: Text('Login Me')),
                  ElevatedButton(
                      onPressed: () =>
                          submit('olajide@gmail.com', '00000000', context),
                      child: Text('Login Olajide')),
                  ElevatedButton(
                      onPressed: () =>
                          submit('enouch@gmail.com', '00000000', context),
                      child: Text('Login Enouch')),
                  ElevatedButton(
                      onPressed: () =>
                          submit('mansour@gmail.com', '00000000', context),
                      child: Text('Login Ruqayyah')),
                  ElevatedButton(
                      onPressed: () =>
                          submit('mansour@gmail.com', '11', context),
                      child: Text('wrong')),
                ],
              ));
        })));
  }

  submit(String username, String password, BuildContext context) {
    // BlocProvider.of<LoginBloc>(context).add(Login(password, username));
    Get.offAll(() => MainHome());
  }

  signUpButton(BuildContext context) {
    // BlocProvider.of<LoginBloc>(context).add(Signup());
  }
}

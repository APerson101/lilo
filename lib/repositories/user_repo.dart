import 'dart:async';
import 'dart:convert';
import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lilo/models/user.dart';
import 'package:lilo/repositories/rapyd/APIHandler.dart';
import 'package:pretty_json/pretty_json.dart';
import 'package:provider/provider.dart';

import 'package:lilo/models/wallet.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';

import 'rapyd/APIErrors.dart';

class UserRepository extends APIHandler {
  UserModel? user;
  String userId;
  UserRepository(this.userId) {
    loadUser();
  }

  loadUser() async {
    var response =
        await callFunction(body: {"userID": userId}, function: 'loadUser');
    print(response);
    this.user = UserModel.fromMap(response);
    return user;
  }
}

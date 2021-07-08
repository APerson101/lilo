import 'package:get/get.dart';
import 'package:lilo/controllers/authentication.dart';
import 'package:lilo/models/wallet.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';

class SignUpRepository {
  WalletRepository _walletRepository = Get.find<WalletRepository>();
  AuthenticationController _authenticationController =
      Get.find<AuthenticationController>();

  signUpProcedure(Map<String, dynamic> data) async {
    //formate data
    Wallet _wallet = formatData(data);
    //create user
    var status = await createUser(userData: _wallet);
    print('status is $status');
    return status;
    //if creation is successful, move to home page, otherwise show error
    //create card?
  }

  formatData(Map<String, dynamic> data) {
    Wallet _wallet = Wallet(
        contact: Contact(
          address: ContactAddress(
              name: data['first_name'] + ' ' + data['last_name'],
              line_1: data['line_1'],
              city: data['city'],
              state: data['state'],
              country: data['country'],
              zip: data['zip'],
              phone_number: data['phoneNumber']),
          city: data['city'],
          email: data['email'],
          phone_number: data['phone_number'],
          first_name: data['first_name'],
          last_name: data['last_name'],
          mothers_name: data['mothers_name'],
          date_of_birth: data['date_of_birth'],
          country: data['country_contact'],
          gender: data['gender'],
          house_type: data['house_type'],
          marital_status: data['marital_status'],
          nationality: data['nationality'],
        ),
        first_name: data['first_name'],
        last_name: data['last_name'],
        email: data['email'],
        accounts: [],
        phone_number: data['phone_number']);
    return _wallet;
  }

  createUser({required Wallet userData}) async {
    //
    var status = await _walletRepository.createUser(userData);
    return status;
  }

  signUpProcedure2(Map<String, dynamic> data) async {
    //sign up with whatever user entered
    Wallet _wallet = formatData(data);
    var status = await _walletRepository.createUser1(_wallet.toMap(), data);
    return status;
  }

  signUpProcedure3(Map<String, dynamic> data) async {
    //sign up with required fields only
  }
}

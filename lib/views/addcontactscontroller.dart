import 'package:faker/faker.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:random_string/random_string.dart';

class AddContactController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Map<String, dynamic> enteredFields = {};

  saveContact() {
    Faker f = Faker();
    String num = randomNumeric(10);
    var fakeData = {
      'last_name': f.person.lastName(),
      'phone_number': '+1$num',
      'first_name': f.person.firstName(),
      'email': f.internet.email(),
      // 'middle_name':
      // 'id_date_of_issue': id_date_of_issue,
      // 'id_issue_authority': id_issue_authority,
      // 'id_issue_location': id_issue_location,
      // 'tax_id': tax_id,
      'date_of_birth': '01/01/01',
      'city': f.address.city(),
      'address': f.address.streetAddress(),
      // 'state': state,
      // 'postcode': postcode,
      // 'suburb': suburb,
      // 'phone_country_code': phone_country_code,
      'nationality': f.address.countryCode(),
    };
  }
}

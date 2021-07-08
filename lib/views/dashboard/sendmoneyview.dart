import 'package:country_list_pick/country_list_pick.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:lilo/models/constants.dart';
import 'package:lilo/models/contact.dart';
import 'package:lilo/models/wallet.dart';
import 'package:styled_widget/styled_widget.dart';

import 'sendmoneyController.dart';

class SendMoney extends StatelessWidget {
  SendMoney({Key? key}) : super(key: key);
  SendMoneyController controller = Get.put(SendMoneyController());

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //dropdown
        Text("SEND MONEY"),
        SizedBox(height: 15),
        _transferSource(),
        _benefitiaryType(),
        Obx(
          () => bodyDecider(),
        ),
      ],
    ));
  }

  _transferSource() {
    return Obx(() {
      String dropDownValue = controller.category.value;
      return DropdownButtonHideUnderline(
        child: GFDropdown(
          borderRadius: BorderRadius.circular(5),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Colors.grey,
          value: dropDownValue,
          items: [
            'Bank',
            'Cash',
            'Card Transfer',
            'Wallet Transfer',
            'Other eWallet'
          ]
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
          onChanged: (newvalue) {
            controller.category.value = newvalue.toString();
          },
        ),
      );
    });
  }

  _benefitiaryType() {
    List<String> _status = ["contact", "new receiver"];
    return Obx(() {
      var _verticalGroupValue = controller.benefitiaryType.value;
      return RadioGroup<String>.builder(
        groupValue: _verticalGroupValue,
        onChanged: (value) => controller.benefitiaryType.value = value!,
        items: _status,
        itemBuilder: (item) => RadioButtonBuilder(
          item,
          textPosition: RadioButtonTextPosition.left,
        ),
      );
    });
  }

  bodyDecider() {
    var category = controller.category.value;
    var recieverType = controller.benefitiaryType.value;
    List<Beneficiary> previousWalletContacts = [];
    previousWalletContacts = controller.allContacts.value;

    if (previousWalletContacts.isEmpty || recieverType == 'new receiver')
      return newTransfer(category);

    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            benefitiaries(previousWalletContacts),
            TextField(
              decoration: InputDecoration(hintText: 'enter amount'),
              onChanged: (value) =>
                  controller.enteredAmount.value = double.parse(value),
            ),
            ElevatedButton(
                onPressed: () => controller.sendMoney(),
                child: Text('send money'))
            // SizedBox(height: 20),
            // newTransfer(setting)
          ]),
    );
  }

  Widget newTransfer(String type) {
    if (type == 'Wallet Transfer')
      return Expanded(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(
              child: ElevatedButton(
                  onPressed: () => newContact(), child: Text("new contact"))),
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: 'Enter eWallet ID'),
              onChanged: (value) => controller.eWalletReceiverId.value = value,
            ),
          ),
          // Expanded(child:
          _accountsDropDown(),
          // ),
          // Expanded(
          //     child:
          TextField(
            decoration: InputDecoration(labelText: 'Enter Amount'),
            onChanged: (value) =>
                controller.enteredAmount.value = double.parse(value),
          ),
          // ),
          // Expanded(
          //   child:
          ElevatedButton(
              onPressed: () => controller.sendMoney(), child: Text('send')),
          // )
        ]),
      );
    else
      return Container(
          color: Colors.orange,
          child: Column(children: [
            ElevatedButton(
                onPressed: _currencyPicker(Get.context),
                child: Text('select receiver currency')),
            _accountType(),
            _countryPicker(),
            ElevatedButton(
                child: Text('find'),
                onPressed: () => controller.getPayoutMethods())
          ]));
  }

  _currencyPicker(context) {
    return (() => showCurrencyPicker(
        context: context,
        showFlag: false,
        showCurrencyName: true,
        showCurrencyCode: true,
        onSelect: (Currency currency) =>
            controller.currency.value = currency.code));
  }

  _accountType() {
    List<String> _status = ["individual", "company"];
    return Obx(() {
      var _verticalGroupValue = controller.benefitiaryaccountType.value;
      return RadioGroup<String>.builder(
        groupValue: _verticalGroupValue,
        onChanged: (value) =>
            controller.benefitiaryaccountType.value = value.toString(),
        items: _status,
        itemBuilder: (item) => RadioButtonBuilder(
          item,
          textPosition: RadioButtonTextPosition.left,
        ),
      );
    });
  }

  _countryPicker() {
    return Obx(() => CountryListPick(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Text('Pick receiver country'),
          ),
          theme: CountryTheme(
            isShowFlag: false,
            isShowTitle: true,
            isShowCode: false,
            isDownIcon: true,
            showEnglishName: false,
          ),
          initialSelection: controller.country.value,
          onChanged: (code) {
            controller.country.value = code!.code!;
          },
        ));
  }

  Widget benefitiaries(List<Beneficiary> previousWalletContacts) {
    String currentbenefitiaryName = '';
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Contacts'),
          SizedBox(
              // width: 400,
              height: 100,
              child: Container(
                  color: Colors.red,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: previousWalletContacts.length + 2,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == previousWalletContacts.length) {
                          return ElevatedButton(
                              onPressed: () => newContact(),
                              child: Text('add new contact'));
                        }
                        if (index == previousWalletContacts.length + 1) {
                          return ElevatedButton(
                              onPressed: () => allContact(),
                              child: Text('view all contacts'));
                        }

                        currentbenefitiaryName =
                            previousWalletContacts[index].first_name;
                        return GestureDetector(
                          child: Stack(
                              alignment: AlignmentDirectional.topCenter,
                              children: [
                                Container(
                                    color: Colors.purple,
                                    child: Stack(children: [
                                      GFAvatar(
                                        backgroundImage: NetworkImage(
                                            "https://i0.wp.com/previews.123rf.com/images/apoev/apoev1903/apoev190300094/124282475-person-gray-photo-placeholder-man-in-a-shirt-on-gray-background.jpg"),
                                      ),
                                      Text(
                                        currentbenefitiaryName,
                                        style: TextStyle(color: Colors.black),
                                      )
                                          .padding(top: 50)
                                          .alignment(Alignment.center)
                                    ]))
                              ]).padding(all: 10),
                          onTap: () {
                            //if selected contact has multiple options,
                            List<PayoutDetails> alloptions =
                                previousWalletContacts[index].payout_fields!;
                            if (alloptions.length > 1) {
                              // show all
                              Get.defaultDialog(
                                  content: SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: Column(children: [
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount: alloptions.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (BuildContext text,
                                                  int current) {
                                                //
                                                return ElevatedButton(
                                                    child: Text(
                                                            alloptions[current]
                                                                .name!)
                                                        .paddingOnly(left: 8),
                                                    onPressed: () {
                                                      controller.contactSelected
                                                          .value = true;
                                                      controller
                                                          .contactTransferOption
                                                          .value = current;
                                                      Get.back();
                                                    });
                                              }),
                                        ),
                                        Expanded(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  //add new payment method
                                                },
                                                child: Text("add new")))
                                      ])));
                            } else {
                              //fill in details and save them
                            }
                            controller.selectedContact.value = index;
                          },
                        );
                      })))
        ]);
  }

  _accountsDropDown() {
    List<Account> accounts = controller.getAccounts();
    return Container(
      child: GFDropdown(
          items: accounts
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value.currency),
                  ))
              .toList(),
          onChanged: (value) => chnged(value)),
    );
  }

  void chnged(Object? account) {
    if (account is Account) controller.selectedSourceAccount.value = account.id;
  }

  newContact() {
    Get.defaultDialog(
        title: "new contact",
        textConfirm: "next",
        content: newContactForm().constrained(width: 200, height: 400),
        onCancel: () => Get.back(),
        onConfirm: () => controller.newContact());
  }

  allContact() {
    Get.bottomSheet(allContactsList(controller.allContacts));
  }

  Widget newContactForm() {
    List<String> fields = Constants.getContactField;
    return Container(
        child: ListView.builder(
            itemCount: fields.length,
            itemBuilder: (builcontext, index) {
              return TextFormField(
                onChanged: (newEntry) =>
                    controller.formValues[fields[index]] = newEntry,
                decoration: InputDecoration(hintText: fields[index]),
              );
            }));
  }

  allContactsList(List<Beneficiary> value) {
    return ListView.builder(
        itemCount: value.length,
        itemBuilder: (buildcontext, index) {
          return Column(children: [
            Text(value[index].first_name),
            ElevatedButton(
                onPressed: () => controller.deleteContact(value[index]),
                child: Text('delete contact'))
          ]);
        });
  }
}

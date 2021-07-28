import 'package:country_list_pick/country_list_pick.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:lilo/controllers/speechController.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/views/dashboard/dashboardController.dart';
import 'package:lilo/views/dashboard/widgets/allgiftcards.dart';

import 'buttonsController.dart';
import 'dashboardRepository.dart';
import 'subscriptionController.dart';
import '../../styles.dart';
import 'package:styled_widget/styled_widget.dart';

class Buttons extends StatelessWidget {
  DashboardController controller = Get.find();

  ButtonsController buttonsController = Get.put(ButtonsController());
  SubscriptionController subController = Get.put(SubscriptionController());

  Buttons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _icons()
        .decorated(
            color: Get.theme.backgroundColor,
            borderRadius: BorderRadius.circular(20))
        .padding(left: 10);
  }

  Widget _icons() {
    return <Widget>[
      GestureDetector(
          child: _buildActionItem(
              'Subscribe', Icons.attach_money_rounded, Colors.red),
          onTap: () => subscribeButton()),
      GestureDetector(
          child: _buildActionItem(
              'Gift Card', Icons.card_giftcard_rounded, Colors.green),
          onTap: () => giftCards()),
      GestureDetector(
          child: _buildActionItem(
              'Add funds', Icons.add_box_outlined, Colors.blue),
          onTap: () => addfunds()),
      GestureDetector(
          child: _buildActionItem(
              'Withdraw', Icons.remove_circle_outline_rounded, Colors.amber),
          onTap: () => withdraw()),
      GestureDetector(
          child: _buildActionItem(
              'Request', Icons.request_page_outlined, Colors.black),
          onTap: () => familyRequest()),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround);
  }

  Widget _buildActionItem(String name, IconData icon, Color color) {
    final Widget actionIcon = Icon(icon, size: 40, color: color)
        .alignment(Alignment.center)
        .ripple()
        .constrained(width: 70, height: 70)
        .backgroundColor(Colors.lightBlue.shade100)
        .clipOval()
        .padding(bottom: 5);

    final Widget actionText = Text(
      name,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            wordSpacing: 1),
      ),
    );

    return <Widget>[
      actionIcon,
      actionText,
    ].toColumn().padding(vertical: 20);
  }

  giftCards() async {
    await buttonsController.getGiftCards();
    Get.to(() => AllCards());
  }

  addfunds() {
    buttonsController.addfunds();
  }

  withdraw() {
    buttonsController.removefunds();
  }

  familyRequest() {
    Get.defaultDialog(
        content: Container(
          child: Column(children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'Enter Amount'),
            )
          ]),
        ),
        onConfirm: () => buttonsController.familyRequest(),
        textConfirm: "Request",
        textCancel: "cancel",
        onCancel: () => Get.back());
  }

  buttonStop() {
    return GFIconButton(
        icon: Icon(Icons.mic),
        onPressed: () async {
          buttonsController.addfunds();
          // speechController.stop();
        });
  }

  SpeechController speechController = Get.put(SpeechController());
  buttonBuy() {
    return GFIconButton(
        icon: Icon(Icons.build_circle_sharp),
        onPressed: () async {
          await buttonsController.getGiftCards();
          Get.to(() => AllCards());
        });
  }

  buttonRequest() {
    return GFIconButton(
        icon: Icon(Icons.request_page),
        onPressed: () async {
          await buttonsController.familyRequest();
        });
  }

  buttonSubscribe() {
    return GFIconButton(
        icon: Icon(Icons.subtitles),
        onPressed: () {
          subscribeButton();
        });
  }

  subscribeButton() {
    var title = '';
    Widget view = Container();

    Get.defaultDialog(
        onWillPop: () => subController.reset(),
        title: subController.title.value,
        content: ObxValue((value) {
          if (subController.currentView.value ==
              displayOptions.newSubscription) {
            subController.title.value = 'Add subscription';
            view = _subscritionView();
          }
          if (subController.currentView.value ==
              displayOptions.requirementsPage) {
            subController.title.value = 'fill requirements in';
            view = _requirementsForm();
          }
          if (subController.currentView.value == displayOptions.payoutOptions) {
            subController.title.value = 'options';
            view = _fillPayoutOptions();
          }
          if (subController.currentView.value == displayOptions.loading) {
            subController.title.value = 'loading';
            view = CircularProgressIndicator();
          }
          return view;
        }, subController.currentView));
  }

  _subscritionView() {
    if (controller.allAccounts.isEmpty) ;

    return Container(
        child: SizedBox(
            // width: 400,
            // height: 400,
            // child: Expanded(
            child: Column(
      children: [
        _subscriptionDateStartStop(),
        TextField(
            decoration: InputDecoration(hintText: 'name'),
            onChanged: (value) => subController.product_name.value = value),
        TextField(
            decoration: InputDecoration(hintText: 'category'),
            onChanged: (value) => subController.productcategory.value = value),
        TextField(
            decoration: InputDecoration(hintText: 'description'),
            onChanged: (value) =>
                subController.product_description.value = value),
        TextField(
            decoration: InputDecoration(hintText: 'enter amount'),
            onChanged: (value) =>
                subController.amount.value = double.parse(value)),
        ElevatedButton(
            onPressed: () =>
                subController.currentView.value = displayOptions.payoutOptions,
            child: Text("next")),
      ],
    )));
  }

  _fillPayoutOptions() {
    return Container(
        child: SizedBox(
            child: Column(
      children: [
        _subscriptionSource(),
        _subscriptionBody(),
      ],
    )));
  }

  _subscriptionDateStartStop() {
    //
    return Container(
        // width: 100,
        // height: 100,
        child: Row(
      children: [
        Text('every'),
        Expanded(
          child: TextField(
            decoration: InputDecoration(hintText: "1"),
            onChanged: (value) =>
                subController.subscriptionalFrequency.value = value,
          ),
        ),
        _subscriptionInterval()
      ],
    ));
  }

  _subscriptionInterval() {
    return Obx(() {
      String interval = subController.subscriptionInterval.value;
      return DropdownButtonHideUnderline(
        child: GFDropdown(
          borderRadius: BorderRadius.circular(5),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Colors.grey,
          value: interval,
          items: ['day', 'week', 'month', 'year']
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
          onChanged: (newvalue) {
            subController.subscriptionInterval.value = newvalue.toString();
          },
        ),
      );
    });
  }

  _subscriptionSource() {
    return Obx(() {
      String value = subController.subscriptionSource.value;
      return DropdownButtonHideUnderline(
        child: GFDropdown(
          borderRadius: BorderRadius.circular(5),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Colors.grey,
          value: value,
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
            subController.subscriptionSource.value = newvalue.toString();
          },
        ),
      );
    });
  }

  _subscriptionBody() {
    String currentlySelected = subController.subscriptionSource.value;
    return ObxValue((RxString state) {
      return newSubscription(currentlySelected);
    }, subController.subscriptionSource);
  }

  Widget newSubscription(String type) {
    if (type == 'Wallet Transfer')
      return Container(
          child: Column(children: [
        TextField(
            decoration: InputDecoration(labelText: 'Enter eWallet ID'),
            onChanged: (value) => subController.receiverID.value = value),
        _accountOptions(),
        ElevatedButton(
            onPressed: () async {
              subController.currentView.value = displayOptions.loading;
              var status = await subController.createSubscription();
              if (status == "stew") {
                Get.back();
                Get.snackbar("subscription", "E NO BURSTTTT!!!!");
              }
            },
            child: Text('create subscription'))
      ]));
    else
      return _methodsForm();
  }

  _methodsForm() {
    return Container(
        // color: Colors.orange,
        child: Column(children: [
      ElevatedButton(
          onPressed: _currencyPicker(Get.context),
          child: Text('select receiver currency')),
      _accountType(),
      _countryPicker(),
      _accountOptions(),
      ElevatedButton(
          child: Text('find'),
          onPressed: () async {
            await subController.getPayoutMethods();
            var items = subController.payoutOptions.value;
            Get.bottomSheet(ListView.builder(
              itemBuilder: (buildcontext, index) {
                print(items[index]['name']);
                return ElevatedButton(
                    child: Text(items[index]['name']),
                    onPressed: () async {
                      //check if user has account there, then top it up?
                      print("details  are ${items[index]}");
                      Get.back();
                      subController.payout_method_type.value =
                          items[index]["payout_method_type"];
                      await subController.getPayoutRequirements();
                    });
              },
              itemCount: items.length,
            ));
          })
    ]));
  }

  _requirementsForm() {
    return Container(
        width: 400,
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('sender requirements'),
            Expanded(
              child: _senderRequirements(),
            ),
            Text('benefitiary requirements'),
            Expanded(child: _benefitiaryRequirements()),
            Expanded(
                child: ElevatedButton(
                    child: Text("subscribe"),
                    onPressed: () {
                      subController.createSubscription();
                    })),
          ],
        ));
  }

  _senderRequirements() {
    WalletRepository _walletRepository = Get.find();
    List requirements =
        subController.payoutRequirements.value['sender_required_fields'];
    List updated = [];
    var keys = _walletRepository.trialUser!.toMap().keys;
    for (var requirement in requirements) {
      if (keys.contains(requirement["name"])) {
        subController.senderRequirements.value[requirement['name']] =
            _walletRepository.trialUser!.toMap()[requirement['name']];
      } else {
        updated.add(requirement);
      }
    }
    return ListView.builder(
        itemBuilder: (buildContext, index) {
          var currentOne = updated[index];

          return TextField(
            decoration: InputDecoration(
                hintText: currentOne['description'],
                labelText: currentOne['name']),
            onChanged: (value) => subController
                .senderRequirements.value[currentOne['name']] = value,
          );
        },
        itemCount: updated.length);
  }

  _benefitiaryRequirements() {
    List requirements =
        subController.payoutRequirements.value['beneficiary_required_fields'];
    return ListView.builder(
        itemBuilder: (buildContext, index) {
          var currentOne = requirements[index];
          return TextField(
            decoration: InputDecoration(
                hintText: currentOne['description'],
                labelText: currentOne['name']),
            onChanged: (value) => subController
                .receiverRequirements.value[currentOne['name']] = value,
          );
        },
        itemCount: requirements.length);
  }

  _accountType() {
    List<String> _status = ["individual", "company"];
    return Obx(() {
      var _verticalGroupValue = subController.accountType.value;
      return RadioGroup<String>.builder(
        groupValue: _verticalGroupValue,
        onChanged: (value) => subController.accountType.value = value!,
        items: _status,
        itemBuilder: (item) => RadioButtonBuilder(
          item,
          textPosition: RadioButtonTextPosition.left,
        ),
      );
    });
  }

  _accountOptions() {
    List<String> things = [];
    var accounts = controller.allAccounts;
    for (var item in accounts) {
      things.add(item.balance.toString());
    }
    return Obx(() {
      var selected = subController.selectedAccount.value;
      subController.sender_currency.value = accounts[0].currency;
      return GroupButton(
        isRadio: true,
        spacing: 10,
        selectedButton: selected,
        onSelected: (index, isSelected) {
          print('$index button is selected');
          subController.selectedAccount.value = index;
          subController.sender_currency.value = accounts[index].currency;
        },
        buttons: things,
      );
    });
  }

  _currencyPicker(context) {
    return (() => showCurrencyPicker(
        context: context,
        showFlag: false,
        showCurrencyName: true,
        showCurrencyCode: true,
        onSelect: (Currency currency) =>
            subController.receiver_currency.value = currency.code));
  }

  RxString startForm = 'start'.obs;
  RxString id = ''.obs;

  otherForm(String id) {
    TextEditingController account = TextEditingController();
    TextEditingController amount = TextEditingController();
    return Container(
      child: SizedBox(
        height: 400,
        width: 400,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'account number'),
              controller: account,
            ),
            TextField(
              decoration: InputDecoration(hintText: 'amount'),
              controller: amount,
            ),
            ElevatedButton(
                onPressed: () async {
                  var status = await controller.processProviderPayment(
                      account.text, amount.text, id);
                  if (status == 'success')
                    Get.back();
                  else {
                    //set error message
                    startForm.value = 'error';
                  }
                },
                child: Text('pay'))
          ],
        ),
      ),
    );
  }

  _countryPicker() {
    return Obx(() => CountryListPick(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Text('Pick country'),
          ),
          theme: CountryTheme(
            isShowFlag: false,
            isShowTitle: true,
            isShowCode: false,
            isDownIcon: true,
            showEnglishName: false,
          ),
          initialSelection: subController.country.value,
          onChanged: (code) {
            subController.country.value = code!.code!;
          },
        ));
  }
}

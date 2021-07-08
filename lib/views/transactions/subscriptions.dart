import 'package:flutter/material.dart';

class SubscriptionsView extends StatelessWidget {
  const SubscriptionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: subsbody(),
    );
  }

  Widget subsbody() {
    return Container(
      child: Column(
        children: [
          Container(
            child: Row(children: [
              Text("total subs:"),
              Text("total amount:"),
            ]),
          ),
          //tableview
          Container(
            child: Text("table view of subscriptions"),
          )
        ],
      ),
    );
  }
}

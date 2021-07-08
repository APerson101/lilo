import 'package:flutter/material.dart';

class UpcomingPayments extends StatelessWidget {
  const UpcomingPayments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [Text("Netflix"), Text('22/33/43'), Text("USD 70")],
      ),
    );
  }
}

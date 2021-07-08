import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("it is loading....")));
  }
}

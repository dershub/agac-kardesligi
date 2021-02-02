import 'package:flutter/material.dart';

class SafeArka extends StatelessWidget {
  final Widget child;

  const SafeArka({Key key, @required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF083A1D),
      child: SafeArea(child: child),
    );
  }
}

/* 
Widget SafeArka({@required Widget child}) {
  return Container(
    color: Color(0xFF083A1D),
    child: SafeArea(child: child),
  );
}
*/

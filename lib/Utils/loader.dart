import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Loader {
  static sw(BuildContext context) {
    return context.loaderOverlay.show(widget: MyLoader());
  }

  static hd(BuildContext context) {
    return context.loaderOverlay.hide();
  }
}

class MyLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      SpinKitFadingCircle(color: Colors.black);
}

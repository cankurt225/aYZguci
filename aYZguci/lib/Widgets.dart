import 'package:flutter/material.dart';

Container def_container(text, bool is_long, String is_def) {
  List<Widget> widgets = [];
  if (is_def == "önbilgi") {
    widgets = [
      Expanded(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40), color: Colors.red),
          child: Center(child: Text("ÖN BİLGİ")),
        ),
      )),
      Expanded(child: Center(child: Text(text)))
    ];
  } else if (is_def == "özet") {
    widgets = [
      Expanded(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40), color: Colors.green),
          child: Center(child: Text("TANIM")),
        ),
      )),
      Expanded(child: Text(text))
    ];
  } else {
    widgets = [Center(child: Text(text))];
  }
  return Container(
    child: Center(
      child: is_long == true
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text),
            )
          : Column(
              children: widgets,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
    ),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(35)),
  );
}
// Text lang_text(String text){
//   return Text(text)
// }

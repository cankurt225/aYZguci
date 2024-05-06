import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/notification.dart';

import 'api.dart';

class Data_api with ChangeNotifier {
  late API api = API();
  late String? short_def1 = " ";
  late String? short_def2 = " ";
  late String? long_def = " ";
  late String? len_description = "0";
  late String? search = " ";
  late bool? searched = false;
  late bool can_search = true;
  late List? description_list = ["0"];
  late int? index_description = 0;
  late bool? isfirst = true;
  late bool? write_search = false;
  late String? search_lang = "en";
  late bool result_come = true;
  String sirayaalindiniz =
      "Sıraya alındınız. En kısa sürede cevabnınız getirilecek.";

  Notification_Api notifications = Notification_Api();

  bool isanswer_sirayalindiniz(String answer) {
    // amswer = 1 short def 1
    // amswer = 2 short def 2
    // amswer = 3 long def 3
    if (answer == "1") {
      answer = short_def1!;
    } else if (answer == "2") {
      answer = short_def2!;
    } else {
      answer = long_def!;
    }
    if (answer == sirayaalindiniz) {
      return true;
    } else {
      return false;
    }
  }

  bool isanswer_empty(String answer) {
    // amswer = 1 short def 1
    // amswer = 2 short def 2
    // amswer = 3 long def 3
    if (answer == "1") {
      answer = short_def1!;
    } else if (answer == "2") {
      answer = short_def2!;
    } else {
      answer = long_def!;
    }
    if (answer == " ") {
      return true;
    } else {
      return false;
    }
  }

  void change_cansearch(bool val) {
    can_search = val;
    notifyListeners();
  }

  void change_lang(String lang) {
    search_lang = lang;
    notifyListeners();
  }

  void change_isfirst(bool val) {
    isfirst = val;
    notifyListeners();
  }

  void reset_definitions() {
    short_def1 = " ";
    short_def2 = " ";
    long_def = " ";
    notifyListeners();
  }

  Future<void> checkdefinitions() async {
    write_search = true;
    change_cansearch(false);
    if (short_def1 == " " && short_def2 == " " && long_def == " ") {
      change_searched(true);
      await get_shortdef1();

      await get_shortdef2();

      await get_longdef();
    } else if (short_def1 != " " && short_def2 != " " && long_def != " ") {
      reset();
      change_searched(true);
      print("try içine girildi");
      await get_shortdef1();
      print("try içine girildi");

      await get_shortdef2();
      print("try içine girildi");
      await get_longdef();
    } else if (searched == true &&
        (short_def1 == " " || short_def2 == " " || long_def == " ")) {}
    // reset_definitions();
    // reset_search();
    // change_searched(false);
    change_cansearch(true);
    notifyListeners();
  }

  void reset() {
    reset_definitions();
    change_searched(false);
  }

  void reset_search() {
    search = " ";
    notifyListeners();
  }

  void change_search(String search) {
    this.search = search;

    notifyListeners();
  }

  void change_searched(bool searched) {
    this.searched = searched;
    notifyListeners();
  }

  // Future<List> get_api(type, model) async {
  //   var def_list = await api.call_api(search, type, model);
  //   String def = def_list[0];
  //   var len;
  //   List defs;
  //   try {
  //     len = def[1];
  //     defs = [def, len];
  //   } catch (e) {
  //     defs = [def];
  //   }
  //   return defs;
  // }

  Future<void> get_shortdef1() async {
    try {
      List defs = await api.call_api(search!, "1", "q_a", search_lang!);
      print("DEFS $defs");

      short_def1 = defs[0];
    } catch (e) {
      get_shortdef1_again();
    }
    notifyListeners();
  }

  Future<void> get_shortdef1_again() async {
    short_def1 = sirayaalindiniz;
    notifyListeners();
    while (true) {
      try {
        print("get long def try içine girildi");
        List? defs = await api.call_api(search!, "1", "q_a", search_lang!);
        short_def1 = defs[0];
      } catch (a) {
        print("eroor");
      }

      print("Again API: $short_def1 ");
      if (short_def1 != sirayaalindiniz ||
          short_def1 != null ||
          short_def1 != " ") {
        notifications.sendNotifications("aYZguci", "Ön bilgi yazıldı!");

        break;
      }
    }

    notifyListeners();
  }

  Future<void> get_shortdef2() async {
    try {
      List defs = await api.call_api(search!, "2", "q_a", search_lang!);
      short_def2 = defs[0];
    } catch (e) {
      get_shortdef2_again();
    }

    notifyListeners();
  }

  Future<void> get_shortdef2_again() async {
    short_def2 = sirayaalindiniz;
    notifyListeners();

    while (true) {
      try {
        print("get long def try içine girildi");
        List? defs = await api.call_api(search!, "2", "q_a", search_lang!);
        short_def2 = defs[0];
      } catch (a) {
        print("eroor");
      }

      print("Again API: $short_def2 ");
      if (short_def2 != sirayaalindiniz &&
          short_def2 != null &&
          short_def2 != "") {
        break;
      }
    }

    notifyListeners();
  }

  Future<void> get_longdef() async {
    try {
      List defs = await api.call_api(search!, "0", "s_m", search_lang!);
      long_def = defs[0];
    } catch (e) {
      get_longdef_again();
    }

    notifyListeners();
  }

  Future<void> get_longdef_again() async {
    long_def = sirayaalindiniz;
    notifyListeners();
    print("döngüye girilecek");
    while (true) {
      try {
        print("get long def try içine girildi");
        List? defs = await api.call_api(search!, "0", "s_m", search_lang!);
        long_def = defs[0];
      } catch (a) {
        print("eroor");
      }

      print("Again API: $long_def");
      if (long_def != sirayaalindiniz && long_def != null || long_def != " ") {
        notifications.sendNotifications("aYZguci", "Tanım yazıldı!");

        break;
      }
    }

    print("LONG DEF $long_def");
    notifyListeners();
  }

  bool check_answers_come() {
    if ((short_def1 != sirayaalindiniz || short_def1 != " ") &&
        (short_def2 != sirayaalindiniz || short_def2 != " ") &&
        (long_def != sirayaalindiniz && long_def != " ")) {
      return true;
    } else {
      return false;
    }
  }

//   void get_desription(int type) async {
//     index_description = type;
//     List defs_ = await api.call_api(search, type.toString(), "s_m",);
//     print(defs_);
//     description_list.add(defs_[0]);
//     notifyListeners();
//   }
}

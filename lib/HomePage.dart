import 'package:background_fetch/background_fetch.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:myapp/notification.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'Data.dart';
import 'Widgets.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentTabIndex = 0;
  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:
        _navigatorKey.currentState?.pushReplacementNamed("Ogretici");
        break;
      case 1:
        _navigatorKey.currentState?.pushReplacementNamed("Ana Sayfa");
        break;
      case 2:
        _navigatorKey.currentState?.pushReplacementNamed("Hakkimizda");
        break;
    }
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }

  List<BottomNavigationBarItem> Navigator_items = [
    BottomNavigationBarItem(icon: Icon(Icons.post_add), label: "Öğretici"),
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
    BottomNavigationBarItem(icon: Icon(Icons.info), label: "Hakkımızda")
  ];

  Widget _bottomNavigationBar(can_search, longdef, shortdef, shortdef1) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: Navigator_items,
      onTap: (int tabIndex) {
        if (can_search == true &&
            (longdef !=
                    "Sıraya alındınız. Cevabınız en kısa sürede getirilecek." &&
                shortdef !=
                    "Sıraya alındınız. Cevabınız en kısa sürede getirilecek." &&
                shortdef1 !=
                    "Sıraya alındınız. Cevabınız en kısa sürede getirilecek.")) {
          _onTap(tabIndex);
        } else {}
      },
      currentIndex: _currentTabIndex,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data_api>(
        create: (context) => Data_api(),
        builder: (context, child) {
          // No longer throws
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.red,
              drawerScrimColor: Colors.red,
              body:
                  Navigator(key: _navigatorKey, onGenerateRoute: generateRoute),
              bottomNavigationBar: _bottomNavigationBar(
                  Provider.of<Data_api>(context).can_search,
                  Provider.of<Data_api>(context).long_def,
                  Provider.of<Data_api>(context).short_def1,
                  Provider.of<Data_api>(context).short_def2),
              resizeToAvoidBottomInset: false,
            ),
          );
        });
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  final CountDownController _controller = CountDownController();

  late final RewardedAd rewardedAd;

  final String rewardedAdUnitId = "ca-app-pub-3357711144228932/8226842360";

  Notification_Api notifications = Notification_Api();
  void backgroundFetchHeadlessTask(HeadlessTask task) async {
    var taskId = task.taskId;
    if (taskId == "your_task_id") {
      print("your_task_id");
      print("${BackgroundFetch} Headless event received.");
//TODO: perform tasks like — call api, DB and local notification etc…
    }
  }

  Future<void> initPlatformState() async {
// Configure BackgroundFetch.
    var status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          forceAlarmManager: false,
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
        ),
        _onBackgroundFetch,
        _onBackgroundFetchTimeout);
    print("${BackgroundFetch} configure success: $status");
// Schedule backgroundfetch for the 1st time it will execute with 1000ms delay.
// where device must be powered (and delay will be throttled by the OS).
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "com.ayzguci.task",
        delay: 10000000000,
        periodic: false,
        stopOnTerminate: false,
        enableHeadless: true));
  }

  void _onBackgroundFetchTimeout(String taskId) {
    print("[BackgroundFetch] TIMEOUT: $taskId");
    BackgroundFetch.finish(taskId);
  }

  void _onBackgroundFetch(String taskId) async {
    if (taskId == "your_task_id") {
      print("[BackgroundFetch] Event received");
//TODO: perform your task like : call the API’s, call the DB and local notification.
    }
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this as WidgetsBindingObserver);
    //load ad here...
    _loadRewardedAd();
    initPlatformState();
    notifications.InitilazeNotifications();
  }

  //method to load an ad
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        //when failed to load
        onAdFailedToLoad: (LoadAdError error) {
          print("Failed to load rewarded ad, Error: $error");
        },
        //when loaded
        onAdLoaded: (RewardedAd ad) {
          print("$ad loaded");
          // Keep a reference to the ad so you can show it later.
          rewardedAd = ad;

          //set on full screen content call back
          _setFullScreenContentCallback();
        },
      ),
    );
  }

  //method to load an ad
  void _setFullScreenContentCallback() {
    if (rewardedAd == null) return;
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      //when ad  shows fullscreen
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print("$ad onAdShowedFullScreenContent"),
      //when ad dismissed by user
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print("$ad onAdDismissedFullScreenContent");

        //dispose the dismissed ad
        ad.dispose();
      },
      //when ad fails to show
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print("$ad  onAdFailedToShowFullScreenContent: $error ");
        //dispose the failed ad
        ad.dispose();
      },

      //when impression is detected
      onAdImpression: (RewardedAd ad) => print("$ad Impression occured"),
    );
  }

  //show ad method
  void _showaRewardedAd() {
    //this method take a on user earned reward call back
    rewardedAd.show(
        //user earned a reward
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      //reward user for watching your ad
      num amount = rewardItem.amount;
      print("You earned: $amount");
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sıraya Alındınız..'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      'Sunucumuz sizi ve diğer kullanıcılar için çalışıyor. Uygulama arka planda çalışmakta ve sonuç gelince bildirim gelmektedir.'),
                  Text(
                      'Ancak bazı özel android sistemlerde bildirimler engellenebilir. uzun süre bildirim gelmez ise uyuglamayı kontrol ediniz.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Approve'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Provider.of<Data_api>(context).can_search == false
                  ? def_container(
                      Provider.of<Data_api>(context).search, false, "N")
                  : Provider.of<Data_api>(context).result_come == true
                      ? ListTile(
                          title: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    onChanged: (text) {
                                      Provider.of<Data_api>(context,
                                              listen: false)
                                          .change_search(text.toLowerCase());
                                      // Provider.of<Data_api>(context, listen: false)
                                      //     .reset_search();
                                    },
                                    decoration: InputDecoration(
                                        hoverColor: Colors.red,
                                        focusColor: Colors.red,
                                        fillColor: Colors.red,
                                        prefixIconColor: Colors.red,
                                        suffixIconColor: Colors.red,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        labelText: 'Nedir',
                                        hintText: "Örnek: yapay zeka"),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: def_container(
                                      "+ Nedir", false, "önvilgi"),
                                )
                              ],
                            ),
                          ),
                          trailing: IconButton(
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              onPressed: () async {
                                //_showaRewardedAd();

                                // if (Provider.of<Data_api>(context).isfirst == true) {
                                //   Provider.of<Data_api>(context, listen: false)
                                //       .change_isfirst(false);
                                // } else {
                                //   Provider.of<Data_api>(context, listen: false).reset();
                                // }
                                //Provider.of<Data_api>(context, listen: false).reset();

                                await Provider.of<Data_api>(context,
                                        listen: false)
                                    .checkdefinitions();

                                _controller.start();
                                // if (Provider.of<Data_api>(context).short_def1 == " " &&
                                //     Provider.of<Data_api>(context).short_def2 == " " &&
                                //     Provider.of<Data_api>(context).long_def == " ") {
                                //   Provider.of<Data_api>(context).change_searched(true);
                                //   print("try içine girildi");
                                //   Provider.of<Data_api>(context).get_shortdef1();
                                //   print("try içine girildi");
                                //
                                //   Provider.of<Data_api>(context).get_shortdef2();
                                //   print("try içine girildi");
                                //
                                //   Provider.of<Data_api>(context).get_longdef();
                                // } else {
                                //   print("else çalıştı");
                                // }
                                // Provider.of<Data_api>(context).reset_definitions();
                                // Provider.of<Data_api>(context).reset_search();
                                // Provider.of<Data_api>(context).change_searched(false);
                              },
                              icon: Icon(Icons.search)),
                        )
                      : def_container(
                          Provider.of<Data_api>(context).search, false, "N"),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40), color: Colors.white),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: PopupMenuButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  def_container(
                                      "Araştırma Dili : ", false, "n"),
                                ],
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: TextButton(
                                  child: Text("En"),
                                  onPressed: () {
                                    Provider.of<Data_api>(context,
                                            listen: false)
                                        .change_lang("en");
                                  },
                                )),
                                PopupMenuItem(
                                    child: TextButton(
                                  child: Text("TR"),
                                  onPressed: () {
                                    Provider.of<Data_api>(context,
                                            listen: false)
                                        .change_lang("tr");
                                  },
                                )),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: def_container(
                                  Provider.of<Data_api>(context).search_lang,
                                  false,
                                  "N"),
                            ),
                          )
                        ],
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Provider.of<Data_api>(context).write_search == false
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: def_container(
                                Provider.of<Data_api>(context).search,
                                false,
                                "N"),
                          ),
                    flex: 1,
                  ),
                  Expanded(
                      flex: 3,
                      child: Provider.of<Data_api>(context).searched == true
                          ? Provider.of<Data_api>(context).short_def1 == " "
                              ? CircularCountDownTimer(
                                  duration: 10,
                                  initialDuration: 0,
                                  controller: CountDownController(),
                                  width: MediaQuery.of(context).size.width / 2,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  ringColor: Colors.grey[300]!,
                                  ringGradient: null,
                                  fillColor: Colors.red,
                                  fillGradient: null,
                                  backgroundColor: Colors.red,
                                  backgroundGradient: null,
                                  strokeWidth: 20.0,
                                  strokeCap: StrokeCap.round,
                                  textStyle: TextStyle(
                                      fontSize: 33.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textFormat: CountdownTextFormat.S,
                                  isReverse: true,
                                  isReverseAnimation: true,
                                  isTimerTextShown: true,
                                  autoStart: true,
                                  onStart: () {
                                    debugPrint('Countdown Started');
                                  },
                                  onComplete: () {
                                    debugPrint('Countdown Ended');

                                    _showMyDialog();
                                    Provider.of<Data_api>(context,
                                            listen: false)
                                        .get_shortdef1_again();
                                  },
                                  onChange: (String timeStamp) {},
                                )
                              : def_container(
                                  Provider.of<Data_api>(context).short_def1,
                                  false,
                                  "önbilgi")
                          : Container()),
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  Expanded(
                      flex: 3,
                      child: Provider.of<Data_api>(context).searched == true
                          ? Provider.of<Data_api>(context).short_def2 == " "
                              ? CircularCountDownTimer(
                                  duration: 20,
                                  initialDuration: 0,
                                  controller: CountDownController(),
                                  width: MediaQuery.of(context).size.width / 2,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  ringColor: Colors.grey[300]!,
                                  ringGradient: null,
                                  fillColor: Colors.red,
                                  fillGradient: null,
                                  backgroundColor: Colors.red,
                                  backgroundGradient: null,
                                  strokeWidth: 20.0,
                                  strokeCap: StrokeCap.round,
                                  textStyle: TextStyle(
                                      fontSize: 33.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textFormat: CountdownTextFormat.S,
                                  isReverse: true,
                                  isReverseAnimation: true,
                                  isTimerTextShown: true,
                                  autoStart: true,
                                  onStart: () {
                                    debugPrint('Countdown Started');
                                  },
                                  onComplete: () {
                                    debugPrint('Countdown Ended');
                                    Provider.of<Data_api>(context,
                                            listen: false)
                                        .get_shortdef2_again();
                                  },
                                  onChange: (String timeStamp) {},
                                )
                              : def_container(
                                  Provider.of<Data_api>(context).short_def2,
                                  false,
                                  "önbilgi")
                          : Container()),
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  Expanded(
                      flex: 3,
                      child: Provider.of<Data_api>(context).searched == true
                          ? Provider.of<Data_api>(context).long_def == " "
                              ? CircularCountDownTimer(
                                  duration: 180,
                                  initialDuration: 0,
                                  controller: CountDownController(),
                                  width: MediaQuery.of(context).size.width / 2,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  ringColor: Colors.grey[300]!,
                                  ringGradient: null,
                                  fillColor: Colors.red,
                                  fillGradient: null,
                                  backgroundColor: Colors.red,
                                  backgroundGradient: null,
                                  strokeWidth: 20.0,
                                  strokeCap: StrokeCap.round,
                                  textStyle: TextStyle(
                                      fontSize: 33.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textFormat: CountdownTextFormat.S,
                                  isReverse: true,
                                  isReverseAnimation: true,
                                  isTimerTextShown: true,
                                  autoStart: true,
                                  onStart: () {
                                    debugPrint('Countdown Started');
                                  },
                                  onComplete: () {
                                    debugPrint('Countdown Ended');
                                    Provider.of<Data_api>(context,
                                            listen: false)
                                        .get_longdef_again();
                                  },
                                  onChange: (String timeStamp) {},
                                )
                              : def_container(
                                  Provider.of<Data_api>(context).long_def,
                                  true,
                                  "özet")
                          : Container()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Tutorial extends StatelessWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
          child: ListView.separated(
        itemCount: 9,
        itemBuilder: (context, index) => Image.asset("images/${index + 1}.png"),
        separatorBuilder: (context, index) {
          if (index == 0) {
            // add widget after three item
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                  Text(
                    "KAYDIR",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height / 25),
                  ),
                  Icon(Icons.download, color: Colors.white)
                ],
              ),
            );
          }
          return Container();
        },
      )),
    );
  }
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "Ana Sayfa":
      return MaterialPageRoute(
        builder: (context) => SearchPage(),
      );
    case "Ogretici":
      return MaterialPageRoute(builder: (context) => Tutorial());
    case "Hakkimizda":
      return MaterialPageRoute(
          builder: (context) => Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text(
                      "Bu uygulama Can Ahmet Kurt tarafından geliştirilmiştir ve ona aittir. ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width / 15),
                    ),
                  ],
                ),
              ));
    default:
      return MaterialPageRoute(builder: (context) => Tutorial());
  }
}

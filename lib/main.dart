import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.requestPermission();
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final RewardedAd rewardedAd;
  final String rewardedAdUnitId = "ca-app-pub-3940256099942544/1033173712";
  @override
  void initState() {
    super.initState();

    //load ad here...
    initPlatformState();
    _loadRewardedAd();
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

  //method to set show content call back
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
        //dispose flutter build apk --releasethe failed ad
        ad.dispose();
      },

      //when impression is detected
      onAdImpression: (RewardedAd ad) => print("$ad Impression occured"),
    );
  }

  //show ad method
  void _showRewardedAd() {
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
    return MaterialApp(
        title: "aYZguci",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.red,
          scaffoldBackgroundColor: Colors.red,
          accentColor: Colors.white,
          buttonColor: Colors.white,
        ),
        home: HomePage());
  }
}

import 'package:firebase_admob/firebase_admob.dart';

class AdmobOperations {
  static final String appIdLive = "ca-app-pub-6179411340794613~8787199049";
  static final String appIdTest = FirebaseAdMob.testAppId;
  static final String banner1Live = "ca-app-pub-6179411340794613/8727489294";
  static final String odulluReklamTest = RewardedVideoAd.testAdUnitId;
  static int howManyTimesToShow = 0;
  static admodInitialize() {
    FirebaseAdMob.instance.initialize(appId: appIdTest);
  }

  static final MobileAdTargetingInfo mobileAdTargetingInfo =
      MobileAdTargetingInfo(
    keywords: <String>['flutter', 'chat app'],
    contentUrl: 'https://ihalilsungur.com',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

  static BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: mobileAdTargetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          print("Banner Yüklendi.");
        }
      },
    );
  }

  static InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: mobileAdTargetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // Switches between Test IDs and Production IDs automatically
  static String get bannerAdUnitId {
    if (kReleaseMode) {
      return Platform.isAndroid 
          ? dotenv.get('ANDROID_BANNER_ID', fallback: '') 
          : dotenv.get('IOS_BANNER_ID', fallback: '');
    }
    // Google Test Banner IDs
    return Platform.isAndroid 
        ? "ca-app-pub-3940256099942544/6300978111" 
        : "ca-app-pub-3940256099942544/2934735716";
  }

  static String get interstitialAdUnitId {
    if (kReleaseMode) {
      return Platform.isAndroid 
          ? dotenv.get('ANDROID_INTERSTITIAL_ID', fallback: '') 
          : dotenv.get('IOS_INTERSTITIAL_ID', fallback: '');
    }
    // Google Test Interstitial IDs
    return Platform.isAndroid 
        ? "ca-app-pub-3940256099942544/1033173712" 
        : "ca-app-pub-3940256099942544/4411468910";
  }

  // Logic to load and show Interstitial Ad
  static void showInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (err) {
          debugPrint('InterstitialAd failed to load: $err');
        },
      ),
    );
  }
}

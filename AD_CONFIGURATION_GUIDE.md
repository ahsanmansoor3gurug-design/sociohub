# 📱 SocioHub Ad Configuration & Production Guide

This guide outlines how to move your integrated ads from **Test Mode** to **Production Mode** for the App Store and Play Store.

---

## 1. Environment Configuration (`.env`)
To keep your production Ad IDs secure, add them to your `.env` file. Replace the placeholders with your actual IDs from the AdMob Dashboard.

```env
# --- ADMOB CONFIGURATION ---

# Android Production IDs
ANDROID_BANNER_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
ANDROID_INTERSTITIAL_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX

# iOS Production IDs
IOS_BANNER_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
IOS_INTERSTITIAL_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
```

---

## 2. Update AdService Logic
Update `lib/ads/ad_service.dart` to automatically switch between Test IDs (Development) and Real IDs (Production) using `kReleaseMode`.

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdService {
  static String get bannerAdUnitId {
    if (kReleaseMode) {
      return Platform.isAndroid 
          ? dotenv.get('ANDROID_BANNER_ID') 
          : dotenv.get('IOS_BANNER_ID');
    }
    // Test Banner ID
    return Platform.isAndroid 
        ? "ca-app-pub-3940256099942544/6300978111" 
        : "ca-app-pub-3940256099942544/2934735716";
  }

  static String get interstitialAdUnitId {
    if (kReleaseMode) {
      return Platform.isAndroid 
          ? dotenv.get('ANDROID_INTERSTITIAL_ID') 
          : dotenv.get('IOS_INTERSTITIAL_ID');
    }
    // Test Interstitial ID
    return Platform.isAndroid 
        ? "ca-app-pub-3940256099942544/1033173712" 
        : "ca-app-pub-3940256099942544/4411468910";
  }
}
```

---

## 3. Native Manifest Configuration (Android)
**IMPORTANT:** Your app will crash if the `APPLICATION_ID` in `AndroidManifest.xml` does not match your AdMob App ID.

**File:** `android/app/src/main/AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/> 
    <!-- Replace with your REAL APP ID (the one with the ~ tilde) -->
```

---

## 4. Final Checklist for Publishing
| Task | Description |
|:---|:---|
| **App-ads.txt** | Once your app is live, you MUST host this file on your developer website to verify ownership. |
| **Verify Payment** | AdMob will not serve live ads until your payment address and tax info are verified. |
| **Linked Accounts** | Link your AdMob account to your Firebase/Play Store account for better analytics. |
| **Test Devices** | Add your physical phone as a "Test Device" in AdMob to avoid being banned for "Invalid Click Activity." |

---

## 5. Developer Tips
*   **Never Click Your Own Ads**: Google uses advanced tracking. Clicking your own live ads will result in a permanent account ban.
*   **Load Time**: Ads may take 24-48 hours to start appearing after you first link your app to the store.
*   **Ad Inspector**: Use the "Ad Inspector" tool (included in the SDK) to debug why ads might not be showing.

---
**SocioHub Ad Management System v1.0**

# 🚀 AdMob Production: Final Steps for SocioHub

Congratulations on adding your app to AdMob! Based on your current progress, follow these steps to finalize your production setup.

---

## 1. Create Ad Units in AdMob Dashboard
You have successfully created your Ad Units. Here are your IDs for reference:

### **A. Banner Ad Unit**
*   **Ad unit name**: `SocioHub_Home_Banner`
*   **Ad Unit ID**: `ca-app-pub-2480480406785116/3515882485`

### **B. Interstitial Ad Unit**
*   **Ad unit name**: `SocioHub_Main_Transition`
*   **Ad Unit ID**: `ca-app-pub-2480480406785116/2450212826`

---

## 2. Secure Your Production IDs (`.env`)
Update your `.env` file in the project root with the real IDs from your screenshot.

```env
# --- ADMOB PRODUCTION IDs ---

# Android
ANDROID_BANNER_ID=ca-app-pub-2480480406785116/3515882485
ANDROID_INTERSTITIAL_ID=ca-app-pub-2480480406785116/2450212826

# iOS (If applicable)
IOS_BANNER_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
IOS_INTERSTITIAL_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
```

---

## 3. Mandatory Android Manifest Update
**✅ COMPLETED:** The App ID has been updated in your `AndroidManifest.xml`.

**File:** `android/app/src/main/AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-2480480406785116~4165420061"/>
```

---

## 4. Testing & Deployment Strategy
| Environment | Ad Behavior | How it works |
| :--- | :--- | :--- |
| **Debug Mode** | **Test Ads** | Automatically uses Google's safe Test IDs. |
| **Release Mode** | **Real Ads** | Automatically pulls your real IDs from the `.env` file. |

> **⚠️ WARNING:** NEVER click on your own live ads. Even one click can lead to a permanent AdMob account suspension.

---

## 5. Post-Publishing Task (Required for Ads to Show)
Once your app is live on the Google Play Store:
1.  Return to **AdMob**.
2.  Go to **App Settings** > **App stores**.
3.  Click **Add** and search for your app link.
4.  Link your app to the store. 

*Note: It may take 24-48 hours for ads to start appearing after linking.*

---
**SocioHub Ad Integration Complete!**

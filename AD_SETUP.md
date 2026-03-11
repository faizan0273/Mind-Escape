# What You Need to Show Ads (Cipher Escape)

The game uses **rewarded ads** for Hint 3. Right now `AdService` is a **stub** (no real ads). To show real ads (e.g. Google AdMob), do the following.

---

## 1. Add the dependency

In `pubspec.yaml`:

```yaml
dependencies:
  google_mobile_ads: ^5.0.0   # or latest from pub.dev
```

Run:

```bash
flutter pub get
```

---

## 2. Create ad units in AdMob

1. Go to [AdMob](https://admob.google.com/) and create an app (Android and/or iOS).
2. Create a **Rewarded** ad unit for each platform.
3. Copy the **Ad unit IDs** (e.g. `ca-app-pub-xxxxx/yyyyy`).

---

## 3. Initialize the SDK

In `main.dart`, before `runApp`:

```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  // ... rest of your main (storage, Get.put, etc.)
  runApp(const CipherEscapeApp());
}
```

---

## 4. Wire AdService to real rewarded ads

In `lib/core/services/ad_service.dart`:

- Replace the stub with `RewardedAd.load()` using your **rewarded ad unit ID**.
- In `showRewardedAd()`, show the loaded ad and in the **onUserEarnedReward** callback set `isAdLoaded` and return `true` so Hint 3 is unlocked.
- After showing, load the next rewarded ad for the next time.

Example (conceptual):

```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService extends GetxService {
  static const String _rewardedAdUnitId = 'ca-app-pub-3940498728...'; // use your ID
  RewardedAd? _rewardedAd;

  Future<void> _loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          isAdLoaded.value = true;
        },
        onAdFailedToLoad: (err) {
          isAdLoaded.value = false;
        },
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    _loadRewardedAd();
  }

  Future<bool> showRewardedAd() async {
    if (_rewardedAd == null) return false;
    final completer = Completer<bool>();
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd();
      },
    );
    await _rewardedAd!.show(
      onUserEarnedReward: (_, reward) => completer.complete(true),
    );
    return completer.future;
  }
}
```

Use your real rewarded ad unit ID and handle errors (e.g. complete with `false` if the ad fails to show).

---

## 5. Platform configuration

**Android** (`android/app/src/main/AndroidManifest.xml`):

- Add your AdMob **App ID** in `<meta-data>` (see [AdMob Android setup](https://developers.google.com/admob/android/quick-start)).

**iOS** (`ios/Runner/Info.plist`):

- Add `GADApplicationIdentifier` and, if needed, `SKAdNetworkItems` (see [AdMob iOS setup](https://developers.google.com/admob/ios/quick-start)).
- For iOS 14+, consider [App Tracking Transparency](https://developer.apple.com/documentation/apptrackingtransparency) if you use personalized ads.

---

## 6. Test IDs (optional)

For development, use Google’s test rewarded ad unit IDs so you don’t trigger policy issues:

- Android: `ca-app-pub-3940256099942544/5224354917`
- iOS: `ca-app-pub-3940256099942544/1712485313`

Switch to your real ad unit IDs for release builds.

---

## Summary checklist

| Step | What to do |
|------|------------|
| 1 | Add `google_mobile_ads` in `pubspec.yaml` |
| 2 | Create app and **Rewarded** ad unit in AdMob; copy ad unit IDs |
| 3 | Call `MobileAds.instance.initialize()` in `main.dart` |
| 4 | Implement `AdService` with `RewardedAd.load` / `show` and reward callback |
| 5 | Add AdMob App ID (and iOS SKAdNetwork if needed) in AndroidManifest and Info.plist |
| 6 | Use test ad unit IDs in debug, real IDs in release |

After this, when the player taps “Watch Ad” for Hint 3, a real rewarded ad will show and, on reward, Hint 3 will unlock.

class AdMobService {
  // AdMob temporarily disabled due to build issues
  // TODO: Re-enable AdMob with proper configuration

  static dynamic createBannerAd() {
    // Return null when AdMob is not available
    return null;
  }

  static Future<void> showInterstitialAd() async {
    // No-op when AdMob is not available
    print('AdMob not available - interstitial ad skipped');
  }
}
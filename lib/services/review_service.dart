import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static const String _playlistCountKey = 'playlist_count';
  static const String _reviewRequestedKey = 'review_requested';

  final InAppReview _inAppReview = InAppReview.instance;

  /// Call this method whenever a playlist is added
  Future<void> onPlaylistAdded() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if review was already requested
    final reviewRequested = prefs.getBool(_reviewRequestedKey) ?? false;
    if (reviewRequested) {
      return;
    }

    // Get current playlist count
    final currentCount = prefs.getInt(_playlistCountKey) ?? 0;
    final newCount = currentCount + 1;

    // Save new count
    await prefs.setInt(_playlistCountKey, newCount);

    // Show review dialog after second playlist with 5 second delay
    if (newCount == 2) {
      await Future.delayed(const Duration(seconds: 5));
      await _requestReview();
      await prefs.setBool(_reviewRequestedKey, true);
    }
  }

  Future<void> _requestReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    }
  }

  /// Force show review dialog (for testing)
  Future<void> showReviewDialog() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    }
  }

  /// Reset review tracking (for testing)
  Future<void> resetTracking() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_playlistCountKey);
    await prefs.remove(_reviewRequestedKey);
  }
}

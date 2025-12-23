# App Store Review Notes - IPTV Player

## Demo Mode for Reviewers

This app includes a special **demo mode** for Apple App Store reviewers to test all features without requiring a real IPTV subscription.

### How to Access Demo Mode

1. **Launch the app** on your device or simulator
2. **Tap "Add Playlist"** or similar option to add IPTV source
3. **Select "Xtream Codes API"** option
4. **Enter demo credentials:**
   - **Server URL:** `http://demo.example.com` (any URL, will be ignored)
   - **Username:** `demo`
   - **Password:** `demo`
   - **Playlist Name:** Any name you prefer
5. **Tap "Submit" or "Connect"**

The app will automatically load a pre-configured test playlist with sample channels instead of connecting to a real server.

### What You Can Test in Demo Mode

✅ **Live TV Channels** - 8 demo channels across different categories
✅ **Channel Categories** - Entertainment, News, Sports, Movies
✅ **Video Playback** - All channels use working HLS test streams
✅ **Channel Navigation** - Browse channels, switch between them
✅ **Favorites** - Add/remove channels to favorites
✅ **Watch History** - Track recently watched content
✅ **Premium Features** - Test in-app purchase flow (sandbox mode)
✅ **Settings** - App settings and customization

### Test Credentials Summary

```
Type: Xtream Codes API
URL: http://demo.example.com
Username: demo
Password: demo
```

### Technical Details

- Demo mode uses **embedded M3U playlist** with public HLS test streams
- Test streams are hosted by:
  - Apple Developer (official Apple HLS examples)
  - Mux.com (streaming technology provider)
- No external IPTV service required
- All video streams are **legal, public test content**

### Notes for Reviewers

- The app is designed for users with **existing IPTV subscriptions**
- Normal users will enter their own service credentials
- Demo mode is **only** for testing purposes and review
- Production use requires valid Xtream Codes or M3U URL from IPTV provider

### Support

If you encounter any issues during review, please contact:
- **Email:** [your-support-email@example.com]
- **Demo expires:** Never (embedded in app)

---

**Last Updated:** December 2025
**App Version:** 1.0.0
**Build:** 1

import 'package:another_iptv_player/models/playlist_model.dart';
import 'package:another_iptv_player/repositories/user_preferences.dart';
import 'package:another_iptv_player/screens/m3u/m3u_home_screen.dart';
import 'package:another_iptv_player/screens/playlist_screen.dart';
import 'package:another_iptv_player/screens/xtream-codes/xtream_code_home_screen.dart';
import 'package:another_iptv_player/services/app_state.dart';
import 'package:another_iptv_player/services/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Playlist? _loadedPlaylist;
  bool _dataLoaded = false;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadAppData();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _loadAppData() async {
    _loadedPlaylist = await _getLastPlaylist();
    setState(() {
      _dataLoaded = true;
    });
    _checkAndNavigate();
  }

  Future<Playlist?> _getLastPlaylist() async {
    final lastPlaylistId = await UserPreferences.getLastPlaylist();

    if (lastPlaylistId != null) {
      final playlist = await PlaylistService.getPlaylistById(lastPlaylistId);
      if (playlist != null) {
        AppState.currentPlaylist = playlist;
        return playlist;
      }
    }
    return null;
  }

  void _onAnimationComplete() {
    setState(() {
      _animationCompleted = true;
    });
    _checkAndNavigate();
  }

  void _checkAndNavigate() {
    if (_dataLoaded && _animationCompleted && mounted) {
      _navigateToNextScreen(_loadedPlaylist);
    }
  }

  void _navigateToNextScreen(Playlist? playlist) {
    Widget nextScreen;

    if (playlist == null) {
      nextScreen = const PlaylistScreen();
    } else {
      switch (playlist.type) {
        case PlaylistType.xtream:
          nextScreen = XtreamCodeHomeScreen(playlist: playlist);
          break;
        case PlaylistType.m3u:
          nextScreen = M3UHomeScreen(playlist: playlist);
          break;
      }
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Lottie.asset(
          'assets/splash_2.json',
          fit: BoxFit.contain,
          repeat: false,
          animate: true,
          onLoaded: (composition) {
            _animationController = AnimationController(
              vsync: this,
              duration: composition.duration,
            );

            _animationController!.addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                _onAnimationComplete();
              }
            });

            _animationController!.forward();
          },
          controller: _animationController,
        ),
      ),
    );
  }
}

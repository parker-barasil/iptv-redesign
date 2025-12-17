import 'package:another_iptv_player/repositories/user_preferences.dart';
import 'package:another_iptv_player/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/controllers/iptv_controller.dart';
import 'package:another_iptv_player/models/api_configuration_model.dart';
import 'package:another_iptv_player/models/playlist_model.dart';
import 'package:another_iptv_player/repositories/iptv_repository.dart';
import 'package:another_iptv_player/widgets/splash_animation.dart';
import 'package:provider/provider.dart';
import 'xtream_code_home_screen.dart';

class XtreamCodeDataLoaderScreen extends StatefulWidget {
  final Playlist playlist;
  bool refreshAll = false;

  XtreamCodeDataLoaderScreen({
    super.key,
    required this.playlist,
    this.refreshAll = false,
  });

  @override
  XtreamCodeDataLoaderScreenState createState() =>
      XtreamCodeDataLoaderScreenState();
}

class XtreamCodeDataLoaderScreenState extends State<XtreamCodeDataLoaderScreen> {
  late IptvController _controller;

  @override
  void initState() {
    super.initState();

    final repository = IptvRepository(
      ApiConfig(
        baseUrl: widget.playlist.url!,
        username: widget.playlist.username!,
        password: widget.playlist.password!,
      ),
      widget.playlist.id,
    );
    _controller = IptvController(repository, widget.refreshAll);

    _startLoading();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startLoading() async {
    // Start loading data in background
    final success = await _controller.loadAllData();

    if (success) {
      AppState.currentPlaylist = widget.playlist;
      await UserPreferences.setLastPlaylist(widget.playlist.id);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: _controller,
              child: XtreamCodeHomeScreen(playlist: widget.playlist),
            ),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashAnimation(
        duration: Duration(milliseconds: 2400),
      ),
    );
  }
}

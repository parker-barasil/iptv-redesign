import 'package:another_iptv_player/models/m3u_item.dart';
import 'package:another_iptv_player/repositories/user_preferences.dart';
import 'package:another_iptv_player/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/controllers/m3u_controller.dart';
import 'package:another_iptv_player/models/playlist_model.dart';
import 'package:another_iptv_player/widgets/splash_animation.dart';
import 'package:provider/provider.dart';
import 'm3u_home_screen.dart';

class M3uDataLoaderScreen extends StatefulWidget {
  final Playlist playlist;
  final List<M3uItem> m3uItems;
  bool refreshAll = false;
  final List<M3uItem>? oldM3uItems;

  M3uDataLoaderScreen({
    super.key,
    required this.playlist,
    required this.m3uItems,
    this.refreshAll = false,
    this.oldM3uItems,
  });

  @override
  M3uDataLoaderScreenState createState() => M3uDataLoaderScreenState();
}

class M3uDataLoaderScreenState extends State<M3uDataLoaderScreen> {
  late M3uController _controller;

  @override
  void initState() {
    super.initState();

    _controller = M3uController(
      playlistId: widget.playlist.id,
      m3uItems: widget.m3uItems,
      refreshAll: widget.refreshAll,
    );

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
              child: M3UHomeScreen(playlist: widget.playlist),
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

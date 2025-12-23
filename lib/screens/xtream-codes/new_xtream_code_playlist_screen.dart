import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/core/style/app_typography.dart';
import 'package:another_iptv_player/screens/xtream-codes/xtream_code_data_loader_screen.dart';
import 'package:another_iptv_player/screens/m3u/m3u_data_loader_screen.dart';
import 'package:another_iptv_player/services/m3u_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:another_iptv_player/core/style/app_colors.dart';
import 'package:another_iptv_player/core/new_widgets/app_button.dart';
import 'package:another_iptv_player/core/constants/enums/app_button_variants_enum.dart';
import '../../../../controllers/playlist_controller.dart';
import '../../../../models/api_configuration_model.dart';
import '../../../../models/playlist_model.dart';
import '../../../../repositories/iptv_repository.dart';

class NewXtreamCodePlaylistScreen extends StatefulWidget {
  const NewXtreamCodePlaylistScreen({super.key});

  @override
  NewXtreamCodePlaylistScreenState createState() =>
      NewXtreamCodePlaylistScreenState();
}

class NewXtreamCodePlaylistScreenState
    extends State<NewXtreamCodePlaylistScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _urlController.addListener(_validateForm);
    _usernameController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_nameController.text.isEmpty) {
      _nameController.text = context.loc.default_xtream_code_playlist_name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          _nameController.text.trim().isNotEmpty &&
          _urlController.text.trim().isNotEmpty &&
          _usernameController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(context.loc.xstream_playlist)),
      body: Consumer<PlaylistController>(
        builder: (context, controller, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(colorScheme),
                  SizedBox(height: 32),
                  _buildPlaylistNameField(colorScheme),
                  SizedBox(height: 20),
                  _buildUrlField(colorScheme),
                  SizedBox(height: 20),
                  _buildUsernameField(colorScheme),
                  SizedBox(height: 20),
                  _buildPasswordField(colorScheme),
                  SizedBox(height: 32),
                  _buildSaveButton(controller, colorScheme),
                  if (controller.error != null) ...[
                    SizedBox(height: 20),
                    _buildErrorCard(controller.error!, colorScheme),
                  ],
                  // SizedBox(height: 20),
                  // _buildInfoCard(colorScheme),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            Icons.stream_rounded,
            size: 30,
            color: colorScheme.onPrimary,
          ),
        ),
        SizedBox(height: 16),
        Text(
          context.loc.xstream_playlist,
          style: AppTypography.headline2.copyWith(
            fontSize: 26,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        Text(
          context.loc.xtream_code_description,
          style: AppTypography.body1Regular.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylistNameField(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.playlist_name,
          style: AppTypography.body1SemiBold.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: context.loc.playlist_name_placeholder,
            prefixIcon: Icon(
              Icons.playlist_add_rounded,
              color: colorScheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.loc.playlist_name_required;
            }
            if (value.trim().length < 2) {
              return context.loc.playlist_name_min_2;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUrlField(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.api_url,
          style: AppTypography.body1SemiBold.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _urlController,
          keyboardType: TextInputType.url,
          maxLines: null,
          minLines: 1,
          maxLength: null,
          decoration: InputDecoration(
            hintText: context.loc.api_url_example_hint,
            prefixIcon: Icon(Icons.link_rounded, color: colorScheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.loc.api_url_required;
            }

            final uri = Uri.tryParse(value.trim());
            if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
              return context.loc.url_format_validate_error;
            }

            if (!['http', 'https'].contains(uri.scheme)) {
              return context.loc.url_format_validate_error;
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUsernameField(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.username,
          style: AppTypography.body1SemiBold.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: context.loc.username_placeholder,
            prefixIcon: Icon(Icons.person_rounded, color: colorScheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.loc.username_required;
            }
            if (value.trim().length < 3) {
              return context.loc.username_min_3;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.password,
          style: AppTypography.body1SemiBold.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: context.loc.password_placeholder,
            prefixIcon: Icon(Icons.lock_rounded, color: colorScheme.primary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.loc.password_required;
            }
            if (value.length < 3) {
              return context.loc.password_min_3;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton(
    PlaylistController controller,
    ColorScheme colorScheme,
  ) {
    return AppButton(
      text: context.loc.submit_create_playlist,
      icon: Icons.save_rounded,
      onPressed: controller.isLoading
          ? null
          : (_isFormValid ? _savePlaylist : null),
      style: AppButtonStyleEnum.primaryGradient,
      size: AppButtonSizeEnum.large,
      isLoading: controller.isLoading,
      isActive: _isFormValid,
      fullWidth: true,
    );
  }

  Widget _buildErrorCard(String error, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: colorScheme.error),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.loc.error_occurred,
                  style: AppTypography.body1SemiBold.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  error,
                  style: AppTypography.body2Regular.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                context.loc.info,
                style: AppTypography.body1SemiBold.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${context.loc.all_datas_are_stored_in_device}\n${context.loc.url_format_validate_message}',
            style: AppTypography.body3Regular.copyWith(
              color: colorScheme.onPrimaryContainer,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _savePlaylist() async {
    if (_formKey.currentState!.validate()) {
      final controller = Provider.of<PlaylistController>(
        context,
        listen: false,
      );

      controller.clearError();

      // ========== DEMO MODE FOR APP STORE REVIEW ==========
      // If username is "demo" and password is "demo", load demo playlist
      final isDemoMode = _usernameController.text.trim() == 'demo' &&
          _passwordController.text.trim() == 'demo';

      if (isDemoMode) {
        debugPrint('🎭 DEMO MODE: Loading demo playlist for App Store Review');
        await _loadDemoPlaylist(controller);
        return;
      }
      // ====================================================

      final repository = IptvRepository(
        ApiConfig(
          baseUrl: _urlController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        ),
        _nameController.text.trim(),
      );

      var playerInfo = await repository.getPlayerInfo(forceRefresh: true);

      if (playerInfo == null) {
        controller.setError(context.loc.invalid_credentials);
        return;
      }

      final playlist = await controller.createPlaylist(
        name: _nameController.text.trim(),
        type: PlaylistType.xtream,
        url: _urlController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (playlist != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                XtreamCodeDataLoaderScreen(playlist: playlist),
          ),
        );
      }
    }
  }

  /// Load demo playlist for App Store Review
  ///
  /// This method loads a pre-configured M3U playlist from assets when
  /// the user enters demo/demo credentials. This allows Apple reviewers
  /// to test the app without needing a real IPTV subscription.
  Future<void> _loadDemoPlaylist(PlaylistController controller) async {
    try {
      debugPrint('🎭 Loading demo playlist from assets...');

      // Load demo M3U file from assets
      final demoM3uContent = await rootBundle.loadString('assets/demo_playlist.m3u');

      debugPrint('🎭 Demo M3U loaded, length: ${demoM3uContent.length} chars');

      // Create M3U playlist in database (with dummy URL)
      final playlist = await controller.createPlaylist(
        name: '${_nameController.text.trim()} (Demo)',
        type: PlaylistType.m3u,
        url: 'demo://app-store-review',
      );

      if (playlist == null) {
        debugPrint('❌ Failed to create demo playlist');
        controller.setError('Failed to load demo playlist');
        return;
      }

      debugPrint('🎭 Demo playlist created, parsing M3U content...');

      // Parse M3U content using M3uParser
      final m3uItems = M3uParser.parseM3u(playlist.id, demoM3uContent);

      if (m3uItems.isEmpty) {
        debugPrint('❌ No channels found in demo playlist');
        await controller.deletePlaylist(playlist.id);
        controller.setError('Demo playlist is empty');
        return;
      }

      debugPrint('🎭 Demo playlist parsed successfully: ${m3uItems.length} channels');

      // Navigate to M3U data loader screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => M3uDataLoaderScreen(
              playlist: playlist,
              m3uItems: m3uItems,
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading demo playlist: $e');
      debugPrint('StackTrace: $stackTrace');
      controller.setError('Error loading demo content: $e');
    }
  }
}

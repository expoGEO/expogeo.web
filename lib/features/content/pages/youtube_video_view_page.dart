import 'package:expogeo/core/components/structure/navbar.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeVideoViewPage extends StatefulWidget {
  final String themeId;
  final String subthemeId;
  final String contentId;

  const YoutubeVideoViewPage({
    super.key,
    required this.themeId,
    required this.subthemeId,
    required this.contentId,
  });

  @override
  State<YoutubeVideoViewPage> createState() => _YoutubeVideoViewPageState();
}

class _YoutubeVideoViewPageState extends State<YoutubeVideoViewPage> {
  late YoutubePlayerController _controller;

  late final theme = ThemeDataModel.themes.firstWhere(
    (t) => t.type.value == widget.themeId,
    orElse: () => ThemeDataModel.themes.first,
  );

  late final subtheme = theme.subthemes.firstWhere(
    (s) => s.type.value == widget.subthemeId,
    orElse: () => theme.subthemes.first,
  );

  late final content = subtheme.contents.firstWhere(
    (c) => c.id == widget.contentId,
    orElse: () => subtheme.contents.first,
  );

  @override
  void initState() {
    super.initState();

    final videoUrl = content.registrationInfo.location;
    final videoId = _extractVideoId(videoUrl) ?? '';

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
        enableCaption: true,
      ),
    );
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pauseVideo();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: theme.color.withValues(alpha: 0.2)),
        child: Column(
          children: [
            const Navbar(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
                  child: YoutubePlayerScaffold(
                    controller: _controller,
                    aspectRatio: 4 / 3,
                    builder: (context, player) => SingleChildScrollView(
                      child: Column(
                        children: [
                          player,
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  content.contentInfo.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  content.contentInfo.description,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Extrai o videoId de uma URL do YouTube
  String? _extractVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // Formato: https://www.youtube.com/watch?v=VIDEO_ID
    if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
      final videoId =
          uri.queryParameters['v'] ??
          (uri.host.contains('youtu.be') ? uri.pathSegments.last : null);
      if (videoId != null && videoId.isNotEmpty) {
        return videoId;
      }
    }

    // Formato: https://youtu.be/VIDEO_ID
    if (uri.host.contains('youtu.be') && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.first;
    }

    // Se já for um ID direto
    if (url.length == 11 && RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(url)) {
      return url;
    }

    return null;
  }
}

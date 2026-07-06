import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoSection extends StatefulWidget {
  final String url;
  const VideoSection({super.key, required this.url});

  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.url))
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(0);
        load();
      });
  }

  void load() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller));
  }
}

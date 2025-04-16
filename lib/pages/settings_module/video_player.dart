import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
import '../../components/common_widget.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String title, url;
  const VideoPlayerScreen({super.key, required this.title, required this.url});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  String videoUrl = "https://denvenproductionstorage.blob.core.windows.net/trainings-video/Mobile/stock-app/Update_Edit_Details.mp4";

/*  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(showLogo: false,title: widget.title, centerLogo: true),
/*
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Container(),
      ),*/
    );
  }
}

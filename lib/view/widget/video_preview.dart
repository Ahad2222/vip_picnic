import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:vip_picnic/constant/color.dart';
import 'package:vip_picnic/view/widget/loading.dart';
import 'package:vip_picnic/view/widget/my_appbar.dart';

class VideoPreview extends StatefulWidget {
  VideoPreview({
    this.videoUrl,
  });

  String? videoUrl;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    if (_videoPlayerController1 != null) _videoPlayerController1.dispose();
    if (_chewieController != null) _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(widget.videoUrl ??
        "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4");
    await Future.wait([
      _videoPlayerController1.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: false,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      aspectRatio: _videoPlayerController1.value.aspectRatio,
      fullScreenByDefault: true,
      hideControlsTimer: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: _chewieController!,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loading(),
                      SizedBox(height: 20),
                      Text('loading'.tr),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// TextButton(
//   onPressed: () {
//     _chewieController?.enterFullScreen();
//   },
//   child: const Text('Fullscreen'),
// ),
// Row(
//   children: <Widget>[
//     Expanded(
//       child: TextButton(
//         onPressed: () {
//           setState(() {
//             _videoPlayerController1.pause();
//             _videoPlayerController1.seekTo(Duration.zero);
//             _createChewieController();
//           });
//         },
//         child: const Padding(
//           padding: EdgeInsets.symmetric(vertical: 16.0),
//           child: Text("Landscape Video"),
//         ),
//       ),
//     ),
//   ],
// ),
// Row(
//   children: <Widget>[
//     Expanded(
//       child: TextButton(
//         onPressed: () {
//           setState(() {
//             _platform = TargetPlatform.android;
//           });
//         },
//         child: const Padding(
//           padding: EdgeInsets.symmetric(vertical: 16.0),
//           child: Text("Android controls"),
//         ),
//       ),
//     ),
//     Expanded(
//       child: TextButton(
//         onPressed: () {
//           setState(() {
//             _platform = TargetPlatform.iOS;
//           });
//         },
//         child: const Padding(
//           padding: EdgeInsets.symmetric(vertical: 16.0),
//           child: Text("iOS controls"),
//         ),
//       ),
//     )
//   ],
// ),
// // Row(
// //   children: <Widget>[
// //     Expanded(
// //       child: TextButton(
// //         onPressed: () {
// //           setState(() {
// //             _platform = TargetPlatform.windows;
// //           });
// //         },
// //         child: const Padding(
// //           padding: EdgeInsets.symmetric(vertical: 16.0),
// //           child: Text("Desktop controls"),
// //         ),
// //       ),
// //     ),
// //   ],
// // ),
// if (Platform.isAndroid)
//   ListTile(
//     title: const Text("Delay"),
//     subtitle: DelaySlider(
//       delay:
//       _chewieController?.progressIndicatorDelay?.inMilliseconds,
//       onSave: (delay) async {
//         if (delay != null) {
//           bufferDelay = delay == 0 ? null : delay;
//           await initializePlayer();
//         }
//       },
//     ),
//   )
class DelaySlider extends StatefulWidget {
  const DelaySlider({Key? key, required this.delay, required this.onSave})
      : super(key: key);

  final int? delay;
  final void Function(int?) onSave;

  @override
  State<DelaySlider> createState() => _DelaySliderState();
}

class _DelaySliderState extends State<DelaySlider> {
  int? delay;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    delay = widget.delay;
  }

  @override
  Widget build(BuildContext context) {
    const int max = 1000;
    return ListTile(
      title: Text(
        "Progress indicator delay ${delay != null ? "${delay.toString()} MS" : ""}",
      ),
      subtitle: Slider(
        value: delay != null ? (delay! / max) : 0,
        onChanged: (value) async {
          delay = (value * max).toInt();
          setState(() {
            saved = false;
          });
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.save),
        onPressed: saved
            ? null
            : () {
                widget.onSave(delay);
                setState(() {
                  saved = true;
                });
              },
      ),
    );
  }
}

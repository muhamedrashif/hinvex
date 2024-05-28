// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoWidget extends StatefulWidget {
//   final String videoUrl;

//   const VideoWidget({required this.videoUrl, super.key});

//   @override
//   State<VideoWidget> createState() => _VideoWidgetState();
// }

// class _VideoWidgetState extends State<VideoWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();
//     // ignore: deprecated_member_use
//     _controller = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Stack(
//             children: [
//               AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               ),
//               Positioned.fill(
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       if (_controller.value.isPlaying) {
//                         _controller.pause();
//                       } else {
//                         _controller.play();
//                       }
//                     });
//                   },
//                   child: Center(
//                     child: Icon(
//                       _controller.value.isPlaying
//                           ? Icons.pause
//                           : Icons.play_arrow,
//                       color: Colors.white,
//                       size: 50.0,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }

//@dart=2.9
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter_ffmpeg/completed_ffmpeg_execution.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:xigyu_manager/api/api.dart';

typedef _ValueCallBack = void Function(String value);
Map<String, String> map = Map();
Widget buildItem(BuildContext context, int initIndex, List<String> sourceList,
    {bool isVideo = false, bool isNet = true}) {
  String tag = Uuid().v1();
  return Hero(
    tag: tag,
    placeholderBuilder: (BuildContext context, Size heroSize, Widget child) {
      // keep building the image since the images can be visible in the
      // background of the image gallery
      return child;
    },
    child: GestureDetector(
      onTap: () => openGallery(context, initIndex, sourceList, tag,
          isVideo: isVideo, isNet: isNet),
      child: Stack(
        alignment: Alignment.center,
        children: [
          isNet
              ? CachedNetworkImage(
                  imageUrl:
                      isVideo ? sourceList[initIndex] : sourceList[initIndex],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity)
              : StatefulBuilder(builder: (context, state) {
                  if (isVideo && map[sourceList[initIndex]] == null) {
                    // getFirstFrameExecute(sourceList[initIndex], (value) {
                    //   state(() {
                    //     map[sourceList[initIndex]] = value;
                    //   });
                    // });
                  }
                  return isVideo
                      ? (map[sourceList[initIndex]] == null
                          ? SizedBox()
                          : Image.file(File(map[sourceList[initIndex]]),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity))
                      : Image.file(File(sourceList[initIndex]),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity);
                }),
          isVideo
              ? Icon(
                  Icons.play_circle_filled,
//            color: Colors.white,
                )
              : SizedBox(),
        ],
      ),
    ),
  );
}

//获取视频第一帧
// void getFirstFrameExecute(String videoPath, _ValueCallBack callback) async {
//   var uuid = Uuid().v1();
//   var dir = await getTemporaryDirectory();
//   final arguments =
//       '-y -i $videoPath ' + '-f image2 -vframes 1 ' + '${dir.path}/$uuid.jpg';
//   //执行命令
//   final FlutterFFmpeg _encoder = new FlutterFFmpeg();
//   _encoder.executeAsync(arguments, (CompletedFFmpegExecution execution) {
//     if (execution.returnCode == 0) {
//       print("successfully");
//       print(dir.path + '/$uuid.jpg');
//       var path = dir.path + '/$uuid.jpg';
//       callback(path);
//     } else {
//       print("failed with rc=${execution.returnCode}.");
//     }
//   }).then((executionId) {
//     print(
//         "Async FFmpeg process started with arguments '$arguments' and executionId $executionId.");
//   });
// }

void openGallery(
    BuildContext context, int initIndex, List<String> sourceList, String tag,
    {bool isVideo = false, bool isNet = true}) {
  Navigator.of(context).push(
    HeroDialogRoute<void>(
      // DisplayGesture is just debug, please remove it when use
      builder: (BuildContext context) => InteractiveviewerGallery<String>(
        sources: sourceList,
        initIndex: initIndex,
        itemBuilder: (BuildContext context, int index, bool isFocus) {
          if (isVideo) {
            return VideoItem(
              tag,
              sourceList[index],
              isNet: isNet,
              isFocus: isFocus,
            );
          } else {
            return ImageItem(tag, sourceList[index], isNet: isNet);
          }
        },
        onPageChanged: (int pageIndex) {
          print("nell-pageIndex:$pageIndex");
        },
      ),
    ),
  );
}

class ImageItem extends StatefulWidget {
  final bool isNet;
  final String url;
  final String tag;

  ImageItem(this.tag, this.url, {this.isNet = true});

  @override
  _ImageItemState createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  @override
  void initState() {
    super.initState();
    // print('initState: ${widget.url + (widget.isNet ? Api.bigImg : '')}');
  }

  @override
  void dispose() {
    super.dispose();
    // print('dispose: ${widget.url + (widget.isNet ? Api.bigImg : '')}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: Center(
        child: Hero(
          tag: widget.tag,
          child: widget.isNet
              ? CachedNetworkImage(
                  imageUrl: widget.url,
                  fit: BoxFit.contain,
                )
              : Image.file(
                  File(widget.url),
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  final String tag;
  final String url;
  final bool isNet;
  final bool isFocus;

  VideoItem(this.tag, this.url, {this.isNet = true, this.isFocus});

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController _controller;
  VoidCallback listener;
  String localFileName;

  _VideoItemState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  @override
  void initState() {
    super.initState();
    print('initState: ${widget.url}');
    init();
  }

  init() async {
    File file;
    if (widget.isNet) {
      //缓存视频
      file = await DefaultCacheManager().getSingleFile(widget.url);
    } else {
      file = File(widget.url);
    }
    if (file == null) return;
    _controller = VideoPlayerController.file(file);
    // loop play
    _controller.setLooping(false);
    await _controller.initialize();
    setState(() {});
    _controller.addListener(listener);
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose: ${widget.url}');
    _controller?.removeListener(listener);
    _controller?.pause();
    _controller?.dispose();
  }

  @override
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isFocus && !widget.isFocus) {
      // pause
      _controller?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller == null
        ? buildTheme()
        : _controller.value.isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Hero(
                      tag: widget.tag,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                  _controller.value.isPlaying == true
                      ? SizedBox()
                      : IgnorePointer(
                          ignoring: true,
                          child: Icon(
                            Icons.play_circle_filled,
                            size: 100,
//            color: Colors.white,
                          ),
                        ),
                ],
              )
            : buildTheme();
  }

  Theme buildTheme() {
    return Theme(
        data: ThemeData(
            cupertinoOverrideTheme:
                CupertinoThemeData(brightness: Brightness.dark)),
        child: CupertinoActivityIndicator(radius: 30));
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:chat_ui_kit/src/models/message_base.dart';
import 'package:chat_ui_kit/src/utils/enums.dart';
import 'package:chat_ui_kit/src/utils/extensions.dart';
import 'package:chat_ui_kit/src/widgets/core/messages_list_tile.dart';
import 'package:chat_ui_kit/src/widgets/helpers/message_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// A default Widget that can be used to show a video preview.
/// One would play the video upon clicking the item.
/// This is more an example to give you an idea how to structure your own Widget,
/// since too many aspects would require to be customized, for instance
/// implementing your own image loader, padding, constraints, footer etc.
class ChatMessageVideo extends StatefulWidget {
  final int index;

  final MessageBase message;

  final MessagePosition? messagePosition;

  final MessageFlow messageFlow;

  const ChatMessageVideo(
      this.index, this.message, this.messagePosition, this.messageFlow,
      {Key? key})
      : super(key: key);

  @override
  _ChatMessageVideoState createState() => _ChatMessageVideoState();
}

class _ChatMessageVideoState extends State<ChatMessageVideo> {
  Future<VideoData?>? _videoData;
  Future<Uint8List?>? _videoThumbnail;

  double get _maxSize => MediaQuery.of(context).size.width * 0.5;

  @override
  void initState() {
    _videoData = getVideoInfo(File(widget.message.url));
    _videoThumbnail = VideoThumbnail.thumbnailData(
      video: widget.message.url,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    super.initState();
  }

  /// Retrieve video metaData
  Future<VideoData?> getVideoInfo(File file) {
    final videoInfo = FlutterVideoInfo();
    return videoInfo.getVideoInfo(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final Widget _footer = Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.videocam),
            FutureBuilder(
                future: _videoData,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    final data = snapshot.data as VideoData;
                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                            Duration(milliseconds: data.duration!.toInt())
                                .verboseDuration));
                  }
                  return Container();
                }),
            Spacer(),
            MessageFooter(widget.message)
          ],
        ));

    return SizedBox(
        height: _maxSize,
        width: _maxSize,
        child: FutureBuilder(
            future: _videoThumbnail,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return MessageContainer(
                    constraints:
                        BoxConstraints(maxWidth: _maxSize, maxHeight: _maxSize),
                    padding: EdgeInsets.zero,
                    decoration: messageDecoration(context,
                        messagePosition: widget.messagePosition,
                        color: Colors.transparent,
                        messageFlow: widget.messageFlow),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Image.memory(snapshot.data as Uint8List,
                            fit: BoxFit.cover,
                            width: _maxSize,
                            height: _maxSize),
                        _footer
                      ],
                    ));
              }

              return Container();
            }));
  }
}

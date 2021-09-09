import 'dart:async';

import 'package:chat_ui_kit/src/utils/enums.dart';
import 'package:flutter/material.dart';

/// A typing handler that will emit a [TypingEvent] when necessary
/// Four steps are required to use it:
/// 1. Add [MessageInputTypingHandler] as a mixin to your class
/// 2. Override [typingCallback]
/// 3. Override [textController]
/// 4. Call [attachTypingListener] when creating your class
/// [MessageInput] will give you an example.
abstract class MessageInputTypingHandler {
  /// If the user starts typing and stops for [idleStopDelay],
  /// a [TypingEvent.stop] will be emitted
  /// Defaults to 5 seconds, override at will;
  Duration idleStopDelay = Duration(seconds: 5);

  /// Called when the user starts typing or stops typing
  Function(TypingEvent event)? get typingCallback;

  TextEditingController get textController;

  /// Keep track internally of the current typing status
  bool _isTyping = false;

  /// The internal timer called after [idleStopDelay] to trigger [TypingEvent.stop]
  Timer? _timer;

  /// Call this method in your [initState]
  void attachTypingListener() =>
      textController.addListener(_onTextChangedTypingListener);

  void _onTextChangedTypingListener() {
    if (textController.text.isNotEmpty) {
      if (!_isTyping) {
        //set status to typing and emit new status
        _isTyping = true;
        if (typingCallback != null) typingCallback!(TypingEvent.start);
      }
      //start or reset the stop delay
      _timer?.cancel();
      _timer = Timer(idleStopDelay, () {
        _isTyping = false;
        if (typingCallback != null) typingCallback!(TypingEvent.stop);
      });
    } else {
      //text changed to nothing, emit stop event
      _isTyping = false;
      if (typingCallback != null) typingCallback!(TypingEvent.stop);
      //cancel timer since stop event has already been emitted
      _timer?.cancel();
    }
  }
}

class MessageInput extends StatefulWidget {
  MessageInput(
      {Key? key,
      required this.textController,
      required this.sendCallback,
      this.typingCallback,
      this.focusNode})
      : super(key: key);

  /// Called when the user sends a (non empty) message
  final Function(String text) sendCallback;

  /// Triggered by [MessageInputTypingHandler] on typing events
  final Function(TypingEvent event)? typingCallback;
  final TextEditingController textController;
  final FocusNode? focusNode;

  @override
  _MessageInputState createState() => _MessageInputState();
}

/// Uses [MessageInputTypingHandler] as a mixin to handle typing events
class _MessageInputState extends State<MessageInput>
    with TickerProviderStateMixin, MessageInputTypingHandler {
  late AnimationController _animationControllerCheckMark;
  late AnimationController _animationControllerSend;
  late Animation<double> _animationCheckmark;
  late Animation<double> _animationSend;

  bool isAnimating = false;

  /// Supply the [TextEditingController] to [MessageInputTypingHandler]
  @override
  TextEditingController get textController => widget.textController;

  /// Supply the callback to [MessageInputTypingHandler]
  @override
  Function(TypingEvent event)? get typingCallback => widget.typingCallback;

  @override
  void initState() {
    /// Attach the [MessageInputTypingHandler] listener to the [TextEditingController].
    /// This step is mandatory to make MessageInputTypingHandler work.
    attachTypingListener();

    _animationControllerCheckMark =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animationControllerSend =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animationCheckmark =
        Tween<double>(begin: 0, end: 1).animate(_animationControllerCheckMark);
    _animationSend =
        Tween<double>(begin: 1, end: 0).animate(_animationControllerSend);
    super.initState();
  }

  void sendMessage() {
    if (textController.text.isNotEmpty && !isAnimating) {
      widget.sendCallback(textController.text);
      textController.clear();

      isAnimating = true;
      _animationControllerSend
          .forward()
          .then((value) => _animationControllerCheckMark.forward());

      Future.delayed(Duration(seconds: 2), () {
        _animationControllerCheckMark.reverse().then((value) =>
            _animationControllerSend
                .reverse()
                .then((value) => isAnimating = false));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Theme.of(context).disabledColor))),
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: textController,
                        focusNode: widget.focusNode)),
                Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: RaisedButton(
                        onPressed: sendMessage,
                        child: Stack(alignment: Alignment.center, children: [
                          ScaleTransition(
                              scale: _animationCheckmark,
                              child: Icon(Icons.check)),
                          ScaleTransition(
                              scale: _animationSend, child: Icon(Icons.send)),
                        ])))
              ],
            )));
  }

  @override
  void dispose() {
    _animationControllerCheckMark.dispose();
    _animationControllerSend.dispose();
    // Cancel any timer still running at this point.
    _timer?.cancel();
    super.dispose();
  }
}

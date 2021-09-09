import 'package:chat_ui_kit/chat_ui_kit.dart';
import 'package:mockito/mockito.dart';
import 'dart:math';

String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}

class FakeMessage extends Fake implements MessageBase {
  String id;
  String? text;

  FakeMessage({this.text, this.id = ''}) {
    if (this.id == '') {
      this.id = generateRandomString(10);
    }
  }

  @override
  DateTime get createdAt => DateTime.now();
}

class FakeChat extends Fake implements ChatBase {
  String id;
  String name;
  MessageBase? lastMessage;
  int? unreadCount;

  FakeChat({this.name = '', this.id = '', this.lastMessage}) {
    if (this.id == '') {
      this.id = generateRandomString(10);
    }
  }

  @override
  List<UserBase> get members => [];

  @override
  bool get isUnread => true;
}

class FakeUser extends Fake implements UserBase {}

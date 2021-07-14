import 'package:chat_ui_kit/chat_ui_kit.dart';

import 'chat_message.dart';
import 'chat_user.dart';
import 'package:example/utils/app_const.dart';

class Chat {
  String? id; //usually a UUID
  String? name;
  String? ownerId;
  int unreadCount;

  Chat({this.id, this.name, this.ownerId, this.unreadCount = 0});
}

class ChatWithMembers extends ChatBase {
  Chat? chat;
  List<ChatUser> members;
  ChatMessage? lastMessage;

  ChatWithMembers({this.chat, required this.members, this.lastMessage});

  @override
  int get unreadCount => chat?.unreadCount ?? 0;

  @override
  String get name {
    final _name = (chat?.name ?? null);
    if (_name != null && _name.isNotEmpty) return chat!.name!;
    return membersWithoutSelf.map((e) => e.username).toList().join(", ");
  }

  @override
  String get id => chat?.id ?? "";

  List<ChatUser> get membersWithoutSelf {
    List<ChatUser> membersWithoutSelf = [];
    for (ChatUser chatUser in members) {
      if (AppConstants.LOCAL_USER_ID != chatUser.id)
        membersWithoutSelf.add(chatUser);
    }
    return membersWithoutSelf;
  }

  bool get isGroupChat => members.length > 2;
}

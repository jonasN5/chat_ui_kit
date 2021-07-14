import 'package:example/models/chat.dart';
import 'package:example/models/chat_message.dart';
import 'package:example/models/chat_user.dart';
import 'package:example/utils/app_const.dart';
import 'package:chat_ui_kit/chat_ui_kit.dart';

class ChatViewModel {
  ChatViewModel() {
    chatMessages = {
      "test_chat_id_0": [
        ChatMessage(
            author: chatUsers[1],
            text: "you? :)",
            creationTimestamp: DateTime.now().millisecondsSinceEpoch - 5000),
        ChatMessage(
            author: chatUsers[1],
            text: "not much",
            creationTimestamp: DateTime.now().millisecondsSinceEpoch - 3000),
        ChatMessage(
            author: localUser,
            text: "sup",
            creationTimestamp: DateTime.now().millisecondsSinceEpoch),
      ],
      "test_chat_id_1": [
        ChatMessage(
            type: ChatMessageType.image,
            author: localUser,
            attachment: 'assets/other/paris_e_tower.jpg',
            creationTimestamp: DateTime(2020, 12, 29).millisecondsSinceEpoch)
      ],
      "test_chat_id_2": [
        ChatMessage(
            author: localUser,
            text: "Xmas was awesome!",
            creationTimestamp: DateTime(2020, 12, 28).millisecondsSinceEpoch)
      ],
      "test_chat_id_3": [
        ChatMessage(
            author: localUser,
            text: "Let's create a group",
            creationTimestamp: DateTime(2020, 12, 27).millisecondsSinceEpoch)
      ],
      "test_chat_id_4": [
        ChatMessage(
            author: localUser,
            type: ChatMessageType.image,
            attachment: 'assets/other/paris_e_tower.jpg',
            creationTimestamp:
                DateTime(2020, 12, 26, 10, 5, 4).millisecondsSinceEpoch),
        ChatMessage(
            author: localUser,
            text: "Check out where I went during my last holidays",
            creationTimestamp:
                DateTime(2020, 12, 26, 10, 5, 2).millisecondsSinceEpoch),
        ChatMessage(
            author: localUser,
            text: "Me three",
            creationTimestamp:
                DateTime(2020, 12, 22, 8, 6, 2).millisecondsSinceEpoch),
        ChatMessage(
            author: chatUsers[5],
            text: "Me too",
            creationTimestamp:
                DateTime(2020, 12, 22, 8, 6).millisecondsSinceEpoch),
        ChatMessage(
            author: chatUsers[1],
            text: "I like it",
            creationTimestamp:
                DateTime(2020, 12, 22, 8, 5).millisecondsSinceEpoch),
        ChatMessage(
            author: chatUsers[3],
            text: "Do you guys like the new title?",
            creationTimestamp:
                DateTime(2020, 12, 22, 8, 1).millisecondsSinceEpoch),
        ChatMessage(
            author: chatUsers[3],
            type: ChatMessageType.renameChat,
            text: "Paradise",
            creationTimestamp:
                DateTime(2020, 12, 22, 8).millisecondsSinceEpoch),
      ],
      "test_chat_id_5": [
        ChatMessage(
            author: chatUsers[5],
            text: "What are you doing on new year's eve?",
            creationTimestamp: DateTime(2020, 12, 23).millisecondsSinceEpoch)
      ],
    };
  }

  List<ChatUser> chatUsers = [
    ChatUser(
        id: AppConstants.LOCAL_USER_ID,
        username: "MrJ",
        fullname: "Jonas S.",
        avatarURL: 'assets/avatars/local_user_avatar.png'),
    ChatUser(
        id: "local_user_id_0",
        username: "Kiraf",
        fullname: "Kira Fowler",
        avatarURL: 'assets/avatars/woman0.jpg'),
    ChatUser(
        id: "local_user_id_1",
        username: "Eleanor",
        avatarURL: 'assets/avatars/woman1.jpg'),
    ChatUser(
        id: "local_user_id_2",
        username: "crysty",
        fullname: "Crystal Leblanc",
        avatarURL: 'assets/avatars/woman2.jpg'),
    ChatUser(
        id: "local_user_id_3",
        username: "Ewan",
        fullname: "Ewan Kemp",
        avatarURL: 'assets/avatars/man0.jpg'),
    ChatUser(
        id: "local_user_id_4",
        username: "Wilfredh",
        fullname: "Wilfred Hanna",
        avatarURL: 'assets/avatars/man1.jpg'),
    ChatUser(
        id: "local_user_id_5",
        username: "tyler.henry",
        fullname: "Tyler Henry",
        avatarURL: 'assets/avatars/man2.jpg'),
  ];

  ChatUser get localUser => chatUsers[0];

  Map<String, List<ChatMessage>> chatMessages = {};

  late ChatsListController controller;

  List<ChatWithMembers> generateExampleChats() {
    final List<ChatWithMembers> _chats = [];
    _chats.add(ChatWithMembers(
        lastMessage: chatMessages["test_chat_id_0"]!.first,
        chat: Chat(id: "test_chat_id_0", ownerId: localUser.id, unreadCount: 2),
        members: [chatUsers[0], chatUsers[1]]));
    _chats.add(ChatWithMembers(
        lastMessage: chatMessages["test_chat_id_1"]!.first,
        chat: Chat(id: "test_chat_id_1", ownerId: localUser.id),
        members: [chatUsers[0], chatUsers[4]]));
    _chats.add(ChatWithMembers(
        lastMessage: chatMessages["test_chat_id_2"]!.first,
        chat: Chat(id: "test_chat_id_2", ownerId: localUser.id),
        members: [chatUsers[0], chatUsers[5]]));
    _chats.add(ChatWithMembers(
        lastMessage: chatMessages["test_chat_id_3"]!.first,
        chat: Chat(id: "test_chat_id_3", ownerId: localUser.id),
        members: [chatUsers[0], chatUsers[1], chatUsers[3]]));
    _chats.add(ChatWithMembers(
        lastMessage: chatMessages["test_chat_id_4"]!.first,
        chat: Chat(
            id: "test_chat_id_4", ownerId: chatUsers[3].id, name: "Paradise"),
        members: [chatUsers[0], chatUsers[1], chatUsers[3], chatUsers[5]]));
    _chats.add(ChatWithMembers(
        lastMessage: chatMessages["test_chat_id_5"]!.first,
        chat: Chat(id: "test_chat_id_5", ownerId: chatUsers[2].id),
        members: [chatUsers[0], chatUsers[2]]));
    return _chats;
  }
}

/// The base class for your custom User model, which has to extend [UserBase]
abstract class UserBase {
  /// Id of your User
  String get id;

  /// Typically the username
  String get name;

  /// The URL to fetch the avatar
  String get avatar;
}

## [1.3.0] - 09/09/2021

* Added test coverage on all important parts
* Updated dependencies

## [1.2.4] - 14/07/2021

* Migrated example app to null safety

## [1.2.3] - 04/06/2021

* Fixed a null safety TypeError

## [1.2.2] - 29/05/2021

* Fixed a bug where a TypingEvent.stop would be emitted twice if the user deleted the input
* Fixed NotificationListener null safety issue in some cases

## [1.2.1] - 16/05/2021

* Fixed assertion error in MessagesList (thnx to https://github.com/knaeckeKami)

## [1.2.0] - 13/05/2021

* Fixed changelog wrong years (thnx to https://github.com/jangruenwaldt)
* Updated dependencies
* Bumped null safety to stable version

## [1.2.0-nullsafety.0] - 23/03/2021

* Migrated to null safety
* Exposed ScrollPhysics parameter for ChatsList and MessagesList

## [1.1.7] - 17/03/2021

* Added the possibility to display the GroupAvatar images in stacked circles, for a more modern UI. Check out GroupAvatarMode.stackedCircles.

## [1.1.6] - 01/03/2021

* Move chat padding from top level to message level to make item selection cover the whole screen width
* Updated documentation to reflect the change

## [1.1.5] - 24/02/2021

* Increased the default unread messages bubble padding to make it more readable

## [1.1.4] - 20/02/2021

* Fixed a bug where ChatsListController.updateById would not update the item
* Style is now correctly passed from MessagesListTile to IncomingMessage

## [1.1.3] - 22/01/2021

* LastMessage can now be null

## [1.1.2] - 07/01/2021

* Fixed a bug where the typing event would not be emitted after deleting a message
* Added a convenience method to get an item by id
* Added item not in list safety check
* Fixed a bug where adding/removing an item would sometimes build the wrong padding/date
* Added a few convenience methods to the data controllers
* Fixed a bug in the GroupAvatar where 4 members or more with a separator would result in overflowing the separator's height at the bottom of the widget
* Updated dependencies and example app

## [1.1.1] - 29/12/2020

* Apply pub changes

## [1.1.0] - 29/12/2020

* Added an example app
* Fixed a bug where item deletion caused an error
* Removed a forgotten print statement that polluted the console
* Improved inline documentation a little bit

## [1.0.0] - 19/12/2020

* Initial release.

## [1.1.5] - 24/02/2020

* Increased the default unread messages bubble padding to make it more readable

## [1.1.4] - 20/02/2020

* Fixed a bug where ChatsListController.updateById would not update the item
* Style is now correctly passed from MessagesListTile to IncomingMessage

## [1.1.3] - 22/01/2020

* LastMessage can now be null

## [1.1.2] - 07/01/2020

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

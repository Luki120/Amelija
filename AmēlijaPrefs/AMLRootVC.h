@import AudioToolbox.AudioServices;
@import ObjectiveC.message;
@import ObjectiveC.runtime;
@import Preferences.PSListController;
@import Preferences.PSSpecifier;
@import Preferences.PSTableCell;
#import <spawn.h>
#import "Headers/Common.h"


@interface OBWelcomeController : UIViewController
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end


@interface AMLRootVC : PSListController
@end


@interface LSRootVC : PSListController
@end


@interface HSRootVC : PSListController
@end


@interface AmelijaLinksVC : PSListController
@end


@interface AmelijaContributorsVC : PSListController
@end


@interface PSListController ()
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end

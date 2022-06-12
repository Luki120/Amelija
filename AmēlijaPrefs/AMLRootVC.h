#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <AudioToolbox/AudioServices.h>
#import <spawn.h>
#import "Headers/Constants.h"


@interface OBWelcomeController : UIViewController
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end


@interface AMLRootVC : PSListController
@end


@interface LSRootVC : PSListController
@property (nonatomic, strong) NSMutableDictionary *savedSpecifiers;
@end


@interface HSRootVC : PSListController
@property (nonatomic, strong) NSMutableDictionary *savedSpecifiers;
@end


@interface AmelijaLinksVC : PSListController
@end


@interface AmelijaContributorsVC : PSListController
@end


@interface PSTableCell ()
- (void)setTitle:(NSString *)t;
@end


@interface AmelijaTableCell : PSTableCell
@end


@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end

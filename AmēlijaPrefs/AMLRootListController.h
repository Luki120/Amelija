#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>




@interface AmelijaTableCell : PSTableCell
@end


@interface AmelijaLinksRootListController : PSListController
@end


@interface AmelijaContributorsRootListController : PSListController
@end


@interface AMLRootListController : PSListController
- (void)loadPrefs;
@end


@interface LSRootListController : PSListController
@end


@interface HSRootListController : PSListController
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end
@import UIKit;
@import CydiaSubstrate;
#import "Common.h"
#import "Prefs.h"


@interface CSCoverSheetViewController : UIViewController
@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, strong) _UIBackdropView *gaussianBlurView;
- (void)unleashThatLSBlur;
- (void)showBlurIfNotifsPresent;
- (void)fadeInBlur;
- (void)fadeOutBlur;
@end


@interface SBHomeScreenViewController : UIViewController
@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, strong) _UIBackdropView *gaussianBlurView;
- (void)unleashThatHSBlur;
@end


@interface NCNotificationMasterList : NSObject
@property (assign, nonatomic) NSInteger notificationCount;
- (void)postNotif;
@end

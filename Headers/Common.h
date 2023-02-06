static NSString *const kPath = @"/var/mobile/Library/Preferences/me.luki.amēlijaprefs.plist";

static NSNotificationName const AmelijaLSBlurAppliedNotification = @"AmelijaLSBlurAppliedNotification";
static NSNotificationName const AmelijaNotificationArrivedNotification = @"AmelijaNotificationArrivedNotification";
static NSNotificationName const AmelijaHSBlurAppliedNotification = @"AmelijaHSBlurAppliedNotification";


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(NSInteger)arg1;
@end


@interface _UIBackdropView : UIView
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

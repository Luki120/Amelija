#import "Headers/Prefs.h"


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


@interface AXNView : UIView
@end


@interface TKOView : UIView
@end


// Reusable

static UIView *blurView(UIViewController *self, CGFloat alpha) {

	UIView *blurView = [[UIVisualEffectView alloc] initWithEffect: blurEffect];
	blurView.tag = 1337;
	blurView.alpha = alpha;
	blurView.frame = self.view.bounds;
	blurView.clipsToBounds = YES;
	blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view insertSubview:blurView atIndex:0];

	return blurView;

}

static _UIBackdropView *gaussianBlurView(UIViewController *self, CGFloat alpha) {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];
		
	_UIBackdropView *gaussianBlurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	gaussianBlurView.tag = 1337;
	gaussianBlurView.alpha = alpha;
	gaussianBlurView._blurQuality = @"high";
	gaussianBlurView.blurRadiusSetOnce = NO;
	[self.view insertSubview:gaussianBlurView atIndex:0];

	return gaussianBlurView;

}

static void blurType(NSInteger blurType) {

	switch(blurType) {
		case 1: blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]; break;
		case 2: blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]; break;
		case 3: blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]; break;
		case 4: blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent]; break;
		case 5: blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterial]; break;
		case 6: blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial]; break;
		case 7: blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial]; break;
	}

}


static NSInteger (*origAxonNumberOfItemsInSection)(id self, SEL _cmd, id collectionView, NSInteger);

static NSInteger overrideAxonNumberOfItemsInSection(id self, SEL _cmd, id collectionView, NSInteger section) {

	axonCellCount = origAxonNumberOfItemsInSection(self, _cmd, collectionView, section);

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

	return axonCellCount;

}

static NSInteger (*origTakoNumberOfItemsInSection)(id self, SEL _cmd, id collectionView, NSInteger);

static NSInteger overrideTakoNumberOfItemsInSection(id self, SEL _cmd, id collectionView, NSInteger section) {

	takoCellCount = origTakoNumberOfItemsInSection(self, _cmd, collectionView, section);

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

	return takoCellCount;

}


%hook SpringBoard


- (void)applicationDidFinishLaunching:(id)app {

	%orig;

	MSHookMessageEx(%c(AXNView), @selector(collectionView:numberOfItemsInSection:), (IMP) &overrideAxonNumberOfItemsInSection, (IMP *) &origAxonNumberOfItemsInSection);
	MSHookMessageEx(%c(TKOView), @selector(collectionView:numberOfItemsInSection:), (IMP) &overrideTakoNumberOfItemsInSection, (IMP *) &origTakoNumberOfItemsInSection);

}


%end


%hook NCNotificationMasterList


- (void)removeNotificationRequest:(id)arg1 { // get notification count in a reliable way

	%orig;
	[self postNotif];

}


- (void)insertNotificationRequest:(id)arg1 {

	%orig;
	[self postNotif];

}


- (void)modifyNotificationRequest:(id)arg1 {

	%orig;
	[self postNotif];

}


%new

- (void)postNotif {

	notificationCount = [self notificationCount];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

}


%end


%hook CSCoverSheetViewController


%property (nonatomic, strong) UIView *blurView;
%property (nonatomic, strong) _UIBackdropView *gaussianBlurView;


%new

- (void)unleashThatLSBlur { // self explanatory

	loadPrefs();

	[[self.view viewWithTag:1337] removeFromSuperview];

	if(!lsBlur) return;

	if(lsBlurType == 0) {

		self.gaussianBlurView = gaussianBlurView(self, lsIntensity);

		if(blurIfNotifs && notificationCount == 0) self.gaussianBlurView.alpha = 0;

	}

	else {

		blurType(lsBlurType);

		self.blurView = blurView(self, lsIntensity);

		if(blurIfNotifs && notificationCount == 0) self.blurView.alpha = 0;

	}

	if(self.blurView || self.gaussianBlurView) [self showBlurIfNotifsPresent];

}


%new

- (void)showBlurIfNotifsPresent { // self explanatory

	loadPrefs();

	if(!blurIfNotifs) {

		self.blurView.alpha = lsBlur ? lsIntensity : 1;
		self.gaussianBlurView.alpha = lsBlur ? lsIntensity : 1;

	}

	else if(!kTakoExists) {

 		if(axonCellCount == 0 && notificationCount == 0) [self fadeOutBlur];
 		else [self fadeInBlur];

	} 

	else {

		if(takoCellCount == 0) [self fadeOutBlur];
		else [self fadeInBlur];

	}

}


%new

- (void)fadeInBlur {

	[UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		self.blurView.alpha = lsBlur ? lsIntensity : 1;
		self.gaussianBlurView.alpha = lsBlur ? lsIntensity : 1;

	} completion:nil];

}


%new

- (void)fadeOutBlur {

	[UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		self.blurView.alpha = 0;
		self.gaussianBlurView.alpha = 0;

	} completion:nil];

}


- (void)viewDidLoad { // create notification observers

	%orig;

	[self unleashThatLSBlur];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(unleashThatLSBlur) name:@"lsBlurApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(showBlurIfNotifsPresent) name:@"notifArrivedSoApplyingBlurNow" object:nil];

}


%end


%hook SBHomeScreenViewController


%property (nonatomic, strong) UIView *blurView;
%property (nonatomic, strong) _UIBackdropView *gaussianBlurView;


%new


- (void)unleashThatHSBlur { // self explanatory

	loadPrefs();

	[[self.view viewWithTag:1337] removeFromSuperview];

	if(!hsBlur) return;

	if(hsBlurType == 0) self.gaussianBlurView = gaussianBlurView(self, hsIntensity);

	else {

		blurType(hsBlurType);

		self.blurView = blurView(self, hsIntensity);

	}

}


- (void)viewDidLoad { // create notification observers

	%orig;

	[self unleashThatHSBlur];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(unleashThatHSBlur) name:@"hsBlurApplied" object:nil];

}


%end


%ctor { loadPrefs(); }

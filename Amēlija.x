@import UIKit;


// LS

static BOOL lsBlur;
static BOOL blurIfNotifs;

static int lsBlurType;

static float lsIntensity = 1.0f;

static UIBlurEffect *lsBlurEffect;

static int notificationCount = 0;
static NSInteger axonCellCount = 0;
static NSInteger takoCellCount = 0;


// HS

static BOOL hsBlur;

static int hsBlurType;

static float hsIntensity = 1.0f;

static UIBlurEffect *hsBlurEffect;


static NSString *const takeMeThere = @"/var/mobile/Library/Preferences/me.luki.amēlijaprefs.plist";
#define kTakoExists [[NSFileManager defaultManager] fileExistsAtPath:@"Library/MobileSubstrate/DynamicLibraries/Tako.dylib"]


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(long long)arg1;
@end


@interface _UIBackdropView : UIView
@property (assign, nonatomic) BOOL blurRadiusSetOnce;
@property (copy, nonatomic) NSString *_blurQuality;
@property (assign, nonatomic) double _blurRadius;
- (id)initWithSettings:(id)arg1;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end


@interface CSCoverSheetViewController : UIViewController
@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, strong) _UIBackdropView *gaussianBlurView;
- (void)unleashThatLSBlur;
- (void)showBlurIfNotifsPresent;
@end


@interface SBHomeScreenViewController : UIViewController
@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, strong) _UIBackdropView *gaussianBlurView;
- (void)unleashThatHSBlur;
@end


@interface NCNotificationMasterList : NSObject
@property (assign, nonatomic) NSInteger notificationCount;
@end


@interface AXNView : UIView
@end


@interface TKOView : UIView
@end


static void loadPrefs() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:takeMeThere];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	lsBlur = prefs[@"lsBlur"] ? [prefs[@"lsBlur"] boolValue] : NO;
	blurIfNotifs = prefs[@"blurIfNotifs"] ? [prefs[@"blurIfNotifs"] boolValue] : NO;
	lsBlurType = prefs[@"lsBlurType"] ? [prefs[@"lsBlurType"] integerValue] : 0;
	lsIntensity = prefs[@"lsIntensity"] ? [prefs[@"lsIntensity"] floatValue] : 1.0f;

	hsBlur = prefs[@"hsBlur"] ? [prefs[@"hsBlur"] boolValue] : NO;
	hsBlurType = prefs[@"hsBlurType"] ? [prefs[@"hsBlurType"] integerValue] : 0;
	hsIntensity = prefs[@"hsIntensity"] ? [prefs[@"hsIntensity"] floatValue] : 1.0f;

}


/*

Axon support smh, only because I love your creation Nepeta,
thank you so much for this gem. Hope you come back some day.
Lmao I'm writing this like if she's ever gonna come here,
anyways here's the magic, and we gotta do it kinda the old school way
because otherwise due to Amēlija being alphabetically before Axon
in the loading process, normal hooks loaded in the constructor wouldn't
take any effect, so that's why we pass a message with MSHookMessageEx
so we can control when to load it. And no, fuck dlopen, this is better

*/


static NSInteger (*origNumberOfCells)(id self, SEL _cmd, id collectionView, NSInteger section);

NSInteger numberOfCells(id self, SEL _cmd, id collectionView, NSInteger section) {

	axonCellCount = origNumberOfCells(self, _cmd, collectionView, section);

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

	return axonCellCount;

}

static NSInteger (*takoOrigNumberOfCells)(id self, SEL _cmd, id collectionView, NSInteger section);

NSInteger takoNumberOfCells(id self, SEL _cmd, id collectionView, NSInteger section) {

	takoCellCount = takoOrigNumberOfCells(self, _cmd, collectionView, section);

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

	return takoCellCount;

}


%hook SpringBoard


- (void)applicationDidFinishLaunching:(id)app {

	%orig;

	MSHookMessageEx(%c(AXNView), @selector(collectionView:numberOfItemsInSection:), (IMP) &numberOfCells, (IMP *) &origNumberOfCells);
	MSHookMessageEx(%c(TKOView), @selector(collectionView:numberOfItemsInSection:), (IMP) &takoNumberOfCells, (IMP *) &takoOrigNumberOfCells);

}


%end




%hook NCNotificationMasterList


- (void)removeNotificationRequest:(id)arg1 { // get notification count in a reliable way

	%orig;

	notificationCount = [self notificationCount];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

}


- (void)insertNotificationRequest:(id)arg1 {

	%orig;

	notificationCount = [self notificationCount];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

}


- (void)modifyNotificationRequest:(id)arg1 {

	%orig;

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

		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];
			
		self.gaussianBlurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		self.gaussianBlurView.tag = 1337;
		self.gaussianBlurView.alpha = lsIntensity;
		self.gaussianBlurView._blurQuality = @"high";
		self.gaussianBlurView.blurRadiusSetOnce = NO;
		[self.view insertSubview:self.gaussianBlurView atIndex:0];

		if(blurIfNotifs && notificationCount == 0) self.gaussianBlurView.alpha = 0;

	}

	else {

		switch(lsBlurType) {

			case 1:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				break;


			case 2:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				break;


			case 3:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
				break;


			case 4:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
				break;


			case 5:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterial];
				break;


			case 6:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
				break;


			case 7:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
				break;

		}

		self.blurView = [[UIVisualEffectView alloc] initWithEffect:lsBlurEffect];
		self.blurView.tag = 1337;
		self.blurView.alpha = lsIntensity;
		self.blurView.frame = self.view.bounds;
		self.blurView.clipsToBounds = YES;
		self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view insertSubview:self.blurView atIndex:0];

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

 		if((notificationCount == 0) && (axonCellCount == 0)) {

			[UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

				self.blurView.alpha = 0;
				self.gaussianBlurView.alpha = 0;

			} completion:nil];

		} else {

			[UIView transitionWithView:self.blurView duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

				self.blurView.alpha = lsBlur ? lsIntensity : 1;
				self.gaussianBlurView.alpha = lsBlur ? lsIntensity : 1;

			} completion:nil];

		}

	} 

	else {

		if(takoCellCount == 0) {

			[UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

				self.blurView.alpha = 0;
				self.gaussianBlurView.alpha = 0;

			} completion:nil];

		} else {

			[UIView transitionWithView:self.blurView duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

				self.blurView.alpha = lsBlur ? lsIntensity : 1;
				self.gaussianBlurView.alpha = lsBlur ? lsIntensity : 1;

			} completion:nil];

		}

	}

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

	if(hsBlurType == 0) {

		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

		self.gaussianBlurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		self.gaussianBlurView.tag = 1337;
		self.gaussianBlurView.alpha = hsIntensity;
		self.gaussianBlurView._blurRadius = 80.0;
		self.gaussianBlurView._blurQuality = @"high";
		self.gaussianBlurView.blurRadiusSetOnce = NO;
		[self.view insertSubview:self.gaussianBlurView atIndex:0];

	}

	else {

		switch(hsBlurType) {

			case 1:

				hsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				break;


			case 2:

				hsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				break;


			case 3:

				hsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
				break;


			case 4:

				hsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
				break;


			case 5:

				hsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterial];
				break;


			case 6:

				hsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
				break;


			case 7:

				hsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
				break;

		}

		self.blurView = [[UIVisualEffectView alloc] initWithEffect:hsBlurEffect];
		self.blurView .tag = 1337;
		self.blurView.alpha = hsIntensity;
		self.blurView .frame = self.view.bounds;
		self.blurView .clipsToBounds = YES;
		self.blurView .autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view insertSubview:self.blurView atIndex:0];

	}

}


- (void)viewDidLoad { // create notification observers

	%orig;

	[self unleashThatHSBlur];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(unleashThatHSBlur) name:@"hsBlurApplied" object:nil];

}


%end


%ctor {

	loadPrefs();

}

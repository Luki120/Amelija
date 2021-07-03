#import <UIKit/UIKit.h>




// LS


static BOOL lsBlur;
static BOOL epicLSBlur;
static BOOL blurIfNotifs;

static int lsBlurType;

float lsIntensity = 1.0f;
float epicLSBlurIntensity = 1.0f;

UIBlurEffect* lsBlurEffect;

int notificationCount = 0;


// HS


static BOOL hsBlur;
static BOOL epicHSBlur;

static int blurType;

float hsIntensity = 1.0f;
float epicHSBlurIntensity = 1.0f;

UIBlurEffect* hsBlurType;


static NSString *takeMeThere = @"/var/mobile/Library/Preferences/me.luki.amēlijaprefs.plist";


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(long long)arg1;
@end


@interface _UIBackdropView : UIView
@property (assign,nonatomic) BOOL blurRadiusSetOnce;
@property (nonatomic,copy) NSString * _blurQuality;
@property (assign,nonatomic) double _blurRadius;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
- (id)initWithSettings:(id)arg1;
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end


@interface CSCoverSheetViewController : UIViewController
@property (nonatomic, strong) UIView *blurView;
- (void)unleashThatLSBlur;
- (void)showBlurIfNotifsPresent;
@end


@interface SBHomeScreenViewController : UIViewController
- (void)unleashThatHSBlur;
@end




static void loadPrefs() {


	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:takeMeThere];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	
	lsBlur = prefs[@"lsBlur"] ? [prefs[@"lsBlur"] boolValue] : NO;
	epicLSBlur = prefs[@"epicLSBlur"] ? [prefs[@"epicLSBlur"] boolValue] : NO;
	blurIfNotifs = prefs[@"blurIfNotifs"] ? [prefs[@"blurIfNotifs"] boolValue] : NO;
	lsBlurType = prefs[@"lsBlurType"] ? [prefs[@"lsBlurType"] integerValue] : 0;
	lsIntensity = prefs[@"lsIntensity"] ? [prefs[@"lsIntensity"] floatValue] : 1.0f;
	epicLSBlurIntensity = prefs[@"epicLSBlurIntensity"] ? [prefs[@"epicLSBlurIntensity"] floatValue] : 1.0f;


	hsBlur = prefs[@"hsBlur"] ? [prefs[@"hsBlur"] boolValue] : NO;
	epicHSBlur = prefs[@"epicHSBlur"] ? [prefs[@"epicHSBlur"] boolValue] : NO;
	blurType = prefs[@"blurType"] ? [prefs[@"blurType"] integerValue] : 0;
	hsIntensity = prefs[@"hsIntensity"] ? [prefs[@"hsIntensity"] floatValue] : 1.0f;
	epicHSBlurIntensity = prefs[@"epicHSBlurIntensity"] ? [prefs[@"epicHSBlurIntensity"] floatValue] : 1.0f;


}




%hook NCNotificationMasterList


- (unsigned long long)notificationCount { // get notifications count


	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

    notificationCount = %orig;

    return notificationCount;


}


%end




%hook CSCoverSheetViewController


%property (nonatomic, strong) UIView *blurView;


%new


- (void)unleashThatLSBlur { // self explanatory


	loadPrefs();

	[[self.view viewWithTag:1337] removeFromSuperview];


	if(lsBlur) {


		switch(lsBlurType) {


			case 1:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				break;


			case 2:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
				break;


			case 3:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
				break;


			case 4:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterial];
				break;


			case 5:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
				break;


			case 6:

				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
				break;


			default:
    	
				lsBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				break;


		}


		UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:lsBlurEffect];
		blurEffectView.tag = 1337;
		blurEffectView.alpha = lsIntensity;
		blurEffectView.frame = self.view.bounds;
		blurEffectView.clipsToBounds = YES;
		blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view insertSubview:blurEffectView atIndex:0];

		self.blurView = blurEffectView;


	}


	else if(epicLSBlur) {


		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

		_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		blurView.blurRadiusSetOnce = NO;
		blurView._blurRadius = 80.0;
		blurView._blurQuality = @"high";
		blurView.tag = 1337;
		blurView.alpha = epicLSBlurIntensity;
		[self.view insertSubview:blurView atIndex:0];
		
		self.blurView = blurView;


	}

	
	if(self.blurView) [self showBlurIfNotifsPresent];


}


%new


- (void)showBlurIfNotifsPresent { // self explanatory
	

	loadPrefs();


	if(!blurIfNotifs) self.blurView.hidden = NO; 


	else {

 		
 		if(notificationCount == 0) {


			[UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

				self.blurView.alpha = 0;

			} completion:nil];

		} else {


			[UIView transitionWithView:self.blurView duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
				
				self.blurView.alpha = epicLSBlurIntensity;
            
			} completion:nil];

		}

	}

}


- (void)viewDidLoad { // create notification observers


	%orig;


	[self unleashThatLSBlur];


	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(unleashThatLSBlur) name:@"lsBlurApplied" object:nil];
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(showBlurIfNotifsPresent) name:@"notifArrivedSoApplyingBlurNow" object:nil];


}


%end




%hook SBHomeScreenViewController


%new


- (void)unleashThatHSBlur { // self explanatory


	loadPrefs();

	[[self.view viewWithTag:1337] removeFromSuperview];


	if(hsBlur) {


		switch(blurType) {


			case 1:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				break;


			case 2:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
				break;


			case 3:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
				break;


			case 4:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterial];
				break;


			case 5:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
				break;


			case 6:

				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
				break;


			default:
    	
				hsBlurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				break;


		}


		UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:hsBlurType];
		blurEffectView.tag = 1337;
		blurEffectView.alpha = hsIntensity;
		blurEffectView.frame = self.view.bounds;
		blurEffectView.clipsToBounds = YES;
		blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view insertSubview:blurEffectView atIndex:0];


	}


	if(!(hsBlur) && (epicHSBlur)) {


		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

		_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero
		autosizesToFitSuperview:YES settings:settings];
		blurView.blurRadiusSetOnce = NO;
		blurView._blurRadius = 80.0;
		blurView._blurQuality = @"high";
		blurView.tag = 1337;
		blurView.alpha = epicHSBlurIntensity;
		[self.view insertSubview:blurView atIndex:0];


	}

}


- (void)viewDidLoad { // create notification observers


	%orig;

	[self unleashThatHSBlur];

	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(unleashThatHSBlur) name:@"hsBlurApplied" object:nil];


}


%end




%ctor {

	loadPrefs();

}
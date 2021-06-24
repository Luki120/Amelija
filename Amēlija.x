#import <UIKit/UIKit.h>




// LS


static BOOL lsBlur;
static BOOL epicLSBlur;
static BOOL blurIfNotifs;

static int lsBlurType;

float lsIntensity = 1.0f;
float epicLSBlurIntensity = 1.0f;

UIBlurEffect* lsBlurEffect;


// HS


static BOOL hsBlur;
static BOOL epicHSBlur;

static int blurType;

float hsIntensity = 1.0f;
float epicHSBlurIntensity = 1.0f;

UIBlurEffect* hsBlurType;


static int notificationCount;


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
- (void)unleashThatLSBlur;
- (void)showBlurIfNotifsPresent;
@property (nonatomic, strong) UIView *testView;
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


    notificationCount = %orig;

    return notificationCount;

}


%end




%hook CSCoverSheetViewController


%new





- (void)unleashThatLSBlur {


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
		[self.view insertSubview:blurEffectView atIndex:1];


	}


	if(!lsBlur) {


		if(epicLSBlur) {


			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

			_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero
			autosizesToFitSuperview:YES settings:settings];
			blurView.blurRadiusSetOnce = NO;
			blurView._blurRadius = 80.0;
			blurView._blurQuality = @"high";
			blurView.tag = 1337;
			blurView.alpha = epicLSBlurIntensity;
			[self.view insertSubview:blurView atIndex:1];


		}

	}

}


%new


%property (nonatomic, strong) UIView *testView;


- (void)showBlurIfNotifsPresent {


	loadPrefs();

	[[self.view viewWithTag:120] removeFromSuperview];


	if((blurIfNotifs) && (notificationCount > 0)) {


		self.testView = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,100)];
		self.testView.tag = 120;
		self.testView.backgroundColor = [UIColor redColor];


		[self.view addSubview: self.testView];


	}

}


- (void)viewDidLoad {


	%orig;


	[self unleashThatLSBlur];
	[self showBlurIfNotifsPresent];


	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(unleashThatLSBlur) name:@"lsBlurApplied" object:nil];
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(showBlurIfNotifsPresent) name:@"notifArrivedSoApplyingBlurNow" object:nil];


}


%end




%hook SBHomeScreenViewController


%new


- (void)unleashThatHSBlur {


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


	if(!hsBlur) {


		if(epicHSBlur) {


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

}


- (void)viewDidLoad {


	%orig;

	[self unleashThatHSBlur];

	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(unleashThatHSBlur) name:@"hsBlurApplied" object:nil];


}


%end




%ctor {

	loadPrefs();

}
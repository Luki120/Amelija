#import <UIKit/UIKit.h>




static BOOL lsBlur;
static BOOL hsBlur;
static BOOL epicBlur;
static int blurType;
float intensity = 1.0f;




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
@end


@interface SBHomeScreenViewController : UIViewController
@end




static void loadPrefs() {


    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:takeMeThere];
    NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
    lsBlur = prefs[@"lsBlur"] ? [prefs[@"lsBlur"] boolValue] : NO;
	hsBlur = prefs[@"hsBlur"] ? [prefs[@"hsBlur"] boolValue] : NO;
	epicBlur = prefs[@"epicBlur"] ? [prefs[@"epicBlur"] boolValue] : NO;
	blurType = prefs[@"blurType"] ? [prefs[@"blurType"] integerValue] : 0;
	intensity = prefs[@"intensity"] ? [prefs[@"intensity"] floatValue] : 1.0f;


}




%hook CSCoverSheetViewController


- (void)viewDidLoad {


	loadPrefs();

    %orig;


	if(lsBlur) {


    	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

		_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero
		autosizesToFitSuperview:YES settings:settings];
		blurView.blurRadiusSetOnce = NO;
		blurView._blurRadius = 80.0;
		blurView._blurQuality = @"high";
		blurView.alpha = 0.95;
		[self.view insertSubview:blurView atIndex:0];


	}

}


%end




%hook SBHomeScreenViewController


- (void)viewDidLoad {


	loadPrefs();

	%orig;


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
		blurEffectView.alpha = intensity;
		blurEffectView.frame = self.view.bounds;
    	[blurEffectView setClipsToBounds:YES];
		blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view insertSubview:blurEffectView atIndex:0];


	}


	if(!hsBlur) {


		if(epicBlur) {


			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

			_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero
			autosizesToFitSuperview:YES settings:settings];
			blurView.blurRadiusSetOnce = NO;
			blurView._blurRadius = 80.0;
			blurView._blurQuality = @"high";
			blurView.alpha = intensity;
			[self.view insertSubview:blurView atIndex:0];

		}

	}

}


%end




%ctor {


	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:takeMeThere];
    NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
    lsBlur = prefs[@"lsBlur"] ? [prefs[@"lsBlur"] boolValue] : NO;
	hsBlur = prefs[@"hsBlur"] ? [prefs[@"hsBlur"] boolValue] : NO;
	epicBlur = prefs[@"epicBlur"] ? [prefs[@"epicBlur"] boolValue] : NO;
	blurType = prefs[@"blurType"] ? [prefs[@"blurType"] integerValue] : 0;
	intensity = prefs[@"intensity"] ? [prefs[@"intensity"] floatValue] : 1.0f;


}
#include "AMLRootListController.h"




// LS 


static BOOL lsBlur;
static BOOL epicLSBlur;

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


static NSString *takeMeThere = @"/var/mobile/Library/Preferences/me.luki.amēlijaprefs.plist";

#define tint [UIColor colorWithRed: 0.47 green: 0.21 blue: 0.24 alpha: 1.00]



@implementation AMLRootListController


- (void)loadPrefs {


	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:takeMeThere];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	lsBlur = prefs[@"lsBlur"] ? [prefs[@"lsBlur"] boolValue] : NO;
	epicLSBlur = prefs[@"epicLSBlur"] ? [prefs[@"epicLSBlur"] boolValue] : NO;
	lsBlurType = prefs[@"lsBlurType"] ? [prefs[@"lsBlurType"] integerValue] : 0;
	lsIntensity = prefs[@"lsIntensity"] ? [prefs[@"lsIntensity"] floatValue] : 1.0f;
	epicLSBlurIntensity = prefs[@"epicLSBlurIntensity"] ? [prefs[@"epicLSBlurIntensity"] floatValue] : 1.0f;
	hsBlur = prefs[@"hsBlur"] ? [prefs[@"hsBlur"] boolValue] : NO;
	epicHSBlur = prefs[@"epicHSBlur"] ? [prefs[@"epicHSBlur"] boolValue] : NO;
	blurType = prefs[@"blurType"] ? [prefs[@"blurType"] integerValue] : 0;
	hsIntensity = prefs[@"hsIntensity"] ? [prefs[@"hsIntensity"] floatValue] : 1.0f;
	epicHSBlurIntensity = prefs[@"epicHSBlurIntensity"] ? [prefs[@"epicHSBlurIntensity"] floatValue] : 1.0f;


}


- (NSArray *)specifiers {

	if (!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

	}

	return _specifiers;

}


- (id)readPreferenceValue:(PSSpecifier*)specifier {

    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:takeMeThere]];
    return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {

    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:takeMeThere]];
    [settings setObject:value forKey:specifier.properties[@"key"]];
    [settings writeToFile:takeMeThere atomically:YES];
	CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];

	if (notificationName) {

		[self loadPrefs];
		
	}

}

@end




@implementation LSRootListController


- (NSArray *)specifiers {

	if (!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"LS" target:self];

	}

	return _specifiers;

}


@end


@implementation HSRootListController


- (NSArray *)specifiers {

	if (!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"HS" target:self];

	}

	return _specifiers;

}


@end




@implementation AmelijaLinksRootListController


- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"AmelijaLinks" target:self];
    }

    return _specifiers;
}


- (void)discord {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"] options:@{} completionHandler:nil];


}


- (void)paypal {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];


}


- (void)github {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/Luki120/April"] options:@{} completionHandler:nil];


}


- (void)april {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.april"] options:@{} completionHandler:nil];


}


- (void)arizona {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.arizona"] options:@{} completionHandler:nil];


}


@end




@implementation AmelijaContributorsRootListController


- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"AmelijaContributors" target:self];
	}

	return _specifiers;
}


- (void)luki {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/Lukii120"] options:@{} completionHandler:nil];


}


- (void)ethn {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/ethanwhited"] options:@{} completionHandler:nil];


}


- (void)ben {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/BenOwl3"] options:@{} completionHandler:nil];


}


- (void)GCGamer {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/mrgcgamer"] options:@{} completionHandler:nil];


}


@end




@implementation AmelijaTableCell


- (void)tintColorDidChange {

    [super tintColorDidChange];

    self.textLabel.textColor = tint;
    self.textLabel.highlightedTextColor = tint;

}


- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {

    [super refreshCellContentsWithSpecifier:specifier];

    if ([self respondsToSelector:@selector(tintColor)]) {

        self.textLabel.textColor = tint;
        self.textLabel.highlightedTextColor = tint;

    }
}


@end
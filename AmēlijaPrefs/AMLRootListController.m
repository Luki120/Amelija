#include "AMLRootListController.h"




static BOOL lsBlur;
static BOOL hsBlur;
static BOOL epicBlur;
static int blurType;
float intensity = 1.0f;


static NSString *takeMeThere = @"/var/mobile/Library/Preferences/me.luki.amēlijaprefs.plist";




@implementation AMLRootListController


- (void)loadPrefs {


    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:takeMeThere];
    NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
    lsBlur = prefs[@"lsBlur"] ? [prefs[@"lsBlur"] boolValue] : NO;
	hsBlur = prefs[@"hsBlur"] ? [prefs[@"hsBlur"] boolValue] : NO;
    epicBlur = prefs[@"epicBlur"] ? [prefs[@"epicBlur"] boolValue] : NO;
    blurType = prefs[@"blurType"] ? [prefs[@"blurType"] integerValue] : 0;
    intensity = prefs[@"intensity"] ? [prefs[@"intensity"] floatValue] : 1.0f;


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
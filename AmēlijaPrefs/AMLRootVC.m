#import "AMLRootVC.h"


@implementation AMLRootVC {

	UITableView *_table;
	UIImageView *iconView;
	UIView *headerView;
	UIImageView *headerImageView;
	OBWelcomeController *changelogController;

}


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

	return _specifiers;

}


- (id)init {

	self = [super init];

	if(self) [self setupUI];

	return self;

}


- (void)setupUI {

	UIImage *icon = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AmēlijaPrefs.bundle/Assets/Amēlija@2x.png"];
	UIImage *banner = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AmēlijaPrefs.bundle/Assets/AMBanner.png"];

	headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
	headerImageView = [UIImageView new];
	headerImageView.image = banner;
	headerImageView.contentMode = UIViewContentModeScaleAspectFill;
	headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	[headerView addSubview:headerImageView];

	UIButton *changelogButton =  [UIButton buttonWithType:UIButtonTypeCustom];
	changelogButton.tintColor = AmelijaTintColor;
	[changelogButton setImage : [UIImage systemImageNamed:@"atom"] forState:UIControlStateNormal];
	[changelogButton addTarget : self action:@selector(showWtfChangedInThisVersion) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changelogButton];
	self.navigationItem.rightBarButtonItem = changelogButtonItem;

	self.navigationItem.titleView = [UIView new];
	iconView = [UIImageView new];
	iconView.image = icon;
	iconView.contentMode = UIViewContentModeScaleAspectFit;
	iconView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.navigationItem.titleView addSubview:iconView];

	_table.tableHeaderView = headerView;

	[self layoutUI];

}


- (void)layoutUI {

	[iconView.topAnchor constraintEqualToAnchor : self.navigationItem.titleView.topAnchor].active = YES;
	[iconView.bottomAnchor constraintEqualToAnchor : self.navigationItem.titleView.bottomAnchor].active = YES;
	[iconView.leadingAnchor constraintEqualToAnchor : self.navigationItem.titleView.leadingAnchor].active = YES;
	[iconView.trailingAnchor constraintEqualToAnchor : self.navigationItem.titleView.trailingAnchor].active = YES;

	[headerImageView.topAnchor constraintEqualToAnchor : headerView.topAnchor].active = YES;
	[headerImageView.bottomAnchor constraintEqualToAnchor : headerView.bottomAnchor].active = YES;
	[headerImageView.leadingAnchor constraintEqualToAnchor : headerView.leadingAnchor].active = YES;
	[headerImageView.trailingAnchor constraintEqualToAnchor : headerView.trailingAnchor].active = YES;

}


- (void)showWtfChangedInThisVersion {

	AudioServicesPlaySystemSound(1521);

	UIImage *tweakIconImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AmēlijaPrefs.bundle/Assets/AMHotIcon.png"];
	UIImage *checkmarkImage = [UIImage systemImageNamed:@"checkmark.circle.fill"];

	changelogController = [[OBWelcomeController alloc] initWithTitle:@"Amēlija" detailText:@"1.0.7" icon:tweakIconImage];

	[changelogController addBulletedListItemWithTitle:@"Code" description:@"Fixed contributors & links page." image:checkmarkImage];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	backdropView.translatesAutoresizingMaskIntoConstraints = NO;
	[changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];

	[backdropView.topAnchor constraintEqualToAnchor : changelogController.viewIfLoaded.topAnchor].active = YES;
	[backdropView.bottomAnchor constraintEqualToAnchor : changelogController.viewIfLoaded.bottomAnchor].active = YES;
	[backdropView.leadingAnchor constraintEqualToAnchor : changelogController.viewIfLoaded.leadingAnchor].active = YES;
	[backdropView.trailingAnchor constraintEqualToAnchor : changelogController.viewIfLoaded.trailingAnchor].active = YES;

	changelogController.modalInPresentation = NO;
	changelogController.modalPresentationStyle = UIModalPresentationPageSheet;
	changelogController.view.tintColor = AmelijaTintColor;
	changelogController.viewIfLoaded.backgroundColor = UIColor.clearColor;
	[self presentViewController:changelogController animated:YES completion:nil];

}


- (void)shatterThePrefsToPieces {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Amēlija" message:@"Do you want to start fresh?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Shoot" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

		NSFileManager *fileM = [NSFileManager defaultManager];

		BOOL success = [fileM removeItemAtPath:@"var/mobile/Library/Preferences/me.luki.amēlijaprefs.plist" error:nil];

		if(success) [self crossDissolveBlur];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Meh" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction:confirmAction];
	[alertController addAction:cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)crossDissolveBlur {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.alpha = 0;
	backdropView.frame = self.view.bounds;
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	[self.view addSubview:backdropView];

	[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		backdropView.alpha = 1;

	} completion:^(BOOL finished) {

		[self launchRespring];

	}];

}


- (void)launchRespring {

	pid_t pid;
	const char* args[] = {"sbreload", NULL, NULL, NULL};
	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:takeMeThere]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:takeMeThere]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:takeMeThere atomically:YES];

}


// Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	tableView.tableHeaderView = headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}


@end


@implementation LSRootVC


- (NSArray *)specifiers {

	if(!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"LS" target:self];

		NSArray *chosenIDs = @[@"GroupCell-3", @"MiscLSBlursList", @"GroupCell-4", @"SliderCell-2", @"GroupCell-5", @"BlurOnlyWithNotifsSwitch"];

		self.savedSpecifiers = (self.savedSpecifiers) ?: [NSMutableDictionary new];

		for(PSSpecifier *specifier in _specifiers)

			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	}

	return _specifiers;

}


- (void)reloadSpecifiers { // Dynamic specifiers

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"MiscLSBlursSwitch"]] boolValue]) {

		[self removeSpecifier:self.savedSpecifiers[@"GroupCell-3"] animated:NO];
		[self removeSpecifier:self.savedSpecifiers[@"MiscLSBlursList"] animated:NO];
		[self removeSpecifier:self.savedSpecifiers[@"GroupCell-4"] animated:NO];
		[self removeSpecifier:self.savedSpecifiers[@"SliderCell-2"] animated:NO];
		[self removeSpecifier:self.savedSpecifiers[@"GroupCell-5"] animated:NO];
		[self removeSpecifier:self.savedSpecifiers[@"BlurOnlyWithNotifsSwitch"] animated:NO];

	}

	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-3"]]) {

		[self insertSpecifier:self.savedSpecifiers[@"GroupCell-3"] afterSpecifierID:@"MiscLSBlursSwitch" animated:NO];
		[self insertSpecifier:self.savedSpecifiers[@"MiscLSBlursList"] afterSpecifierID:@"GroupCell-3" animated:NO];
		[self insertSpecifier:self.savedSpecifiers[@"GroupCell-4"] afterSpecifierID:@"MiscLSBlursList" animated:NO];
		[self insertSpecifier:self.savedSpecifiers[@"SliderCell-2"] afterSpecifierID:@"GroupCell-4" animated:NO];
		[self insertSpecifier:self.savedSpecifiers[@"GroupCell-5"] afterSpecifierID:@"SliderCell-2" animated:NO];
		[self insertSpecifier:self.savedSpecifiers[@"BlurOnlyWithNotifsSwitch"] afterSpecifierID:@"GroupCell-5" animated:NO];

	}

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:takeMeThere]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:takeMeThere]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:takeMeThere atomically:YES];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"lsBlurApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"lsBlur"]) {

		if(![value boolValue]) {

			[self removeSpecifier:self.savedSpecifiers[@"GroupCell-3"] animated:YES];
			[self removeSpecifier:self.savedSpecifiers[@"MiscLSBlursList"] animated:YES];
			[self removeSpecifier:self.savedSpecifiers[@"GroupCell-4"] animated:YES];
			[self removeSpecifier:self.savedSpecifiers[@"SliderCell-2"] animated:YES];
			[self removeSpecifier:self.savedSpecifiers[@"GroupCell-5"] animated:YES];
			[self removeSpecifier:self.savedSpecifiers[@"BlurOnlyWithNotifsSwitch"] animated:YES];

		}

		else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-3"]]) {

			[self insertSpecifier:self.savedSpecifiers[@"GroupCell-3"] afterSpecifierID:@"MiscLSBlursSwitch" animated:YES];
			[self insertSpecifier:self.savedSpecifiers[@"MiscLSBlursList"] afterSpecifierID:@"GroupCell-3" animated:YES];
			[self insertSpecifier:self.savedSpecifiers[@"GroupCell-4"] afterSpecifierID:@"MiscLSBlursList" animated:YES];
			[self insertSpecifier:self.savedSpecifiers[@"SliderCell-2"] afterSpecifierID:@"GroupCell-4" animated:YES];
			[self insertSpecifier:self.savedSpecifiers[@"GroupCell-5"] afterSpecifierID:@"SliderCell-2" animated:YES];
			[self insertSpecifier:self.savedSpecifiers[@"BlurOnlyWithNotifsSwitch"] afterSpecifierID:@"GroupCell-5" animated:YES];

		}

	}

}


@end


@implementation HSRootVC


- (NSArray *)specifiers {

	if(!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"HS" target:self];

		NSArray *chosenIDs = @[@"GroupCell-7", @"MiscHSBlursList", @"GroupCell-8", @"SliderCell-4"];

		self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];

		for(PSSpecifier *specifier in _specifiers)

			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	}

	return _specifiers;

}


- (void)reloadSpecifiers { // Dynamic specifiers

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"MiscHSBlursSwitch"]] boolValue]) {

		[self removeSpecifier:self.savedSpecifiers[@"GroupCell-7"] animated:NO];
		[self removeSpecifier:self.savedSpecifiers[@"MiscHSBlursList"] animated:NO];
		[self removeSpecifier:self.savedSpecifiers[@"GroupCell-8"] animated:NO];
		[self removeSpecifier:self.savedSpecifiers[@"SliderCell-4"] animated:NO];

	}

	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-7"]]) {

		[self insertSpecifier:self.savedSpecifiers[@"GroupCell-7"] afterSpecifierID:@"MiscHSBlursSwitch" animated:NO];
		[self insertSpecifier:self.savedSpecifiers[@"MiscHSBlursList"] afterSpecifierID:@"GroupCell-7" animated:NO];
		[self insertSpecifier:self.savedSpecifiers[@"GroupCell-8"] afterSpecifierID:@"MiscHSBlursList" animated:NO];
		[self insertSpecifier:self.savedSpecifiers[@"SliderCell-4"] afterSpecifierID:@"GroupCell-8" animated:NO];

	}

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:takeMeThere]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:takeMeThere]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:takeMeThere atomically:YES];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"hsBlurApplied" object:nil];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"hsBlur"]) {

		if(![value boolValue]) {

			[self removeSpecifier:self.savedSpecifiers[@"GroupCell-7"] animated:YES];
			[self removeSpecifier:self.savedSpecifiers[@"MiscHSBlursList"] animated:YES];
			[self removeSpecifier:self.savedSpecifiers[@"GroupCell-8"] animated:YES];
			[self removeSpecifier:self.savedSpecifiers[@"SliderCell-4"] animated:YES];

		}

		else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-7"]]) {

			[self insertSpecifier:self.savedSpecifiers[@"GroupCell-7"] afterSpecifierID:@"MiscHSBlursSwitch" animated:YES];
			[self insertSpecifier:self.savedSpecifiers[@"MiscHSBlursList"] afterSpecifierID:@"GroupCell-7" animated:YES];
			[self insertSpecifier:self.savedSpecifiers[@"GroupCell-8"] afterSpecifierID:@"MiscHSBlursList" animated:YES];
			[self insertSpecifier:self.savedSpecifiers[@"SliderCell-4"] afterSpecifierID:@"GroupCell-8" animated:YES];

		}

	}

}


@end


@implementation AmelijaContributorsVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"AmelijaContributors" target:self];

	return _specifiers;

}


@end


@implementation AmelijaLinksVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"AmelijaLinks" target:self];

	return _specifiers;

}


- (void)launchDiscord {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"] options:@{} completionHandler:nil];

}


- (void)launchPayPal {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];

}


- (void)launchGitHub {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://github.com/Luki120/Amelija"] options:@{} completionHandler:nil];

}


- (void)launchApril {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.april"] options:@{} completionHandler:nil];

}


- (void)launchMeredith {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.meredith"] options:@{} completionHandler:nil];

}


@end


@implementation AmelijaTableCell


- (void)setTitle:(NSString *)t {

	[super setTitle:t];

	self.titleLabel.textColor = AmelijaTintColor;

}


@end

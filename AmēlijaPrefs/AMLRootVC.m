#import "AMLRootVC.h"


@implementation AMLRootVC {

	UIView *headerView;
	UIImageView *iconView;
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
	headerImageView.clipsToBounds = YES;
	headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	[headerView addSubview: headerImageView];

	UIButton *changelogButton =  [UIButton new];
	changelogButton.tintColor = kAmelijaTintColor;
	[changelogButton setImage:[UIImage systemImageNamed:@"atom"] forState: UIControlStateNormal];
	[changelogButton addTarget:self action:@selector(showWtfChangedInThisVersion) forControlEvents: UIControlEventTouchUpInside];

	UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView: changelogButton];
	self.navigationItem.rightBarButtonItem = changelogButtonItem;

	self.navigationItem.titleView = [UIView new];
	iconView = [UIImageView new];
	iconView.image = icon;
	iconView.contentMode = UIViewContentModeScaleAspectFit;
	iconView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.navigationItem.titleView addSubview: iconView];

	[self layoutUI];

}


- (void)layoutUI {

	[iconView.topAnchor constraintEqualToAnchor: self.navigationItem.titleView.topAnchor].active = YES;
	[iconView.bottomAnchor constraintEqualToAnchor: self.navigationItem.titleView.bottomAnchor].active = YES;
	[iconView.leadingAnchor constraintEqualToAnchor: self.navigationItem.titleView.leadingAnchor].active = YES;
	[iconView.trailingAnchor constraintEqualToAnchor: self.navigationItem.titleView.trailingAnchor].active = YES;

	[headerImageView.topAnchor constraintEqualToAnchor: headerView.topAnchor].active = YES;
	[headerImageView.bottomAnchor constraintEqualToAnchor: headerView.bottomAnchor].active = YES;
	[headerImageView.leadingAnchor constraintEqualToAnchor: headerView.leadingAnchor].active = YES;
	[headerImageView.trailingAnchor constraintEqualToAnchor: headerView.trailingAnchor].active = YES;

}


- (void)showWtfChangedInThisVersion {

	AudioServicesPlaySystemSound(1521);

	UIImage *tweakIconImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AmēlijaPrefs.bundle/Assets/AMHotIcon.png"];
	UIImage *checkmarkImage = [UIImage systemImageNamed:@"checkmark.circle.fill"];

	changelogController = [[OBWelcomeController alloc] initWithTitle:@"Amēlija" detailText:@"1.1" icon:tweakIconImage];
	[changelogController addBulletedListItemWithTitle:@"Code" description:@"Refactoring." image:checkmarkImage];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	backdropView.translatesAutoresizingMaskIntoConstraints = NO;
	[changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];

	[backdropView.topAnchor constraintEqualToAnchor: changelogController.viewIfLoaded.topAnchor].active = YES;
	[backdropView.bottomAnchor constraintEqualToAnchor: changelogController.viewIfLoaded.bottomAnchor].active = YES;
	[backdropView.leadingAnchor constraintEqualToAnchor: changelogController.viewIfLoaded.leadingAnchor].active = YES;
	[backdropView.trailingAnchor constraintEqualToAnchor: changelogController.viewIfLoaded.trailingAnchor].active = YES;

	changelogController.modalInPresentation = NO;
	changelogController.modalPresentationStyle = UIModalPresentationPageSheet;
	changelogController.view.tintColor = kAmelijaTintColor;
	changelogController.viewIfLoaded.backgroundColor = UIColor.clearColor;
	[self presentViewController:changelogController animated:YES completion:nil];

}


- (void)shatterThePrefsToPieces {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Amēlija" message:@"Do you want to start fresh?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Shoot" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		NSFileManager *fileM = [NSFileManager defaultManager];

		[fileM removeItemAtPath:@"/var/mobile/Library/Preferences/me.luki.amēlijaprefs.plist" error:nil];
		[self crossDissolveBlur];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Meh" style:UIAlertActionStyleDefault handler:nil];

	[alertController addAction: confirmAction];
	[alertController addAction: cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)crossDissolveBlur {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.alpha = 0;
	backdropView.frame = self.view.bounds;
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	[self.view addSubview: backdropView];

	[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		backdropView.alpha = 1;

	} completion:^(BOOL finished) { [self launchRespring]; }];

}


- (void)launchRespring {

	pid_t pid;
	const char* args[] = {"sbreload", NULL, NULL, NULL};
	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPath atomically:YES];

	[super setPreferenceValue:value specifier:specifier];

}


// Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	tableView.tableHeaderView = headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}

@end


@implementation LSRootVC

- (NSArray *)specifiers {

	if(_specifiers) return nil;
	_specifiers = [self loadSpecifiersFromPlistName:@"LS" target:self];

	NSArray *chosenIDs = @[
		@"GroupCell-1",
		@"MiscLSBlursList",
		@"GroupCell-2",
		@"BlurSliderCell",
		@"GroupCell-3",
		@"BlurOnlyWithNotifsSwitch"
	];

	self.savedSpecifiers = self.savedSpecifiers ?: [NSMutableDictionary new];

	for(PSSpecifier *specifier in _specifiers)

		if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

			[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	return _specifiers;

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


- (void)reloadSpecifiers { // Dynamic specifiers

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"MiscLSBlursSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"MiscLSBlursList"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"BlurSliderCell"], self.savedSpecifiers[@"GroupCell-3"], self.savedSpecifiers[@"BlurOnlyWithNotifsSwitch"]] animated:NO];

	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"MiscLSBlursList"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"BlurSliderCell"], self.savedSpecifiers[@"GroupCell-3"], self.savedSpecifiers[@"BlurOnlyWithNotifsSwitch"]] afterSpecifierID:@"MiscLSBlursSwitch" animated:NO];

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPath atomically:YES];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"lsBlurApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"notifArrivedSoApplyingBlurNow" object:nil];

	[super setPreferenceValue:value specifier:specifier];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"lsBlur"]) {

		if(![value boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"MiscLSBlursList"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"BlurSliderCell"], self.savedSpecifiers[@"GroupCell-3"], self.savedSpecifiers[@"BlurOnlyWithNotifsSwitch"]] animated:YES];

		else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"MiscLSBlursList"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"BlurSliderCell"], self.savedSpecifiers[@"GroupCell-3"], self.savedSpecifiers[@"BlurOnlyWithNotifsSwitch"]] afterSpecifierID:@"MiscLSBlursSwitch" animated:YES];

	}

}

@end


@implementation HSRootVC

- (NSArray *)specifiers {

	if(_specifiers) return nil;
	_specifiers = [self loadSpecifiersFromPlistName:@"HS" target:self];

	NSArray *chosenIDs = @[
		@"GroupCell-1",
		@"MiscHSBlursList",
		@"GroupCell-2",
		@"BlurSliderCell"
	];

	self.savedSpecifiers = self.savedSpecifiers ?: [NSMutableDictionary new];

	for(PSSpecifier *specifier in _specifiers)

		if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

			[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	return _specifiers;

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


- (void)reloadSpecifiers { // Dynamic specifiers

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"MiscHSBlursSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"MiscHSBlursList"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"BlurSliderCell"]] animated:NO];

	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"MiscHSBlursList"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"BlurSliderCell"]] afterSpecifierID:@"MiscHSBlursSwitch" animated:NO];


}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPath]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPath atomically:YES];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"hsBlurApplied" object:nil];

	[super setPreferenceValue:value specifier:specifier];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"hsBlur"]) {

		if(![value boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"MiscHSBlursList"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"BlurSliderCell"]] animated:YES];

		else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"MiscHSBlursList"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"BlurSliderCell"]] afterSpecifierID:@"MiscHSBlursSwitch" animated:YES];

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
	self.titleLabel.textColor = kAmelijaTintColor;

}

@end

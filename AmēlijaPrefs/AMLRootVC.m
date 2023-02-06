#import "AMLRootVC.h"


#define kAmelijaTintColor [UIColor colorWithRed:0.47 green:0.21 blue:0.24 alpha: 1.0]

@implementation AMLRootVC {

	UIView *headerView;
	UIImageView *iconImageView;
	UIImageView *headerImageView;
	NSString *xinaPath;
	OBWelcomeController *changelogController;

}

// ! Lifecycle

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	return _specifiers;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^{ registerAmelijaTintCellClass(); });

	xinaPath = [[NSFileManager defaultManager] fileExistsAtPath: @"/var/jb/"] ? @"/var/jb/" : @"";
	[self setupUI];

	return self;

}


- (void)setupUI {

	NSString *bannerImagePath = [NSString stringWithFormat:@"%@Library/PreferenceBundles/AmēlijaPrefs.bundle/Assets/AMBanner.png", xinaPath];

	UIImage *iconImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AmēlijaPrefs.bundle/Assets/Amēlija@2x.png"];
	UIImage *bannerImage = [UIImage imageWithContentsOfFile: bannerImagePath];

	if(!headerView) headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];

	if(!headerImageView) {
		headerImageView = [UIImageView new];
		headerImageView.image = bannerImage;
		headerImageView.contentMode = UIViewContentModeScaleAspectFill;
		headerImageView.clipsToBounds = YES;
		headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
		[headerView addSubview: headerImageView];
	}

	UIButton *changelogButton =  [UIButton new];
	changelogButton.tintColor = kAmelijaTintColor;
	[changelogButton setImage:[UIImage systemImageNamed:@"atom"] forState: UIControlStateNormal];
	[changelogButton addTarget:self action:@selector(showWtfChangedInThisVersion) forControlEvents: UIControlEventTouchUpInside];

	UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView: changelogButton];
	self.navigationItem.rightBarButtonItem = changelogButtonItem;

	self.navigationItem.titleView = [UIView new];

	if(!iconImageView) {
		iconImageView = [UIImageView new];
		iconImageView.image = iconImage;
		iconImageView.contentMode = UIViewContentModeScaleAspectFit;
		iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.navigationItem.titleView addSubview: iconImageView];
	}

	[self layoutUI];

}


- (void)layoutUI {

	[iconImageView.topAnchor constraintEqualToAnchor: self.navigationItem.titleView.topAnchor].active = YES;
	[iconImageView.bottomAnchor constraintEqualToAnchor: self.navigationItem.titleView.bottomAnchor].active = YES;
	[iconImageView.leadingAnchor constraintEqualToAnchor: self.navigationItem.titleView.leadingAnchor].active = YES;
	[iconImageView.trailingAnchor constraintEqualToAnchor: self.navigationItem.titleView.trailingAnchor].active = YES;

	[headerImageView.topAnchor constraintEqualToAnchor: headerView.topAnchor].active = YES;
	[headerImageView.bottomAnchor constraintEqualToAnchor: headerView.bottomAnchor].active = YES;
	[headerImageView.leadingAnchor constraintEqualToAnchor: headerView.leadingAnchor].active = YES;
	[headerImageView.trailingAnchor constraintEqualToAnchor: headerView.trailingAnchor].active = YES;

}

// ! Selectors

- (void)showWtfChangedInThisVersion {

	AudioServicesPlaySystemSound(1521);

	NSString *tweakIconImagePath = [NSString stringWithFormat: @"%@Library/PreferenceBundles/AmēlijaPrefs.bundle/Assets/AMHotIcon.png", xinaPath];

	UIImage *tweakIconImage = [UIImage imageWithContentsOfFile: tweakIconImagePath];
	UIImage *checkmarkImage = [UIImage systemImageNamed:@"checkmark.circle.fill"];

	if(changelogController) { [self presentViewController:changelogController animated:YES completion:nil]; return; }
	changelogController = [[OBWelcomeController alloc] initWithTitle:@"Amēlija" detailText:@"1.2" icon:tweakIconImage];
	[changelogController addBulletedListItemWithTitle:@"Code" description:@"Refactoring ⇝ everything works the same, but better." image:checkmarkImage];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	backdropView.clipsToBounds = YES;
	[changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];

	changelogController.viewIfLoaded.backgroundColor = UIColor.clearColor;
	changelogController.view.tintColor = kAmelijaTintColor;
	changelogController.modalInPresentation = NO;
	changelogController.modalPresentationStyle = UIModalPresentationPageSheet;
	[self presentViewController:changelogController animated:YES completion:nil];

}


- (void)shatterThePrefsToPieces {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Amēlija" message:@"Do you want to start fresh?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Shoot" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[[NSFileManager defaultManager] removeItemAtPath:kPath error:nil];
		[self crossDissolveBlur];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Meh" style:UIAlertActionStyleDefault handler:nil];

	[alertController addAction: confirmAction];
	[alertController addAction: cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)crossDissolveBlur {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView =  [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	backdropView.alpha = 0;
	backdropView.clipsToBounds = YES;
	[self.view addSubview: backdropView];

	[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		backdropView.alpha = 1;

	} completion:^(BOOL finished) { [self launchRespring]; }];

}


- (void)launchRespring {

	pid_t pid;
	const char* args[] = {"killall", "backboardd", NULL, NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);

}

// ! Preferences

- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	return settings[specifier.properties[@"key"]] ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPath atomically:YES];

	[super setPreferenceValue:value specifier:specifier];

}

// ! UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	tableView.tableHeaderView = headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}

// ! Dark juju

static void amelija_setTitle(PSTableCell *self, SEL _cmd, NSString *title) {

	struct objc_super superSetTitle = {
		self,
		[self superclass]
	};

	id (*superCall)(struct objc_super *, SEL, NSString *) = (void *)objc_msgSendSuper;
	superCall(&superSetTitle, _cmd, title);

	self.titleLabel.textColor = kAmelijaTintColor;
	self.titleLabel.highlightedTextColor = kAmelijaTintColor;

}

static void registerAmelijaTintCellClass() {

	Class AmelijaTintCellClass = objc_allocateClassPair([PSTableCell class], "AmelijaTintCell", 0);
	Method method = class_getInstanceMethod([PSTableCell class], @selector(setTitle:));
	const char *typeEncoding = method_getTypeEncoding(method);
	class_addMethod(AmelijaTintCellClass, @selector(setTitle:), (IMP) amelija_setTitle, typeEncoding);

	objc_registerClassPair(AmelijaTintCellClass);

}

@end


@implementation LSRootVC {

	NSMutableDictionary *savedSpecifiers;

}

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

	savedSpecifiers = savedSpecifiers ?: [NSMutableDictionary new];

	for(PSSpecifier *specifier in _specifiers)

		if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

			[savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	return _specifiers;

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

	[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self class]]].minimumTrackTintColor = kAmelijaTintColor;
	[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self class]]].onTintColor = kAmelijaTintColor;

}


- (void)reloadSpecifiers {

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"MiscLSBlursSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-1"], savedSpecifiers[@"MiscLSBlursList"], savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"BlurSliderCell"], savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"BlurOnlyWithNotifsSwitch"]] animated:NO];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-1"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-1"], savedSpecifiers[@"MiscLSBlursList"], savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"BlurSliderCell"], savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"BlurOnlyWithNotifsSwitch"]] afterSpecifierID:@"MiscLSBlursSwitch" animated:NO];

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

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:AmelijaLSBlurAppliedNotification object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:AmelijaNotificationArrivedNotification object:nil];

	[super setPreferenceValue:value specifier:specifier];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"lsBlur"]) {

		if(![value boolValue])

			[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-1"], savedSpecifiers[@"MiscLSBlursList"], savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"BlurSliderCell"], savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"BlurOnlyWithNotifsSwitch"]] animated:YES];

		else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-1"]])

			[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-1"], savedSpecifiers[@"MiscLSBlursList"], savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"BlurSliderCell"], savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"BlurOnlyWithNotifsSwitch"]] afterSpecifierID:@"MiscLSBlursSwitch" animated:YES];

	}

}

@end


@implementation HSRootVC {

	NSMutableDictionary *savedSpecifiers;

}

- (NSArray *)specifiers {

	if(_specifiers) return nil;
	_specifiers = [self loadSpecifiersFromPlistName:@"HS" target:self];

	NSArray *chosenIDs = @[
		@"GroupCell-1",
		@"MiscHSBlursList",
		@"GroupCell-2",
		@"BlurSliderCell"
	];

	savedSpecifiers = savedSpecifiers ?: [NSMutableDictionary new];

	for(PSSpecifier *specifier in _specifiers)

		if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

			[savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	return _specifiers;

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

	[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self class]]].minimumTrackTintColor = kAmelijaTintColor;
	[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self class]]].onTintColor = kAmelijaTintColor;

}


- (void)reloadSpecifiers { // Dynamic specifiers

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"MiscHSBlursSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-1"], savedSpecifiers[@"MiscHSBlursList"], savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"BlurSliderCell"]] animated:NO];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-1"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-1"], savedSpecifiers[@"MiscHSBlursList"], savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"BlurSliderCell"]] afterSpecifierID:@"MiscHSBlursSwitch" animated:NO];


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

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:AmelijaHSBlurAppliedNotification object:nil];

	[super setPreferenceValue:value specifier:specifier];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"hsBlur"]) {

		if(![value boolValue])

			[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-1"], savedSpecifiers[@"MiscHSBlursList"], savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"BlurSliderCell"]] animated:YES];

		else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-1"]])

			[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-1"], savedSpecifiers[@"MiscHSBlursList"], savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"BlurSliderCell"]] afterSpecifierID:@"MiscHSBlursSwitch" animated:YES];

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


- (void)launchDiscord { [self launchURL: [NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"]]; }
- (void)launchGitHub { [self launchURL: [NSURL URLWithString: @"https://github.com/Luki120/Amelija"]]; }
- (void)launchPayPal { [self launchURL: [NSURL URLWithString: @"https://paypal.me/Luki120"]]; }
- (void)launchApril { [self launchURL: [NSURL URLWithString:@"https://repo.twickd.com/get/com.twickd.luki120.april"]]; }
- (void)launchMeredith { [self launchURL: [NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.meredith"]]; }

- (void)launchURL:(NSURL *)url { [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil]; }

@end

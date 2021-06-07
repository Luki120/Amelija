#include "AMLRootListController.h"




static NSString *takeMeThere = @"/var/mobile/Library/Preferences/me.luki.amēlijaprefs.plist";

#define tint [UIColor colorWithRed: 0.47 green: 0.21 blue: 0.24 alpha: 1.00]



@implementation AMLRootListController


- (NSArray *)specifiers {

	if (!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		
	}

	return _specifiers;

}


- (void)viewDidLoad {


	[super viewDidLoad];


 	UIImage *banner = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AmēlijaPrefs.bundle/hotbanner.png"];

	self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,UIScreen.mainScreen.bounds.size.width,UIScreen.mainScreen.bounds.size.width * banner.size.height / banner.size.width)];
	self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
	self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.headerImageView.image = banner;
	self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;


	[self.headerView addSubview:self.headerImageView];


	UIButton *changelogButton =  [UIButton buttonWithType:UIButtonTypeCustom];
	changelogButton.frame = CGRectMake(0,0,30,30);
	changelogButton.layer.cornerRadius = changelogButton.frame.size.height / 2;
	changelogButton.layer.masksToBounds = YES;
	[changelogButton setImage:[UIImage systemImageNamed:@"atom"] forState:UIControlStateNormal];
	[changelogButton addTarget:self action:@selector(showWtfChangedInThisVersion:) forControlEvents:UIControlEventTouchUpInside];
	changelogButton.tintColor = [UIColor colorWithRed: 0.47 green: 0.21 blue: 0.24 alpha: 1.00];


	changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changelogButton];

	self.navigationItem.rightBarButtonItem = changelogButtonItem;
	self.navigationItem.titleView = [UIView new];
    	self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,10)];
    	self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    	self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AmēlijaPrefs.bundle/icon@2x.png"];
    	self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    	self.iconView.alpha = 1.0;
    	[self.navigationItem.titleView addSubview:self.iconView];


	[NSLayoutConstraint activateConstraints:@[

        	[self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        	[self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        	[self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],   
        	[self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
        	[self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
        	[self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
        	[self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
        	[self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],

	]];

	_table.tableHeaderView = self.headerView;

}


- (void)showWtfChangedInThisVersion:(id)sender {
    
    AudioServicesPlaySystemSound(1521);

    self.changelogController = [[OBWelcomeController alloc] initWithTitle:@"Amēlija" detailText:@"1.0" icon:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AmēlijaPrefs.bundle/HotIcon.png"]];

    [self.changelogController addBulletedListItemWithTitle:@"Initial Release" description:@"" image:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
  
    //[self.changelogController addBulletedListItemWithTitle:@"Is" description:@"Fucking Hot" image:[UIImage systemImageNamed:@"exclamationmark.circle.fill"]];

    _UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

    _UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
    backdropView.layer.masksToBounds = YES;
    backdropView.clipsToBounds = YES;
    backdropView.frame = self.changelogController.viewIfLoaded.frame;
    [self.changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];
    
    backdropView.translatesAutoresizingMaskIntoConstraints = NO;
    [backdropView.bottomAnchor constraintEqualToAnchor:self.changelogController.viewIfLoaded.bottomAnchor constant:0].active = YES;
    [backdropView.leftAnchor constraintEqualToAnchor:self.changelogController.viewIfLoaded.leftAnchor constant:0].active = YES;
    [backdropView.rightAnchor constraintEqualToAnchor:self.changelogController.viewIfLoaded.rightAnchor constant:0].active = YES;
    [backdropView.topAnchor constraintEqualToAnchor:self.changelogController.viewIfLoaded.topAnchor constant:0].active = YES;

    self.changelogController.viewIfLoaded.backgroundColor = [UIColor clearColor];
    self.changelogController.view.tintColor = [UIColor colorWithRed: 0.47 green: 0.21 blue: 0.24 alpha: 1.00];
    self.changelogController.modalPresentationStyle = UIModalPresentationPageSheet;
    self.changelogController.modalInPresentation = NO;
    [self presentViewController:self.changelogController animated:YES completion:nil];

}


- (void)dismissVC {

    [self.changelogController dismissViewControllerAnimated:YES completion:nil];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

	CGFloat offsetY = scrollView.contentOffset.y;

	if (offsetY > 0) offsetY = 0;

	self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);

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

}


@end




@implementation LSRootListController


- (NSArray *)specifiers {

    if (!_specifiers) {

        _specifiers = [self loadSpecifiersFromPlistName:@"LS" target:self];

        NSArray *chosenIDs = @[@"GroupCell-1", @"SliderCell-1", @"GroupCell-3", @"MiscLSBlursList", @"GroupCell-4", @"SliderCell-2"];
        self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
        for(PSSpecifier *specifier in _specifiers) {
            if([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
                [self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
            }
        }
    }

    return _specifiers;
    
}


- (void)reloadSpecifiers { // Dynamic specifiers

    [super reloadSpecifiers];


    if (![[self readPreferenceValue:[self specifierForID:@"EpicLSBlurSwitch"]] boolValue]) {

        [self removeSpecifier:self.savedSpecifiers[@"GroupCell-1"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"SliderCell-1"] animated:NO];

    }


    else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]]) {

        [self insertSpecifier:self.savedSpecifiers[@"GroupCell-1"] afterSpecifierID:@"EpicLSBlurSwitch" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"SliderCell-1"] afterSpecifierID:@"GroupCell-1" animated:NO];

    }


    if (![[self readPreferenceValue:[self specifierForID:@"MiscLSBlursSwitch"]] boolValue]) {

        [self removeSpecifier:self.savedSpecifiers[@"GroupCell-3"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"MiscLSBlursList"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"GroupCell-4"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"SliderCell-2"] animated:NO];

    }


    else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell-3"]]) {

        [self insertSpecifier:self.savedSpecifiers[@"GroupCell-3"] afterSpecifierID:@"MiscLSBlursSwitch" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"MiscLSBlursList"] afterSpecifierID:@"GroupCell-3" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"GroupCell-4"] afterSpecifierID:@"MiscLSBlursList" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"SliderCell-2"] afterSpecifierID:@"GroupCell-4" animated:NO];

    }

}


- (void)viewDidLoad {


    [super viewDidLoad];
    [self reloadSpecifiers];


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

    [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"lsBlurApplied" object:nil];


    NSString *key = [specifier propertyForKey:@"key"];


    if([key isEqualToString:@"epicLSBlur"]) {

        
        if (![value boolValue]) {


            [self removeSpecifier:self.savedSpecifiers[@"GroupCell-1"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"SliderCell-1"] animated:YES];


        }


        else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]]) {

            [self insertSpecifier:self.savedSpecifiers[@"GroupCell-1"] afterSpecifierID:@"EpicLSBlurSwitch" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"SliderCell-1"] afterSpecifierID:@"GroupCell-1" animated:YES];


        }


    }


    if([key isEqualToString:@"lsBlur"]) {
        

        if (![value boolValue]) {

            [self removeSpecifier:self.savedSpecifiers[@"GroupCell-3"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"MiscLSBlursList"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"GroupCell-4"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"SliderCell-2"] animated:YES];

        }
        

        else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell-3"]]) {

            [self insertSpecifier:self.savedSpecifiers[@"GroupCell-3"] afterSpecifierID:@"MiscLSBlursSwitch" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"MiscLSBlursList"] afterSpecifierID:@"GroupCell-3" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"GroupCell-4"] afterSpecifierID:@"MiscLSBlursList" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"SliderCell-2"] afterSpecifierID:@"GroupCell-4" animated:YES];

        }

    }

}


@end


@implementation HSRootListController


- (NSArray *)specifiers {

    if (!_specifiers) {

        _specifiers = [self loadSpecifiersFromPlistName:@"HS" target:self];

        NSArray *chosenIDs = @[@"GroupCell-5", @"SliderCell-3", @"GroupCell-6", @"GroupCell-7", @"MiscHSBlursList", @"MiscHSBlursList", @"GroupCell-8", @"SliderCell-4"];
        self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
        for(PSSpecifier *specifier in _specifiers) {
            if([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
                [self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
            }
        }
    }

    return _specifiers;
    
}


- (void)reloadSpecifiers { // Dynamic specifiers

    [super reloadSpecifiers];


    if (![[self readPreferenceValue:[self specifierForID:@"EpicHSBlurSwitch"]] boolValue]) {

        [self removeSpecifier:self.savedSpecifiers[@"GroupCell-5"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"SliderCell-3"] animated:NO];

    }


    else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell-5"]]) {

        [self insertSpecifier:self.savedSpecifiers[@"GroupCell-5"] afterSpecifierID:@"EpicHSBlurSwitch" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"SliderCell-3"] afterSpecifierID:@"GroupCell-5" animated:NO];

    }


    if (![[self readPreferenceValue:[self specifierForID:@"MiscHSBlursSwitch"]] boolValue]) {

        [self removeSpecifier:self.savedSpecifiers[@"GroupCell-7"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"MiscHSBlursList"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"GroupCell-8"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"SliderCell-4"] animated:NO];

    }


    else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell-7"]]) {

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

    [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"hsBlurApplied" object:nil];


    NSString *key = [specifier propertyForKey:@"key"];


    if([key isEqualToString:@"epicHSBlur"]) {

        
        if (![value boolValue]) {


            [self removeSpecifier:self.savedSpecifiers[@"GroupCell-5"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"SliderCell-3"] animated:YES];

        }


        else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell-5"]]) {

            [self insertSpecifier:self.savedSpecifiers[@"GroupCell-5"] afterSpecifierID:@"EpicHSBlurSwitch" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"SliderCell-3"] afterSpecifierID:@"GroupCell-5" animated:YES];

        }


    }


    if([key isEqualToString:@"hsBlur"]) {
        

        if (![value boolValue]) {

            [self removeSpecifier:self.savedSpecifiers[@"GroupCell-7"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"MiscHSBlursList"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"GroupCell-8"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"SliderCell-4"] animated:YES];

        }
        

        else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell-7"]]) {

            [self insertSpecifier:self.savedSpecifiers[@"GroupCell-7"] afterSpecifierID:@"MiscHSBlursSwitch" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"MiscHSBlursList"] afterSpecifierID:@"GroupCell-7" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"GroupCell-8"] afterSpecifierID:@"MiscHSBlursList" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"SliderCell-4"] afterSpecifierID:@"GroupCell-8" animated:YES];

        }

    }

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


- (void)miguelaka {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.reddit.com/user/Miguelaka95/"] options:@{} completionHandler:nil];


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

#import "Common.h"


static NSString *const kPath = @"/var/mobile/Library/Preferences/me.luki.amēlijaprefs.plist";

#define kAmelijaTintColor [UIColor colorWithRed: 0.47 green: 0.21 blue: 0.24 alpha: 1.0]
#define kTakoExists [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Tako.dylib"]


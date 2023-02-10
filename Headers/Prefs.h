// LS

static BOOL lsBlur;
static BOOL blurIfNotifs;

static NSInteger lsBlurType;

static float lsIntensity = 1.0f;

static UIBlurEffect *blurEffect;

// HS

static BOOL hsBlur;

static NSInteger hsBlurType;

static float hsIntensity = 1.0f;

static void loadPrefs() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: kPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	lsBlur = prefs[@"lsBlur"] ? [prefs[@"lsBlur"] boolValue] : NO;
	blurIfNotifs = prefs[@"blurIfNotifs"] ? [prefs[@"blurIfNotifs"] boolValue] : NO;
	lsBlurType = prefs[@"lsBlurType"] ? [prefs[@"lsBlurType"] integerValue] : 0;
	lsIntensity = prefs[@"lsIntensity"] ? [prefs[@"lsIntensity"] floatValue] : 1.0f;

	hsBlur = prefs[@"hsBlur"] ? [prefs[@"hsBlur"] boolValue] : NO;
	hsBlurType = prefs[@"hsBlurType"] ? [prefs[@"hsBlurType"] integerValue] : 0;
	hsIntensity = prefs[@"hsIntensity"] ? [prefs[@"hsIntensity"] floatValue] : 1.0f;

}

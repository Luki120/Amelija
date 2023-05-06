// LS

static BOOL lsBlur;
static BOOL blurIfNotifs;

static NSInteger lsBlurType;

static float lsIntensity;

static UIBlurEffect *blurEffect;

// HS

static BOOL hsBlur;

static NSInteger hsBlurType;

static float hsIntensity;

static void loadPrefs() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: kPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	lsBlur = prefs[@"lsBlur"] ? [prefs[@"lsBlur"] boolValue] : NO;
	blurIfNotifs = prefs[@"blurIfNotifs"] ? [prefs[@"blurIfNotifs"] boolValue] : NO;
	lsBlurType = prefs[@"lsBlurType"] ? [prefs[@"lsBlurType"] integerValue] : 0;
	lsIntensity = prefs[@"lsIntensity"] ? [prefs[@"lsIntensity"] floatValue] : 0.85f;

	hsBlur = prefs[@"hsBlur"] ? [prefs[@"hsBlur"] boolValue] : NO;
	hsBlurType = prefs[@"hsBlurType"] ? [prefs[@"hsBlurType"] integerValue] : 0;
	hsIntensity = prefs[@"hsIntensity"] ? [prefs[@"hsIntensity"] floatValue] : 0.85f;

}

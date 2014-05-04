#import "HMSBAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation HMSBAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Add in your API key here:
  [GMSServices provideAPIKey:@"AIzaSyBoxDSYm0axb50wSay_JbuDH1mBO2N3oN0"];
  return YES;
}

@end

/* Copyright Airship and Contributors */

#import "AppDelegate.h"

@import AirshipCore;
@import AirshipLocation;
@import AirshipAutomation;
@import AirshipMessageCenter;
@import AirshipExtendedActions;
@import AirshipAccengage;

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Exercise various SDK integration entry points
    UAConfig *cfg = [UAConfig defaultConfig];
    [UAirship takeOff:cfg launchOptions:launchOptions];
    
    [UALocation shared].backgroundLocationUpdatesAllowed = NO;
    [[UAMessageCenter shared] display];
    [UAInAppAutomation shared].inAppMessageManager.displayInterval = 12345;
    [UAAccengageUtils decryptData:[NSData data] key:@"cool"];
    [[UAirship shared].actionRegistry registerAction:[[UARateAppAction alloc] init] name:@"raa"];

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end

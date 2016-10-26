//
//  AppDelegate.m
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () < UNUserNotificationCenterDelegate >

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!error) {
                                  NSLog(@"request authorization succeeded!");
                                  //    [self showAlert];
                              }
                          }];
    
    return YES;
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"Notification is triggered");
    //  [self addLabel:notification.request.identifier backgroundColor:[UIColor blueColor]];
    
    
    // You can either present alert, sound or increase badge while the app is in foreground too with iOS 10
    // Must be called when finished, when you do not want foreground show, pass UNNotificationPresentationOptionNone to the completionHandler()
    completionHandler(UNNotificationPresentationOptionAlert);
    // completionHandler(UNNotificationPresentationOptionBadge);
    // completionHandler(UNNotificationPresentationOptionSound);
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)())completionHandler {
    NSLog(@"Tapped in notification");
    NSString *actionIdentifier = response.actionIdentifier;
    
    if ([actionIdentifier isEqualToString:@"com.apple.UNNotificationDefaultActionIdentifier"] ||
        [actionIdentifier isEqualToString:@"com.apple.UNNotificationDismissActionIdentifier"]) {
        return;
    }
    BOOL accept = [actionIdentifier isEqualToString:@"com.elonchan.yes"];
    BOOL decline = [actionIdentifier isEqualToString:@"com.elonchan.no"];
    BOOL snooze = [actionIdentifier isEqualToString:@"com.elonchan.snooze"];
    do {
        if (accept) {
            NSString *title = @"Tom is comming now";
            //  [self addLabel:title backgroundColor:[UIColor yellowColor]];
            break;
        }
        if (decline) {
            NSString *title = @"Tom won't come";
            //  [self addLabel:title backgroundColor:[UIColor redColor]];
            break;
        }
        if (snooze) {
            NSString *title = @"Tom will snooze for minute";
            //  [self addLabel:title backgroundColor:[UIColor redColor]];
        }
    } while (NO);
    // Must be called when finished
    completionHandler();
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

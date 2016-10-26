//
//  GlobalFunction.h
//  KeysToHana
//
//  Created by Prince on 10/21/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <UserNotifications/UserNotifications.h>


typedef enum {
    SO_FACEBOOK,
    SO_TWITTER,
    SO_WHATSAPP,
    SO_IMESSAGE,
    SO_EMAIL,
} SOCIAL_TYPE;

@interface GlobalFunction : NSObject

+ (GlobalFunction *) getInstance;

#pragma mark - UIImage Edit -
- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size;
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha image:(UIImage *)image;

#pragma mark - Notification - 
- (void)sendLocalNotification;

#pragma mark - Sharing to Social - 
- (void)shareToSicial:(SOCIAL_TYPE)type viewCtrl:(UIViewController*)viewController image:(UIImage*)image file:(NSURL *)fileUrl;

@end

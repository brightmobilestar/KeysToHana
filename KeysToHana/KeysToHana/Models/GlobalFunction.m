//
//  GlobalFunction.m
//  KeysToHana
//
//  Created by Prince on 10/21/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "GlobalFunction.h"

@implementation GlobalFunction

+ (GlobalFunction *) getInstance {
    static GlobalFunction * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

#pragma mark - Image Edit -
/*
 - (UIImage *)createImage:(CGSize)size {
 
 UIGraphicsBeginImageContextWithOptions(size, YES, 0);
 [[UIColor whiteColor] setFill];
 UIRectFill(CGRectMake(0, 0, size.width, size.height));
 UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 return image;
 }
 */

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha image:(UIImage *)image {
    
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGSize size = CGSizeMake(width / 2, height / 2);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, size.width, size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, imageRef);
    
    UIImage* tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tempImage;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MIN(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*) addToImage:(UIImage *)baseImage newImage:(UIImage*)newImage atPoint:(CGPoint)point transform:(CGAffineTransform)transform {
    
    UIGraphicsBeginImageContext(baseImage.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [baseImage drawInRect:CGRectMake(0, 0, baseImage.size.width, baseImage.size.height)];
    
    //    [newImage drawAtPoint:point];  draw without applying the transformation
    
    CGContextConcatCTM(context, transform);
    
    CGRect originalRect = CGRectMake((baseImage.size.width - newImage.size.width) / 2,
                                     (baseImage.size.height - newImage.size.height) / 2,
                                     newImage.size.width,
                                     newImage.size.height);
    
    CGContextDrawImage(context, originalRect, newImage.CGImage);
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

#pragma mark - Notification & Badge - 
- (void)sendLocalNotification {
    
    //        //Deliver the notification at 08:30 everyday
    //        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    //        dateComponents.hour = 8;
    //        dateComponents.minute = 30;
    //        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:YES];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"Elon said:" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"Hello Tom！Get up, let's play with Jerry!"
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    /// 4. update application icon badge number
    content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
    // Deliver the notification in five seconds.
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:0.5 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                          content:content trigger:trigger];
    /// 3. schedule localNotification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"add NotificationRequest succeeded!");
        }
    }];
    
}

#pragma mark - Shring To social -
- (void)shareToSicial:(SOCIAL_TYPE)type viewCtrl:(UIViewController*)viewController image:(UIImage*)image file:(NSURL *)fileUrl {
    
    MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
    NSString* strPath = [[NSBundle mainBundle] pathForResource:@"40@3x" ofType:@"png"];
    NSData* fileData = [NSData dataWithContentsOfFile:strPath];
    
    switch (type) {
        
        case SO_FACEBOOK:
            
            if ( [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] ) {
                //        SLComposeViewController* fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [fbSheet addImage:image];
                [fbSheet addURL:fileUrl];
                [fbSheet setTitle:@"Check in! +50 Point"];
                [fbSheet setInitialText:@"Hey Guys! Download the new Busy Bees app!"];
                
                if (fbSheet == nil) {
                    
                    [[[UIAlertView alloc] initWithTitle:@"You need to sign in with Facebook App in Settings." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                    
                    return;
                }
                
                [viewController presentViewController:fbSheet animated:true completion:nil];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"In order to share with Facebook, go to your Apple Settings and scroll down to the apps area. You'll see \"Facebook\" listed there. Click on Facebook and then sign into the app. This will allow us to post to Facebook." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
            
            break;
        case SO_TWITTER:
            if ( [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] ) {
                SLComposeViewController* fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                [fbSheet addImage:image];
                [fbSheet addURL:fileUrl];
                [fbSheet setInitialText:@"Hey Guys! Download the new Busy Bees app!"];
                
                [viewController presentViewController:fbSheet animated:true completion:nil];
            }
            break;
        case SO_WHATSAPP:
            
            break;
            
        case SO_IMESSAGE:
            
            [mailController setMailComposeDelegate:nil];
            [mailController setSubject:@"A Friend Recommended the Busy Bees App!"];
            [mailController setToRecipients:@[]];
            [mailController setMessageBody:@"[Enter your personalized message here]" isHTML:NO];
        
            
            [mailController addAttachmentData:fileData mimeType:@"image/png" fileName:@"Busy Bees.png"];
            [viewController presentViewController:mailController animated:true completion:nil];
            break;
            
        case SO_EMAIL:
            
            [mailController setMailComposeDelegate:nil];
            [mailController setSubject:@"A Friend Recommended the Busy Bees App!"];
            [mailController setToRecipients:@[]];
            [mailController setMessageBody:@"[Enter your personalized message here]" isHTML:NO];
            
            [mailController addAttachmentData:fileData mimeType:@"media/mov" fileName:@"mymoment.mov"];
            [viewController presentViewController:mailController animated:true completion:nil];
            break;
            
        default:
            break;
    }
}



@end

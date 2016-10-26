//
//  ViewCtrlComplete.m
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "ViewCtrlComplete.h"
#import "VideoMaker.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewCtrlComplete () <UIAlertViewDelegate> {
    
    IBOutlet UIProgressView *           _progressView;
    IBOutlet UIButton *                 _btnGotoHome;
    IBOutlet UIView *                   _viewShare;
    
    IBOutlet UIActivityIndicatorView *  _activityView1;
    IBOutlet UIActivityIndicatorView *  _activityView2;
    IBOutlet UIActivityIndicatorView *  _activityView3;
    IBOutlet UIActivityIndicatorView *  _activityView4;
    
    UIBackgroundTaskIdentifier          _backgroundRenderingID;
    
    float                               _currentProgress;
    
    NSString*                           _videoPath;
}

- (IBAction)onBtnGotoHome:(id)sender;
- (IBAction)onBtnShare:(id)sender;

@end

@implementation ViewCtrlComplete

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    
    [GlobalData getInstance].m_viewCtrlComplete = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    UIApplication *app = [UIApplication sharedApplication];
    
    _backgroundRenderingID = [app beginBackgroundTaskWithExpirationHandler:^{
        
        //  [app endBackgroundTask:_backgroundRenderingID];
        //  _backgroundRenderingID = UIBackgroundTaskInvalid;
        
        
    }];
    
   [self createVideo];
}

-(void) finishedViewCreate:(NSString *)path {
    
    _progressView.hidden = true;
    _btnGotoHome.hidden = false;
    _viewShare.hidden = false;
    [self saveVideoToLibrary];
    
    _progressView.progress = 1.0f;
    
    VideoMaker* maker = [VideoMaker getInstance];
    
    CFRetain((__bridge CFTypeRef)(maker));
    CFRelease((__bridge CFTypeRef)(maker));
    
    _videoPath = path;
    
    [self showAlert];
    
    [[UIApplication sharedApplication] endBackgroundTask:_backgroundRenderingID];
}

- (void)showAlert {
    [[GlobalFunction getInstance] sendLocalNotification];
}

- (void)finishedSave  {
    
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:_videoPath] completionBlock:^(NSURL *assetURL, NSError *error) {
        
        if (error) {
            NSLog(@"Error");
        } else {
            
            _progressView.hidden = true;
            _btnGotoHome.hidden = false;
            _viewShare.hidden = false;
            
            [[[UIAlertView alloc] initWithTitle:@"You have saved video to PhotoLibrary" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
    }];
    
}

- (void)onTimer {
    _currentProgress = _currentProgress + 0.1f;
    
    _progressView.progress = _currentProgress / 20;
    
    if (_progressView.progress == 1) {
        
    }
}

- (void)saveVideoToLibrary {
    [[[UIAlertView alloc] initWithTitle:@"Completed VideoCreate! \n Please wait, You are saving video to Photo Library." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertView delegate - 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        _progressView.hidden = true;
        _btnGotoHome.hidden = false;
    } else {
        [self finishedSave];
    }
}

#pragma mark - Create Video & Merge Audio -
-(void)createVideo {
    VideoMaker* maker = [VideoMaker getInstance];
//    [maker setPeriodEveryImage:2];
//    [maker setImageList:[GlobalData getInstance].m_arrayImageList];
    
    NSString* strPath = [maker makeVideo];
    
    strPath = strPath;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBtnGotoHome:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
    
}

- (IBAction)onBtnShare:(id)sender {
    
    UIButton* btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case 1:
            [[GlobalFunction getInstance] shareToSicial:SO_FACEBOOK viewCtrl:self image:[UIImage imageNamed:@"icon.png"] file:[NSURL fileURLWithPath:_videoPath]];
            break;
        case 2:
            [[GlobalFunction getInstance] shareToSicial:SO_TWITTER viewCtrl:self image:[UIImage imageNamed:@"icon.png"] file:[NSURL fileURLWithPath:_videoPath]];
            break;
        case 3:
            [[GlobalFunction getInstance] shareToSicial:SO_IMESSAGE viewCtrl:self image:[UIImage imageNamed:@"icon.png"] file:[NSURL fileURLWithPath:_videoPath]];
            break;
        case 4:
            [[GlobalFunction getInstance] shareToSicial:SO_EMAIL viewCtrl:self image:[UIImage imageNamed:@"icon.png"] file:[NSURL fileURLWithPath:_videoPath]];
            break;
            
        default:
            break;
    }
    
}
@end

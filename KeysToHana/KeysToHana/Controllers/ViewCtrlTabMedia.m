//
//  ViewCtrlTabMedia.m
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "ViewCtrlTabMedia.h"
#import "VideoMaker.h"

@interface ViewCtrlTabMedia ()

- (IBAction)onBtnVIdeoMaker:(id)sender;

@end

@implementation ViewCtrlTabMedia

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation -

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBtnVIdeoMaker:(id)sender {

//    VideoMaker* maker = [[VideoMaker alloc] init];
//    [maker mergeAudioAndVideo:nil video:nil];
    UINavigationController* navCtrl = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavViewCtrlMedia"];
    
    [self.tabBarController presentViewController:navCtrl animated:true completion:nil];
}

@end

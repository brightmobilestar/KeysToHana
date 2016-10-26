//
//  ViewCtrlTabTutorial.m
//  KeysToHana
//
//  Created by Prince on 10/25/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "ViewCtrlTabTutorial.h"

@interface ViewCtrlTabTutorial () {
    
    IBOutlet UIScrollView *         _scrollView;
    
    
    CGSize          _sizeScreen;
}

- (IBAction)onBtnSecondSlide:(id)sender;

@end

@implementation ViewCtrlTabTutorial

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _sizeScreen = [UIScreen mainScreen].bounds.size;
    
    [_scrollView setContentSize:CGSizeMake(_sizeScreen.width * 2, _sizeScreen.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBtnSecondSlide:(id)sender {
    [_scrollView setContentOffset:CGPointMake(_sizeScreen.width, 0) animated:true];
}
@end

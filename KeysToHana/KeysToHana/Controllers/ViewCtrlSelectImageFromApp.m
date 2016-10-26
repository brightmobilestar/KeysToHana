//
//  ViewCtrlSelectImageFromApp.m
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "ViewCtrlSelectImageFromApp.h"
#import "VideoMaker.h"

@interface ViewCtrlSelectImageFromApp () <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    IBOutlet UICollectionView *_collectionView;
    
    NSMutableArray*             _arrayImageList;
    NSMutableArray*             _arrayImageSelected;
}

- (IBAction)onBtnCancel:(id)sender;
- (IBAction)onBtnDone:(id)sender;

@end

@implementation ViewCtrlSelectImageFromApp

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _arrayImageList = [[NSMutableArray alloc] init];
    _arrayImageSelected = [[NSMutableArray alloc] init];
    
    [_arrayImageList addObject:[UIImage imageNamed:@"1.jpg"]];    [_arrayImageList addObject:[UIImage imageNamed:@"2.jpg"]];
    [_arrayImageList addObject:[UIImage imageNamed:@"3.jpg"]];    [_arrayImageList addObject:[UIImage imageNamed:@"4.jpg"]];
    [_arrayImageList addObject:[UIImage imageNamed:@"5.jpg"]];    [_arrayImageList addObject:[UIImage imageNamed:@"6.jpg"]];
    [_arrayImageList addObject:[UIImage imageNamed:@"7.jpg"]];    [_arrayImageList addObject:[UIImage imageNamed:@"8.jpg"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Delegate -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_arrayImageList count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        
    }
    
    // To set Image
    UIImageView* imgView = [cell viewWithTag:1];
    
    UIImage* img = [_arrayImageList objectAtIndex:indexPath.row];
    
    [imgView setImage:img];
    
    
    // To check if it is selected or not
    UIView*     checkView = [cell viewWithTag:2];
    
    if ([_arrayImageSelected containsObject:img]) {
        checkView.hidden = false;
    } else {
        checkView.hidden = true;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage* img = [_arrayImageList objectAtIndex:indexPath.row];
    if ([_arrayImageSelected containsObject:img]) {
        [_arrayImageSelected removeObject:img];
    } else {
        [_arrayImageSelected addObject:img];
    }
    
    [collectionView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBtnCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onBtnDone:(id)sender {
    
    for (UIImage* img in _arrayImageSelected) {
        
        CGSize newSize = CGSizeMake(336, 224);
        
        UIImage *  temp = [[GlobalFunction getInstance] imageWithImage:img scaledToFillSize:newSize];
        
        [[GlobalData getInstance].m_arrayImageList addObject:temp];
    }
    [self dismissViewControllerAnimated:true completion:nil];
}
@end

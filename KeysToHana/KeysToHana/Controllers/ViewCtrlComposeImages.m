//
//  ViewCtrlComposeImages.m
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "ViewCtrlComposeImages.h"
#import "GMImagePickerController.h"
#import "VideoMaker.h"

@import UIKit;
@import Photos;

@interface ViewCtrlComposeImages () <UITableViewDelegate, UITableViewDataSource, GMImagePickerControllerDelegate> {
    
    NSMutableArray*         _arrayImgList;
    
    UIImage*                _tempImage;
    
    
    
    IBOutlet UIButton *     _gmImagePickerButton;
    IBOutlet UIButton *     _appPickerButton;
    IBOutlet UITableView *  _tblViewImageList;
    
}

- (IBAction)onBtnFromGallery:(id)sender;

@end

@implementation ViewCtrlComposeImages

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tblViewImageList.editing = true;
}

- (void)viewDidAppear:(BOOL)animated {
    
    _arrayImgList = [GlobalData getInstance].m_arrayImageList;
    
    [_tblViewImageList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayImgList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (cell == NULL) {
        [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    _tempImage = [_arrayImgList objectAtIndex:indexPath.row];
    
    UIImageView* imgView = (UIImageView *)[cell viewWithTag:1];
    
    [imgView setImage:_tempImage];
    
    CFRetain((__bridge CFTypeRef)(_tempImage));
    CFRelease((__bridge CFTypeRef)(_tempImage));
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

// Index

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index __TVOS_PROHIBITED;  // tell table which section corresponds to section title/index (e.g. "B",1))

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_arrayImgList removeObjectAtIndex:indexPath.row];
    
    [tableView reloadData];
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    UIImage* img = [_arrayImgList objectAtIndex:sourceIndexPath.row];
    
    [_arrayImgList removeObject:img];
    
    if ([_arrayImgList count] > destinationIndexPath.row) {
        [_arrayImgList insertObject:img atIndex:destinationIndexPath.row];
    }
}

#pragma mark - GMImagePickerController Delegate -
- (void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assetArray
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    PHImageManager *manager = [PHImageManager defaultManager];
    
    for (PHAsset * asset in assetArray) {
        
        [manager requestImageForAsset:asset
                           targetSize:PHImageManagerMaximumSize
                          contentMode:PHImageContentModeDefault
                              options:options
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                            
                            
                            CGSize newSize = CGSizeMake(336, 224);
                            
                            UIImage *  temp = [[GlobalFunction getInstance] imageWithImage:image scaledToFillSize:newSize];
                            [_arrayImgList addObject:temp];
                            
                            [_tblViewImageList reloadData];
                            
                        }];
    }
    
    NSLog(@"GMImagePicker: User ended picking assets. Number of selected items is: %lu", (unsigned long)assetArray.count);
}

-(void)assetsPickerControllerDidCancel:(GMImagePickerController *)picker
{
    NSLog(@"GMImagePicker: User pressed cancel button");
}

//-(void)uploadImages:(NSArray *)assetArray {
//    
//    m_intTempMaxNumber = [assetArray count];
//    m_intTempCount = 0;
//    
//    PHImageRequestOptions* requestOptions = [[PHImageRequestOptions alloc] init];
//    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
//    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//    
//    // this one is key
//    requestOptions.synchronous = true;
//    
//    PHImageManager *manager = [PHImageManager defaultManager];
//    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[assetArray count]];
//    
//    // assets contains PHAsset objects.
//    __block UIImage *ima;
//    
//    NSInteger dataCount = 0;
//    
//    for (PHAsset * asset in assetArray) {
//        
//        if ( !asset.isVideo ) {
//            
//            // Do something with the asset
//            dataCount = dataCount + 1;
//            
//            [asset fetchOriginalImage:true completeBlock:^(UIImage * image, NSDictionary * info) {
//                
//                [self uploadImage:image index:dataCount];
//                
//            }];
//            
//        }
//    }
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBtnCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onBtnFromGallery:(id)sender {
    
    GMImagePickerController *picker = [[GMImagePickerController alloc] init];
    picker.delegate = self;
    picker.title = @"My Photos";
    
    picker.customDoneButtonTitle = @"Done";
    picker.customCancelButtonTitle = @"Cancel";
//    picker.customNavigationBarPrompt = @"Take a new photo or select an existing one!";
    
    picker.colsInPortrait = 3;
    picker.colsInLandscape = 5;
    picker.minimumInteritemSpacing = 2.0;
    
    picker.mediaTypes = @[@(PHAssetMediaTypeImage)];
    
//    PHAssetCollectionSubtype.SmartAlbumUserLibrary,
//    PHAssetCollectionSubtype.AlbumRegular
    
    picker.customSmartCollections = @[@(PHAssetCollectionSubtypeAlbumRegular)];
//    , @(PHAssetCollectionSubtypeSmartAlbumUserLibrary)
    
    //    picker.allowsMultipleSelection = NO;
    //    picker.confirmSingleSelection = YES;
    //    picker.confirmSingleSelectionPrompt = @"Do you want to select the image you have chosen?";
    
    //    picker.showCameraButton = YES;
    //    picker.autoSelectCameraImages = YES;
    
    picker.modalPresentationStyle = UIModalPresentationPopover;
    
    //    picker.mediaTypes = @[@(PHAssetMediaTypeImage)];
    
    //    picker.pickerBackgroundColor = [UIColor blackColor];
    //    picker.pickerTextColor = [UIColor whiteColor];
    //    picker.toolbarBarTintColor = [UIColor darkGrayColor];
    //    picker.toolbarTextColor = [UIColor whiteColor];
    //    picker.toolbarTintColor = [UIColor redColor];
    //    picker.navigationBarBackgroundColor = [UIColor blackColor];
    //    picker.navigationBarTextColor = [UIColor whiteColor];
    //    picker.navigationBarTintColor = [UIColor redColor];
    //    picker.pickerFontName = @"Verdana";
    //    picker.pickerBoldFontName = @"Verdana-Bold";
    //    picker.pickerFontNormalSize = 14.f;
    //    picker.pickerFontHeaderSize = 17.0f;
    //    picker.pickerStatusBarStyle = UIStatusBarStyleLightContent;
    //    picker.useCustomFontForNavigationBar = YES;
    
    UIPopoverPresentationController *popPC = picker.popoverPresentationController;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popPC.sourceView = _gmImagePickerButton;
    popPC.sourceRect = _gmImagePickerButton.bounds;
    //    popPC.backgroundColor = [UIColor blackColor];
    
//    [self showViewController:picker sender:nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}

@end

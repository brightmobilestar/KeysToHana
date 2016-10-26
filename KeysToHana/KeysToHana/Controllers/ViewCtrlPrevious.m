//
//  ViewCtrlPrevious.m
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "ViewCtrlPrevious.h"
#import "ViewCtrlComplete.h"
#import "VideoMaker.h"

@interface ViewCtrlPrevious () <AVAudioPlayerDelegate> {
    
    IBOutlet UIImageView *  _imgView;
    
    AVAudioPlayer*          _audioPlayer;
    
    Boolean                 _isPlaying;
    NSInteger               _currentImageNumber;
}

- (IBAction)onBtnBack:(id)sender;

- (IBAction)onBtnPlay:(id)sender;

- (IBAction)onBtnCreateVideo:(id)sender;
@end

@implementation ViewCtrlPrevious

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isPlaying = false;
    _currentImageNumber = 0;
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    
    
    VideoMaker* maker = [VideoMaker getInstance];
    [maker setPeriodEveryImage:2];
    [maker setImageList:[GlobalData getInstance].m_arrayImageList];
    
    
    [self createAudio];
    
}


- (void)onTimer {
    
    
    if (_isPlaying) {
        
        _currentImageNumber = _currentImageNumber + 1;
        
        if (_currentImageNumber < [[GlobalData getInstance].m_arrayImageList count]) {
            UIImage* img = [[GlobalData getInstance].m_arrayImageList objectAtIndex:_currentImageNumber];
            [_imgView setImage:img];
        } else {
            _currentImageNumber = 0;
            _isPlaying = false;
            [self audioStop];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PreView -
-(void)createAudio {
    
    if ([[GlobalData getInstance].m_arrayImageList count] > 0) {
        [_imgView setImage:[[GlobalData getInstance].m_arrayImageList firstObject]];
    }
    
    if ([[GlobalData getInstance].m_arrayMusicList count] > 0) {
        
        NSMutableArray* array = [GlobalData getInstance].m_arrayMusicList;
        MdlMusic* music = [array objectAtIndex:0];
        
        _audioPlayer = [music createAudioPlayer:self];
    } else {
        _audioPlayer = nil;
    }
}

- (void)audioPlay {
    if (_audioPlayer != nil) {
        [_audioPlayer play];
    }
}

- (void)audioStop {
    if (_audioPlayer != nil) {
        [_audioPlayer stop];
        
        _audioPlayer = nil;
        
        [self createAudio];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Event Actions -
- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)onBtnPlay:(id)sender {
    
    _isPlaying = true;
    _currentImageNumber = 0;
    [self audioPlay];
}

- (IBAction)onBtnCreateVideo:(id)sender {
    
    if (_audioPlayer != nil) {
        if ([_audioPlayer isPlaying]) {
            [_audioPlayer stop];
        }
        
        _audioPlayer = nil;
    }
    
    
    ViewCtrlComplete* navCtrl = (ViewCtrlComplete *)[self.storyboard instantiateViewControllerWithIdentifier:@"ViewCtrlComplete"];
    
    [self.navigationController pushViewController:navCtrl animated:false];
    
}
@end

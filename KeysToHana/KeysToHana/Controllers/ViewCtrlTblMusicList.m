//
//  ViewCtrlTblMusicList.m
//  KeysToHana
//
//  Created by Prince on 10/23/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "ViewCtrlTblMusicList.h"

@interface ViewCtrlTblMusicList () <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate> {
    
    NSMutableArray*         _arrayMusicList;
    IBOutlet UITableView *  _tblViewList;
    
    IBOutlet UIButton *     _btnPlay;
    
    AVAudioPlayer *         _audioPlayer;
    MdlMusic *              _currentMusic;
    
}

- (IBAction)onBtnPrev:(id)sender;
- (IBAction)onBtnPlay:(id)sender;
- (IBAction)onBtnNext:(id)sender;
@end

@implementation ViewCtrlTblMusicList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _arrayMusicList = [[TestData getInstance] SampleAudioFiles];
    
    // init _audioPlayer
    _currentMusic = [_arrayMusicList objectAtIndex:0];
    _audioPlayer = [_currentMusic createAudioPlayer:self];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PreView -
-(void)createAudio:(MdlMusic *)music {
    
    _audioPlayer = [music createAudioPlayer:self];
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
        
        //  [self createAudio];
    }
}

#pragma mark - UITableView Delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayMusicList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    MdlMusic* obj = [_arrayMusicList objectAtIndex:indexPath.row];
    
    if ( [obj isEqual:_currentMusic] ) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell.textLabel setText:obj.m_strName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _currentMusic = [_arrayMusicList objectAtIndex:indexPath.row];
    
    
    [[GlobalData getInstance].m_arrayMusicList removeAllObjects];
    [[GlobalData getInstance].m_arrayMusicList addObject:_currentMusic];
    //    if ([[GlobalData getInstance].m_arrayMusicList containsObject:obj]) {
    //        [[GlobalData getInstance].m_arrayMusicList removeObject:obj];
    //    } else {
    //        [[GlobalData getInstance].m_arrayMusicList addObject:obj];
    //    }
    
    
    // ====
    MdlMusic *mdl = [_arrayMusicList objectAtIndex:indexPath.row];
    if ( ![mdl isEqual:_currentMusic] ) {
        if (_audioPlayer != nil) {
            if ([_audioPlayer isPlaying]) {
                [_audioPlayer stop];
            }
            _audioPlayer = nil;
        }
        _audioPlayer = [_currentMusic createAudioPlayer:self];
        [self audioPlay];
    }
    
    [tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIAction delegate -
- (IBAction)onBtnPrev:(id)sender {
    
    int _currentIndex = 0;
    for (MdlMusic* tempMusic in _arrayMusicList) {
        if ([tempMusic isEqual:_currentMusic]) {
            break;
        }
        
        _currentIndex = _currentIndex + 1;
    }
    
    _currentIndex = _currentIndex - 1;
    if (_currentIndex > -1) {
        _currentMusic = [_arrayMusicList objectAtIndex:_currentIndex];
        if (_audioPlayer != nil) {
            if ([_audioPlayer isPlaying]) {
                [_audioPlayer stop];
            }
            _audioPlayer = nil;
        }
        _audioPlayer = [_currentMusic createAudioPlayer:self];
        
    }
    
    [self onBtnPlay:nil];
    
}

- (IBAction)onBtnPlay:(id)sender {
    
    if ([_audioPlayer isPlaying]) {
        [_audioPlayer pause];
        [_btnPlay setTitle:@"Play" forState:UIControlStateNormal];
    } else {
        [_audioPlayer play];
        [_btnPlay setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
    [_tblViewList reloadData];
}

- (IBAction)onBtnNext:(id)sender {
    
    int _currentIndex = 0;
    for (MdlMusic* tempMusic in _arrayMusicList) {
        if ([tempMusic isEqual:_currentMusic]) {
            break;
        }
        
        _currentIndex = _currentIndex + 1;
    }
    
    _currentIndex = _currentIndex + 1;
    if ( [_arrayMusicList count] > _currentIndex ) {
        _currentMusic = [_arrayMusicList objectAtIndex:_currentIndex];
        
        if (_audioPlayer != nil) {
            if ([_audioPlayer isPlaying]) {
                [_audioPlayer stop];
            }
            _audioPlayer = nil;
        }
        _audioPlayer = [_currentMusic createAudioPlayer:self];
    }
    
    [self onBtnPlay:nil];
}
@end

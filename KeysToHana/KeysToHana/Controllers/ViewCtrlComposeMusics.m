//
//  ViewCtrlComposeMusics.m
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "ViewCtrlComposeMusics.h"

@interface ViewCtrlComposeMusics () <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate> {
    
    NSMutableArray*             _arrayMusicList;
    
    IBOutlet UITableView *      _tblViewMusicList;
    
    AVAudioPlayer*              _audioPlayer;
}

- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnNext:(id)sender;

@end

@implementation ViewCtrlComposeMusics

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _arrayMusicList = [[TestData getInstance] SampleAudioFiles];
}

- (void)playAudio {
    
    if ([[GlobalData getInstance].m_arrayMusicList count] > 0 && false) {
        
        NSMutableArray* array = [GlobalData getInstance].m_arrayMusicList;
        MdlMusic* music = [array objectAtIndex:0];
        
        NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:music.m_strName ofType:@"mp3"];
        NSURL*  soundFileUrl =  [NSURL fileURLWithPath:soundFilePath];
        
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileUrl error:nil];
        _audioPlayer.numberOfLoops = -1;
        [_audioPlayer setDelegate:self];
        [_audioPlayer prepareToPlay];
        
        [_audioPlayer play];
    }
    
}



- (void)viewDidAppear:(BOOL)animated {
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ([[GlobalData getInstance].m_arrayMusicList containsObject:obj]) {
        
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    } else {
        
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    [cell.textLabel setText:obj.m_strName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MdlMusic* obj = [_arrayMusicList objectAtIndex:indexPath.row];

    [[GlobalData getInstance].m_arrayMusicList removeAllObjects];
    [[GlobalData getInstance].m_arrayMusicList addObject:obj];
//    if ([[GlobalData getInstance].m_arrayMusicList containsObject:obj]) {
//        [[GlobalData getInstance].m_arrayMusicList removeObject:obj];
//    } else {
//        [[GlobalData getInstance].m_arrayMusicList addObject:obj];
//    }
    
    [tableView reloadData];
    
    [self playAudio];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)onBtnNext:(id)sender {
    
}

@end

//
//  MdlMusic.m
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "MdlMusic.h"

@implementation MdlMusic

-(id)init:(NSString*)str {
    
    self = [super init];
    if (self) {
        self.m_strName = str;
    }
    
    return self;
}

-(AVAudioPlayer *)createAudioPlayer:(UIViewController<AVAudioPlayerDelegate> *)ctrl {
    NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:self.m_strName ofType:@"mp3"];
    NSURL*  soundFileUrl =  [NSURL fileURLWithPath:soundFilePath];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileUrl error:nil];
    _audioPlayer.numberOfLoops = 0;
    [_audioPlayer setDelegate:ctrl];
    [_audioPlayer prepareToPlay];
    
    return _audioPlayer;
}

@end

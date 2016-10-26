//
//  MdlMusic.h
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MdlMusic : NSObject {
    AVAudioPlayer*          _audioPlayer;
}

@property(nonatomic, strong)    NSString*       m_strName;


-(id)init:(NSString*)str;

- (AVAudioPlayer *)createAudioPlayer:(UIViewController<AVAudioPlayerDelegate> *)ctrl;

@end

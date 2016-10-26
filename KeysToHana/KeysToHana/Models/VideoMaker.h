//
//  VideoMaker.h
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoMaker : NSObject {
    
    NSMutableArray*     _arrayImageList;
    NSMutableArray*     _arrayAudioList;
    
    float               _periodEveryImage;
    
    int                 _countEveryImage;
    
    AVURLAsset* videoAsset;
    AVURLAsset* audioAsset;
}

+ (VideoMaker *) getInstance;

-(void)setPeriodEveryImage:(float)period;
-(void)setImageList:(NSMutableArray *)array;
-(void)setAudioList:(NSMutableArray *)array;



- (NSString *) makeVideo;
-(NSString *)mergeAudioAndVideo:(NSURL *)audio_inputFileUrl video:(NSURL *)video_inputFileUrl;

@end

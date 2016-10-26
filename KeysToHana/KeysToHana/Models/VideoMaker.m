//
//  VideoMaker.m
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "VideoMaker.h"
#import "ViewCtrlComplete.h"

@implementation VideoMaker {
    
    UIImage*        tempImage;
    UIImage*        tempImage1;
    
}

+ (VideoMaker *) getInstance {
    static VideoMaker * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

- (id) init {
    self = [super init];
    if (self) {
        _arrayImageList = [[NSMutableArray alloc] init];
        _arrayAudioList = [[NSMutableArray alloc] init];
        
        _periodEveryImage = 1;
    }
    return self;
}

-(void)setPeriodEveryImage:(float)period {
    
    _periodEveryImage = period;
}

-(void)setImageList:(NSMutableArray *)array {

    [_arrayImageList removeAllObjects];
    
    for (UIImage* _image in array) {
    
//        float scaleX = 672.0f / CGImageGetWidth([_image CGImage]);
//        float scaleY = 448.0f / CGImageGetHeight([_image CGImage]);
//        
//        CGSize newSize = CGSizeMake(336, 224);
//        
//        UIImage *  temp = [self imageWithImage:_image scaledToFillSize:newSize];
//        
//        scaleX = CGImageGetWidth([temp CGImage]);
//        scaleY = CGImageGetHeight([temp CGImage]);
        
        [_arrayImageList addObject:_image];
    }
    
    [GlobalData getInstance].m_arrayImageList = [_arrayImageList mutableCopy];
}

-(void)setAudioList:(NSMutableArray *)array {
    _arrayAudioList = array;
}

#pragma mark - Make Video -
- (NSString *) makeVideo
{
    _countEveryImage = 20.0f * _periodEveryImage;
    
    CGSize size = CGSizeMake(672, 448);
    //  size = CGSizeMake(336, 224);
    
    NSString *betaCompressionDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    
    NSError *error = nil;
    
    unlink([betaCompressionDirectory UTF8String]);
    
    //----initialize compression engine
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:betaCompressionDirectory]
                                                           fileType:AVFileTypeQuickTimeMovie
                                                              error:&error];
    NSParameterAssert(videoWriter);
    if(error)
        NSLog(@"error = %@", [error localizedDescription]);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey, nil];
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    if ([videoWriter canAddInput:writerInput])
        NSLog(@"I can add this input");
    else
        NSLog(@"i can't add this input");
    
    [videoWriter addInput:writerInput];
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    
    dispatch_queue_t    dispatchQueue = dispatch_queue_create("mediaInputQueue", NULL);
    int __block         frame = 0;
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        while ([writerInput isReadyForMoreMediaData])
        {
            if(++frame >= [_arrayImageList count] * _countEveryImage)
            {
                [writerInput markAsFinished];
                [videoWriter finishWriting];
                
                [self merge:betaCompressionDirectory];
                
                break;
            } else {
                int temp = frame / _countEveryImage;
                
                //  UIImage* temp1 = nil;
                
                int tempInt1 = frame % _countEveryImage;
                float scaleOpacity = ((float)tempInt1) / ((float)_countEveryImage) * 2.0f;
                
                scaleOpacity = scaleOpacity < 1.0f ? scaleOpacity : 2.0 - scaleOpacity;
                scaleOpacity = scaleOpacity + 0.5f;
                
                GlobalFunction* gbl = [GlobalFunction getInstance];
                tempImage = [gbl imageByApplyingAlpha:scaleOpacity image:[_arrayImageList objectAtIndex:temp]];
                
                CVPixelBufferRef buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[tempImage CGImage] size:size];
                if (buffer)
                {
                    if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, 10)])
                        NSLog(@"FAIL");
                    else
                        NSLog(@"Success:%d", frame);
                    CFRelease(buffer);
                }
                
                if( frame % 20 == 0) sleep(1);
                
                CFRetain((__bridge CFTypeRef)(tempImage));
                CFRelease((__bridge CFTypeRef)(tempImage));
                
                tempImage = nil;
                //  temp1 = nil;
                
                //  dispatch_sync(dispatch_get_main_queue(), ^{
                    //hide any progress indicators
                   
                //  });
            }
            
            
        }
    }];
    
    NSLog(@"outside for loop");
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"FinalVideo.mov"]];
    
    return outputFilePath;
}


- (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)imageRef size:(CGSize)size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options, &pxbuffer);
    // CVReturn status = CVPixelBufferPoolCreatePixelBuffer(NULL, adaptor.pixelBufferPool, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)), imageRef);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

#pragma mark - Merge Audio & Video - 
-(void)merge:(NSString*)strVideoPath {
    NSMutableArray* array = [GlobalData getInstance].m_arrayMusicList;
    MdlMusic* music = [array objectAtIndex:0];
    
    NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:music.m_strName ofType:@"mp3"];
    NSURL*  soundFileUrl =  [NSURL fileURLWithPath:soundFilePath];
    
    [self mergeAudioAndVideo:soundFileUrl video:[NSURL fileURLWithPath:strVideoPath]];
}

-(NSString *)mergeAudioAndVideo:(NSURL *)audio_inputFileUrl video:(NSURL *)video_inputFileUrl
{
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"FinalVideo.mov"]];
    NSURL*    outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
        [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
    
    
    CMTime nextClipStartTime = kCMTimeZero;
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
    
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:nextClipStartTime error:nil];
    
    //nextClipStartTime = CMTimeAdd(nextClipStartTime, a_timeRange.duration);
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audio_inputFileUrl options:nil];
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:nextClipStartTime error:nil];
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    _assetExport.outputURL = outputFileUrl;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:^{
        
        [_arrayImageList removeAllObjects];
        [[GlobalData getInstance].m_viewCtrlComplete finishedViewCreate:outputFilePath];
        
    }];
    
    return outputFilePath;
}

@end

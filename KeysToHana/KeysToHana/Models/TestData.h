//
//  TestData.h
//  KeysToHana
//
//  Created by Prince on 10/26/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestData : NSObject

+ (TestData *) getInstance;

-(NSMutableArray *)SampleGeofences;
-(NSMutableArray *)SampleAudioFiles;

@end

//
//  TestData.m
//  KeysToHana
//
//  Created by Prince on 10/26/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "TestData.h"

@implementation TestData

+ (TestData *) getInstance {
    static TestData * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

- (id) init {
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

-(NSMutableArray *)SampleGeofences {
    NSMutableArray* muArray = [[NSMutableArray alloc] init];
    
    [muArray addObject:[[MdlGeofence alloc] init:@"20.853906" lon:@"-156.310298" title:@"Location 1"]];
    [muArray addObject:[[MdlGeofence alloc] init:@"20.953906" lon:@"-156.380298" title:@"Location 1"]];
    [muArray addObject:[[MdlGeofence alloc] init:@"20.859906" lon:@"-156.310298" title:@"Location 1"]];
    [muArray addObject:[[MdlGeofence alloc] init:@"20.853906" lon:@"-157.310298" title:@"Location 1"]];
    [muArray addObject:[[MdlGeofence alloc] init:@"21.853906" lon:@"-157.390298" title:@"Location 1"]];
    [muArray addObject:[[MdlGeofence alloc] init:@"21.853906" lon:@"-157.310298" title:@"Location 1"]];
    
    return muArray;
}

-(NSMutableArray *)SampleAudioFiles {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObject:[[MdlMusic alloc] init:@"012016-Trigger-5 Lite App (Rough Mix)"]];
    [tempArray addObject:[[MdlMusic alloc] init:@"012016-Trigger-6 Lite App (Rough Mix)"]];
    [tempArray addObject:[[MdlMusic alloc] init:@"012016-Trigger-7 Lite App (Rough Mix)"]];
    [tempArray addObject:[[MdlMusic alloc] init:@"012016-Trigger-8 Lite App (Rough Mix)"]];
    
    return tempArray;
}

@end

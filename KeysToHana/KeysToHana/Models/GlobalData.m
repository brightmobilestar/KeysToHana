//
//  GlobalData.m
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData

+ (GlobalData *) getInstance {
    static GlobalData * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

- (id) init {
    self = [super init];
    if (self) {
        self.m_arrayImageList = [[NSMutableArray alloc] init];
        self.m_arrayMusicList = [[NSMutableArray alloc] init];
    }
    return self;
}


@end

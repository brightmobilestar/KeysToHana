//
//  MdlGeofence.m
//  KeysToHana
//
//  Created by Prince on 10/26/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import "MdlGeofence.h"

@implementation MdlGeofence

- (id) init:(NSString *)lat lon:(NSString *)lon title:(NSString *)title {
    self = [super init];
    if (self) {
        self.m_location = [NSArray arrayWithObjects:lat, lon, nil];
        self.m_title = title;
        
    }
    return self;
}

@end

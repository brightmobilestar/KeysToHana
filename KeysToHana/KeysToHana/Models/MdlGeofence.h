//
//  MdlGeofence.h
//  KeysToHana
//
//  Created by Prince on 10/26/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MdlGeofence : NSObject

@property(nonatomic, strong)    NSArray*        m_location;
@property(nonatomic, strong)    NSString*       m_title;

- (id) init:(NSString *)lat lon:(NSString *)lon title:(NSString *)title;

@end

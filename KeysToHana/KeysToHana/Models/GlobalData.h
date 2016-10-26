//
//  GlobalData.h
//  KeysToHana
//
//  Created by Prince on 10/18/16.
//  Copyright © 2016 Steven, Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewCtrlComplete;

@interface GlobalData : NSObject {
    
    NSMutableArray*     _arrayImageList;
    NSMutableArray*     _arrayMusicList;
}

@property(nonatomic, strong)  NSMutableArray*        m_arrayImageList;
@property(nonatomic, strong)  NSMutableArray*   m_arrayMusicList;

@property ViewCtrlComplete*     m_viewCtrlComplete;

+ (GlobalData *) getInstance;

@end

//
//  MovFromLivePhoto.h
//  MovFromLivePhoto
//
//  Created by verba8888 on 2015/10/19.
//  Copyright © 2015年 verba8888. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface MovFromLivePhoto : NSObject

+ (MovFromLivePhoto*)sharedInstance;

/** get PHAssets only Live Photo */
-(NSMutableArray*)getLivePhotoPHAssets;

/** save .MOV File From Live Photo PHAsset */
-(void)saveMovFileFromLivePhotoPHAsset:(PHAsset*)asset;

@end

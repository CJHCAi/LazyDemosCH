//
//  VideoRotate.h
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/3/14.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface VideoRotate : NSObject

typedef NS_ENUM(NSInteger,VideoRotateEnum)
{
    /** 0度 */
    VideoRotate0 = 1,
    
    /** 90度 */
    VideoRotate90 = 2,
    
    /** 180度 */
    VideoRotate180 = 3,
    
    /** 270度 */
    VideoRotate270 = 4
    
};

@property AVMutableComposition *mutableComposition;
@property AVMutableVideoComposition *mutableVideoComposition;
@property AVAssetExportSession *exportSession;;

- (void)exportWithAsset:(AVAsset *)asset completion:(void(^)(NSError * error))completion;


- (void)videoChangeRotateWithAsset:(AVAsset*)asset Rotate:(VideoRotateEnum)degrees completion:(void(^)(CGAffineTransform transform))completion;



@end

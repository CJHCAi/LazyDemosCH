//
//  BDFCustomPhotoAlbum.h
//  SavePhotoDemo
//
//  Created by allison on 2018/8/13.
//  Copyright © 2018年 allison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BDFCustomPhotoAlbum : NSObject
+ (instancetype _Nonnull )shareInstance;
- (void)saveToNewThumb:(nonnull UIImage *)image;
- (void)showAlertMessage:(NSString *_Nonnull)message;
@end


//
//  CTAlbumModel.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/25.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQAlbumModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, strong) id fetchResult;//PHFetchResult<PHAsset *> *
@end

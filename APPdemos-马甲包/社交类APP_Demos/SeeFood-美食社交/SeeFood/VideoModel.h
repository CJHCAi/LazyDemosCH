//
//  VideoModel.h
//  SeeFood
//
//  Created by 纪洪波 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSTimeInterval date;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger collectionCount;
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, copy) NSString *stringDuration;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *coverForDetail;
@property (nonatomic, copy) NSString *coverBlurred;
@property (nonatomic, copy) NSString *mydescription;
@property (nonatomic, copy) NSString *playUrl;
@property (nonatomic, copy) NSString *savePath;
@property (nonatomic, assign) float progress;

+ (NSMutableArray *)jsonToModel:(NSDictionary *)dic;
@end

//
//  PixabayService.h
//  WallPaper
//
//  Created by Never on 2019/7/18.
//  Copyright © 2019 Never. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PixabayCompletion)(NSArray *Pixabaypapers,BOOL success);

@interface PixabayService : NSObject

+ (void)requestWallpapersParams:(NSMutableDictionary *)params completion:(PixabayCompletion)completion;

@end

NS_ASSUME_NONNULL_END

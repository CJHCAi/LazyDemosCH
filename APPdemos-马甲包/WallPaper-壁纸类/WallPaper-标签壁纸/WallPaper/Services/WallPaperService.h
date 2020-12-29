//
//  WallPaperService.h
//  WallPaper
//
//  Created by Never on 2017/2/10.
//  Copyright © 2017年 Never. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WallpapersCompletion)(NSArray *wallpapers,BOOL success);

@interface WallPaperService : NSObject

+ (void)requestWallpapersFromURL:(NSURL *)url completion:(WallpapersCompletion)completion;
@end

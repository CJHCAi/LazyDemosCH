//
//  VideoVC.h
//  SeeFood
//
//  Created by 纪洪波 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoVCDelegate <NSObject>

- (void)changeView;

@end

@interface VideoVC : UIViewController
@property (nonatomic, assign) NSInteger middleImageIndex;
@property (nonatomic, assign) id<VideoVCDelegate>delegate;

@property (nonatomic, retain) NSMutableArray *modelArray;
@end

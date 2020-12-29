//
//  VideoCVC.h
//  SeeFood
//
//  Created by 纪洪波 on 15/11/25.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoCVCDelegate <NSObject>

- (void)changeView;
- (void)changeViewWithIndex:(NSInteger)index;

- (void)updateModelArray:(NSMutableArray *)array;

@end

@interface VideoCVC : UIViewController
@property (nonatomic, assign) id<VideoCVCDelegate>delegate;
@end

//
//  ViewController.m
//  TJImageEditer
//
//  Created by TanJian on 16/8/1.
//  Copyright © 2016年 Joshpell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCPosterEditViewDelegate <NSObject>

- (void)getFinalPoster:(UIImage *)image;

@end

@interface MCPosterEditController : UIViewController

@property (nonatomic,strong)UIImage *editImage;
@property (nonatomic,assign)CGFloat imageH;
@property (nonatomic,assign)CGFloat imageW;
@property (nonatomic,strong)UIViewController *superVC;
@property (nonatomic,weak)  id<MCPosterEditViewDelegate> delegate;

@end

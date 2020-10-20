//
//  SDRevealView.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/11.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDRevealView : UIView

@property (nonatomic, strong) UIImage * revealImage;

@property (nonatomic, weak) UIImageView * theRevealView;


- (void)addTargetView:(UIView *)view;

@end

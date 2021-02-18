//
//  JossSelectViewController.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/20.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "BaseViewController.h"

@class JossSelectViewController;

@protocol  JossSelectViewControllerDelegate<NSObject>

-(void)chooseJossImage:(UIImage *)image;

@end

@interface JossSelectViewController : BaseViewController
/** 代理人*/
@property (nonatomic, weak) id<JossSelectViewControllerDelegate> delegate;
@end

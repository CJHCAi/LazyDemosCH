//
//  ZJActionSheet.h
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/14.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJAction.h"

@interface ZJActionSheet : UIView

@property(nonatomic, strong)NSMutableArray *actionArray;

- (void)addAction:(ZJAction *)action;

- (void)show;



@end

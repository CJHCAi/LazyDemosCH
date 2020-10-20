//
//  DFBaseUserLineCell.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseUserLineItem.h"
#import <UIImageView+WebCache.h>

@protocol DFBaseUserLineCellDelegate <NSObject>

@required

-(void) onClickItem:(DFBaseUserLineItem *) item;

@end



@interface DFBaseUserLineCell : UITableViewCell


@property (nonatomic, strong) id<DFBaseUserLineCellDelegate> delegate;


@property (nonatomic, strong) UIButton *bodyView;

-(void) updateWithItem:(DFBaseUserLineItem *) item;


-(void) updateBodyWithHeight:(CGFloat)height;


+(CGFloat) getCellHeight:(DFBaseUserLineItem *) item;


@end

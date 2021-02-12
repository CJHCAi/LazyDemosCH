//
//  CMEdgeListHeadView.h
//  明医智
//
//  Created by LiuLi on 2019/1/17.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMNode.h"

@class CMEdgeListHeadView;
@protocol CMEdgeListHeadViewDelegate <NSObject>

- (void)tapHeadView:(CMEdgeListHeadView *)headView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CMEdgeListHeadView : UIView

@property (nonatomic,weak) id<CMEdgeListHeadViewDelegate> delegate;

@property (nonatomic,strong) UIView *edgeLine;
@property (nonatomic,strong) UILabel *nameLabel;
//@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) CMNode *node;

@end

NS_ASSUME_NONNULL_END

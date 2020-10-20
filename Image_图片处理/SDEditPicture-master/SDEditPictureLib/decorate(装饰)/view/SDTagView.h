//
//  SDTagView.h
//  NestHouse
//
//  Created by shansander on 2017/5/6.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPasterView.h"
typedef NS_ENUM(NSUInteger, SDDecorationTagModel) {
    SDDecorationTagRight,
    SDDecorationTagLeft,
};




@interface SDTagView : UIView
{
//    CGPoint startPoint;
}
@property (nonatomic, strong) UIPanGestureRecognizer *panResizeGesture;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic,weak) id<SDPasterViewDelegate> delegate;

@property (nonatomic, strong) NSString * tag_string;

@property (nonatomic, assign) SDDecorationTagModel tagModel;

@property (nonatomic, strong) UIFont * tag_font;



- (instancetype)initWithFrame:(CGRect)frame DecorationFunction:(SDDecorationTagModel )tagModel;


- (void)hideTagLine;

@end


@interface SDTagContentView : UIView

@property (nonatomic, weak) UILabel * theTagLabel;

@property (nonatomic, strong) NSString * tag_string;
@property (nonatomic, assign) SDDecorationTagModel tagModel;

@end

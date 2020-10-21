//
//  DrawCoreViewController.h
//  PhotoEditor
//
//  Created by 0xfeedface on 16/7/12.
//  Copyright © 2016年 0xfeedface. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DrawRectType) {
    DrawRectTypeRadio,
    DrawRectTypeCub,
    DrawRectTypeText
};

typedef NS_ENUM(NSUInteger, DrawViewType) {
    DrawViewTypeRawImage,
    DrawViewTypeDrawImage,
    DrawViewTypeMiddleImage
};

struct DrawPath {
    CGRect rect;
    NSUInteger type;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
};

typedef struct DrawPath DrawPath;

#define DrawViewTagStart 100

@interface DrawCoreViewController : UIViewController
- (instancetype)initWithImage:(UIImage *)image;
@property (nonatomic, copy) void (^loadImage)(UIImage *image);
@end

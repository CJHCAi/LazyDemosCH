//
//  CYCropCornerView.h
//  CYImageCrop
//
//  Created by Cyrus on 16/6/9.
//  Copyright © 2016年 Cyrus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CYCropCornerPosition) {
    CYCropCornerPositionLeftTop,
    CYCropCornerPositionRightTop,
    CYCropCornerPositionLeftBottom,
    CYCropCornerPositionRightBottom,
};

@interface CYCropCornerView : UIView

- (instancetype)initWithPosition:(CYCropCornerPosition)position;

@end

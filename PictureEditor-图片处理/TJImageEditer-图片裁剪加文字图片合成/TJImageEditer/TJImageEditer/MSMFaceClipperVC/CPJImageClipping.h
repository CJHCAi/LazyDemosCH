//
//  CPJImageClipping.h
//  IOSTestFramework
//
//  Created by shuaizhai on 11/27/15.
//  Copyright © 2015 com.shuaizhai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CPJClippingPanel;
@interface CPJImageClipping : UIViewController

@property (nonatomic, strong)CPJClippingPanel* clippingPanel;
/**
 * 需要被裁减的位置，以及大小
 */
@property (nonatomic, assign)CGRect            clippingRect;

/**
 * 需要裁减的图片
 */
@property (nonatomic, strong)UIImage*          image;

- (UIImage *)clippImage;

@end

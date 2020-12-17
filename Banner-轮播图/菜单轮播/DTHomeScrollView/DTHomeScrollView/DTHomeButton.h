//
//  DTHomeButton.h
//  DTcollege
//
//  Created by 信达 on 2018/7/24.
//  Copyright © 2018年 ZDQK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTHomeButton : UIButton

/**
 The tilte Label.
 */
@property (nonatomic, strong) UILabel *btnTitle;

/**
 The tilte ImageView.
 */
@property (nonatomic, strong) UIImageView *btnImage;

/**
 The imageURL string.
 */
@property (nonatomic, copy) NSString *imageURLString;

/**
 The titleString
 */
@property (nonatomic, copy) NSString *titleString;

/**
 The titleColor default #343434.
 */
@property (nonatomic, copy) NSString *titleColor;

/**
  Initialize frame with title and imageURLString.

 @param frame frame
 @param title buttonTitle
 @param imageURLString buttonIamgeURLString
 @return object of DTHomeButton
 */
- (instancetype)initWithFrame:(CGRect)frame
                    withTitle:(NSString *)title
           withImageURLString:(NSString *)imageURLString;



@end

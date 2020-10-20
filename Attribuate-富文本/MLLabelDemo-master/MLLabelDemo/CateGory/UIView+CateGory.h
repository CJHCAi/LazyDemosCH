//
//  UIView+CateGory.h
//  MLLabelDemo
//
//  Created by 孙巧巧 on 2017/11/28.
//  Copyright © 2017年 孙巧巧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CateGory)

@property ( nonatomic,assign ) CGPoint origin;

@property ( nonatomic,assign ) CGSize size;



@property ( nonatomic,assign ) CGFloat X;

@property ( nonatomic,assign ) CGFloat Y;

@property ( nonatomic,assign ) CGFloat right;

@property ( nonatomic,assign ) CGFloat bottom;

@property ( nonatomic,assign ) CGFloat width;

@property ( nonatomic,assign ) CGFloat height;



- (CGRect)midframewithheight:(CGFloat)height width:(CGFloat)width;

- (BOOL)containssubviewOfClassType:(Class)cls;

- (void)removeAllsubViews;

- (void)removeSubviewsWithSubviewClass:(Class)cls;


+ (UINib*)nib;

+(instancetype)instanceFromNib;

- (void)simpleTransitionWithDuration:(CFTimeInterval)duration andType:(NSString *)type;


@end

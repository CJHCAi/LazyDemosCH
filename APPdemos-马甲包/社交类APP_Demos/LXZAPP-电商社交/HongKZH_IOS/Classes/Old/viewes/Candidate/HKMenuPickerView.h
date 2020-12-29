//
//  HKMenuPickerView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HKMenuPickerViewBlock)(NSInteger index);

@interface HKMenuPickerView : UIView
@property (nonatomic, copy) NSString *menuTitle;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, copy) HKMenuPickerViewBlock block;
+ (void)showInView:(UIView *)containerView
         menuTitle:(NSString *)menuTitle
          curIndex:(NSInteger )curIndex
            titles:(NSMutableArray *)titles
             block:(HKMenuPickerViewBlock)block;
@end

//
//  SearchNabarView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchNabarViewDelegate <NSObject>

@optional
- (void)textChangeWithText:(NSString *)textStr;
- (void)back ;
@end
@interface SearchNabarView : UIView
@property (nonatomic,weak) id<SearchNabarViewDelegate> delegate;
@property (nonatomic, copy)NSString *placeHoder;
@end

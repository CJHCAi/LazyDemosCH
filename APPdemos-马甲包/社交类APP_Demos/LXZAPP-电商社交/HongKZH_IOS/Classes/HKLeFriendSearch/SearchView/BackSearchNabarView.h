//
//  BackSearchNabarView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BackSearchNabarViewDelegate <NSObject>

@optional
- (void)textChangeWithText:(NSString *)textStr;
- (void)back ;
-(void)cancleClick;
@end
@interface BackSearchNabarView : UIView
@property (nonatomic,weak) id<BackSearchNabarViewDelegate> delegate;
@property (nonatomic, copy)NSString *searchText;
@property (nonatomic, copy)NSString *placeHoder;
@end

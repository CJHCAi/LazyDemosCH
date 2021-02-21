//
//  YCEditBackView.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/1.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YCEditBackViewDelegate<NSObject>

- (void)clickBackBtn;
- (void)clickLoveBtn;
@end

@interface YCEditBackView : UIView

@property (nonatomic, assign) id<YCEditBackViewDelegate> delegate;

- (void)setLoveBtnSelete:(BOOL)selete;

@end

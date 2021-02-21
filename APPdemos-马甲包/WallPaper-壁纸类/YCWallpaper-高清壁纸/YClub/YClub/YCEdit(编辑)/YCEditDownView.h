//
//  YCEditDownView.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/1.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YCEditDownViewDelegate<NSObject>

- (void)clickDownBtn;
- (void)clickReadBtn:(UIButton *)sender;
@end

@interface YCEditDownView : UIView

@property (nonatomic, assign) id<YCEditDownViewDelegate>delegate;

@end

//
//  ChooseBtnView.h
//  ListV
//
//  Created by imac on 16/7/20.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ChooseBtnViewDelegate<NSObject>

- (void)chooseType:(UIButton*)sender;

@end

@interface ChooseBtnView : UIView

@property (weak,nonatomic) id<ChooseBtnViewDelegate>delegate;

@end

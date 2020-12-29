//
//  HKNavSearchView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKNavSearchViewDelegate <NSObject>

@optional
-(void)closeSearch;
@end
@interface HKNavSearchView : UIView
@property (weak, nonatomic) IBOutlet UIButton *textFieldClck;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,weak) id<HKNavSearchViewDelegate> delegate;
@end

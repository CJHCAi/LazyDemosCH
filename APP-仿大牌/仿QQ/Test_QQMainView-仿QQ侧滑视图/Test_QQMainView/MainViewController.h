//
//  MainViewController.h
//  Text_QQMainView
//
//  Created by jaybin on 15/4/17.
//  Copyright (c) 2015年 jaybin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  点击类型
 */
typedef enum {
    ELeftButtonClicked = 0,
    ERightButtonClicked
}BarButtonClickType;


/**
 *  BarButtonBlock
 */
typedef void(^BarButtonBlock)(BarButtonClickType type);


@interface MainViewController : UIViewController{
    BarButtonBlock  _barButtonBlock;
}

@property (nonatomic, strong) BarButtonBlock barButtonBlock;

- (void)pushToSubView:(NSString *)desc;

@end

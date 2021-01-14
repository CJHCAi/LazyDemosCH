//
//  LanguageViewController.h
//  多语言切换demo
//
//  Created by 黄坚 on 2018/3/19.
//  Copyright © 2018年 黄坚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageViewController : UIViewController
@property (nonatomic,copy)NSString *leftTitle;
@property (nonatomic,copy)NSString *rightTitle;
-(void)back;
@end

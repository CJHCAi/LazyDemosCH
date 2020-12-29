//
//  HKAddProductDescViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddProductDescViewController.h"
#import "UITextView+Placeholder.h"
#import "HKToolBarOverKeyboard.h"
@interface HKAddProductDescViewController ()
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong)HKToolBarOverKeyboard *toolBarOverKeyboard;
@end

@implementation HKAddProductDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.textView.placeholder = @"请输入…";
    _toolBarOverKeyboard = [HKToolBarOverKeyboard initWithFrame:self.toolBarView.frame itemImageNames:@[@"fontb1",@"tupian1a",@"downe"] inView:self.toolBarView];
    UIToolbar*toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
     HKToolBarOverKeyboard*toolBarOverKeyboard = [HKToolBarOverKeyboard initWithFrame:CGRectMake(0, 0, kScreenWidth, 45) itemImageNames:@[@"fontb1",@"tupian1a",@"downe"] inView:nil];
    [toolBar addSubview:toolBarOverKeyboard];
    self.textView.inputAccessoryView = toolBar;
  toolBarOverKeyboard.clickItemCallback =   _toolBarOverKeyboard.clickItemCallback = ^(NSInteger index) {
        switch (index) {
            case 0:
            {
                //字体
                
            }
                break;
            case 1:
            {
                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                
                //自定义消息框
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
                //显示消息框
                [sheet showInView:self.view];
            }
                break;
            case 2:
            {
                //收起键盘
                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            }
                break;
            default:
                break;
        }
    };
}
@end

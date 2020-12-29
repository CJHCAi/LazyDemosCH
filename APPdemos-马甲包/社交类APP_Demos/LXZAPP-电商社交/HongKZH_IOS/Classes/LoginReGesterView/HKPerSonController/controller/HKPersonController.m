//
//  HKPersonController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPersonController.h"
#import "PickerView.h"
#import "HK_LoginRegesterTool.h"
#import "UIButton+LXMImagePosition.h"
@interface HKPersonController ()
{
    BOOL _isSelectedDate;
}
@property (weak, nonatomic) IBOutlet UITextField *birthTF;
@property (weak, nonatomic) IBOutlet UIButton *selfBtn;

@property (weak, nonatomic) IBOutlet UIView *liveFirst;
@property (weak, nonatomic) IBOutlet UITextField *genderTF;

@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;

@property (weak, nonatomic) IBOutlet UIView *liveTwo;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation HKPersonController
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppUtils setPopHidenNavBarForFirstPageVc:self];
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)configueUI {
    self.birthTF.enabled =NO;
    self.birthTF.textColor =[UIColor colorFromHexString:@"666666"];
    self.genderTF.enabled =NO;
    self.genderTF.textColor =[UIColor colorFromHexString:@"666666"];
    [self.selfBtn setTitleColor:[UIColor colorFromHexString:@"999999"] forState:UIControlStateNormal];
    [self.selfBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [self.selfBtn setImagePosition:1 spacing:6];
    [self.womanBtn setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [self.manBtn setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [self.womanBtn setImage:[UIImage imageNamed:@"Select"] forState:UIControlStateSelected];
    [self.manBtn setImage:[UIImage imageNamed:@"Select"] forState:UIControlStateSelected];
    [self.womanBtn setImagePosition:0 spacing:6];
    [self.manBtn setImagePosition:0 spacing:6];
    self.nextBtn.layer.cornerRadius =5;
    self.nextBtn.layer.masksToBounds =YES;
    self.nextBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
    [self.womanBtn setTitleColor:[UIColor colorFromHexString:@"999999"] forState:UIControlStateNormal];
    [self.manBtn setTitleColor:[UIColor colorFromHexString:@"999999"] forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextBtn.enabled =NO;
    
}
#pragma mark 选择生日
- (IBAction)selectDate:(id)sender {
    PickerView *vi = [[PickerView alloc] init];
    vi.type = PickerViewTypeBirthday;
//    @weakify(self);
    vi.block = ^(NSString *result) {
//        @strongify(self);
        self.birthTF.text =result;
        self->_isSelectedDate  =YES;
        if (self.womanBtn.selected ||self.manBtn.selected) {
            self.nextBtn.backgroundColor =RGB(255,49,34);
            self.nextBtn.enabled =YES;
        }
    };
    [self.navigationController.view addSubview:vi];
}
//下一步
- (IBAction)nextStep:(id)sender {
    NSInteger gender = self.manBtn.selected ?1:2;
    
    [HK_LoginRegesterTool completeUserInfoFirstStepWithBirthDay:self.birthTF.text WithSex:gender andCurrentVc:self];
}
//选择性别男
- (IBAction)SelectGender:(id)sender {
    
    self.manBtn.selected =YES;
    self.womanBtn.selected =NO;
  //可能触发的事件
    if (_isSelectedDate) {
        self.nextBtn.backgroundColor =RGB(255,49,34);
        self.nextBtn.enabled =YES;
    }
}
//选择性别女
- (IBAction)SelectWoman:(id)sender {
    
    self.manBtn.selected =NO;
    self.womanBtn.selected =YES;
    //可能触发的事件
    if (_isSelectedDate) {
        self.nextBtn.backgroundColor =RGB(255,49,34);
        self.nextBtn.enabled =YES;
    }
}
//跳过设置
-(void)skip {
    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"确定要跳过此步骤吗?"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:RGB(35,35,35) range:NSMakeRange(0, 9)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 9)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    UIAlertAction *cancleA =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancleA setValue:RGB(132,132,132) forKey:@"titleTextColor"];
                             
    [alertController addAction:cancleA];
                             UIAlertAction *define =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HKNickNameController *nick =[[HKNickNameController alloc] initWithNibName:@"HKNickNameController" bundle:nil];
        [self.navigationController pushViewController:nick animated:YES];
    }];
    [define setValue:RGB(233,67,48) forKey:@"titleTextColor"];
    [alertController addAction:define];
                            [self presentViewController:alertController animated:YES completion:nil];

}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
  {
      if (self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
             self.sx_disableInteractivePop =YES;
      }
      return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton =YES;
    self.title =@"完善个人信息";
    self.view.backgroundColor =[UIColor whiteColor];
    [AppUtils addBarButton:self title:@"跳过" action:@selector(skip) position:PositionTypeRight];
    [self configueUI];
    
}


@end

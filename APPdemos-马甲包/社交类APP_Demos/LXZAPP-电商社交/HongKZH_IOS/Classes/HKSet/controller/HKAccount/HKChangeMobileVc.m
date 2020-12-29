//
//  HKChangeMobileVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKChangeMobileVc.h"
#import "HK_RowFundCell.h"
#import "HK_CodeReceived.h"
@interface HKChangeMobileVc ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextField * _PhoneNumberTF;
}
@property (nonatomic, strong)UIView * topInfoView;
@property (nonatomic, strong)UIButton *subMitBtn;
@property (nonatomic, strong)UITableView *rowTableView;

@end

@implementation HKChangeMobileVc

-(UIView *)topInfoView {
    if (!_topInfoView) {
        _topInfoView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,60)];
        _topInfoView.backgroundColor =RGBA(245,245,245, 1);
        
        UILabel *tipsLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,15,kScreenWidth-30,40)];
        tipsLabel.numberOfLines = 0;
        [AppUtils getConfigueLabel:tipsLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:RGBA(102,102,102,1) text:[NSString stringWithFormat:@"你的账号目前绑定手机号是86 %@，请输入你希望绑定的手机号.",self.mobile]];
        [_topInfoView addSubview:tipsLabel];
        
    }
    return _topInfoView;
}
-(UIButton *)subMitBtn {
    if (!_subMitBtn) {
        _subMitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [AppUtils getButton:_subMitBtn font:PingFangSCRegular16 titleColor:[UIColor whiteColor] title:@"提交"];
        _subMitBtn.frame =CGRectMake(30,CGRectGetMaxY(self.rowTableView.frame)+40,kScreenWidth-60,49);
        _subMitBtn.layer.cornerRadius =5;
        _subMitBtn.layer.masksToBounds = YES;
        _subMitBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
        [_subMitBtn addTarget:self action:@selector(subComplains) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subMitBtn;
}
//下一步...
-(void)subComplains {
    HK_CodeReceived *code =[[HK_CodeReceived alloc] init];
    code.typeCode = codeChangeMobile;
    code.phonString = _PhoneNumberTF.text;
    code.previsPhone =self.mobile;
    [self.navigationController pushViewController:code animated:YES];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title =@"更换手机号";
    self.showCustomerLeftItem =YES;
    [self.view addSubview:self.topInfoView];
    [self.view addSubview:self.rowTableView];
    [self.view addSubview:self.subMitBtn];
    
}
-(UITableView *)rowTableView {
    if (!_rowTableView) {
        _rowTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topInfoView.frame),kScreenWidth,100) style:UITableViewStylePlain];
        _rowTableView.delegate =self;
        _rowTableView.dataSource =self;
        _rowTableView.rowHeight =50;
        _rowTableView.tableFooterView =[[UIView alloc] init];
        _rowTableView.scrollEnabled =NO;
        _rowTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    }
    return _rowTableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_RowFundCell * cell =[tableView dequeueReusableCellWithIdentifier:@"ROW"];
    if (cell==nil) {
        cell =[[HK_RowFundCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ROW"];
    }

    switch (indexPath.row) {
        case 0:
        {
            cell.tagLabel.text =@"当前手机号";
            cell.tagLabel.textColor =RGBA(153,153, 153, 1);
            cell.tagLabel.font = PingFangSCRegular15;
            cell.imageRow.hidden = YES;
            cell.textInput.enabled = NO;
            cell.textInput.placeholder =[NSString stringWithFormat:@"86 %@",self.mobile];
        }
            break;
        case 1:
        {
            cell.tagLabel.text = @"中国+86";
            cell.tagLabel.textColor =RGBA(51,51,51, 1);
            cell.tagLabel.font = PingFangSCRegular15;
            cell.imageRow.hidden = YES;
            cell.textInput.placeholder =@"请输入手机号码";
            cell.textInput.enabled = YES;
            _PhoneNumberTF =cell.textInput;
            [cell.textInput addTarget:self action:@selector(confirmSubmit) forControlEvents:UIControlEventEditingChanged];
        }
            break;
        default:
            break;
    }
    return  cell;
}
-(void)confirmSubmit {
    if (_PhoneNumberTF.text.length==11) {
        self.subMitBtn.backgroundColor = RGB(255,74,44);
        self.subMitBtn.enabled =YES;
    }else {
        self.subMitBtn.backgroundColor =[ UIColor colorFromHexString:@"#cccccc"];
        self.subMitBtn.enabled =NO;
    }
}

@end

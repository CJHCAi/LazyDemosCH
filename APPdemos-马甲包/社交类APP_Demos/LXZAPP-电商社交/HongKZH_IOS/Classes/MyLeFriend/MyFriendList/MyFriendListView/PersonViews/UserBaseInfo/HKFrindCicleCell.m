//
//  HKFrindCicleCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFrindCicleCell.h"
#import "HKFrindCicleInfoCell.h"
@interface HKFrindCicleCell ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation HKFrindCicleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
       // [self.contentView addSubview:self.tableView];
    }
    return self;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,20,200,14)
                      ];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"000000"] text:@""];
    }
    return _titleLabel;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.titleLabel.frame)+12,kScreenWidth,0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled =NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HKFrindCicleInfoCell class] forCellReuseIdentifier:@"info"];
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return  self.response.data.circles.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.response.data.circles.count>0?60:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKFrindCicleInfoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"info" forIndexPath:indexPath];
    cell.accessoryType  =UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
-(void)setResponse:(HKMediaInfoResponse *)response {
    _response = response;
    NSString *countStr =[NSString stringWithFormat:@"%zd",response.data.circles.count];
    NSString *titles =[NSString stringWithFormat:@"加入的圈子 %@",countStr];
    NSMutableAttributedString * att =[[NSMutableAttributedString alloc] initWithString:titles];
    [att addAttribute:NSForegroundColorAttributeName value:keyColor range:NSMakeRange(6,countStr.length)];
    self.titleLabel.attributedText = att;
   // CGFloat tabH =60*response.data.circles.count;
    //self.tableView.frame =CGRectMake(0,CGRectGetMaxY(self.titleLabel.frame)+12,kScreenWidth,tabH);
   // [self.tableView reloadData];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

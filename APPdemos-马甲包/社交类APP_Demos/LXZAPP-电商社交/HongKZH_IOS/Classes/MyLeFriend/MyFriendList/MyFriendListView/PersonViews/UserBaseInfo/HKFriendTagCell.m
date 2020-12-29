//
//  HKFriendTagCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFriendTagCell.h"
#import "TTTagView.h"
@interface HKFriendTagCell ()

@property (nonatomic, strong)UILabel * titleLabel;
/**
 *  记录输入标签的高度
 */
@property (assign, nonatomic) CGFloat inputHeight;
/**
 *  输入标签的背景视图(为了改变其高度)
 */
@property (strong, nonatomic) UIView *textBgView;

@end

@implementation HKFriendTagCell
{
    TTTagView *inputTagView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.inputHeight = 100;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView  addSubview:self.textBgView];
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
#pragma mark - 懒加载数据
- (UIView *)textBgView {
    if (_textBgView == nil) {
        _textBgView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.titleLabel.frame)+12,kScreenWidth,self.inputHeight)];
        _textBgView.backgroundColor =[UIColor whiteColor];
        inputTagView =[[TTTagView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth,self.inputHeight)];
        inputTagView.type = TTTagView_Type_Display;
        inputTagView.translatesAutoresizingMaskIntoConstraints=YES;
        {// 这些属性有默认值, 可以不进行设置
            inputTagView.inputBgColor = [UIColor whiteColor];
            inputTagView.bgColor = [UIColor colorFromHexString:@"eef2f8"];
            inputTagView.textColor = [UIColor colorFromHexString:@"333333"];
            inputTagView.selBgColor =[UIColor colorFromHexString:@"eef2f8"];
            inputTagView.selTextColor =[UIColor colorFromHexString:@"333333"];
        }
        // KVO监测其高度是否发生改变(改变的话就需要修改下边的所有控件的frame)
       // [inputTagView addObserver:self forKeyPath:@"changeHeight" options:NSKeyValueObservingOptionNew context:nil];
        [_textBgView addSubview:inputTagView];
        // 这里刷新是为了如果没有已经存在的标签(bqlabStr)传进来的话就会出问题
        [inputTagView layoutTagviews];
        [inputTagView resignFirstResponder];
    }
    return _textBgView;
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//
//    self.inputHeight = [[change valueForKey:@"new"] floatValue];
//    self.textBgView.frame = CGRectMake(0,self.textBgView.frame.origin.y,self.textBgView.frame.size.width,self.inputHeight);
//
//    DLog(@"观察监听的inputView高度...%@",change);
//}
-(void)setResponse:(HKMediaInfoResponse *)response {
    _response = response;
    NSArray *labels =response.data.labels;
    NSMutableArray * tags =[[NSMutableArray alloc] init];
    if (labels.count) {
        for (HKUSerTag * model in response.data.labels) {
            if (model.name.length) {
                 [tags addObject:model.name];
            }
        }
        [inputTagView addTags:tags];
    }else {
        [inputTagView addTags:@[@"看电影",@"外貌协会",@"完美主义",@"LOL",@"舞蹈"]];
    }
    
    NSString *countStr =[NSString stringWithFormat:@"%zd",labels.count];
    NSString *titles =[NSString stringWithFormat:@"标签 %@",countStr];
    NSMutableAttributedString * att =[[NSMutableAttributedString alloc] initWithString:titles];
    [att addAttribute:NSForegroundColorAttributeName value:keyColor range:NSMakeRange(3,countStr.length)];
  self.titleLabel.attributedText = att;
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

//
//  ContactTableViewCell.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "ContactTableViewCell.h"
#import "ContactModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ContactTableViewCell ()

@property (nonatomic,strong) UIImageView *headImageView;//头像
@property (nonatomic,strong) UILabel *nameLabel;//姓名
@property (nonatomic,strong) UIButton *selectButton;//选择按钮

@end

@implementation ContactTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self setUpView];
    }
    return self;
}

- (void)setContact:(ContactModel *)contact{
    _contact = contact;
    
    [self.headImageView setImage:[UIImage imageNamed:@"2"]];
    [self.nameLabel setText:contact.name];
    
    if ([self.contact.isSelected isEqualToString:@"1"]) {
                [self.selectButton setTitle:@"🔴" forState:UIControlStateNormal];

    }else{
                [self.selectButton setTitle:@"⚪️" forState:UIControlStateNormal];

    }

}


- (void)testAction:(UIButton *)sender{

    if ([self.contact.isSelected isEqualToString:@"0"]) {
   
        [self.selectButton setTitle:@"🔴" forState:UIControlStateNormal];
        self.contact.isSelected = @"1";
  
    }else{
        [self.selectButton setTitle:@"⚪️" forState:UIControlStateNormal];
        self.contact.isSelected = @"0";

    }

    
    !_selectedBlock ?: _selectedBlock(self.contact);

    
}
#pragma mark - setUpView
- (void)setUpView{
    
    //按钮
    [self.contentView addSubview:self.selectButton];
    //头像
    [self.contentView addSubview:self.headImageView];
    //姓名
    [self.contentView addSubview:self.nameLabel];
}


- (UIButton *)selectButton{
    if (!_selectButton) {
        _selectButton=[[UIButton alloc]initWithFrame:CGRectMake(5.0, 0, 50, 50)];

        [_selectButton addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _selectButton.titleLabel.font = [UIFont systemFontOfSize:20];
//        [_selectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        
//        [_selectButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_selectButton setTitle:@"⚪️" forState:UIControlStateNormal];
        


        }
    return _selectButton;
}


- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 5.0, 40.0, 40.0)];
        [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _headImageView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 5.0, kScreenWidth-60.0, 40.0)];\
        [_nameLabel setFont:[UIFont systemFontOfSize:16.0]];
    }
    return _nameLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  CustomHeadFooterView.m
//  核心动画
//
//  Created by 朱伟阁 on 2019/1/26.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import "CustomHeadFooterView.h"
#import "GroupModel.h"

@interface CustomHeadFooterView ()

@property(nonatomic, strong) UIButton *btnGroupTitle;
@property(nonatomic, strong) UILabel *lblCount;

@end

@implementation CustomHeadFooterView

+ (instancetype)headFooterViewWithTableview:(UITableView *)tableview{
    CustomHeadFooterView *view = [tableview dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([CustomHeadFooterView class])];
    if (view == nil) {
        view = [[CustomHeadFooterView alloc]initWithReuseIdentifier:NSStringFromClass([CustomHeadFooterView class])];
    }
    return view;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        UIButton *btnGroupTitle = [[UIButton alloc]init];
        [btnGroupTitle setImage:[UIImage imageNamed:@"sanjiaoxing-4.png"] forState:UIControlStateNormal];
        [btnGroupTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnGroupTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnGroupTitle setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [btnGroupTitle setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [btnGroupTitle addTarget:self action:@selector(btnGroupTitleClickd:) forControlEvents:UIControlEventTouchUpInside];
        //设置按钮中图片的显示模式
        btnGroupTitle.contentMode = UIViewContentModeCenter;
        //设置图片超出的部分不要截掉
        btnGroupTitle.imageView.clipsToBounds = NO;
        [self.contentView addSubview:btnGroupTitle];
        self.btnGroupTitle = btnGroupTitle;
        UILabel *lblCount = [[UILabel alloc]init];
        [self.contentView addSubview:lblCount];
        self.lblCount = lblCount;
    }
    return self;
}

- (void)btnGroupTitleClickd:(UIButton *)sender{
    NSLog(@"---%d",self.group.visible);
    //设置组状态
    self.group.visible = !self.group.isVisible;
    if(self.delegate&&[self.delegate respondsToSelector:@selector(groupHeaderViewDidClickTitleButton:)]){
        [self.delegate groupHeaderViewDidClickTitleButton:self];
    }
}

//当一个新的headerview已经加到某个父控件的时候调用
- (void)didMoveToSuperview{
    if(self.group.isVisible){
        self.btnGroupTitle.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else{
        self.btnGroupTitle.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)setGroup:(GroupModel *)group{
    //设置frame不要在这里设置frame，因为这个时候的当前控件(self)的宽和高都是0
    _group = group;
    [self.btnGroupTitle setTitle:group.name forState:UIControlStateNormal];
    self.lblCount.text = [NSString stringWithFormat:@"%@/%lu",group.online,(unsigned long)group.friends.count];
    if(self.group.isVisible){
        self.btnGroupTitle.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else{
        self.btnGroupTitle.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

//当前控件的frame发生改变的时候会调用这个方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.btnGroupTitle setFrame:self.bounds];
    CGFloat lblX = self.bounds.size.width - 10 - 100;
    [self.lblCount setFrame:CGRectMake(lblX, 0, 100, 44)];
}

@end

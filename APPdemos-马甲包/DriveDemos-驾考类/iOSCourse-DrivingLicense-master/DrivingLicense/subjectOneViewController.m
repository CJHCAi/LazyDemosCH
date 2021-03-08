//
//  subjectOneViewController.m
//  DrivingLicense
//
//  Created by 孙伊凡 on 17/2/18.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "subjectOneViewController.h"

@interface subjectOneViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation subjectOneViewController

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEM_WIDTH, self.view.frame.size.height)];
        _scrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEM_WIDTH, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:topView];
    [self.view addSubview:topView];
    
    UIButton *ruleBtn = [[UIButton alloc] initWithFrame:CGRectMake(9, (topView.frame.size.height - 30) / 2, (topView.frame.size.width / 3) - 6, 30)];
    ruleBtn.layer.cornerRadius = 5;
    [ruleBtn setTitle:@"科一考规" forState:UIControlStateNormal];
    [ruleBtn setFont:[UIFont systemFontOfSize:15]];
    [ruleBtn setTitleColor:[UIColor colorWithRed:0 green:139/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
    [topView addSubview:ruleBtn];
    ruleBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:1 blue:193/255.0 alpha:1.0];
    
    UIButton *skillBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ruleBtn.frame) + 6, ruleBtn.frame.origin.y, ruleBtn.frame.size.width - 6, ruleBtn.frame.size.height)];
    skillBtn.layer.cornerRadius = 5;
    [skillBtn setTitle:@"答题技巧" forState:UIControlStateNormal];
    [skillBtn setFont:[UIFont systemFontOfSize:15]];
    [skillBtn setTitleColor:[UIColor colorWithRed:65/255.0 green:105/255.0 blue:225/255.0 alpha:1] forState:UIControlStateNormal];
    [topView addSubview:skillBtn];
    skillBtn.backgroundColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1.0];
    
    UIButton *logoBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(skillBtn.frame) + 6, skillBtn.frame.origin.y, ruleBtn.frame.size.width - 6, ruleBtn.frame.size.height)];
    logoBtn.layer.cornerRadius = 5;
    [logoBtn setTitle:@"图标速记" forState:UIControlStateNormal];
    [logoBtn setFont:[UIFont systemFontOfSize:15]];
    [logoBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    [topView addSubview:logoBtn];
    logoBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:174/255.0 blue:185/255.0 alpha:1.0];

    UIView *TitleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + 10, SCREEM_WIDTH, self.view.frame.size.height * 0.3)];
    TitleView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:TitleView];
    
    UIButton *orderTitleBtn = [[UIButton alloc] initWithFrame:CGRectMake((TitleView.frame.size.width - TitleView.frame.size.width * 0.2) / 10, (TitleView.frame.size.height - TitleView.frame.size.width * 0.2) / 2, TitleView.frame.size.width * 0.35, TitleView.frame.size.width * 0.13)];
    orderTitleBtn.layer.cornerRadius = 20;
    orderTitleBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1.0];
    [orderTitleBtn setTitle:@"顺序答题" forState:UIControlStateNormal];
    [orderTitleBtn setFont:[UIFont systemFontOfSize:16]];
    [TitleView addSubview:orderTitleBtn];
    
    UIButton *randomTitleBtn = [[UIButton alloc] initWithFrame:CGRectMake(TitleView.frame.size.width / 2 + orderTitleBtn.frame.origin.x, orderTitleBtn.frame.origin.y, orderTitleBtn.frame.size.width, orderTitleBtn.frame.size.height)];
    randomTitleBtn.layer.cornerRadius = 20;
    [randomTitleBtn setTitle:@"随机答题" forState:UIControlStateNormal];
    [randomTitleBtn setFont:[UIFont systemFontOfSize:16]];
    randomTitleBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1.0];
    [TitleView addSubview:randomTitleBtn];
    
    UILabel *finishTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderTitleBtn.frame.origin.x, 2, 50, 20)];
    finishTitleLabel.text = @"已完成题库";
    finishTitleLabel.font = [UIFont systemFontOfSize:10];
    finishTitleLabel.textColor = [UIColor darkGrayColor];
    [TitleView addSubview:finishTitleLabel];
    
    UILabel *finishTitleNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(finishTitleLabel.frame.origin.x, CGRectGetMaxY(finishTitleLabel.frame), orderTitleBtn.frame.size.width, orderTitleBtn.frame.origin.y - CGRectGetMaxY(finishTitleLabel.frame))];
    finishTitleNumberLabel.textColor = orderTitleBtn.backgroundColor;
    finishTitleNumberLabel.text = [NSString stringWithFormat:@"0/1303"];
    [TitleView addSubview:finishTitleNumberLabel];
    
    UILabel *seriesRightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(randomTitleBtn.frame.origin.x, finishTitleLabel.frame.origin.y, finishTitleLabel.frame.size.width, finishTitleNumberLabel.frame.size.height)];
    seriesRightTitleLabel.text = @"最高连对数";
    seriesRightTitleLabel.textColor = finishTitleLabel.textColor;
    seriesRightTitleLabel.font = finishTitleLabel.font;
    [TitleView addSubview:seriesRightTitleLabel];
    
    UILabel *seriesRightTitleNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(seriesRightTitleLabel.frame.origin.x, finishTitleNumberLabel.frame.origin.y, randomTitleBtn.frame.size.width / 2, finishTitleNumberLabel.frame.size.height)];
    seriesRightTitleNumberLabel.text = [NSString stringWithFormat:@"0"];
    seriesRightTitleNumberLabel.textColor = finishTitleNumberLabel.textColor;
    seriesRightTitleNumberLabel.font = finishTitleNumberLabel.font;
    [TitleView addSubview:seriesRightTitleNumberLabel];
    
    UIImageView *wrongBookImg = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetMaxX(orderTitleBtn.frame) - 35)/2, CGRectGetMaxY(orderTitleBtn.frame) + 10, SCREEM_WIDTH * 0.1, SCREEM_WIDTH * 0.115)];
    wrongBookImg.image = [UIImage imageNamed:@"wrongbook"];
    [TitleView addSubview:wrongBookImg];
    
    UILabel *wrongBookLabel = [[UILabel alloc] initWithFrame:CGRectMake(wrongBookImg.frame.origin.x - 8, CGRectGetMaxY(wrongBookImg.frame) + 5, wrongBookImg.frame.size.height + 15, 15)];
    wrongBookLabel.text = @"错题本";
    wrongBookLabel.textAlignment = NSTextAlignmentCenter;
    wrongBookLabel.textColor = [UIColor lightGrayColor];
    wrongBookLabel.font = [UIFont systemFontOfSize:14];
    [TitleView addSubview:wrongBookLabel];
    
    UIImageView *favoriteImg = [[UIImageView alloc] initWithFrame:CGRectMake((TitleView.frame.size.width - wrongBookImg.frame.size.width) / 2, wrongBookImg.frame.origin.y, wrongBookImg.frame.size.width + 5, wrongBookImg.frame.size.height)];
    favoriteImg.image = [UIImage imageNamed:@"favorite"];
    [TitleView addSubview:favoriteImg];
    
    UILabel *favoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(favoriteImg.frame.origin.x - 8, wrongBookLabel.frame.origin.y, wrongBookLabel.frame.size.width, wrongBookLabel.frame.size.height)];
    favoriteLabel.text = @"收藏夹";
    favoriteLabel.textAlignment = NSTextAlignmentCenter;
    favoriteLabel.textColor = wrongBookLabel.textColor;
    favoriteLabel.font = wrongBookLabel.font;
    [TitleView addSubview:favoriteLabel];
    
    UIImageView *indefiniteImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(randomTitleBtn.frame) - wrongBookImg.frame.size.width * 2, wrongBookImg.frame.origin.y, wrongBookImg.frame.size.width + 5, wrongBookImg.frame.size.height)];
    indefiniteImg.image = [UIImage imageNamed:@"indefinite"];
    [TitleView addSubview:indefiniteImg];
    
    UILabel *indefiniteLabel = [[UILabel alloc] initWithFrame:CGRectMake(indefiniteImg.frame.origin.x - 8, wrongBookLabel.frame.origin.y, wrongBookLabel.frame.size.width, wrongBookLabel.frame.size.height)];
    indefiniteLabel.text = @"不确定";
    indefiniteLabel.textColor = wrongBookLabel.textColor;
    indefiniteLabel.textAlignment = NSTextAlignmentCenter;
    indefiniteLabel.font = wrongBookLabel.font;
    [TitleView addSubview:indefiniteLabel];
}

@end

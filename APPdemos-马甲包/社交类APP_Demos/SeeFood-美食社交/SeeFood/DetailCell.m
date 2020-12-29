//
//  DetailCell.m
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/25.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "DetailCell.h"
#import "DIYView.h"
#import "UIImageView+WebCache.h"

#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height

#define KBGColor [UIColor colorWithRed:245 / 255.0 green:244 / 255.0 blue:238 / 255.0 alpha:1]
#define KTextColor [UIColor darkGrayColor]

@interface DetailCell ()

/**标题*/
@property(nonatomic, strong)UILabel *titleLabel;
/**简单介绍*/
@property(nonatomic, strong)UILabel *imtroLabel;
/**用料*/
@property(nonatomic, strong)UIView *usageView;
/**辅助用料*/
@property(nonatomic, strong)UILabel *seasoningLabel;
/**步骤*/
@property(nonatomic, strong)UIView *stepsView;
/**显示@“用料”的label*/
@property(nonatomic, strong)UILabel *label1;
/**显示@“做法”的label*/
@property(nonatomic, strong)UILabel *label2;
/**横线*/
@property(nonatomic, strong)UIView *lineView;

@end

@implementation DetailCell

{
    CGFloat height;
    CGFloat lastY;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        lastY = 0;
        
        self.contentView.backgroundColor = KBGColor;
        
        self.myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -(KScreenWidth * 0 / 4), KScreenWidth, KScreenWidth)];
        self.myImageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_myImageView];
        
        // 标题
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, KScreenWidth - (KScreenWidth * 0 / 4), KScreenWidth - 20, 50)];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:_titleLabel];
        
        height = KScreenWidth + 50 - (KScreenWidth * 0 / 4);
        
        // 简介
        self.imtroLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, height, KScreenWidth - 40, 100)];
        self.imtroLabel.numberOfLines = 0;
        self.imtroLabel.font = [UIFont systemFontOfSize:14];
        self.imtroLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_imtroLabel];
        
        // 显示用料
        self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
        self.label1.text = @"主要原料";
//        self.label1.backgroundColor = KBGColor;
        self.label1.textColor = [UIColor blackColor];
        [self.contentView addSubview:_label1];
        
        // 详细用料
        self.usageView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 100)];
//        self.usageView.backgroundColor = KBGColor;
        [self.contentView addSubview:_usageView];
        
        // 辅助用料seasoning
        self.seasoningLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 30)];
        self.seasoningLabel.numberOfLines = 0;
        self.seasoningLabel.font = [UIFont systemFontOfSize:14];
        self.seasoningLabel.textColor = [UIColor darkGrayColor];
        [self.usageView addSubview:_seasoningLabel];
        
        // 详细用料最后添加一根lineView
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 1)];
        self.lineView.backgroundColor = [UIColor grayColor];
        self.lineView.alpha = 0.5;
        [self.usageView addSubview:_lineView];
        
        // 显示做法
        self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 50)];
        self.label2.text = @"做法";
//        self.label2.backgroundColor = KBGColor;

        self.label2.textColor = [UIColor blackColor];
        [self.contentView addSubview:_label2];
        
        // 步骤
        self.stepsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
//        self.stepsView.backgroundColor = KBGColor;
        [self.contentView addSubview:_stepsView];
    }
    return self;
}


- (void)setModel:(DetailListModel *)model
{
    NSString *urlString = [model.albums firstObject];
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
    // 给标题赋值
    self.titleLabel.text = model.title;
    // 动态返回简洁的高度
    _imtroLabel.text = model.imtro;
    CGRect imtroBounds = [model.imtro boundingRectWithSize:CGSizeMake(KScreenWidth - 40                                                                                                                                                                                                                                                                                                                                                                                            , 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    _imtroLabel.frame = CGRectMake(20, height, KScreenWidth - 40, imtroBounds.size.height);
    
    _label1.frame = CGRectMake(10, height + imtroBounds.size.height, KScreenWidth - 20, 50);
    
    //用料和用量
    NSArray *mainArray = [model.ingredients componentsSeparatedByString:@";"];
    
    NSInteger count = mainArray.count;
    
    self.usageView.frame = CGRectMake(0, height + imtroBounds.size.height + 50, KScreenWidth, 30 * count);
    
    for (int i = 0; i < count; i++) {
        NSString *string = mainArray[i];
        NSArray *tempArray = [string componentsSeparatedByString:@","];
        
        DIYView *diyView = [[DIYView alloc]initWithFrame:CGRectMake(0, 30 * i, KScreenWidth - 20, 30)];
        diyView.seasoning.text = tempArray[0];
        diyView.usage.text = tempArray[1];
        [self.usageView addSubview:diyView];
    }
    self.usageView.frame = CGRectMake(0, height + imtroBounds.size.height + 50, KScreenWidth, 30 * count);
    
    CGRect burdenBounds = [model.burden boundingRectWithSize:CGSizeMake(KScreenWidth - 20                                                                                                                                                                                                                                                                                                                                                                                            , 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    
    self.seasoningLabel.frame = CGRectMake(20, 30 * count + 10, KScreenWidth - 40, burdenBounds.size.height);
    self.seasoningLabel.text = [NSString stringWithFormat:@"%@", model.burden];
    
    self.lineView.frame = CGRectMake(10, 30 * count, KScreenWidth - 20, 1);
    
    CGFloat stepsViewY = height + imtroBounds.size.height + 50 + 30 * count + 50 + 10 + burdenBounds.size.height;
    
    // 做法
    _label2.frame = CGRectMake(10, stepsViewY - 50, KScreenWidth - 20, 50);
    
    NSArray *stepsArray = model.steps;
    for (int i = 0; i < stepsArray.count; i++) {
        NSDictionary *dic = stepsArray[i];
        
        UIImageView *stepImageView = [[UIImageView alloc]initWithFrame:CGRectMake((KScreenWidth - 180) / 2, lastY + 137 * i, 180, 137)];

        stepImageView.backgroundColor = [UIColor grayColor];
        [self.stepsView addSubview:stepImageView];
        [stepImageView sd_setImageWithURL:dic[@"img"]];
        
        CGRect stepLabelBounds = [dic[@"step"] boundingRectWithSize:CGSizeMake(KScreenWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        UILabel *stepLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lastY + 137 * (i + 1) + 5, KScreenWidth - 20, stepLabelBounds.size.height)];
        stepLabel.text = dic[@"step"];
        NSLog(@"%@", dic[@"step"]);
        stepLabel.font = [UIFont systemFontOfSize:16];
        stepLabel.textColor = [UIColor darkGrayColor];
        stepLabel.numberOfLines = 0;
        [self.stepsView addSubview:stepLabel];
        lastY += stepLabelBounds.size.height + 10;
    }
    self.stepsView.frame = CGRectMake(0, stepsViewY, KScreenWidth, lastY);
}

+ (CGFloat)rowHeight:(DetailListModel *)model
{

    CGFloat imageViewY = KScreenWidth - (KScreenWidth * 0 / 4) + 50;
    
    CGRect imtroBounds = [model.imtro boundingRectWithSize:CGSizeMake(KScreenWidth - 20                                                                                                                                                                                                                                                                                                                                                                                            , 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    NSArray *array = [model.ingredients componentsSeparatedByString:@";"];
    CGFloat usageViewHeight = 30 * array.count;
    
    CGRect burdenBounds = [model.burden boundingRectWithSize:CGSizeMake(KScreenWidth - 20                                                                                                                                                                                                                                                                                                                                                                                            , 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    
    NSArray *stepsArray = model.steps;
    CGFloat stepY = 0.0;
    for (int i = 0; i < stepsArray.count; i++) {
        NSDictionary *dic = stepsArray[i];
        CGRect stepLabelBounds = [dic[@"step"] boundingRectWithSize:CGSizeMake(KScreenWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        stepY += stepLabelBounds.size.height + 10 + 137;
    }

    return imageViewY + imtroBounds.size.height + usageViewHeight + burdenBounds.size.height + 30 + stepY + 100;
}

@end

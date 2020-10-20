//
//  WAllGenView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WAllGenView.h"
@interface WAllGenView()

/**他的家谱Label*/
@property (nonatomic,strong) UILabel *famLabel;

@end
@implementation WAllGenView

- (instancetype)initWithFrame:(CGRect)frame model:(WpersonInfoModel *)infoModel
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAllGen];
        
        NSArray <WPersonGenlist *>*myArr = infoModel.genlist;
        
        [myArr enumerateObjectsUsingBlock:^(WPersonGenlist * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self createGenBookWithFrame:AdaptationFrame(40+165*idx, 80, 136, 207) Name:myArr[idx].gename genNumber:myArr[idx].ds famZB:myArr[idx].zb];
        }];
        
    }
    return self;
}

-(void)initAllGen{
    //背景
    UILabel *famLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(25, 25, 100, 25)];
    famLabel.text = @"她的家谱";
    famLabel.font = WFont(20);
    self.famLabel = famLabel;
    [self addSubview:self.famLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:AdaptationFrame(CGRectXW(famLabel)/AdaptationWidth(), 35, 600, 3)];
    lineView.backgroundColor = LH_RGBCOLOR(228, 228, 228);
    [self addSubview:lineView];
    
}

-(void)createGenBookWithFrame:(CGRect)frame Name:(NSString *)genName genNumber:(NSInteger )genNumber famZB:(NSString *)zb{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode  = UIViewContentModeScaleToFill;
    imageView.image = MImage(@"gr_book");
    [self addSubview:imageView];
    
    UILabel *famNameLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(50, 18, 21, 105)];
    famNameLabel.backgroundColor = [UIColor whiteColor];
    famNameLabel.text = [NSString verticalStringWith:genName];
    famNameLabel.font = BFont(19*AdaptationWidth());
    famNameLabel.numberOfLines = 0;
    [imageView addSubview:famNameLabel];
    
    UIView *halfBlackView = [[UIView alloc] initWithFrame:AdaptationFrame(5, 160, 126, 45)];
    halfBlackView.alpha = 0.5;
    halfBlackView.backgroundColor = [UIColor blackColor];
    [imageView addSubview:halfBlackView];
    
    NSString *ds = [NSString translation:(int)genNumber];
    UILabel *buttomLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(0, 160, 126, 45)];
    buttomLabel.font = BFont(16*AdaptationWidth());
    buttomLabel.textAlignment = 1;
    buttomLabel.textColor = [UIColor whiteColor];
    buttomLabel.text = [NSString stringWithFormat:@"第%@代   字辈 %@",ds,zb];
    [imageView addSubview:buttomLabel];
    
}
#pragma mark *** setter ***
-(void)setSex:(BOOL)sex{
    _sex = sex;
    if (_sex) {
        self.famLabel.text = @"他的家谱";
    }else{
        self.famLabel.text = @"她的家谱";
    }
}
@end

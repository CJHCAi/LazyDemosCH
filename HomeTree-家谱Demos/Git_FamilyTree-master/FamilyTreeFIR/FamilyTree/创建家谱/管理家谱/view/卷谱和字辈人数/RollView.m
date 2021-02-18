//
//  RollView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "RollView.h"
@interface RollView()
@property (nonatomic,strong) UIImageView *rollImageView; /*背景图片*/
@property (nonatomic,strong) UILabel *rollLabel; /*名字*/
@end

@implementation RollView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title rollType:(RollViewType)rollType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self addSubview:self.rollImageView];
        
        
        if (rollType == RollViewTypeDecade) {
            
            NSString *nineStr = [title stringByReplacingOccurrencesOfString:@"9" withString:@"9 "];

            self.rollLabel.text = nineStr;

        }else if(rollType == RollViewTypeUnitsDigit){
            
            self.rollLabel.text = [NSString verticalStringWith:title];

        }
        
        [self addSubview:self.rollLabel];

    }
    return self;
}



-(UIImageView *)rollImageView{
    if (!_rollImageView) {
        _rollImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _rollImageView.image = MImage(@"kuang");
    }
    return _rollImageView;
}

-(UILabel *)rollLabel{
    if (!_rollLabel) {
        _rollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35*AdaptationWidth(), self.bounds.size.height)];
        _rollLabel.numberOfLines = 0;
        _rollLabel.textAlignment = 1;
        _rollLabel.font = MFont(30*AdaptationWidth());
        _rollLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
    return _rollLabel;
}


@end

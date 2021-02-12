//
//  CJMonthDayCollectionCell.m
//  CJCalendar
//
//  Created by chjsun on 16/5/26.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import "CJMonthDayCollectionCell.h"

@interface CJMonthDayCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *gregoiainDaylabel;

@property (weak, nonatomic) IBOutlet UILabel *lunarDayLabel;

@end

@implementation CJMonthDayCollectionCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)setGregoiainDay:(NSString *)gregoiainDay{
    _gregoiainDay = gregoiainDay;
    self.gregoiainDaylabel.text = gregoiainDay;
}

-(void)setLunarDay:(NSString *)lunarDay{
    _lunarDay = lunarDay;
    self.lunarDayLabel.text = lunarDay;
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 在此添加
        // 初始化时加载collectionCell.xib文件
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CJMonthDayCollectionCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        
        if(arrayOfViews.count < 1){return nil;}
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}


@end

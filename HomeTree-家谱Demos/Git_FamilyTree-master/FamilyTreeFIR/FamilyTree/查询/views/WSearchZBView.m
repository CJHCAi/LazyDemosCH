//
//  WSearchZBView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/14.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WSearchZBView.h"
@interface WSearchZBView()
/**字辈label*/
@property (nonatomic,strong) UILabel *allZbLabel;
@end

@implementation WSearchZBView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.allZbLabel];
    }
    return self;
}

-(void)reloadWithZBArr:(NSArray *)zbArray{
    NSArray *dataArr = @[@"正",@"大",@"光，明",@"呵，说",@"晕"];
    if (zbArray) {
        
        dataArr = zbArray;
        
    }
    
   NSString *finStr = @"";
    
    for (NSString *obj in dataArr) {
        NSString *str = [obj stringByReplacingOccurrencesOfString:@"，" withString:@""];
        
        finStr = [finStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",str]];
    }
    
    self.allZbLabel.text = finStr;
    
}

#pragma mark *** getters ***
-(UILabel *)allZbLabel{
    if (!_allZbLabel) {
   
        UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 75*AdaptationWidth())];
        theLabel.layer.borderWidth = 1.0f;
        theLabel.layer.borderColor = LH_RGBCOLOR(220, 203, 188).CGColor;
        theLabel.text = @"字辈";
        theLabel.font = WFont(35);
        theLabel.textAlignment = 1;
        [self addSubview:theLabel];
        
        _allZbLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectYH(theLabel), self.bounds.size.width, self.bounds.size.height-theLabel.bounds.size.height)];
        _allZbLabel.font = theLabel.font;
        _allZbLabel.layer.borderColor = theLabel.layer.borderColor;
        _allZbLabel.layer.borderWidth = 1.0f;
        _allZbLabel.textAlignment = 1;
        _allZbLabel.numberOfLines = 0;
        
        
    }
    return _allZbLabel;
}
@end

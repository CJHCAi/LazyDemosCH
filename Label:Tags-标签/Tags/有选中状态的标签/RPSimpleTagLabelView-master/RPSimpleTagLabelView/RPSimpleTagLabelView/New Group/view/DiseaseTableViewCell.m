//
//  DiseaseTableViewCell.m
//  RPSimpleTagLabelView
//
//  Created by 李贤惠 on 2020/3/13.
//  Copyright © 2020 Tao. All rights reserved.
//

#import "DiseaseTableViewCell.h"
#import "NSString+Extension.h"

@implementation DiseaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}
- (void)setDrugsArray:(NSMutableArray *)drugsArray {
    _drugsArray = drugsArray;
    [self commitSubViews];
}
+ (instancetype)instanceWithDiseaseCellIdentifier {
    return [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DiseaseCell"];
}
- (void)commitSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:17.0];
    //    self.addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //    [self.addButton setTitle:@"去添加" forState:UIControlStateNormal];
    //    [self.addButton setHidden:YES];
    //    [self.addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //    self.addButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    [self.addButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    //    self.addButton.layer.borderWidth = 1.0;
    //    self.addButton.layer.cornerRadius = 30.0/2;
    //    self.addButton.frame = CGRectMake(SCREEN_WIDTH - 100, 13, 80, 30.0);
    //    [self addSubview:self.addButton];
    
    CGFloat w = 0;
    CGFloat h = 56.0;
    for (int i= 0; i < self.drugsArray.count; i++) {
        self.label = [[UILabel alloc]init];
        self.label.backgroundColor = [NSString colorWithHexString:@"#3997fd"];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:15.0];
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGFloat length = [self.drugsArray[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        self.label.clipsToBounds = YES;
        self.label.layer.borderWidth = 1.0;
        self.label.layer.borderColor = [UIColor clearColor].CGColor;
        self.label.layer.cornerRadius = 30/2;
        self.label.text = self.drugsArray[i];
        self.label.tag = i;
        self.label.frame = CGRectMake(10 + w, h, length + 15 , 30);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w + length + 15 > SCREEN_WIDTH){
            w = 0; //换行时将w置为0
            h = h + self.label.frame.size.height + 10;//距离父视图也变化
            self.label.frame = CGRectMake(10 + w, h, length + 15, 30);//重设button的frame
        }
        w = self.label.frame.size.width + self.label.frame.origin.x;
        
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swapLabels:)];
        oneTap.numberOfTapsRequired = 1;
        [self.label addGestureRecognizer:oneTap];
        self.label.userInteractionEnabled = YES;
        [self addSubview:self.label];
        self.buttonHeight = CGRectGetMaxY(self.label.frame);
    }
    
    if (self.drugsArray.count == 0) {
        self.buttonHeight = 56 + 1;
    }
    self.line = [[UIView alloc]initWithFrame:CGRectMake(10,self.buttonHeight + 10 + 1, SCREEN_WIDTH-2*10, 1)];
    self.line.backgroundColor = [UIColor clearColor];
    [self addSubview:self.line];
}
-(void)swapLabels:(UITapGestureRecognizer *)sender {
    UILabel *label = sender.view;
    [label setHidden:YES];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(deleteDrugsWithLabel:)]) {
        [self.delegate deleteDrugsWithLabel:label];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(10, 1, 150, 56.0 - 2);
}
- (CGFloat)CellHeight {
    return CGRectGetMaxY(self.line.frame);
}
@end

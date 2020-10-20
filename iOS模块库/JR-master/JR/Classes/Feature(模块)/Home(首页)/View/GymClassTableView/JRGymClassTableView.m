//
//  JRGymClassTableView.m
//  JR
//
//  Created by Zj on 17/8/19.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "JRGymClassTableView.h"
#import "JRGymClassCell.h"

static NSString *const JRGymClassCellReusedId = @"JRGymClassCellReusedId";

@interface JRGymClassTableView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation JRGymClassTableView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        
        [self prepare];
    }
    return self;
}


#pragma mark - private
- (void)prepare{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = NO;
    self.backgroundColor = JRClearColor;
    [self registerClass:[JRGymClassCell class] forCellReuseIdentifier:JRGymClassCellReusedId];
}


#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JRGymClassCellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return JRPadding;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JRGymClassCell *cell = [tableView dequeueReusableCellWithIdentifier:JRGymClassCellReusedId forIndexPath:indexPath];
    UIImage *classImage;
    NSAttributedString *classInfoAtt;
    NSString *classTime;
    switch (indexPath.section) {
        case 0:
            
            classImage = [UIImage imageNamed:@"class1"];
            classInfoAtt = [self classInfoWithClassName:@"肩颈瑜伽" coachName:@" 爱健身的猫"];
            classTime = @"今天 周四 12:00~14:00";
            break;
            
        case 1:
            
            classImage = [UIImage imageNamed:@"class2"];
            classInfoAtt = [self classInfoWithClassName:@"魅力热舞" coachName:@" Elsa"];
            classTime = @"今天 周四 15:00~17:00";
            break;
            
        case 2:
            
            classImage = [UIImage imageNamed:@"class3"];
            classInfoAtt = [self classInfoWithClassName:@"Easy有氧" coachName:@" 伊伊"];
            classTime = @"今天 周四 19:00~21:00";
            break;
            
        default:
            break;
    }
    cell.classImageView.image = classImage;
    cell.classInfoLabel.attributedText = classInfoAtt;
    cell.classTimeLabel.text = classTime;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.JRdelegate respondsToSelector:@selector(JRGymClassTableViewdidSelectedRowWithRow:)]) {
        [self.JRdelegate JRGymClassTableViewdidSelectedRowWithRow:indexPath.row];
    }
}
- (NSAttributedString *)classInfoWithClassName:(NSString *)className coachName:(NSString *)cocahName{
    NSAttributedString *classNameAtt = [[NSAttributedString alloc] initWithString:className attributes:@{
                                                                                                         NSFontAttributeName : JRBlodFont(16),
                                                                                                         NSForegroundColorAttributeName : JRCommonTextColor
                                                                                                         }];
    NSAttributedString *coachNameAtt = [[NSAttributedString alloc] initWithString:cocahName attributes:@{
                                                                                                         NSFontAttributeName : JRCommonFont(13),
                                                                                                         NSForegroundColorAttributeName : JRHexColor(0x4c7780)
                                                                                                         }];
    
    NSMutableAttributedString *classInfo = [[NSMutableAttributedString alloc] init];
    [classInfo appendAttributedString:classNameAtt];
    [classInfo appendAttributedString:coachNameAtt];
    return classInfo;
}


@end

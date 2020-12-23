//
//  historyTableViewCell.m
//  Calculator1
//
//  Created by ruru on 16/4/22.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "historyTableViewCell.h"

@implementation historyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    }

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//}
-(id)initWithData:(NSDictionary *)info tableView:(id)tableView{
    static NSString *CellIdentifier=@"CallId";
    self=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self==nil) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"historyTableViewCell" owner:self options:nil]lastObject];
    }
//     NSDictionary *dic=@{@"ID":IDStr,@"time":time,@"beforeNub":beforeNub,@"operationType":operationType,@"currentNub":currentNub,@"ResultStr":ResultStr};
    self.infoLable.text=[NSString stringWithFormat:@"%@ %@ %@=",info[@"beforeNub"],info[@"operationType"],info[@"currentNub"]]  ;
    self.mathResultLable.text=info[@"ResultStr"];
    int time=[info[@"time"] intValue];//转换成整型
    self.yearLable.text = [self date:time formate:@"YYYY"];
    self.monthLable.text = [self date:time formate:@"M月d"];
    return  self;
}
-(NSString *)date:(int)time formate:(NSString *)formate{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ]init];
    [formatter setDateFormat:formate];
    return [formatter stringFromDate:date];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
}
@end

//
//  TableViewCell.m
//  cellLLLLL
//
//  Created by Janice on 2017/10/11.
//  Copyright © 2017年 Janice. All rights reserved.
//

#import "TableViewCell.h"
#import "Tool.h"

@interface TableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labHit;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (nonatomic,strong) NSString *contentString;
@property (nonatomic,strong) NSString *fixedText;
@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setDicinfo:(NSDictionary *)dicinfo{
    
    _dicinfo = dicinfo;
    self.lab.text = _dicinfo[@"content"];
    BOOL flage = [self infocount:self.lab];
    
    if (flage) {
        if ([_dicinfo[@"isChoice"] isEqualToString:@"NO"]) {
            NSInteger theRange = self.contentString.length-self.fixedText.length+3;
            self.lab.attributedText = [Tool theRichText:self.contentString theRange:theRange changeRange:4 color:[UIColor blueColor]];
            self.labHit.constant =0;
        }else{
            self.labHit.constant =25;
        }
    }else{
        self.labHit.constant =0;
        self.lab.text = _dicinfo[@"content"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (BOOL)infocount:(UILabel *)lable{
    
    NSArray *stringArr = [Tool getLinesArrayOfStringInLabel:lable];
    
    if (stringArr.count>2) {
        NSString *string1 = stringArr[0];
        NSString *string2 = stringArr[1];
        self.fixedText = @"...【展开】";
        NSString *string3 = [NSString stringWithFormat:@"%@%@",string2,self.fixedText];

        if (string3.length>string1.length) {
            NSInteger len = string3.length - string1.length;
            string2 = [string2 substringToIndex:string2.length-len-4];
            string2 = [NSString stringWithFormat:@"%@%@",string2,self.fixedText];
        }
        self.contentString = [NSString stringWithFormat:@"%@%@",string1,string2];
        return YES;
    }

    return NO;
}

@end


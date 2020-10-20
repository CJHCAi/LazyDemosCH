//
//  PortraiView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PortraiView.h"
@interface PortraiView()
@property (nonatomic,strong) UIImageView *headImage; /*头像*/
@property (nonatomic,strong) UILabel *nameInfo; /*名字*/
@property (nonatomic,strong) UILabel *idLabel; /*身份*/
@property (nonatomic,strong) UILabel *fatherLabel; /*父亲*/
@property (nonatomic,strong) UILabel *momLabel; /*母亲*/





@end
@implementation PortraiView
- (instancetype)initWithFrame:(CGRect)frame portaitImageUrl:(NSString *)pImageUrl porName:(NSString *)name infoArr:(NSArray *)infoArr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];;
        UITapGestureRecognizer *tapGues = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToMemberhead)];
        headImage.userInteractionEnabled = YES;
        [headImage addGestureRecognizer:tapGues];
        
        if (pImageUrl) {
            headImage.imageURL = [NSURL URLWithString:pImageUrl];
        }else{
            headImage.image = MImage(@"ziBei_touxiang_man");
        }
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectYH(headImage), self.bounds.size.width, 56*AdaptationWidth())];
        nameLabel.text = name;
        nameLabel.font = MFont(16);
        nameLabel.textAlignment = 1;
        [self addSubview:headImage];
        [self addSubview:nameLabel];
        
        NSArray *maeArr = @[@"身份：",@"父亲：",@"母亲："];
        
        for (int idx = 0; idx<infoArr.count; idx++) {
            UILabel *label = [[UILabel alloc ] initWithFrame:CGRectMake(0,CGRectYH(nameLabel)+idx*24*AdaptationWidth(), self.bounds.size.width+10, 22*AdaptationWidth())];
            label.font = MFont(11);
            label.text = [NSString stringWithFormat:@"%@%@",maeArr[idx],infoArr[idx]];
            [self addSubview:label];
        }
    }
    return self;
}
-(void)respondsToMemberhead{
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"gemeid":self.mygemId} requestID:GetUserId requestcode:kRequestCodequerygemedetailbyid success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            WpersonInfoModel *model = [WpersonInfoModel modelWithJSON:jsonDic[@"data"]];
            
            WPersonInfoViewController *personVc = [[WPersonInfoViewController alloc] initWithTitle:@"个人信息" image:nil];
            personVc.infoModel = model;
            [self.viewController.navigationController pushViewController:personVc animated:YES];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark *** getters ***


@end

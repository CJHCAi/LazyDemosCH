//
//  HKFriendAttentionCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFriendAttentionCell.h"
#import "HKFriendUserCell.h"
@interface HKFriendAttentionCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UICollectionView * collectionView;

@end
@implementation HKFriendAttentionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,20,200,14)
                      ];
        [AppUtils getConfigueLabel:_titleLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"000000"] text:@""];
    }
    return _titleLabel;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing =15;
        layout.itemSize = CGSizeMake(48,70);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.titleLabel.frame)+12,kScreenWidth-30,70) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces =NO;
        _collectionView.showsHorizontalScrollIndicator =NO;
        _collectionView.backgroundColor =[UIColor whiteColor];
        [_collectionView registerClass:[HKFriendUserCell class] forCellWithReuseIdentifier:@"userF"];
    }
    return _collectionView;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.response.data.follows.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKFriendUserCell *userCell =[collectionView dequeueReusableCellWithReuseIdentifier:@"userF" forIndexPath:indexPath];
    HKmediaInfoFollows *model =self.response.data.follows[indexPath.row];
    [userCell.icon sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"Man"]];
    userCell.nameLabel.text =model.name;
    return userCell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,15,0,0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HKmediaInfoFollows *model =self.response.data.follows[indexPath.row];
    if (self.delegete && [self.delegete respondsToSelector:@selector(pushUserDetailWithModel:)]) {
        [self.delegete pushUserDetailWithModel:model];
    }
}
-(void)setResponse:(HKMediaInfoResponse *)response {
    _response =response;
    NSString *countStr =[NSString stringWithFormat:@"%zd",response.data.follows.count];
    NSString *titles =[NSString stringWithFormat:@"关注的人 %@",countStr];
    NSMutableAttributedString * att =[[NSMutableAttributedString alloc] initWithString:titles];
    [att addAttribute:NSForegroundColorAttributeName value:keyColor range:NSMakeRange(5,countStr.length)];
    self.titleLabel.attributedText = att;
    CGFloat collectionH;
    if (response.data.follows.count) {
        collectionH = 70;
    }else {
        collectionH = 0;
    }
    self.collectionView.frame =   CGRectMake(0,CGRectGetMaxY(self.titleLabel.frame)+12,kScreenWidth-30,collectionH);
    [self.collectionView reloadData];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

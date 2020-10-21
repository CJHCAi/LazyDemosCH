//
//  PIPCollectionView.m
//  LuoChang
//
//  Created by Rick on 15/9/14.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import "PIPCollectionView.h"
#import "PIPCollectionViewCell.h"

@implementation PIPCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        _pipArray = self.pipArray;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        self.collectionViewLayout = layout;
        [self registerNib:[UINib nibWithNibName:@"PIPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"pipCell"];
        self.backgroundColor = RGB(235, 237, 237);
    }
    return self;
}

-(NSArray *)pipArray{
    if (!_pipArray) {
        NSMutableArray *pipArray = [NSMutableArray array];
        //    CGFloat y = self.scrollView.frame.size.height-384/2;
        NSDictionary *dict0 = @{
                                @"title":@"无",
                                @"name":@"None"
                                };
        NSDictionary *dict1 = @{
                                @"title":@"影子前锋",
                                @"name":@"画中画01背景.jpg",
                                @"isGIF":@NO,
                                @"layerMasksToBounds":@NO,//layer是否需要裁减圆角
                                @"hasPendant":@YES,//是否有挂件
                                @"pendantName":@"画中画01前景效果.png",
                                @"width":@320,
                                @"height":@192,
                                @"photoFrame":[NSValue valueWithCGRect:CGRectMake(188/2, 38/2, 256/2, 308/2)],
                                @"pendantFrame":[NSValue valueWithCGRect:CGRectMake(188/2, 38/2, 256/2, 308/2)]
                                };
        
        
        NSDictionary *dict2 = @{
                                @"title":@"帽子戏法",
                                @"name":@"画中画02背景.gif",
                                @"isGIF":@YES,
                                @"layerMasksToBounds":@NO,//layer是否需要裁减圆角
                                @"hasPendant":@NO,//是否有挂件
                                @"pendantName":@"",
                                @"width":@320,
                                @"height":@192,
                                @"photoFrame":[NSValue valueWithCGRect:CGRectMake(195/2, 40/2, 251/2, 302/2)]
                                };
        
        NSDictionary *dict4 = @{
                                @"title":@"牛尾巴过人",
                                @"name":@"画中画04背景.jpg",
                                @"isGIF":@NO,
                                @"layerMasksToBounds":@NO,//layer是否需要裁减圆角
                                @"hasPendant":@YES,//是否有挂件
                                @"pendantName":@"画中画04前景效果.png",
                                @"width":@320,
                                @"height":@192,
                                @"photoFrame":[NSValue valueWithCGRect:CGRectMake(147/2, 33/2, 256/2, 308/2)],
                                @"pendantFrame":[NSValue valueWithCGRect:CGRectMake(147/2, 33/2, 256/2, 308/2)]
                                };
        
        
        NSDictionary *dict5 = @{
                                @"title":@"飞火流星",
                                @"name":@"画中画05背景.jpg",
                                @"isGIF":@NO,
                                @"layerMasksToBounds":@NO,//layer是否需要裁减圆角
                                @"hasPendant":@NO,//是否有挂件
                                @"pendantName":@"",
                                @"width":@320,
                                @"height":@192,
                                @"photoFrame":[NSValue valueWithCGRect:CGRectMake(275/2, 36/2, 256/2, 308/2)]
                                };
        
        
        NSDictionary *dict6 = @{
                                @"title":@"凌空抽射",
                                @"name":@"画中画06背景.jpg",
                                @"isGIF":@NO,
                                @"hasPendant":@YES,//是否有挂件
                                @"layerMasksToBounds":@YES,//layer是否需要裁减圆角
                                @"cornerRadius":@(25/2),//圆角弧度
                                @"pendantName":@"画中画06前景效果.png",
                                @"width":@320,
                                @"height":@192,
                                @"photoFrame":[NSValue valueWithCGRect:CGRectMake(236/2, 86/2, 164/2, 220/2)],
                                @"pendantFrame":[NSValue valueWithCGRect:CGRectMake(236/2, 86/2, 164/2, 220/2)]
                                };
        
        
        NSDictionary *dict7 = @{
                                @"title":@"钟摆过人",
                                @"name":@"画中画07背景.jpg",
                                @"isGIF":@NO,
                                @"hasPendant":@YES,//是否有挂件
                                @"layerMasksToBounds":@NO,//layer是否需要裁减圆角
                                @"pendantName":@"画中画07前景效果.png",
                                @"width":@320,
                                @"height":@192,
                                @"photoFrame":[NSValue valueWithCGRect:CGRectMake(146/2, 110/2, 200/2, 239/2)],
                                @"pendantFrame":[NSValue valueWithCGRect:CGRectMake(146/2, 110/2, 200/2, 239/2)]
                                };
        
        NSDictionary *dict8 = @{
                                @"title":@"上帝之手",
                                @"name":@"画中画08背景.jpg",
                                @"isGIF":@NO,
                                @"hasPendant":@YES,//是否有挂件
                                @"layerMasksToBounds":@NO,//layer是否需要裁减圆角
                                @"pendantName":@"画中画08前景效果.png",
                                @"width":@320,
                                @"height":@192,
                                @"photoFrame":[NSValue valueWithCGRect:CGRectMake(177/2, 127/2, 296/2, 156/2)],
                                @"pendantFrame":[NSValue valueWithCGRect:CGRectMake(177/2, 127/2, 296/2, 156/2)]
                                };
        
        NSDictionary *dict9 = @{
                                @"title":@"一球成名",
                                @"name":@"画中画09背景.png",
                                @"isGIF":@NO,
                                @"isIrregular":@YES,//是否为不规则的背景
                                @"hasPendant":@NO,//是否有挂件
                                @"layerMasksToBounds":@NO,//layer是否需要裁减圆角
                                @"width":@320,
                                @"height":@192,
                                @"photoFrame":[NSValue valueWithCGRect:CGRectMake(177/2, 127/2, 296/2, 156/2)]
                                };
        [pipArray addObject:dict0];
        [pipArray addObject:dict1];
        [pipArray addObject:dict2];
        [pipArray addObject:dict4];
        [pipArray addObject:dict5];
        [pipArray addObject:dict6];
        [pipArray addObject:dict7];
        [pipArray addObject:dict8];
        [pipArray addObject:dict9];
        _pipArray = [pipArray copy];
    }
    return _pipArray;
}

#pragma mark - collectionView 代理方法

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self changePip:_pipArray[indexPath.row]];
//    _pipImageBtn.selected = NO;
    if ([self.pipDelegate respondsToSelector:@selector(pipItemClick:pipDict:)]) {
        [self.pipDelegate pipItemClick:indexPath pipDict:_pipArray[indexPath.row]];
    }
    [self removeFromSuperview];

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _pipArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"pipCell";
    
    PIPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *dict = _pipArray[indexPath.item];
    if (indexPath.item == 0) {
        cell.imageView.image = _originalImage;
    }else{
        cell.imageView.image = [UIImage imageNamed:dict[@"name"]];
    }
    
    cell.label.text = dict[@"title"];
    
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(115, 91);
}


@end

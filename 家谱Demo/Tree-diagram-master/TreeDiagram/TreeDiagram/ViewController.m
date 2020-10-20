//
//  ViewController.m
//  家庭关系图
//
//  Created by William on 16/6/16.
//  Copyright © 2016年 William. All rights reserved.
//

#import "ViewController.h"
#import "Family.h"
#import "FamilyModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:sc];

    //关系表示层级,1为最顶端,以此类推
    Family *view = [[Family alloc]initWithFrame:CGRectMake(0, 0, 3200,400)];
    sc.contentSize = view.frame.size;
    
    //前面四家人一直到辈
    NSArray *array1 = [self creatDataModel:@[@"你爷爷",@"你奶奶",@"你爸",@"你",@"儿子",@"儿子的女儿"]];
    NSArray *array2 = [self creatDataModel:@[@"你外公",@"你外婆",@"你妈",@"你",@"儿子",@"儿子的女儿"]];
    NSArray *array3 = [self creatDataModel:@[@"她外公",@"她外婆",@"她妈",@"她",@"儿子",@"儿子的女儿"]];
    NSArray *array4 = [self creatDataModel:@[@"她爷爷",@"她奶奶",@"她爸",@"她",@"儿子",@"儿子的女儿"]];
    
    //前面四家人一直到辈
    NSArray *array5 = [self creatDataModel:@[@"别的爷爷",@"别的奶奶",@"别的爸",@"别的你",@"别的儿子",@"儿子的女儿"]];
    NSArray *array6 = [self creatDataModel:@[@"你别的外公",@"别的外婆",@"别的妈",@"别的你",@"别的儿子",@"儿子的女儿"]];
    NSArray *array7 = [self creatDataModel:@[@"别的外公",@"别的外婆",@"别的妈",@"别的她",@"别的儿子",@"儿子的女儿"]];
    NSArray *array8 = [self creatDataModel:@[@"别的爷爷",@"别的奶奶",@"别的爸",@"别的她",@"别的儿子",@"儿子的女儿"]];
    
    //拼接数组,得到所有第一层级的模型
    NSArray *qianSiJia = [[[array1 arrayByAddingObjectsFromArray:array2]arrayByAddingObjectsFromArray:array3]arrayByAddingObjectsFromArray:array4];
    NSArray *houSiJia = [[[array5 arrayByAddingObjectsFromArray:array6]arrayByAddingObjectsFromArray:array7]arrayByAddingObjectsFromArray:array8];
    view.modelAry = [qianSiJia arrayByAddingObjectsFromArray:houSiJia];
    
    [sc addSubview:view];
}

- (NSArray *)creatDataModel:(NSArray *)nameAry
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < nameAry.count; i++)
    {
        FamilyModel *model = [[FamilyModel alloc]init];
        model.name = nameAry[i];
        switch (i)
        {
            case 0:
                model.level = 1;
                [array addObject:model];
                break;
            case 1:
                model.level = 1;
                [array addObject:model];
                break;
            case 2:
                ((FamilyModel *)array[0]).sunModel = model;
                ((FamilyModel *)array[1]).sunModel = model;
                model.level = 2;
                break;
            case 3:
                ((FamilyModel *)array[0]).sunModel.sunModel = model;
                ((FamilyModel *)array[1]).sunModel.sunModel = model;
                model.level = 3;
                break;
            case 4:
                ((FamilyModel *)array[0]).sunModel.sunModel.sunModel = model;
                ((FamilyModel *)array[1]).sunModel.sunModel.sunModel = model;
                model.level = 3;
                break;
            case 5:
                ((FamilyModel *)array[0]).sunModel.sunModel.sunModel.sunModel = model;
                ((FamilyModel *)array[1]).sunModel.sunModel.sunModel.sunModel = model;
                model.level = 3;
                break;
            default:
                break;
        }
        
    }
    return array;
}


@end

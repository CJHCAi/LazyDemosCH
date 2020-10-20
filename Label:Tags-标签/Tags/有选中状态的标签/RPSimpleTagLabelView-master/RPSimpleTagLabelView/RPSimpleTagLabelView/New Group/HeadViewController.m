//
//  HeadViewController.m
//  RPSimpleTagLabelView
//
//  Created by 李翩翩 on 2019/9/4.
//  Copyright © 2019 Tao. All rights reserved.
//

#import "HeadViewController.h"
#import "SelectDiseaseViewController.h"
#import "DiseaseTableViewCell.h"
#import "NSString+Extension.h"

@interface HeadViewController () <DeleteDrugsDelegate>
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic , strong) DiseaseTableViewCell *diseaseCell;//已选病症
@property (strong , nonatomic) NSMutableArray *nameArray;
@property (strong , nonatomic) NSMutableArray *resultArray;

@end

@implementation HeadViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [NSString colorWithHexString:@"#3997fd"];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if (@available(iOS 13.0, *)) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择确诊疾病";
    self.nameArray = [[NSMutableArray alloc]init];
    self.resultArray = [[NSMutableArray alloc]init];
    _diseaseCell = [DiseaseTableViewCell instanceWithDiseaseCellIdentifier];
    _diseaseCell.drugsArray = self.nameArray;
    _diseaseCell.frame = CGRectMake(0, 64, SCREEN_WIDTH, [self.diseaseCell CellHeight]);
    _diseaseCell.textLabel.text = @"请选择确诊病症:";
    [self.view addSubview:_diseaseCell];
}
- (IBAction)clickButton:(id)sender {
    SelectDiseaseViewController *VC = [[SelectDiseaseViewController alloc]init];
    if (self.nameArray.count > 0) {
        VC.nameArray = self.nameArray;
    }
    if (self.resultArray.count > 0) {
        VC.resultArray = self.resultArray;
    }
    [VC returnDiseaseInfo:^(NSMutableArray * _Nonnull nameArray, NSMutableArray * _Nonnull resultArray) {
        [self.nameArray removeAllObjects];
        [self.nameArray addObjectsFromArray:nameArray];
        
        [self.resultArray removeAllObjects];
        [self.resultArray addObjectsFromArray:resultArray];
        [self creatLastView];
    }];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void) creatLastView {
    [self.diseaseCell removeFromSuperview];
    self.diseaseCell = [DiseaseTableViewCell instanceWithDiseaseCellIdentifier];
    self.diseaseCell.drugsArray = self.nameArray;
    self.diseaseCell.frame = CGRectMake(0, 64, SCREEN_WIDTH, [self.diseaseCell CellHeight]);
    self.diseaseCell.textLabel.text = @"请选择确诊病症";
    _diseaseCell.delegate = self;
    [self.view addSubview:self.diseaseCell];
}

- (void)deleteDrugsWithLabel:(UILabel *)label {
    for (int i = 0; i < [self.nameArray count]; i ++) {
            if ([self.nameArray[i] isEqualToString:label.text]) {
                [self.nameArray removeObject:self.nameArray[i]];
                for (int i = 0; i < self.resultArray.count; i ++) {
                    for (int y = 0; y < [self.resultArray[i] count]; y ++) {
                        if ([[self.resultArray[i][y] objectForKey:@"name"] isEqualToString:label.text]) {
                            [self.resultArray[i] replaceObjectAtIndex:y withObject:@{@"type":@0,@"name":[self.resultArray[i][y] objectForKey:@"name"]}];
                        }
                    }
                }
            }
        }
    [self creatLastView];
}
@end


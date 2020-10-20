//
//  SelectDiseaseViewController.m
//  RPSimpleTagLabelView
//
//  Created by 李贤惠 on 2020/3/13.
//  Copyright © 2020 Tao. All rights reserved.
//

#import "SelectDiseaseViewController.h"
#import "DiagnosisTableViewCell.h"
#import "DiseaseTableViewCell.h"
#import "NSString+Extension.h"

@interface SelectDiseaseViewController ()<UITableViewDelegate,UITableViewDataSource,DiagnosisDelegate,DeleteDrugsDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) DiagnosisTableViewCell *diagnosisCell;//病症列表
@property (nonatomic , strong) DiseaseTableViewCell *diseaseCell;//已选病症
@property (strong , nonatomic) NSMutableArray *dataArray;
@property (strong , nonatomic) NSMutableArray *dataArray1;
@property (strong , nonatomic) NSMutableArray *dataArray2;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@end

@implementation SelectDiseaseViewController
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"选择疾病";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellStyleDefault;
    self.dataArray1 = [NSMutableArray arrayWithObjects:@{@"type":@0,@"name":@"咽炎"},@{@"type":@0,@"name":@"咽喉炎"},@{@"type":@0,@"name":@"鼻炎"},@{@"type":@0,@"name":@"心血管疾病"},@{@"type":@0,@"name":@"咳嗽"},@{@"type":@0,@"name":@"脑膜炎"},nil];
    self.dataArray2 = [NSMutableArray arrayWithObjects:@{@"type":@0,@"name":@"鼻炎"},@{@"type":@0,@"name":@"心血管疾病"},@{@"type":@0,@"name":@"咽炎"},@{@"type":@0,@"name":@"咽喉炎"},nil];
    self.dataArray = [NSMutableArray arrayWithObjects:self.dataArray1,self.dataArray2, nil];
    if (self.resultArray.count > 0) {
        self.dataArray = [self.resultArray mutableCopy];
    } else {
        self.dataArray = [NSMutableArray arrayWithObjects:self.dataArray1,self.dataArray2, nil];
    }
    
    _diseaseCell = [DiseaseTableViewCell instanceWithDiseaseCellIdentifier];
    _diseaseCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 156);
    if (self.resultArray.count > 0) {
        self.resultArray = [self.resultArray mutableCopy];
    }
    if ([self.nameArray count] > 0) {
        self.nameArray = [self.nameArray mutableCopy];
        [self.selectButton setBackgroundColor:[NSString colorWithHexString:@"#3997FD"]];
        self.selectButton.enabled = YES;
    } else {
        self.nameArray = [NSMutableArray array];
        [self.selectButton setBackgroundColor:[UIColor lightGrayColor]];
        self.selectButton.enabled = NO;
    }
    _diseaseCell.drugsArray = self.nameArray;
    _diseaseCell.textLabel.text = @"已选疾病：";
    [self.view addSubview:_diseaseCell];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.dataArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"CellT";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"药品主治疾病：";
        return cell;
    } else {
        _diagnosisCell = [DiagnosisTableViewCell instanceWithDiagnosisTableViewCellIdentifier];
        _diagnosisCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _diagnosisCell.delegate = self;
        _diagnosisCell.dataArray = self.dataArray[indexPath.row];
        _diagnosisCell.textLabel.text = @"药品名";
        return _diagnosisCell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 34.0;
    } else {
        return [_diagnosisCell CellHeight];
    }
}
#warning 点击按钮
- (void)showArray:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected){
        [self.selectButton setBackgroundColor:[NSString colorWithHexString:@"#3997FD"]];
        self.selectButton.enabled = YES;
        // 已选疾病view
        if (![self.nameArray containsObject:button.titleLabel.text]) {
            [self.nameArray addObject:button.titleLabel.text];
            for (int i = 0; i < self.dataArray.count; i ++) {
                for (int y = 0; y < [self.dataArray[i] count]; y ++) {
                    if ([[self.dataArray[i][y] objectForKey:@"name"] isEqualToString:button.titleLabel.text]) {
                        [self.dataArray[i] replaceObjectAtIndex:y withObject:@{@"type":@1,@"name":[self.dataArray[i][y] objectForKey:@"name"]}];
                    }
                }
            }
#warning 必须要写刷新
            [self.tableView reloadData];
        } else {
            button.selected = NO;
        }
        if (self.nameArray.count > 2) {
            button.selected = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多可选择两项" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:true completion:nil];
        }
    }
    if (!button.selected) {
        [self.nameArray removeObject:button.titleLabel.text];
        if (self.nameArray.count == 0) {
            [self.selectButton setBackgroundColor:[UIColor lightGrayColor]];
            self.selectButton.enabled = NO;
        }
        for (int i = 0; i < self.dataArray.count; i ++) {
            for (int y = 0; y < [self.dataArray[i] count]; y ++) {
                if ([[self.dataArray[i][y] objectForKey:@"name"] isEqualToString:button.titleLabel.text]) {
                    [self.dataArray[i] replaceObjectAtIndex:y withObject:@{@"type":@0,@"name":[self.dataArray[i][y] objectForKey:@"name"]}];
                }
            }
        }
#warning 必须要写刷新
        [self.tableView reloadData];
    }
    [_diseaseCell removeFromSuperview];
    _diseaseCell = [DiseaseTableViewCell instanceWithDiseaseCellIdentifier];
    _diseaseCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 156);
    _diseaseCell.drugsArray = self.nameArray;
    _diseaseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _diseaseCell.textLabel.text = @"已选疾病：";
    _diseaseCell.delegate = self;
    [self.view addSubview:_diseaseCell];
}
#warning 点击label
- (void)deleteDrugsWithLabel:(UILabel *)label {
    for (int i = 0; i < [self.nameArray count]; i ++) {
        if ([self.nameArray[i] isEqualToString:label.text]) {
            [self.nameArray removeObject:self.nameArray[i]];
            for (int i = 0; i < self.dataArray.count; i ++) {
                for (int y = 0; y < [self.dataArray[i] count]; y ++) {
                    if ([[self.dataArray[i][y] objectForKey:@"name"] isEqualToString:label.text]) {
                        [self.dataArray[i] replaceObjectAtIndex:y withObject:@{@"type":@0,@"name":[self.dataArray[i][y] objectForKey:@"name"]}];
                    }
                }
            }
#warning 必须要写刷新
            if (self.nameArray.count == 0) {
                [self.selectButton setBackgroundColor:[UIColor lightGrayColor]];
                self.selectButton.enabled = NO;
            }
            [self.tableView reloadData];
        }
    }
    [_diseaseCell removeFromSuperview];
    _diseaseCell = [DiseaseTableViewCell instanceWithDiseaseCellIdentifier];
    _diseaseCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 156);
    _diseaseCell.drugsArray = self.nameArray;
    _diseaseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _diseaseCell.textLabel.text = @"已选疾病：";
    _diseaseCell.delegate = self;
    [self.view addSubview:_diseaseCell];
}
- (IBAction)theButtonWithSelect:(id)sender {
    _diseaseInfo(self.nameArray,self.dataArray);
    [self.navigationController popViewControllerAnimated:YES];
}
#warning block
- (void)returnDiseaseInfo:(DiseaseBlock)block {
    _diseaseInfo = block;
}

@end

//
//  ViewController.m
//  01-购物车
//
//  Created by Shenao on 2017/5/17.
//  Copyright © 2017年 hcios. All rights reserved.
//

#import "ViewController.h"
#import "SABookModel.h"
#import "MJExtension.h"
#import "SABookModelTBCell.h"

@interface ViewController ()<UITableViewDataSource,SABookCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (nonatomic,strong) NSMutableArray *  dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - SABookCellDelegate

-(void)bookCellDidClickPlusButton:(SABookModelTBCell *)bookCell{
    
    double  totalPrice = self.totalPriceLabel.text.doubleValue + bookCell.bookModel.price.doubleValue;
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",totalPrice];
    
    self.buyButton.enabled = YES;
}

- (void)bookCellDidClickMinusButton:(SABookModelTBCell *)bookCell{
    
    double  totalPrice = self.totalPriceLabel.text.doubleValue - bookCell.bookModel.price.doubleValue;
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",totalPrice];
    
    self.buyButton.enabled = (totalPrice > 0);
    
}




- (IBAction)didClickClearButton {
   
    for (SABookModel * bookModel in self.dataArr) {
        
        bookModel.count = 0;
        
    }
    
    [self.tableView reloadData];
    
     self.totalPriceLabel.text = @"0";
    
    self.buyButton.enabled = NO;
}

- (IBAction)didClickBuyButton {
    for (SABookModel * bookModel in self.dataArr ) {
        if (bookModel.count) {
            NSLog(@"购买了%ld本{%@}",bookModel.count,bookModel.name);
        }
    }
    
    
}







#pragma mark - 数据源方法

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}


- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * kCellID = @"bookCell";
    
    SABookModelTBCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    cell.bookModel = self.dataArr[indexPath.row];
    
    cell.delegate = self;
    
    return cell;
    
}


#pragma mark - 懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        
        _dataArr = [SABookModel mj_objectArrayWithFilename:@"books.plist"];
        
    }
    return _dataArr;
}


@end

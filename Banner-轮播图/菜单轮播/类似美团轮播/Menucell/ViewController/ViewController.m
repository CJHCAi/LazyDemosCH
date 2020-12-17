//
//  ViewController.m
//  Menucell
//
//  Created by lujh on 2017/2/21.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import "ViewController.h"
#import "HomeMenuCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,OnTapBtnViewDelegate>
@property(nonatomic,copy)NSMutableArray *menuArray;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据
    [self initData];
    
    // 创建TableView
    [self setUpTableView];
    
}

#pragma mark -初始化数据

-(void)initData{

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Property" ofType:@"plist"];
    
    _menuArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
}

#pragma mark -创建TableView

- (void)setUpTableView {

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}

#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return  1;
        
    }else {
    
        return  10;
    
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {

        return 180;
        
    }else{
        return 70.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        static NSString *cellIndentifier = @"menucell";
        HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:_menuArray];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.onTapBtnViewDelegate = self;
        return cell;} else {
        
            static NSString *cellIndentifier = @"menucellA";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        
        }

}

#pragma mark -OnTapBtnViewDelegate 

- (void)OnTapBtnView:(UITapGestureRecognizer *)sender {

      NSLog(@"tag:%ld",sender.view.tag);

}


@end

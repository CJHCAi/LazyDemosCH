//
//  NMLeftTableView.m
//  XBNetMusic
//
//  Created by 小白 on 15/12/7.
//  Copyright (c) 2015年 小白. All rights reserved.
//

#import "NMLeftTableView.h"
#import "NMleftTableViewCell.h"

@interface NMLeftTableView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *tableViewBtnInfo;

@end


@implementation NMLeftTableView

-(NSArray *)tableViewBtnInfo
{
    if (_tableViewBtnInfo == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"leftViewBtn" ofType:@"plist"];
        _tableViewBtnInfo = [NSArray arrayWithContentsOfFile:path];
    }
    
    return _tableViewBtnInfo;
}



-(instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"12345");
    if (self = [super initWithFrame:frame]) {
      //  self.backgroundColor = [UIColor greenColor];
        self.delegate = self;
        self.dataSource = self;//这个不能少
        
    }
    
    return self;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"bab");
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ttt");
    static NSString *CellIdentifier = @"MYCell";
    NMleftTableViewCell *cell = [NMleftTableViewCell cellWithTableView:tableView];
            UISwitch *aSwitch = [[UISwitch alloc] init];
            cell.accessoryView = aSwitch;
    
   NSDictionary *btninfo = self.tableViewBtnInfo[0];
    cell.imageView.image = [UIImage imageNamed:@"cm2_msg_icn_msg"];
    cell.textLabel.text = @"dddd";
    cell.detailTextLabel.text = @"hero.intro";
    return cell;
}







@end

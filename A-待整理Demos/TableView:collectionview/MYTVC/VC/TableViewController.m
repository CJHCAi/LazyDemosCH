//
//  TableViewController.m
//  cellLLLLL
//
//  Created by Janice on 2017/10/11.
//  Copyright © 2017年 Janice. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

#define LOAD_NIB(_NibName_) [[NSBundle mainBundle] loadNibNamed:_NibName_ owner:nil options:nil][0]

@interface TableViewController ()
@property(nonatomic,strong) NSMutableArray *info;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;
    
    self.info = [NSMutableArray array];
    [self.info addObject:@{@"content":@"听说白雪公主在逃跑小",@"isChoice":@"NO"}];
    
    [self.info addObject:@{@"content":@"只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有",@"isChoice":@"NO"}];
    
    [self.info addObject:@{@"content":@"只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有只有睿智的河",@"isChoice":@"NO"}];
    
    [self.info addObject:@{@"content":@"只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有",@"isChoice":@"NO"}];
    
    [self.info addObject:@{@"content":@"只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有只有睿智的河水知道白雪是因为贪玩跑出了来来红帽来有件抑制啊啊抑制自己变成狼的大变成狼的大红袍总有",@"isChoice":@"NO"}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.info.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"TableViewCell";
    TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    cell.dicinfo = self.info[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.info[indexPath.section];
    NSMutableDictionary *dictemp= [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if ([dic[@"isChoice"] isEqualToString:@"NO"]) {
        [dictemp setObject:@"YES" forKey:@"isChoice"];
        [self.info replaceObjectAtIndex:indexPath.section withObject:dictemp];
    }else{
        [dictemp setObject:@"NO" forKey:@"isChoice"];
        [self.info replaceObjectAtIndex:indexPath.section withObject:dictemp];
    }
    [self.tableView reloadData];
}

@end


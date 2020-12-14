//
//  ViewController.m
//  RemoteImgListOperatorDemo
//
//  Created by jimple on 14-1-7.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import "ViewController.h"
#import "RemoteImgListOperator.h"
#import "ImageCell.h"

@interface ViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) IBOutlet UITableView *m_tableView;
@property (nonatomic, strong) IBOutlet UILabel *m_labelMsg;

@property (nonatomic, readonly) NSMutableArray *m_arrImgURLs;
@property (nonatomic, readonly) RemoteImgListOperator *m_objImgListOper;


@end

@implementation ViewController
@synthesize m_tableView = _tableView;
@synthesize m_arrImgURLs = _arrImgURLs;
@synthesize m_objImgListOper = _objImgListOper;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 创建一个队列对象，以便在当前页面内统一控制下载数量。
    // 页面不需响应图片下载完成的通知，将队列对象扔给具体需显示图片的TableViewCell，由Cell响应通知并显示图片。
    _objImgListOper = [[RemoteImgListOperator alloc] init];
    [_objImgListOper resetListSize:20];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _arrImgURLs = [[NSMutableArray alloc] init];
    self.m_labelMsg.hidden = NO;
    self.m_labelMsg.text = @" 正在从 imgur.com 获取图片URL ... ";
    [self performSelector:@selector(loadDataSource) withObject:nil afterDelay:0.3];
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_arrImgURLs ? _arrImgURLs.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ImageCell";
    
    ImageCell *cell = (ImageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *strURL = [_arrImgURLs objectAtIndex:indexPath.row];
    
    // 页面不需响应图片下载完成的通知，将队列对象扔给具体需显示图片的TableViewCell，由Cell响应通知并显示图片。
    [cell setRemoteImgOper:_objImgListOper];
    
    [cell showImgByURL:strURL];

    return cell;
}

#pragma mark -
// load image URL from imgur.com
- (void)loadDataSource
{
    // Request
    NSString *URLPath = [NSString stringWithFormat:@"http://imgur.com/gallery.json"];
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSArray *arrItems = [res objectForKey:@"data"];
                if (arrItems)
                {
                    for (NSDictionary *item in arrItems)
                    {
                        [_arrImgURLs addObject:[NSString stringWithFormat:@"http://i.imgur.com/%@%@", [item objectForKey:@"hash"], [item objectForKey:@"ext"]]];
                    }
                }else{}
                
                [self dataSourceDidLoad];
            } else {
                [self dataSourceDidError];
            }
        } else {
            [self dataSourceDidError];
        }
    }];
}

- (void)dataSourceDidLoad {
    [_tableView reloadData];
    
    self.m_labelMsg.hidden = YES;
}

- (void)dataSourceDidError {
    [_tableView reloadData];
    
    NSLog(@"\n\n\n\n\n\n从 imgur 获取图片URL失败！\n\n\n\n\n\n");
    
    self.m_labelMsg.hidden = NO;
    self.m_labelMsg.text = @" ! 从 imgur 获取图片URL失败";
}







@end

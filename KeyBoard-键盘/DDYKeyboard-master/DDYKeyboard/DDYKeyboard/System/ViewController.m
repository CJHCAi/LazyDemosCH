#import "ViewController.h"
#import "DDYKeyboard.h"


#ifndef DDYTopH
#define DDYTopH (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
#endif


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DDYKeyboard *keyboard;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MessageCell"];
        [_tableView setFrame:self.view.bounds];
        [_tableView ddy_AddTapTarget:self action:@selector(handleTableViewTap)];
    }
    return _tableView;
}

- (DDYKeyboard *)keyboard {
    if (!_keyboard) {
        _keyboard = [DDYKeyboard keyboardWithType:DDYKeyboardTypeSingle];
    }
    return _keyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // [<_UITileLayer: 0x0000> display]: Ignoring bogus layer size
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.keyboard];
    self.keyboard.associateTableView = self.tableView;
    
    self.tableView.backgroundColor = kbBgSmallColor;
    self.keyboard.backgroundColor = kbBgMidColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.keyboard keyboardDown];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.keyboard keyboardDown];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"测试 test %ld",indexPath.row];
    return cell;
}

- (void)handleTableViewTap {
    [self.keyboard keyboardDown];
}


@end

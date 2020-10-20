//
//  Copyright (C) 2016 Google, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "TableViewController.h"

#import "MenuItem.h"
#import "MenuItemTableViewCell.h"

static NSString *const GADAdUnitID = @"ca-app-pub-3940256099942544/2934735716";
static const CGFloat GADAdViewHeight = 100;

@interface TableViewController () <GADBannerViewDelegate> {
  NSMutableArray *_tableViewItems;
  NSMutableArray<GADBannerView *> *_adsToLoad;
  /// 映射GADBannerView广告的负载状态.
  NSMutableDictionary<NSString *, NSNumber *> *_loadStateForAds;
  NSInteger _adInterval;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _tableViewItems = [[NSMutableArray alloc] init];
  _adsToLoad = [[NSMutableArray alloc] init];
  _loadStateForAds = [[NSMutableDictionary alloc] init];
   
    //一个横幅广告放置在每adInterval UITableView一次。ipad将会有一个/ /大广告间隔,以避免多个广告在屏幕上在同一时间。
    _adInterval = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 16 : 8;

  [self.tableView registerNib:[UINib nibWithNibName:@"MenuItem" bundle:nil]
       forCellReuseIdentifier:@"MenuItemViewCell"];
  [self.tableView registerNib:[UINib nibWithNibName:@"BannerAd" bundle:nil]
       forCellReuseIdentifier:@"GADBannerViewCell"];
  //允许动态地确定行高而优化估计行高。
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 135;

  // Load the sample data.
  [self addMenuItems];
  [self addBannerAds];
  [self preloadNextAd];
}

//返回GADBannerView被使用的内存地址位置的字符串
- (NSString *)referenceKeyForAdView:(GADBannerView *)adView {
  return [[NSString alloc] initWithFormat:@"%p", adView];
}


#pragma mark- UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _tableViewItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([_tableViewItems[indexPath.row] isKindOfClass:[GADBannerView class]]) {
    GADBannerView *adView = _tableViewItems[indexPath.row];
    BOOL isLoaded = [_loadStateForAds[[self referenceKeyForAdView:adView]] boolValue];
    return isLoaded ? GADAdViewHeight : 0;
  }

  return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if ([_tableViewItems[indexPath.row] isKindOfClass:[GADBannerView class]]) {
    UITableViewCell *reusableAdCell =
        [self.tableView dequeueReusableCellWithIdentifier:@"GADBannerViewCell"
                                             forIndexPath:indexPath];
    //从内容视图中移除之前的GADBannerView，添加新的
    for (UIView *subview in reusableAdCell.contentView.subviews) {
      [subview removeFromSuperview];
    }

    GADBannerView *adView = _tableViewItems[indexPath.row];
    [reusableAdCell.contentView addSubview:adView];
    adView.center = reusableAdCell.contentView.center;

    return reusableAdCell;
  } else {
      
    MenuItem *menuItem = _tableViewItems[indexPath.row];
    MenuItemTableViewCell *reusableMenuItemCell =
        [self.tableView dequeueReusableCellWithIdentifier:@"MenuItemViewCell"
                                             forIndexPath:indexPath];

    reusableMenuItemCell.nameLabel.text = menuItem.name;
    reusableMenuItemCell.descriptionLabel.text = menuItem.itemDescription;
    reusableMenuItemCell.priceLabel.text = menuItem.price;
    reusableMenuItemCell.categoryLabel.text = menuItem.category;
    reusableMenuItemCell.photoView.image = menuItem.photo;

    return reusableMenuItemCell;
  }
}

#pragma mark-GADBannerView delegate
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
  //横幅广告标记为成功加载。
  _loadStateForAds[[self referenceKeyForAdView:bannerView]] = @YES;
  //加载adsToLoad列表中的下一个广告。
    [self preloadNextAd];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
  NSLog(@"Failed to receive ad: %@", error.localizedDescription);
  //加载adsToLoad列表中的下一个广告。
  [self preloadNextAd];
}

//- UITableView广告源数据生成//添加横幅广告tableViewItems列表。
- (void)addBannerAds {
  
    NSInteger index = _adInterval;
    //确保子视图的布局已经完成，访问子视图大小。
  [self.tableView layoutIfNeeded];

  while (index < _tableViewItems.count) {
    GADBannerView *adView = [[GADBannerView alloc]
        initWithAdSize:GADAdSizeFromCGSize(
                           CGSizeMake(self.tableView.contentSize.width, GADAdViewHeight))];
    adView.adUnitID = GADAdUnitID;
    adView.rootViewController = self;
    adView.delegate = self;
    [_tableViewItems insertObject:adView atIndex:index];
    [_adsToLoad addObject:adView];
    _loadStateForAds[[self referenceKeyForAdView:adView]] = @NO;

    index += _adInterval;
  }
}

//顺序预载横幅广告。从adsToLoad列表加载下一个广告
- (void)preloadNextAd {
  if (!_adsToLoad.count) {
    return;
  }
  GADBannerView *adView = _adsToLoad.firstObject;
  [_adsToLoad removeObjectAtIndex:0];
  GADRequest *request = [GADRequest request];
  request.testDevices = @[ kGADSimulatorID ];
  [adView loadRequest:request];
}

//解析menuItemsJSON。json文件和填充菜单项在tableViewItems列表中。
- (void)addMenuItems {
  NSError *error = nil;
  NSString *JSONPath = [[NSBundle mainBundle] pathForResource:@"menuItemsJSON" ofType:@"json"];
  NSData *JSONData = [NSData dataWithContentsOfFile:JSONPath options:0 error:&error];
  if (error) {
    NSLog(@"Failed to parse JSON file containing menu item data with error: %@", error);
    return;
  }
  NSArray *JSONArray = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
  if (error) {
    NSLog(@"Failed to load menu item JSON data with error: %@", error);
    return;
  }

  // Create custom objects from JSON array.
  for (NSDictionary *dict in JSONArray) {
    MenuItem *menuIem = [[MenuItem alloc] initWithDictionary:dict];
    [_tableViewItems addObject:menuIem];
  }
}

@end

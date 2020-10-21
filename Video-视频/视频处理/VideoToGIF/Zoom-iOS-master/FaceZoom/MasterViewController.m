//
//  MasterViewController.m
//  Read JSON
//
//  Created by TAMIM Ziad on 8/16/13.
//  Copyright (c) 2013 TAMIM Ziad. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailCell.h"

#import "Group.h"

@interface MasterViewController () {
    NSArray *_groups;
}


@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startFetchingGroups:)
                                                 name:@"kCLAuthorizationStatusAuthorized"
                                               object:nil];
}


#pragma mark - Notification Observer
- (void)startFetchingGroups:(NSNotification *)notification
{
    //[_manager fetchGroupsAtCoordinate:self.locationManager.location.coordinate];
}

#pragma mark - MeetupManagerDelegate
- (void)didReceiveGroups:(NSArray *)groups
{
    _groups = groups;
    [self.tableView reloadData];
}

- (void)fetchingGroupsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;//_groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Celld" forIndexPath:indexPath];

    
    Group *group = _groups[indexPath.row];
    [cell.nameLabel setText:group.name];
    [cell.whoLabel setText:group.who];
    [cell.locationLabel setText:@"poopayyy"];//[NSString stringWithFormat:@"%@, %@", group.city, group.country]];
    [cell.descriptionLabel setText:group.description];
    
    return cell;
}

@end

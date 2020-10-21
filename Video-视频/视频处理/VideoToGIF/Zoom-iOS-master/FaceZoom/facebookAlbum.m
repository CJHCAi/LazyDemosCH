
//
//  facebookAlbum.m
//  FaceZoom
//
//  Created by Ben Taylor on 5/23/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "facebookAlbum.h"
#import "DetailCell.h"

@implementation facebookAlbum

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//[regions count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return 1;//[region.timeZoneWrappers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"Celld";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
 //   Region *region = [regions objectAtIndex:indexPath.section];
 //   TimeZoneWrapper *timeZoneWrapper = [region.timeZoneWrappers objectAtIndex:indexPath.row];    
    
    [cell.nameLabel setText:group.name];
    [cell.whoLabel setText:group.who];
    [cell.locationLabel setText:@"poopayyy"];//[NSString stringWithFormat:@"%@, %@", group.city, group.country]];
    [cell.descriptionLabel setText:group.description];
    return cell;
}
@end
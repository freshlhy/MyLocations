//
//  LocationsViewController.m
//  MyLocations
//
//  Created by freshlhy on 3/19/14.
//  Copyright (c) 2014 showgram. All rights reserved.
//

#import "LocationsViewController.h"
#import "Location.h"
#import "LocationCell.h"
#import "LocationDetailsViewController.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController {
  NSArray *_locations;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // 1
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  // 2
  NSEntityDescription *entity =
      [NSEntityDescription entityForName:@"Location"
                  inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];

  // 3
  NSSortDescriptor *sortDescriptor =
      [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
  [fetchRequest setSortDescriptors:@[ sortDescriptor ]];

  // 4
  NSError *error;
  NSArray *foundObjects =
      [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  if (foundObjects == nil) {
    FATAL_CORE_DATA_ERROR(error);
    return;
  }

  // 5
  _locations = foundObjects;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [_locations count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"Location"];

  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
  LocationCell *locationCell = (LocationCell *)cell;
  Location *location = _locations[indexPath.row];
  if ([location.locationDescription length] > 0) {
    locationCell.descriptionLabel.text = location.locationDescription;
  } else {
    locationCell.descriptionLabel.text = @"(No Description)";
  }
  if (location.placemark != nil) {
    locationCell.addressLabel.text =
        [NSString stringWithFormat:@"%@ %@, %@", location.placemark.subLocality,
                                   location.placemark.locality,
                                   location.placemark.administrativeArea];
  } else {
    locationCell.addressLabel.text =
        [NSString stringWithFormat:@"Lat: %.8f, Long: %.8f",
                                   [location.latitude doubleValue],
                                   [location.longitude doubleValue]];
  }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"EditLocation"]) {
    
    UINavigationController *navigationController =
        segue.destinationViewController;
    
    LocationDetailsViewController *controller =
        (LocationDetailsViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Location *location = _locations[indexPath.row];
    controller.locationToEdit = location;
  }
}

@end

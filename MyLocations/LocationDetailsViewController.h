//
//  LocationDetailsViewController.h
//  MyLocations
//
//  Created by freshlhy on 14-3-17.
//  Copyright (c) 2014年 showgram. All rights reserved.
//

@interface LocationDetailsViewController : UITableViewController

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CLPlacemark *placemark;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

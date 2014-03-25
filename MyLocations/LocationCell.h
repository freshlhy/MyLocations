//
//  LocationCell.h
//  MyLocations
//
//  Created by freshlhy on 3/19/14.
//  Copyright (c) 2014 showgram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@end

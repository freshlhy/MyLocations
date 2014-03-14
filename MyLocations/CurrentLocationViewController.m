//
//  FirstViewController.m
//  MyLocations
//
//  Created by freshlhy on 3/12/14.
//  Copyright (c) 2014 showgram. All rights reserved.
//

#import "CurrentLocationViewController.h"

@interface CurrentLocationViewController ()

@end

@implementation CurrentLocationViewController {
  CLLocationManager *_locationManager;
  CLLocation *_location;
  BOOL _updatingLocation;
  NSError *_lastLocationError;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    _locationManager = [[CLLocationManager alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self updateLabels];
  [self configureGetButton];
}

- (IBAction)getLocation:(id)sender {
  if (_updatingLocation) {
    [self stopLocationManager];
  } else {
    _location = nil;
    _lastLocationError = nil;

    [self startLocationManager];
  }

  [self updateLabels];
  [self configureGetButton];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
  NSLog(@"didFailWithError %@", error);
  if (error.code == kCLErrorLocationUnknown) {
    return;
  }
  [self stopLocationManager];
  _lastLocationError = error;
  [self updateLabels];
  [self configureGetButton];
}

- (void)startLocationManager {
  if ([CLLocationManager locationServicesEnabled]) {
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [_locationManager startUpdatingLocation];
    _updatingLocation = YES;
  }
}

- (void)stopLocationManager {
  if (_updatingLocation) {
    [_locationManager stopUpdatingLocation];
    _locationManager.delegate = nil;
    _updatingLocation = NO;
  }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
  CLLocation *newLocation = [locations lastObject];
  NSLog(@"didUpdateLocations %@", newLocation);
  if ([newLocation.timestamp timeIntervalSinceNow] < -5.0) {
    return;
  }

  if (newLocation.horizontalAccuracy < 0) {
    return;
  }

  if (_location == nil ||
      _location.horizontalAccuracy > newLocation.horizontalAccuracy) {
    _lastLocationError = nil;
    _location = newLocation;
    [self updateLabels];
  }

  if (newLocation.horizontalAccuracy <= _locationManager.desiredAccuracy) {
    NSLog(@"*** We are done!");
    [self stopLocationManager];
    [self configureGetButton];
  }
}

- (void)updateLabels {
  if (_location != nil) {

    self.latitudeLabel.text =
        [NSString stringWithFormat:@"%.8f", _location.coordinate.latitude];
    self.longitudeLabel.text =
        [NSString stringWithFormat:@"%.8f", _location.coordinate.longitude];

    self.tagButton.hidden = NO;
    self.messageLabel.text = @"";

  } else {

    self.latitudeLabel.text = @"";
    self.longitudeLabel.text = @"";
    self.addressLabel.text = @"";
    self.tagButton.hidden = YES;

    NSString *statusMessage;
    if (_lastLocationError != nil) {
      if ([_lastLocationError.domain isEqualToString:kCLErrorDomain] &&
          _lastLocationError.code == kCLErrorDenied) {
        statusMessage = @"Location Services Disabled";
      } else {
        statusMessage = @"Error Getting Location";
      }
    } else if (![CLLocationManager locationServicesEnabled]) {
      statusMessage = @"Location Services Disabled";
    } else if (_updatingLocation) {
      statusMessage = @"Searching...";
    } else {
      statusMessage = @"Press the Button to Start";
    }

    self.messageLabel.text = statusMessage;
  }
}

- (void)configureGetButton {
  if (_updatingLocation) {
    [self.getButton setTitle:@"Stop" forState:UIControlStateNormal];
  } else {
    [self.getButton setTitle:@"Get My Location" forState:UIControlStateNormal];
  }
}

@end

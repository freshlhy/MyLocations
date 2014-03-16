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
    
  CLGeocoder *_geocoder;
  CLPlacemark *_placemark;
  BOOL _performingReverseGeocoding;
  NSError *_lastGeocodingError;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    _locationManager = [[CLLocationManager alloc] init];
    _geocoder = [[CLGeocoder alloc] init];
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
  
  if (!_performingReverseGeocoding) {
    NSLog(@"*** Going to geocode");
    
    _performingReverseGeocoding = YES;
    
    [_geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray *placemarks, NSError *error) {
      NSLog(@"*** Found placemarks: %@, error: %@", placemarks, error);
      
      _lastGeocodingError = error;
      if (error == nil && [placemarks count] > 0) {
        _placemark = [placemarks lastObject];
      } else {
        _placemark = nil;
      }
      
      _performingReverseGeocoding = NO;
      
      [self updateLabels];
      
    }];
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
    
    if (_placemark != nil) {
      self.addressLabel.text = [self stringFromPlacemark:_placemark];
    } else if (_performingReverseGeocoding) {
      self.addressLabel.text = @"Searching for Address...";
    } else if (_lastGeocodingError != nil) {
      self.addressLabel.text = @"Error Finding Address";
    } else {
      self.addressLabel.text = @"No Address Found";
    }

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

- (NSString *)stringFromPlacemark:(CLPlacemark *)thePlacemark
{
  return [NSString stringWithFormat:@"%@ %@\n%@ %@ %@",
          thePlacemark.subThoroughfare, thePlacemark.thoroughfare,thePlacemark.locality, thePlacemark.administrativeArea,
          thePlacemark.postalCode];
}

- (void)configureGetButton {
  if (_updatingLocation) {
    [self.getButton setTitle:@"Stop" forState:UIControlStateNormal];
  } else {
    [self.getButton setTitle:@"Get My Location" forState:UIControlStateNormal];
  }
}

@end

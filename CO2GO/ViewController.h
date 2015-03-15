//
//  ViewController.h
//  CO2GO
//
//  Created by Michael Spearman on 3/13/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Trip.h"
#import "Car.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) Trip *lastTrip;
@property (nonatomic) NSMutableArray *travelLog;
@property (nonatomic) Car *car;

@end


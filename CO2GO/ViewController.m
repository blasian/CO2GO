//
//  ViewController.m
//  CO2GO
//
//  Created by Michael Spearman on 3/13/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import "ViewController.h"
#import "Trip.h"
#import <Parse/Parse.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *track_button;
@property (strong, nonatomic) CLLocationManager *clm;
@property (nonatomic) CLLocationSpeed speed;
@property (strong, nonatomic) CLLocation* location;
@property (weak, nonatomic) IBOutlet UILabel *speed_label;
@property (strong, nonatomic) MKMapView *map;
@property (strong, nonatomic) CLLocation* origin;
@property (nonatomic) CLLocationDistance distance;
@property (weak, nonatomic) IBOutlet UILabel *distance_label;
@property (strong, nonatomic) Trip *trip;
@property (strong, nonatomic) Parse *db;

@end

@implementation ViewController

- (IBAction)trackButtonPressed:(id)sender {
    if (!self.track_button.selected) {
        [self startTracking];
    } else {
        [self stopTracking];
    }
}

- (void)startTracking {
    self.origin = self.location;
    [self.map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.map setShowsUserLocation:YES];
    self.track_button.selected = YES;
    [self.clm startUpdatingLocation];
    self.trip = [[Trip alloc] init];
    self.trip.date = [NSDate date];
}

- (void)stopTracking {
    [self.clm stopUpdatingLocation];
    [self.map setShowsUserLocation:NO];
    self.track_button.selected = NO;
    self.trip.distance = self.distance;
}

- (IBAction)vehicleTypeSelected:(id)sender {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.clm = [[CLLocationManager alloc] init];
    self.clm.delegate = self;
    self.clm.desiredAccuracy = kCLLocationAccuracyBest;
    self.clm.distanceFilter = kCLDistanceFilterNone;
    [self.clm requestAlwaysAuthorization];
    self.location = self.clm.location;
    [self.track_button setTitle:@"Stop" forState:UIControlStateSelected];
    [self.track_button setTitle:@"Track" forState:UIControlStateNormal];
    
    self.db = [[Firebase alloc] initWithUrl:@"https://co2gocars.firebase.com/"];
    [self.db observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot.value);
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations.lastObject;
    self.speed = self.location.speed * 3.6;
    self.distance = [self.origin distanceFromLocation:self.location] / 1000;
    [self.speed_label setText:[NSString stringWithFormat:@"%f", self.speed]];
    [self.distance_label setText: [NSString stringWithFormat:@"%d", (int) self.distance]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

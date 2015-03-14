//
//  ViewController.m
//  CO2GO
//
//  Created by Michael Spearman on 3/13/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *track_button;
@property (strong, nonatomic) CLLocationManager *clm;
@property (nonatomic) CLLocationSpeed speed;
@property (strong, nonatomic) CLLocation* location;
@property (weak, nonatomic) IBOutlet UILabel *speed_label;
@property (strong, nonatomic) MKMapView *map;
@property (strong, nonatomic) CLLocation* origin;
@property (nonatomic) CLLocationDistance distance;


@end

@implementation ViewController

- (IBAction)startTracking:(id)sender {
    if (!self.track_button.selected) {
        [self.clm startUpdatingLocation];
        [self.map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        [self.map setShowsUserLocation:YES];
        self.origin = self.location;
        self.distance = [self.origin distanceFromLocation:self.location];
        self.track_button.selected = YES;
        
    } else {
        [self.clm stopUpdatingLocation];
        [self.map setShowsUserLocation:NO];
        self.track_button.selected = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clm = [[CLLocationManager alloc] init];
    self.clm.delegate = self;
    self.clm.desiredAccuracy = kCLLocationAccuracyBest;
    self.clm.distanceFilter = kCLDistanceFilterNone;
    [self.clm requestAlwaysAuthorization];
    [self.track_button setTitle:@"Stop" forState:UIControlStateSelected];
    [self.track_button setTitle:@"Track" forState:UIControlStateNormal];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations.lastObject;
    self.speed = self.location.speed;
    [self.speed_label setText:[NSString stringWithFormat:@"%f", self.location.speed]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

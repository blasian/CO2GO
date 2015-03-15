//
//  ViewController.m
//  CO2GO
//
//  Created by Michael Spearman on 3/13/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import "ViewController.h"
#import "Trip.h"
#import "StatisticsTableViewController.h"
#import "SearchViewController.h"
#import "StatStore.h"

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
@property (weak, nonatomic) IBOutlet UIButton *viewStatsButton;
@property (weak, nonatomic) IBOutlet UIButton *vehicleButton;
@property (weak, nonatomic) IBOutlet UILabel *carLabel;
@property (nonatomic) double tripEmissions;
@property (weak, nonatomic) IBOutlet UILabel *tripEmissionsLabel;
@property (nonatomic) CLLocation *
lastLocation;

@end

@implementation ViewController
- (IBAction)statButtonPressed:(id)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"StatisticsTableStoryboard" bundle:nil];
    UIViewController *initialViewController = [secondStoryBoard instantiateInitialViewController];
    [self.navigationController pushViewController:initialViewController animated:YES];
}

- (IBAction)vehicleButtonPressed:(id)sender {
    UIStoryboard *secondaryStoryBoard = [UIStoryboard storyboardWithName:@"CarTableViewStoryboard" bundle:nil];
    SearchViewController *tableViewController = [secondaryStoryBoard instantiateInitialViewController];
    tableViewController.parentController = self;
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"StatisticsTableSegue"]) {
        NSLog(@"in prepare for segue");
    }
    
}

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
    self.lastTrip = [[Trip alloc] init];
    self.lastTrip.date = [NSDate date];
    self.tripEmissions = 0;
    self.lastLocation = 0;
}

- (void)stopTracking {
    [self.clm stopUpdatingLocation];
    [self.map setShowsUserLocation:NO];
    self.track_button.selected = NO;
    self.lastTrip.distance = self.distance;
    int driving = [[self.travelLog objectAtIndex:0] intValue];
    int walking = [[self.travelLog objectAtIndex:1] intValue];
    double fraction = driving/(walking + driving);
    double totalDrive = (fraction * self.distance)/1000;
    double avgEmissions = [self.car.emissions doubleValue];
    double emissions = totalDrive * avgEmissions;
    self.lastTrip.emissions = emissions;
    self.lastTrip.timeElapsed = [self.lastTrip.date timeIntervalSinceNow];
    [[StatStore sharedStore] addStat:self.lastTrip];
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
    self.travelLog = [[NSMutableArray alloc] init];
    NSNumber *zero = [NSNumber numberWithInt:0];
    [self.travelLog insertObject:zero atIndex:0];
    [self.travelLog insertObject:zero atIndex:1];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.lastLocation = self.location;
    int driving = [[self.travelLog objectAtIndex:0] intValue];
    int walking = [[self.travelLog objectAtIndex:1] intValue];
    double fraction;
    if(walking+driving == 0){
        fraction = 0;
    } else {
        fraction = driving/(walking + driving);
    }
    double totalDrive = (fraction * self.distance)/1000;
    double avgEmissions = [self.car.emissions doubleValue];
    double emissions = totalDrive * avgEmissions;
    self.tripEmissions = self.tripEmissions + emissions;
    self.location = locations.lastObject;
    self.speed = self.location.speed * 3.6;
    self.distance = self.distance + [self.lastLocation distanceFromLocation:self.location] / 1000;
    [self.speed_label setText:[NSString stringWithFormat:@"%f km/h", self.speed]];
    [self.distance_label setText: [NSString stringWithFormat:@"%f km", self.distance]];
    [self.tripEmissionsLabel setText:[NSString stringWithFormat:@"%f g", self.tripEmissions]];
    [self.map setCenterCoordinate:self.map.userLocation.coordinate animated:YES];
    MKCoordinateRegion zoomRegion = [self.map regionThatFits:MKCoordinateRegionMakeWithDistance(_map.userLocation.coordinate, 800, 800)];
    [self.map setRegion:zoomRegion animated:YES];
    if (self.speed > 7.5){
        int integer = [[self.travelLog objectAtIndex:0] intValue];
        NSNumber *value = [NSNumber numberWithInt:integer + 1];
        [self.travelLog replaceObjectAtIndex:0 withObject:value];
    } else {
        int integer = [[self.travelLog objectAtIndex:1] intValue];
        NSNumber *value = [NSNumber numberWithInt:integer+1];
        [self.travelLog replaceObjectAtIndex:1 withObject:value];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    self.carLabel.text = self.car.brand;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

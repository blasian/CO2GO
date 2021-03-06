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
@property (weak, nonatomic) IBOutlet MKMapView *map;
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
    UIViewController *initialViewController = [secondStoryBoard instantiateViewControllerWithIdentifier:@"StatTableView"];
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
    self.location = self.clm.location;
    self.origin = self.location;
    [self.map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    self.track_button.selected = YES;
    [self.clm startUpdatingLocation];
    self.lastTrip = [[Trip alloc] init];
    self.lastTrip.date = [NSDate date];
    self.tripEmissions = 0;
    self.lastLocation = 0;
    self.lastTrip.distance = 0;
    self.lastTrip.emissions = 0;
    self.distance = 0;
}

- (void)stopTracking {
    [self.clm stopUpdatingLocation];
    self.track_button.selected = NO;
    self.lastTrip.distance = self.distance;
    double driving = [[self.travelLog objectAtIndex:0] intValue];
    double walking = [[self.travelLog objectAtIndex:1] intValue];
    self.lastTrip.emissions = self.tripEmissions;
    self.lastTrip.timeElapsed = [self.lastTrip.date timeIntervalSinceNow] * -1;
    self.lastTrip.vehicle = self.car.brand;
    self.lastTrip.distance = self.distance;
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
    [self.map setShowsUserLocation:YES];
    NSNumber *zero = [NSNumber numberWithInt:0];
    [self.travelLog insertObject:zero atIndex:0];
    [self.travelLog insertObject:zero atIndex:1];
    self.car = [[Car alloc] init];
    self.car.brand = @"AUDI";
    self.car.emissions = [NSNumber numberWithInt:162];
    self.car.model = @"A1";
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    self.lastLocation = self.location;
    double driving = [[self.travelLog objectAtIndex:0] intValue];
    double walking = [[self.travelLog objectAtIndex:1] intValue];
    double fraction;
    if(walking+driving == 0){
        fraction = 0;
        
    } else {
        fraction = driving/(walking + driving);
    }
    double totalDrive = (fraction * self.distance)/1000;
    double avgEmissions = [self.car.emissions doubleValue];
    double emissions = totalDrive * avgEmissions;
    self.location = locations.lastObject;
    self.speed = self.location.speed * 3.6;
    self.distance = self.distance + [self.lastLocation distanceFromLocation:self.location] / 1000;
    if (self.speed > 30) {
        self.tripEmissions = emissions;
    }
    
    [self.speed_label setText:[NSString stringWithFormat:@"%.02f km/h", ((self.speed * 100)/100)]];
    [self.distance_label setText: [NSString stringWithFormat:@"%.02f km", (self.distance * 100)/100]];
    [self.tripEmissionsLabel setText:[NSString stringWithFormat:@"%.02f g", (self.tripEmissions * 100)/100]];
    
    MKCoordinateRegion region;
    region.center = self.clm.location.coordinate;
    region.span = MKCoordinateSpanMake(0.01, 0.01);
    region = [self.map regionThatFits:region];
    //[self.map setRegion:region animated:YES];
    
    if (self.speed > 30){
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

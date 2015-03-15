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
@property (weak, nonatomic) IBOutlet UIButton *viewStatsButton;
@property (weak, nonatomic) IBOutlet UIButton *vehicleButton;


@end

@implementation ViewController
- (IBAction)statButtonPressed:(id)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"StatisticsTableStoryboard" bundle:nil];
    UIViewController *initialViewController = [secondStoryBoard instantiateInitialViewController];
    [self.navigationController pushViewController:initialViewController animated:YES];
}

- (IBAction)vehicleButtonPressed:(id)sender {
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
    
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
    self.trip = [[Trip alloc] init];
    self.trip.date = [NSDate date];
}

- (void)stopTracking {
    [self.clm stopUpdatingLocation];
    [self.map setShowsUserLocation:NO];
    self.track_button.selected = NO;
    self.trip.distance = self.distance;
    self.trip = [[Trip alloc] init];
    NSTimeInterval elapsedTime = [self.trip.date timeIntervalSinceNow];
    int driving = [[self.travelLog objectAtIndex:0] intValue];
    int walking = [[self.travelLog objectAtIndex:1] intValue];
    double fraction = driving/(walking + driving);
    double totalDrive = (fraction * self.distance)/1000;
    // MUTLITPLY TOTALDRIVE BY CAR EFFICIENCY!!!!!!!!!
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
    [self.travelLog insertObject:0 atIndex:0];
    [self.travelLog insertObject:0 atIndex:1];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations.lastObject;
    self.speed = self.location.speed * 3.6;
    self.distance = [self.origin distanceFromLocation:self.location] / 1000;
    [self.speed_label setText:[NSString stringWithFormat:@"%f", self.speed]];
    [self.distance_label setText: [NSString stringWithFormat:@"%d", (int) self.distance]];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  DetailStatViewController.m
//  CO2GO
//
//  Created by Michael Spearman on 3/15/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import "DetailStatViewController.h"
#import "StatStore.h"
#import "Trip.h"

@interface DetailStatViewController ()
@property (weak, nonatomic) IBOutlet UILabel *date_label;
@property (weak, nonatomic) IBOutlet UILabel *distance_label;
@property (weak, nonatomic) IBOutlet UILabel *emissions_label;
@property (weak, nonatomic) IBOutlet UILabel *vehicle_label;
@property (weak, nonatomic) IBOutlet UILabel *interval_label;
@property (weak, nonatomic) IBOutlet UILabel *tripCO2Avg;
@property (weak, nonatomic) IBOutlet UILabel *historicalCO2Avg;

@end

@implementation DetailStatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self.date_label setText:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.trip.date]]];
    [self.distance_label setText:[NSString stringWithFormat:@"%.02f km", self.trip.distance]];
    [self.emissions_label setText:[NSString stringWithFormat:@"%.02f g", self.trip.emissions]];
    [self.vehicle_label setText:self.trip.vehicle];
    [self.interval_label setText:[NSString stringWithFormat:@"%.02f mins", (self.trip.timeElapsed / 60.)]];
    NSArray *allStats = [[StatStore sharedStore] allStats];
    double co = 0;
    double dist = 0;
    for (Trip *t in allStats) {
        co = co + t.emissions;
        dist = dist + t.distance;
    }
    double histAvg = co/dist;
    double myAvg = self.trip.emissions/self.trip.distance;
    
    double diffAvg = myAvg - histAvg;
    if (diffAvg <= 0) {
        self.tripCO2Avg.textColor = [[UIColor alloc] initWithRed: 54./255 green: 190./255 blue:32./255 alpha:1];
    } else {
        self.tripCO2Avg.textColor = [[UIColor alloc] initWithRed:234./255 green:38./255 blue:24./255 alpha:1];
    }
    self.historicalCO2Avg.textColor = [UIColor blackColor];
    [self.tripCO2Avg setText:[NSString stringWithFormat:@"%.02f", myAvg]];
    [self.historicalCO2Avg setText:[NSString stringWithFormat:@"%.02f", histAvg]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

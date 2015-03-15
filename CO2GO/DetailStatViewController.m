//
//  DetailStatViewController.m
//  CO2GO
//
//  Created by Michael Spearman on 3/15/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import "DetailStatViewController.h"

@interface DetailStatViewController ()
@property (weak, nonatomic) IBOutlet UILabel *date_label;
@property (weak, nonatomic) IBOutlet UILabel *distance_label;
@property (weak, nonatomic) IBOutlet UILabel *emissions_label;
@property (weak, nonatomic) IBOutlet UILabel *vehicle_label;
@property (weak, nonatomic) IBOutlet UILabel *interval_label;

@end

@implementation DetailStatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self.date_label setText:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.trip.date]]];
    [self.distance_label setText:[NSString stringWithFormat:@"%f", self.trip.distance]];
    [self.emissions_label setText:[NSString stringWithFormat:@"%f", self.trip.emissions]];
    //[self.vehicle_label setText:self.trip.vehicle];
    [self.interval_label setText:[NSString stringWithFormat:@"%f", self.trip.timeElapsed]];
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

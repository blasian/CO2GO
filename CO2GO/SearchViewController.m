//
//  SearchViewController.m
//  CO2GO
//
//  Created by Michael Spearman on 3/14/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import "SearchViewController.h"
#import <Firebase/Firebase.h>

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchDisplay;
@property (strong, nonatomic) Firebase *ref;

@end

@implementation SearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Create a reference to a Firebase location
    self.ref = [[Firebase alloc] initWithUrl:@"https://co2gocars.firebase.com/"];
    [self.ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot.value);
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
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

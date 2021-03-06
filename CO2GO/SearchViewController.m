//
//  SearchViewController.m
//  CO2GO
//
//  Created by Michael Spearman on 3/14/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import "SearchViewController.h"
#import "Cars.h"
#import "Car.h"
#import "ViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
{
    NSArray *brandArray;
    NSMutableArray *carArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    carArray = [[NSMutableArray alloc] init];
    brandArray = [[NSArray alloc] initWithObjects:@"ABARTH",
     @"ALFA ROMEO",
     @"AUDI",
     @"BMW",
     @"CHRYSLER JEEP",
     @"CITROEN",
     @"FERRARI",
     @"FIAT",
     @"FORD",
     @"JAGUAR",
     @"LEXUS",
     @"MAZDA",
     @"MERCEDES-BENZ",
     @"MINI",
     @"MITSUBISHI",
     @"NISSAN",
     @"PEUGEOT",
     @"PORSCHE",
     @"ROLLS ROYCE",
     @"SKODA", 
     @"SUBARU", 
     @"SUZUKI", 
     @"VAUXHALL", 
     @"VOLKSWAGEN", 
     @"VOLVO", nil];
    NSLog(@"View Did Load data %@", [Cars sharedData]);
    NSLog(@"%@",[[Cars sharedData] data]);
    
    NSURL * bundle = [[NSBundle mainBundle] bundleURL];
    NSURL * file = [NSURL URLWithString:@"./cars.json" relativeToURL:bundle];
    NSData *jsondata = [NSData dataWithContentsOfURL: file];
    NSError *e = nil;
    NSDictionary *jsonCarList = [NSJSONSerialization JSONObjectWithData:jsondata options: NSJSONReadingMutableContainers error: &e];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    for (int i = 0; i < [brandArray count]; i++) {
        NSString *brand = [brandArray objectAtIndex:i];
        NSArray *jsonObjects = [jsonCarList objectForKey: brand];
        for (NSDictionary *value in jsonObjects) {
            Car *car = [[Car alloc] init];
            car.brand = brand;
            car.model = [value objectForKey:@"Model"];
            car.emissions = [f numberFromString:[value objectForKey:@"AVG(CO2_gkm)"]];
            [carArray addObject:car];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [carArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Car" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *brand = ((Car *)[carArray objectAtIndex:indexPath.row]).brand;
    NSString *model = ((Car *)[carArray objectAtIndex:indexPath.row]).model;
    NSString *text = [NSString stringWithFormat:@"%@: %@", brand, model];
    [cell.textLabel setText:text];
     return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    self.parentController.car = [carArray objectAtIndex:indexPath.row];
    [self.navigationController popToRootViewControllerAnimated:YES];
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

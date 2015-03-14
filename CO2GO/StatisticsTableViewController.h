//
//  StatisticsTableViewController.h
//  CO2GO
//
//  Created by Kamil Khan on 2015-03-13.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *trips;

@end

//
//  SearchViewController.h
//  CO2GO
//
//  Created by Michael Spearman on 3/14/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface SearchViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) ViewController *parentController;

@end

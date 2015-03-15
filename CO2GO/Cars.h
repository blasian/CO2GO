//
//  Cars.h
//  CO2GO
//
//  Created by Michael Spearman on 3/14/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import "ViewController.h"

@interface Cars : ViewController

+ (id) sharedData;
- (id)initWith:(NSDictionary*) dict ;

@end

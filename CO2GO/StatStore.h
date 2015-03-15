//
//  StatStore.h
//  CO2GO
//
//  Created by Michael Spearman on 3/15/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

@interface StatStore : NSObject

@property (nonatomic, readonly) NSArray *allStats;

+ (instancetype) sharedStore;
- (void)addStat:(Trip *)trip;

@end

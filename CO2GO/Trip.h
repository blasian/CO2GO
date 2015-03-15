//
//  Trip.h
//  CO2GO
//
//  Created by Kamil Khan on 2015-03-13.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Trip : NSObject

@property double emissions;
@property (nonatomic) CLLocationDistance distance;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *transitType;
@property (nonatomic) NSTimeInterval timeElapsed;

@end

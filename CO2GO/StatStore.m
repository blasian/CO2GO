//
//  StatStore.m
//  CO2GO
//
//  Created by Michael Spearman on 3/15/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import "StatStore.h"
#import "Trip.h"

@interface StatStore ()

@property (nonatomic) NSMutableArray *privateStore;

@end

@implementation StatStore

+ (instancetype)sharedStore
{
    static StatStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use designated init: [FLASHCardStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateStore = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allStats {
    return self.privateStore;
}

- (void)addStat:(Trip *)trip
{
    [_privateStore addObject:trip];
}

@end

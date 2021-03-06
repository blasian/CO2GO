//
//  Cars.m
//  CO2GO
//
//  Created by Michael Spearman on 3/14/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import "Cars.h"

@interface Cars ()

@end


@implementation Cars
@synthesize data;

+ (id)sharedData {
    Cars *car = [[self alloc] initPrivate];
    return car;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        NSURL * bundle = [[NSBundle mainBundle] bundleURL];
        NSURL * file = [NSURL URLWithString:@"./cars.json" relativeToURL:bundle];
        NSData *jsondata = [NSData dataWithContentsOfURL: file];
        NSError *e = nil;
        Cars *car = [[Cars alloc] init];
        car.data = [NSJSONSerialization JSONObjectWithData:jsondata options: NSJSONReadingMutableContainers error: &e];
    }
    return self;
}

- (id)initWith:(NSDictionary*) dict {
    if ((self = [super init])) {
        [self setData:dict];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

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

+ (id)sharedData {
    static Cars *data = nil;
    @synchronized(self) {
        if (data == nil)
            data = [[self alloc] init];
    }
    return data;
}

- (id)init {
    if (self = [super init]) {
        NSLog(@"Default Property Value");
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

//
//  AFHTTPRequestOperation+StartDate.m
//  AFNetworkingMeterApp
//
//  Created by Stanislaw Pankevich on 8/21/13.
//  Copyright (c) 2013 Stanislaw Pankevich. All rights reserved.
//

#import "AFHTTPRequestOperation+AFNM.h"
#import <objc/runtime.h>

void * AFNMHTTPRequestOperationStartDate = &AFNMHTTPRequestOperationStartDate;

@implementation AFHTTPRequestOperation (AFNM)

- (NSDate *)AFNMStartDate {
    return objc_getAssociatedObject(self, AFNMHTTPRequestOperationStartDate);
}

- (void)setAFNMStartDate:(NSDate *)date {
    objc_setAssociatedObject(self, AFNMHTTPRequestOperationStartDate, date, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

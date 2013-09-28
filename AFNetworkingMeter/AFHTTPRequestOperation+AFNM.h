//
//  AFHTTPRequestOperation+StartDate.h
//  AFNetworkingMeterApp
//
//  Created by Stanislaw Pankevich on 8/21/13.
//  Copyright (c) 2013 Stanislaw Pankevich. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@interface AFHTTPRequestOperation (AFNM)

- (NSDate *)AFNMStartDate;
- (void)setAFNMStartDate:(NSDate *)date;

@end

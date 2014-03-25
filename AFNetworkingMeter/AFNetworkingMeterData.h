//
//  AFNetworkingMeterData.h
//  AFNetworkingMeterApp
//
//  Created by Stanislaw Pankevich on 8/21/13.
//  Copyright (c) 2013 Stanislaw Pankevich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFHTTPRequestOperation.h>

@interface AFNetworkingMeterData : NSObject

- (void)collectRequestDataFromAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation;
- (void)collectResponseDataFromAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation;

@end

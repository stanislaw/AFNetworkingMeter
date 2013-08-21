//
//  AFNetworkingMeterData.m
//  AFNetworkingMeterApp
//
//  Created by Stanislaw Pankevich on 8/21/13.
//  Copyright (c) 2013 Stanislaw Pankevich. All rights reserved.
//

#import "AFNetworkingMeterData.h"

#import "AFHTTPRequestOperation+StartDate.h"

static NSString * const AFNetworkingMeterDataRequests = @"Requests";
static NSString * const AFNetworkingMeterDataResponses = @"Responses";

static NSString * const AFNetworkingMeterDataBytesReceived = @"Bytes received";
static NSString * const AFNetworkingMeterDataBytesSent = @"Bytes sent";

static NSString * const AFNetworkingMeterDataMinimalElapsedTimeForRequest = @"Minimal elapsed time for request";
static NSString * const AFNetworkingMeterDataMaximalElapsedTimeForRequest = @"Maximal elapsed time for request";

static NSString * const AFNetworkingMeterDataServerErrors = @"Server errors";
static NSString * const AFNetworkingMeterDataConnectionErrors = @"Connections errors";

#define keypath(...) \
[@[ __VA_ARGS__ ] componentsJoinedByString:@"."]

@interface AFNetworkingMeterData () {
    NSMutableDictionary * _data;
}

@property (readonly) NSDictionary *dataScheme;

@end

@implementation AFNetworkingMeterData

- (id)init {
    self = [super init];

    if (self == nil) return nil;

    _data = [[NSMutableDictionary alloc] init];

    return self;
}

- (void)collectRequestDataFromAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation {
    [self addNumberValue:@(1) forKey:AFNetworkingMeterDataRequests];

    if ([operation.request HTTPBody]) {
        [self addNumberValue:@(operation.request.HTTPBody.length) forKey:AFNetworkingMeterDataBytesSent];
    }

}

- (void)collectResponseDataFromAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation {
    [self addNumberValue:@(1) forKey:AFNetworkingMeterDataResponses];

    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:[operation AFNMStartDate]];

    [self setMinimalNumberValue:@(elapsedTime) forKey:AFNetworkingMeterDataMinimalElapsedTimeForRequest];
    [self setMaximalNumberValue:@(elapsedTime) forKey:AFNetworkingMeterDataMaximalElapsedTimeForRequest];

    if (operation.error) {
        NSError *error = operation.error;
        if ([error.domain isEqualToString:AFNetworkingErrorDomain]) {            
            [self addNumberValue:@(1) forKey:AFNetworkingMeterDataServerErrors];
        } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
            [self addNumberValue:@(1) forKey:AFNetworkingMeterDataConnectionErrors];
            return;
        }
    } else {
    }

    [self addNumberValue:@(operation.responseData.length) forKey:AFNetworkingMeterDataBytesReceived];
}

- (NSDictionary *)collectedData {
    return [NSDictionary dictionaryWithDictionary:_data];
}

#pragma mark
#pragma mark Private API ...

- (void)addNumberValue:(NSNumber *)numberValue forKey:(NSString *)key {
    NSNumber *currentValue = [self valueForKey:key];

    if (currentValue) {
        currentValue = @(currentValue.unsignedIntegerValue + numberValue.unsignedIntegerValue);
    } else {
        currentValue = numberValue;
    }

    [self setValue:currentValue forKey:key];
}

- (void)setMinimalNumberValue:(NSNumber *)numberValue forKey:(NSString *)key {
    NSNumber *currentValue = [self valueForKey:key];
    
    if (currentValue) {
        if (numberValue.unsignedIntegerValue < currentValue.unsignedIntegerValue) {
            currentValue = numberValue;
        }
    } else {
        currentValue = numberValue;
    }

    [self setValue:currentValue forKey:key];
}

- (void)setMaximalNumberValue:(NSNumber *)numberValue forKey:(NSString *)key {
    NSNumber *currentValue = [self valueForKey:key];

    if (currentValue) {
        if (numberValue.unsignedIntegerValue > currentValue.unsignedIntegerValue) {
            currentValue = numberValue;
        }
    } else {
        currentValue = numberValue;
    }

    [self setValue:currentValue forKey:key];
}

#pragma mark
#pragma mark Private API - accessing data

- (id)valueForKey:(NSString *)key {
    NSString *dataKeyPath = [self.dataScheme valueForKey:key];

    return [_data valueForKeyPath:dataKeyPath];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    NSString *dataKeyPath = [self.dataScheme valueForKey:key];

    [_data setValue:value forKeyPath:dataKeyPath];
}

- (NSDictionary *)dataScheme {
    return @{
        AFNetworkingMeterDataRequests: keypath(AFNetworkingMeterDataRequests),
        AFNetworkingMeterDataResponses: keypath(AFNetworkingMeterDataResponses),

        AFNetworkingMeterDataBytesReceived: keypath(AFNetworkingMeterDataBytesReceived),
        AFNetworkingMeterDataBytesSent: keypath(AFNetworkingMeterDataBytesSent),

        AFNetworkingMeterDataMinimalElapsedTimeForRequest: keypath(AFNetworkingMeterDataMinimalElapsedTimeForRequest),
        AFNetworkingMeterDataMaximalElapsedTimeForRequest: keypath(AFNetworkingMeterDataMaximalElapsedTimeForRequest),
        
        AFNetworkingMeterDataServerErrors: keypath(AFNetworkingMeterDataServerErrors),
        AFNetworkingMeterDataConnectionErrors: keypath(AFNetworkingMeterDataConnectionErrors),
    };
}

@end

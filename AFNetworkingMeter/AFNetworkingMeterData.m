//
//  AFNetworkingMeterData.m
//  AFNetworkingMeterApp
//
//  Created by Stanislaw Pankevich on 8/21/13.
//  Copyright (c) 2013 Stanislaw Pankevich. All rights reserved.
//

#import "AFNetworkingMeterData.h"
#import "AFNetworkingMeterConstants.h"

#import "AFHTTPRequestOperation+StartDate.h"

@interface AFNetworkingMeterData () {
    NSMutableDictionary * _data;
}

@end

@implementation AFNetworkingMeterData

- (id)init {
    self = [super init];

    if (self == nil) return nil;

    _data = [[NSMutableDictionary alloc] init];

    return self;
}

#pragma mark
#pragma mark AFHTTPRequestOperation

- (void)collectRequestDataFromAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation {
    [self addNumberValue:@(1) forKey:AFNetworkingMeterDataRequests];

    NSDictionary *HTTPHeaders;
    if ((HTTPHeaders = operation.request.allHTTPHeaderFields)) {
        NSData *HTTPHeadersData = [NSPropertyListSerialization dataFromPropertyList:HTTPHeaders
                                                          format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];

        [self addNumberValue:@(HTTPHeadersData.length) forKey:AFNetworkingMeterDataHeaderBytesSent];
    }

    NSData *HTTPBody;
    if ((HTTPBody = [operation.request HTTPBody])) {
        [self addNumberValue:@(HTTPBody.length) forKey:AFNetworkingMeterDataBodyBytesSent];
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
            [self addNumberValue:@(1) forKey:AFNetworkingMeterDataTotalServerErrors];

            NSString *statusCode = [NSString stringWithFormat:@"%@", @(operation.response.statusCode)];

            NSString *reasonPhrase = RFC2616_HTTPStatusCodesAndReasonPhrases()[@(operation.response.statusCode)];
            if (reasonPhrase) statusCode = [statusCode stringByAppendingFormat:@" %@", reasonPhrase];

            [self incrementValueOfDictionaryKey:statusCode forKey:AFNetworkingMeterDataServerErrors];
            
        } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
            [self addNumberValue:@(1) forKey:AFNetworkingMeterDataTotalConnectionErrors];

            NSString *errorCode = NSStringFromNSURLError(error);
            if (errorCode == nil) errorCode = @"Unknown NSURLError";

            [self incrementValueOfDictionaryKey:errorCode forKey:AFNetworkingMeterDataConnectionErrors];

            return;
        }
    } else {
    }

    NSDictionary *HTTPHeaders;
    if ((HTTPHeaders = operation.response.allHeaderFields)) {
        NSData *HTTPHeadersData = [NSPropertyListSerialization dataFromPropertyList:HTTPHeaders
                                                                             format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];

        [self addNumberValue:@(HTTPHeadersData.length) forKey:AFNetworkingMeterDataHeaderBytesReceived];
    }

    [self addNumberValue:@(operation.responseData.length) forKey:AFNetworkingMeterDataBodyBytesReceived];
}

#pragma mark
#pragma mark AFImageRequestOperation

- (void)collectRequestDataFromAFImageRequestOperation:(AFImageRequestOperation *)operation {
    [self addNumberValue:@(1) forKey:AFNetworkingMeterDataImageRequests];
}

- (void)collectResponseDataFromAFImageRequestOperation:(AFImageRequestOperation *)operation {
    [self addNumberValue:@(1) forKey:AFNetworkingMeterDataImageResponses];

    [self addNumberValue:@(operation.responseData.length) forKey:AFNetworkingMeterDataImageBytesReceived];
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
        if (numberValue.doubleValue < currentValue.doubleValue) {
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
        if (numberValue.doubleValue > currentValue.doubleValue) {
            currentValue = numberValue;
        }
    } else {
        currentValue = numberValue;
    }

    [self setValue:currentValue forKey:key];
}

- (void)incrementValueOfDictionaryKey:(NSString *)dictionaryKey forKey:(NSString *)key {

    NSMutableDictionary *dictionary = [self valueForKey:key];

    if (dictionary == nil) dictionary = [NSMutableDictionary dictionary];

    NSNumber *currentValue = [dictionary valueForKey:dictionaryKey];

    if (currentValue) {
        currentValue = @(currentValue.unsignedIntegerValue + 1);
    } else {
        currentValue = @(1);
    }

    [dictionary setValue:currentValue forKey:dictionaryKey];

    [self setValue:dictionary forKey:key];
}

#pragma mark
#pragma mark Private API - accessing data

- (id)valueForKey:(NSString *)key {
    return [_data valueForKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [_data setValue:value forKeyPath:key];
}

@end

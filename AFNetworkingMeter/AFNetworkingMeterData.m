//
//  AFNetworkingMeterData.m
//  AFNetworkingMeterApp
//
//  Created by Stanislaw Pankevich on 8/21/13.
//  Copyright (c) 2013 Stanislaw Pankevich. All rights reserved.
//

#import "AFNetworkingMeterData.h"

#import "AFHTTPRequestOperation+StartDate.h"

static inline NSString * NSStringForNSURLError(NSError *error) {
    NSString *string;
    
    switch (error.code) {
        case NSURLErrorCancelled:
            string = @"NSURLErrorCancelled";

            break;

        case NSURLErrorBadURL:
            string = @"NSURLErrorBadURL";

            break;

        case NSURLErrorTimedOut:
            string = @"NSURLErrorTimedOut";
            
            break;

        case NSURLErrorUnsupportedURL:
            string = @"NSURLErrorUnsupportedURL";

            break;

        case NSURLErrorCannotFindHost:
            string = @"NSURLErrorCannotFindHost";

            break;

        case NSURLErrorCannotConnectToHost:
            string = @"NSURLErrorCannotConnectToHost";

            break;

        case NSURLErrorNetworkConnectionLost:
            string = @"NSURLErrorNetworkConnectionLost";

            break;

        case NSURLErrorDNSLookupFailed:
            string = @"NSURLErrorDNSLookupFailed";

            break;

        case NSURLErrorHTTPTooManyRedirects:
            string = @"NSURLErrorHTTPTooManyRedirects";

            break;

        case NSURLErrorResourceUnavailable:
            string = @"NSURLErrorResourceUnavailable";

            break;

        case NSURLErrorNotConnectedToInternet:
            string = @"NSURLErrorNotConnectedToInternet";

            break;

        case NSURLErrorRedirectToNonExistentLocation:
            string = @"NSURLErrorRedirectToNonExistentLocation";
            
            break;

        case NSURLErrorBadServerResponse:
            string = @"NSURLErrorBadServerResponse";
            
            break;

        case NSURLErrorUserCancelledAuthentication:
            string = @"NSURLErrorUserCancelledAuthentication";
            
            break;

        case NSURLErrorUserAuthenticationRequired:
            string = @"NSURLErrorUserAuthenticationRequired";

            break;

        case NSURLErrorZeroByteResource:
            string = @"NSURLErrorZeroByteResource";

            break;

        case NSURLErrorCannotDecodeRawData:
            string = @"NSURLErrorCannotDecodeRawData";

            break;

        case NSURLErrorCannotDecodeContentData:
            string = @"NSURLErrorCannotDecodeContentData";
            
            break;

        case NSURLErrorCannotParseResponse:
            string = @"NSURLErrorCannotParseResponse";
            
            break;

        case NSURLErrorFileIsDirectory:
            string = @"NSURLErrorFileIsDirectory";
            
            break;

        case NSURLErrorFileDoesNotExist:
            string = @"NSURLErrorFileDoesNotExist";
            
            break;

        case NSURLErrorNoPermissionsToReadFile:
            string = @"NSURLErrorNoPermissionsToReadFile";
            
            break;

        case NSURLErrorDataLengthExceedsMaximum:
            string = @"NSURLErrorDataLengthExceedsMaximum";
            
            break;

        default:
            string = @"NSURLErrorUnknown";

            break;
    }

    return [NSString stringWithFormat:@"%@ %d", string, error.code];
}

static NSString * const AFNetworkingMeterDataRequests = @"Requests";
static NSString * const AFNetworkingMeterDataResponses = @"Responses";

static NSString * const AFNetworkingMeterDataBytesReceived = @"Received (bytes)";
static NSString * const AFNetworkingMeterDataBytesSent = @"Sent (bytes)";

static NSString * const AFNetworkingMeterDataMinimalElapsedTimeForRequest = @"Minimal elapsed time for request (seconds)";
static NSString * const AFNetworkingMeterDataMaximalElapsedTimeForRequest = @"Maximal elapsed time for request (seconds)";

static NSString * const AFNetworkingMeterDataTotalServerErrors = @"Total server errors";
static NSString * const AFNetworkingMeterDataServerErrors = @"Server errors";

static NSString * const AFNetworkingMeterDataTotalConnectionErrors = @"Total connection errors";
static NSString * const AFNetworkingMeterDataConnectionErrors = @"Connection errors";

#define keypath(...) \
[@[ __VA_ARGS__ ] componentsJoinedByString:@"."]

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
            [self addNumberValue:@(1) forKey:AFNetworkingMeterDataTotalServerErrors];

            NSString *statusCode = [NSString stringWithFormat:@"%@", @(operation.response.statusCode)];
            [self incrementValueOfDictionaryKey:statusCode forKey:AFNetworkingMeterDataServerErrors];
            
        } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
            [self addNumberValue:@(1) forKey:AFNetworkingMeterDataTotalConnectionErrors];

            NSString *errorCode = NSStringForNSURLError(error);
            [self incrementValueOfDictionaryKey:errorCode forKey:AFNetworkingMeterDataConnectionErrors];

            return;
        }
    } else {
    }

    [self addNumberValue:@(operation.responseData.length) forKey:AFNetworkingMeterDataBytesReceived];
}

- (NSString *)formattedData {
    NSMutableArray *formattedDataComponents = [NSMutableArray array];

    NSString *title = @"\n\nAFNetworkingMeter\n=================";
    [formattedDataComponents addObject:title];

    NSNumber *requests = [self valueForKey:AFNetworkingMeterDataRequests];
    NSString *requestsString = [NSString stringWithFormat:@"Requests: %@", requests];
    [formattedDataComponents addObject:requestsString];

    NSNumber *responses = [self valueForKey:AFNetworkingMeterDataResponses];
    NSString *responsesString = [NSString stringWithFormat:@"Responses: %@", responses];
    [formattedDataComponents addObject:responsesString];

    NSNumber *bytesSent = [self valueForKey:AFNetworkingMeterDataBytesSent];
    NSString *bytesSentString = [NSString stringWithFormat:@"Sent (bytes): %@", bytesSent];
    [formattedDataComponents addObject:bytesSentString];

    NSNumber *bytesReceived = [self valueForKey:AFNetworkingMeterDataBytesReceived];
    NSString *bytesReceivedString = [NSString stringWithFormat:@"Received (bytes): %@", bytesReceived];
    [formattedDataComponents addObject:bytesReceivedString];

    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.minimumFractionDigits = 0;
    numberFormatter.maximumFractionDigits = 7;
    numberFormatter.minimumIntegerDigits = 1;

    NSNumber *minimalElapsedTime = [self valueForKey:AFNetworkingMeterDataMinimalElapsedTimeForRequest];
    NSString *minimalElapsedTimeString = [NSString stringWithFormat:@"Minimal elapsed time for request (seconds): %@", [numberFormatter stringFromNumber:minimalElapsedTime]];
    [formattedDataComponents addObject:minimalElapsedTimeString];

    NSNumber *maximalElapsedTime = [self valueForKey:AFNetworkingMeterDataMaximalElapsedTimeForRequest];
    NSString *maximalElapsedTimeString = [NSString stringWithFormat:@"Maximal elapsed time for request (seconds): %@", [numberFormatter stringFromNumber:maximalElapsedTime]];
    [formattedDataComponents addObject:maximalElapsedTimeString];

    NSNumber *totalServerErrors = [self valueForKey:AFNetworkingMeterDataTotalServerErrors];
    NSString *totalServerErrorsString = [NSString stringWithFormat:@"Total server errors: %@", totalServerErrors];
    [formattedDataComponents addObject:totalServerErrorsString];

    NSNumber *serverErrors = [self valueForKey:AFNetworkingMeterDataServerErrors];
    NSString *serverErrorsString = [NSString stringWithFormat:@"Server errors: %@", serverErrors];
    [formattedDataComponents addObject:serverErrorsString];

    NSNumber *totalConnectionErrors = [self valueForKey:AFNetworkingMeterDataTotalConnectionErrors];
    NSString *totalConnectionErrorsString = [NSString stringWithFormat:@"Total connection errors: %@", totalConnectionErrors];
    [formattedDataComponents addObject:totalConnectionErrorsString];

    NSNumber *connectionErrors = [self valueForKey:AFNetworkingMeterDataConnectionErrors];
    NSString *connectionErrorsString = [NSString stringWithFormat:@"Connection errors: %@", connectionErrors];
    [formattedDataComponents addObject:connectionErrorsString];

    return [formattedDataComponents componentsJoinedByString:@"\n"];
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

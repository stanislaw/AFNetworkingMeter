//
//  AFNetworkingMeterReportGenerator.m
//  AFNetworkingMeterApp
//
//  Created by Stanislaw Pankevich on 9/9/13.
//  Copyright (c) 2013 Stanislaw Pankevich. All rights reserved.
//

#import "AFNetworkingMeterReportGenerator.h"
#import "AFNetworkingMeterConstants.h"

#define REPORT_RIGHT_COLUMN_LEFT 50

NSString *string44ForCharacter(NSString *character) {
    NSMutableString *string44 = [NSMutableString stringWithCapacity:44];

    for (int i = 0; i < 44; i++) {
        [string44 insertString:character atIndex:0];
    }

    return [string44 copy];
}

@implementation AFNetworkingMeterReportGenerator

- (NSString *)formattedReportForData:(AFNetworkingMeterData *)data {
    NSMutableArray *formattedDataComponents = [NSMutableArray array];

#pragma mark Header
    
    NSString *headerTop = string44ForCharacter(@"=");
    NSString *headerTitle = @"   AFNetworkingMeter  -  formatted report   ";
    NSString *headerBottom = string44ForCharacter(@"-");
    NSString *headerString = [@[headerTop, headerTitle, headerBottom] componentsJoinedByString:@"\n"];

#pragma mark Summary

    NSNumber *requests = [data valueForKey:AFNetworkingMeterDataRequests];
    NSString *requestsString = [NSString stringWithFormat:@"Requests:"];
    requestsString = [NSString stringWithFormat:@"%@ %@", requestsString, requests];


    NSNumber *responses = [data valueForKey:AFNetworkingMeterDataResponses];
    NSString *responsesString = [NSString stringWithFormat:@"Responses:%*s %@", 2, "+", responses];

    NSNumber *bytesSent = [data valueForKey:AFNetworkingMeterDataBytesSent];
    NSString *bytesSentString = [NSString stringWithFormat:@"Sent (bytes): %@", bytesSent];


    NSNumber *bytesReceived = [data valueForKey:AFNetworkingMeterDataBytesReceived];
    NSString *bytesReceivedString = [NSString stringWithFormat:@"Received (bytes): %@", bytesReceived];

#pragma mark Elapsed time

    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.minimumFractionDigits = 0;
    numberFormatter.maximumFractionDigits = 7;
    numberFormatter.minimumIntegerDigits = 1;

    NSNumber *minimalElapsedTime = [data valueForKey:AFNetworkingMeterDataMinimalElapsedTimeForRequest];
    NSString *minimalElapsedTimeString = [NSString stringWithFormat:@"Minimal elapsed time for request (seconds): %@", [numberFormatter stringFromNumber:minimalElapsedTime]];

    NSNumber *maximalElapsedTime = [data valueForKey:AFNetworkingMeterDataMaximalElapsedTimeForRequest];
    NSString *maximalElapsedTimeString = [NSString stringWithFormat:@"Maximal elapsed time for request (seconds): %@", [numberFormatter stringFromNumber:maximalElapsedTime]];

#pragma mark Image requests

    NSNumber *imageRequests = [data valueForKey:AFNetworkingMeterDataImageRequests];
    NSString *imageRequestsString = [NSString stringWithFormat:@"Image requests: %@", imageRequests];

    NSNumber *imageResponses = [data valueForKey:AFNetworkingMeterDataImageResponses];
    NSString *imageResponsesString = [NSString stringWithFormat:@"Image responses: %@", imageResponses];

    NSNumber *imageBytesReceived = [data valueForKey:AFNetworkingMeterDataImageBytesReceived];
    NSString *imageBytesReceivedString = [NSString stringWithFormat:@"Image data received (bytes): %@", imageBytesReceived];

#pragma mark Server errors

    NSNumber *totalServerErrors = [data valueForKey:AFNetworkingMeterDataTotalServerErrors];
    NSString *totalServerErrorsString = [NSString stringWithFormat:@"Total server errors: %@", totalServerErrors];

    NSNumber *serverErrors = [data valueForKey:AFNetworkingMeterDataServerErrors];
    NSString *serverErrorsString = [NSString stringWithFormat:@"Server errors: %@", serverErrors];

#pragma mark Connection errors

    NSNumber *totalConnectionErrors = [data valueForKey:AFNetworkingMeterDataTotalConnectionErrors];
    NSString *totalConnectionErrorsString = [NSString stringWithFormat:@"Total connection errors: %@", totalConnectionErrors];

    NSNumber *connectionErrors = [data valueForKey:AFNetworkingMeterDataConnectionErrors];
    NSString *connectionErrorsString = [NSString stringWithFormat:@"Connection errors: %@", connectionErrors];

#pragma mark Aggregation of the formatted report

    [formattedDataComponents addObject:@"\n"];
    [formattedDataComponents addObject:headerString];
    [formattedDataComponents addObject:requestsString];
    [formattedDataComponents addObject:responsesString];
    [formattedDataComponents addObject:bytesSentString];
    [formattedDataComponents addObject:bytesReceivedString];
    [formattedDataComponents addObject:minimalElapsedTimeString];
    [formattedDataComponents addObject:maximalElapsedTimeString];
    [formattedDataComponents addObject:imageRequestsString];
    [formattedDataComponents addObject:imageResponsesString];
    [formattedDataComponents addObject:imageBytesReceivedString];
    [formattedDataComponents addObject:totalServerErrorsString];
    [formattedDataComponents addObject:serverErrorsString];
    [formattedDataComponents addObject:totalConnectionErrorsString];
    [formattedDataComponents addObject:connectionErrorsString];

    return [formattedDataComponents componentsJoinedByString:@"\n"];
}

@end

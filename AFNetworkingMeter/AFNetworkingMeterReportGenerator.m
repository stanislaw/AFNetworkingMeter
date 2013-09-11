//
//  AFNetworkingMeterReportGenerator.m
//  AFNetworkingMeterApp
//
//  Created by Stanislaw Pankevich on 9/9/13.
//  Copyright (c) 2013 Stanislaw Pankevich. All rights reserved.
//

#import "AFNetworkingMeterReportGenerator.h"
#import "AFNetworkingMeterConstants.h"

#define REPORT_WIDTH 44

NSString *NSStringFromCharacterAndLength(NSString *character, NSUInteger length) {
    NSMutableString *string = [NSMutableString stringWithCapacity:length];

    for (int i = 0; i < length; i++) {
        [string insertString:character atIndex:0];
    }

    return [string copy];
}

@implementation AFNetworkingMeterReportGenerator

- (NSString *)formattedReportForData:(AFNetworkingMeterData *)data {
    NSMutableArray *formattedDataComponents = [NSMutableArray array];

    NSString *stringWithLengthEqualToReportWidthAndFilledWithSpaces = NSStringFromCharacterAndLength(@" ", REPORT_WIDTH);

#pragma mark Header

    NSString *headerTop = NSStringFromCharacterAndLength(@"=", REPORT_WIDTH);
    NSString *headerTitle = @"   AFNetworkingMeter  -  formatted report   ";
    NSString *headerBottom = NSStringFromCharacterAndLength(@"-", REPORT_WIDTH);
    NSString *headerString = [@[headerTop, headerTitle, headerBottom] componentsJoinedByString:@"\n"];

#pragma mark Summary

    NSString *requestsKey = @"Requests:";
    NSString *requestsValue = [[data valueForKey:AFNetworkingMeterDataRequests] stringValue];

    NSMutableString *requestsString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [requestsString replaceCharactersInRange:NSMakeRange(0, requestsKey.length) withString:requestsKey];
    [requestsString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - requestsValue.length, requestsValue.length) withString:requestsValue];

    NSString *responsesKey = @"Responses:";
    NSString *responsesValue = [[data valueForKey:AFNetworkingMeterDataResponses] stringValue];

    NSMutableString *responsesString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [responsesString replaceCharactersInRange:NSMakeRange(0, responsesKey.length) withString:responsesKey];
    [responsesString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - responsesValue.length, responsesValue.length) withString:responsesValue];

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

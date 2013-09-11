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


    NSString *bytesSentKey = @"Sent (bytes):";
    NSString *bytesSentValue = [[data valueForKey:AFNetworkingMeterDataBytesSent] stringValue];

    NSMutableString *bytesSentString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [bytesSentString replaceCharactersInRange:NSMakeRange(0, bytesSentKey.length) withString:bytesSentKey];
    [bytesSentString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - bytesSentValue.length, bytesSentValue.length) withString:bytesSentValue];


    NSString *bytesReceivedKey = @"Received (bytes):";
    NSString *bytesReceivedValue = [[data valueForKey:AFNetworkingMeterDataBytesReceived] stringValue];

    NSMutableString *bytesReceivedString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [bytesReceivedString replaceCharactersInRange:NSMakeRange(0, bytesReceivedKey.length) withString:bytesReceivedKey];
    [bytesReceivedString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - bytesReceivedValue.length, bytesReceivedValue.length) withString:bytesReceivedValue];

#pragma mark Elapsed time

    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.minimumFractionDigits = 0;
    numberFormatter.maximumFractionDigits = 7;
    numberFormatter.minimumIntegerDigits = 1;


    NSString *minimalElapsedTimeKey = @"Min (seconds):";
    NSString *minimalElapsedTimeValue = [numberFormatter stringFromNumber:[data valueForKey:AFNetworkingMeterDataMinimalElapsedTimeForRequest]];

    NSMutableString *minimalElapsedTimeString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [minimalElapsedTimeString replaceCharactersInRange:NSMakeRange(0, minimalElapsedTimeKey.length) withString:minimalElapsedTimeKey];
    [minimalElapsedTimeString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - minimalElapsedTimeValue.length, minimalElapsedTimeValue.length) withString:minimalElapsedTimeValue];


    NSString *maximalElapsedTimeKey = @"Min (seconds):";
    NSString *maximalElapsedTimeValue = [numberFormatter stringFromNumber:[data valueForKey:AFNetworkingMeterDataMaximalElapsedTimeForRequest]];

    NSMutableString *maximalElapsedTimeString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [maximalElapsedTimeString replaceCharactersInRange:NSMakeRange(0, maximalElapsedTimeKey.length) withString:maximalElapsedTimeKey];
    [maximalElapsedTimeString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - maximalElapsedTimeValue.length, maximalElapsedTimeValue.length) withString:maximalElapsedTimeValue];

#pragma mark Image requests

    NSString *imageRequestsKey = @"Requests:";
    NSString *imageRequestsValue = [[data valueForKey:AFNetworkingMeterDataImageRequests] stringValue];

    NSMutableString *imageRequestsString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [imageRequestsString replaceCharactersInRange:NSMakeRange(0, imageRequestsKey.length) withString:imageRequestsKey];
    [imageRequestsString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - imageRequestsValue.length, imageRequestsValue.length) withString:imageRequestsValue];


    NSString *imageResponsesKey = @"Responses:";
    NSString *imageResponsesValue = [[data valueForKey:AFNetworkingMeterDataImageResponses] stringValue];

    NSMutableString *imageResponsesString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [imageResponsesString replaceCharactersInRange:NSMakeRange(0, imageResponsesKey.length) withString:imageResponsesKey];
    [imageResponsesString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - imageResponsesValue.length, imageResponsesValue.length) withString:imageResponsesValue];

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
    NSString *headerTop = NSStringFromCharacterAndLength(@"=", REPORT_WIDTH);
    NSString *headerTitle = @"   AFNetworkingMeter  -  formatted report   ";
    NSString *headerBottom = NSStringFromCharacterAndLength(@"-", REPORT_WIDTH);
    NSString *headerString = [@[headerTop, headerTitle, headerBottom] componentsJoinedByString:@"\n"];

    [formattedDataComponents addObject:@"\n"];
    [formattedDataComponents addObject:headerString];

    [formattedDataComponents addObject:@"\n\n"];

    [formattedDataComponents addObject:requestsString];
    [formattedDataComponents addObject:@"\n"];
    [formattedDataComponents addObject:responsesString];

    [formattedDataComponents addObject:@"\n\n"];

    [formattedDataComponents addObject:bytesSentString];
    [formattedDataComponents addObject:@"\n"];

    [formattedDataComponents addObject:bytesReceivedString];

    [formattedDataComponents addObject:@"\n\n"];
    [formattedDataComponents addObject:@"Elapsed time for request ..................."];
    [formattedDataComponents addObject:@"\n\n"];

    [formattedDataComponents addObject:minimalElapsedTimeString];
    [formattedDataComponents addObject:@"\n"];

    [formattedDataComponents addObject:maximalElapsedTimeString];

    [formattedDataComponents addObject:@"\n\n"];
    [formattedDataComponents addObject:@"Images ....................................."];
    [formattedDataComponents addObject:@"\n\n"];

    [formattedDataComponents addObject:imageRequestsString];
    [formattedDataComponents addObject:@"\n"];

    [formattedDataComponents addObject:imageResponsesString];
    [formattedDataComponents addObject:@"\n"];

    [formattedDataComponents addObject:imageBytesReceivedString];

    [formattedDataComponents addObject:@"\n\n"];
    [formattedDataComponents addObject:@"Server errors .............................."];
    [formattedDataComponents addObject:@"\n\n"];

    [formattedDataComponents addObject:totalServerErrorsString];
    [formattedDataComponents addObject:serverErrorsString];
    [formattedDataComponents addObject:totalConnectionErrorsString];
    [formattedDataComponents addObject:connectionErrorsString];

    return [formattedDataComponents componentsJoinedByString:@""];
}

@end

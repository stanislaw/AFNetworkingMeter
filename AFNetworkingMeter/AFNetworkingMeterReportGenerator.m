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


    NSString *imageBytesReceivedKey = @"Data received (bytes):";
    NSString *imageBytesReceivedValue = [[data valueForKey:AFNetworkingMeterDataImageBytesReceived] stringValue];
    NSMutableString *imageBytesReceivedString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [imageBytesReceivedString replaceCharactersInRange:NSMakeRange(0, imageBytesReceivedKey.length) withString:imageBytesReceivedKey];
    [imageBytesReceivedString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - imageBytesReceivedValue.length, imageBytesReceivedValue.length) withString:imageBytesReceivedValue];

#pragma mark Server errors

    NSString *totalServerErrorsKey = @"Total:";
    NSString *totalServerErrorsValue = [[data valueForKey:AFNetworkingMeterDataTotalServerErrors] stringValue];

    NSMutableString *totalServerErrorsString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [totalServerErrorsString replaceCharactersInRange:NSMakeRange(0, totalServerErrorsKey.length) withString:totalServerErrorsKey];
    [totalServerErrorsString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - totalServerErrorsValue.length, totalServerErrorsValue.length) withString:totalServerErrorsValue];


    NSDictionary *serverErrorsValue = [data valueForKey:AFNetworkingMeterDataServerErrors];
    NSMutableArray *serverErrorsStringsArray = [NSMutableArray array];

    [serverErrorsValue enumerateKeysAndObjectsUsingBlock:^(NSString *statusCodeString, NSNumber *quantity, BOOL *stop) {
        NSString *quantityString = [quantity stringValue];

        NSMutableString *errorString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];

        [errorString replaceCharactersInRange:NSMakeRange(0, statusCodeString.length) withString:statusCodeString];
        [errorString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - quantityString.length, quantityString.length) withString:quantityString];

        [serverErrorsStringsArray addObject:errorString];
    }];

    NSString *serverErrorsString = [serverErrorsStringsArray componentsJoinedByString:@"\n"];

#pragma mark Connection errors

    NSString *totalConnectionErrorsKey = @"Total:";
    NSString *totalConnectionErrorsValue = [[data valueForKey:AFNetworkingMeterDataTotalConnectionErrors] stringValue];

    NSMutableString *totalConnectionErrorsString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [totalConnectionErrorsString replaceCharactersInRange:NSMakeRange(0, totalConnectionErrorsKey.length) withString:totalConnectionErrorsKey];
    [totalConnectionErrorsString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - totalConnectionErrorsValue.length, totalConnectionErrorsValue.length) withString:totalConnectionErrorsValue];


    NSDictionary *connectionErrorsValue = [data valueForKey:AFNetworkingMeterDataConnectionErrors];
    NSMutableArray *connectionErrorsStringsArray = [NSMutableArray array];

    [connectionErrorsValue enumerateKeysAndObjectsUsingBlock:^(NSString *NSURLErrorString, NSNumber *quantity, BOOL *stop) {
        NSString *quantityString = [quantity stringValue];

        NSMutableString *errorString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];

        [errorString replaceCharactersInRange:NSMakeRange(0, NSURLErrorString.length) withString:NSURLErrorString];
        [errorString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - quantityString.length, quantityString.length) withString:quantityString];

        [connectionErrorsStringsArray addObject:errorString];
    }];

    NSString *connectionErrorsString = [connectionErrorsStringsArray componentsJoinedByString:@"\n"];

#pragma mark Aggregation of the formatted report

    NSString *headerTop = NSStringFromCharacterAndLength(@"=", REPORT_WIDTH);
    NSString *headerTitle = @"   AFNetworkingMeter  -  formatted report   ";
    NSString *headerBottom = NSStringFromCharacterAndLength(@"-", REPORT_WIDTH);
    NSString *headerString = [@[headerTop, headerTitle, headerBottom] componentsJoinedByString:@"\n"];

    [formattedDataComponents addObject:@"\n\n"];
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
    [formattedDataComponents addObject:@"\n"];

    [formattedDataComponents addObject:serverErrorsString];

    [formattedDataComponents addObject:@"\n\n"];
    [formattedDataComponents addObject:@"Connection errors (NSURLError) ............."];
    [formattedDataComponents addObject:@"\n\n"];

    [formattedDataComponents addObject:totalConnectionErrorsString];
    [formattedDataComponents addObject:@"\n"];

    [formattedDataComponents addObject:connectionErrorsString];

    [formattedDataComponents addObject:@"\n\n"];
    [formattedDataComponents addObject:@"============================================"];
    [formattedDataComponents addObject:@"\n\n"];

    return [formattedDataComponents componentsJoinedByString:@""];
}

@end

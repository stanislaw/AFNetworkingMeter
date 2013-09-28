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
    return [@"" stringByPaddingToLength:length withString:character startingAtIndex:0];
}

@implementation AFNetworkingMeterReportGenerator

- (NSString *)generateFormattedReportForData:(AFNetworkingMeterData *)data options:(NSDictionary *)options {
    BOOL includeHTTPHeadersSize = [options.allKeys containsObject:AFNetworkingMeterOptionIncludesHTTPHeadersSize];

    NSMutableArray *formattedDataComponents = [NSMutableArray array];

    NSString *stringWithLengthEqualToReportWidthAndFilledWithSpaces = NSStringFromCharacterAndLength(@" ", REPORT_WIDTH);

    NSMutableString *requestsString,
    *responsesString,
    *minimalElapsedTimeString,
    *maximalElapsedTimeString,
    *imageRequestsString,
    *imageResponsesString,
    *imageBytesReceivedString,
    *totalConnectionErrorsString,
    *connectionErrorsString,
    *serverErrorsString;

#pragma mark Summary

    NSDecimalNumber *requestsNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataRequests] decimalValue]];
    NSDecimalNumber *responsesNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataResponses] decimalValue]];

    BOOL atLeastOneRequestHasBeenMade = [requestsNumber compare:[NSDecimalNumber zero]] == NSOrderedDescending;

    NSString *requestsValue = [requestsNumber stringValue];
    NSString *responsesValue = [responsesNumber stringValue];


    NSDecimalNumber *bodyBytesSentNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataBodyBytesSent] decimalValue]];
    NSDecimalNumber *bodyBytesReceivedNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataBodyBytesSent] decimalValue]];

    NSDecimalNumber *bytesSentNumber = [bodyBytesSentNumber copy];
    NSDecimalNumber *bytesReceivedNumber = [bodyBytesReceivedNumber copy];

    if (includeHTTPHeadersSize) {
        NSDecimalNumber *headerBytesSentNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataHeaderBytesSent] decimalValue]];
        NSDecimalNumber *headerBytesReceivedNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataHeaderBytesSent] decimalValue]];

        bytesSentNumber = [bytesSentNumber decimalNumberByAdding:headerBytesSentNumber];
        bytesReceivedNumber = [bytesReceivedNumber decimalNumberByAdding:headerBytesReceivedNumber];
    }

    NSString *bytesSentValue = [bytesSentNumber stringValue];
    NSString *bytesReceivedValue = [bytesReceivedNumber stringValue];

    
    NSString *requestsKey = @"Requests:";
    NSString *responsesKey = @"Responses:";
    NSString *bytesSentKey = @"Sent (bytes):";
    NSString *bytesReceivedKey = @"Received (bytes):";


    requestsString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [requestsString replaceCharactersInRange:NSMakeRange(0, requestsKey.length) withString:requestsKey];
    [requestsString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - requestsValue.length, requestsValue.length) withString:requestsValue];


    responsesString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [responsesString replaceCharactersInRange:NSMakeRange(0, responsesKey.length) withString:responsesKey];
    [responsesString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - responsesValue.length, responsesValue.length) withString:responsesValue];


    NSMutableString *bytesSentString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [bytesSentString replaceCharactersInRange:NSMakeRange(0, bytesSentKey.length) withString:bytesSentKey];
    [bytesSentString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - bytesSentValue.length, bytesSentValue.length) withString:bytesSentValue];


    NSMutableString *bytesReceivedString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [bytesReceivedString replaceCharactersInRange:NSMakeRange(0, bytesReceivedKey.length) withString:bytesReceivedKey];
    [bytesReceivedString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - bytesReceivedValue.length, bytesReceivedValue.length) withString:bytesReceivedValue];

#pragma mark Elapsed time

    if (atLeastOneRequestHasBeenMade) {
        NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.minimumFractionDigits = 0;
        numberFormatter.maximumFractionDigits = 7;
        numberFormatter.minimumIntegerDigits = 1;


        NSString *minimalElapsedTimeKey = @"Min (seconds):";
        NSString *maximalElapsedTimeKey = @"Max (seconds):";


        NSString *minimalElapsedTimeValue = [numberFormatter stringFromNumber:[data valueForKey:AFNetworkingMeterDataMinimalElapsedTimeForRequest]];
        NSString *maximalElapsedTimeValue = [numberFormatter stringFromNumber:[data valueForKey:AFNetworkingMeterDataMaximalElapsedTimeForRequest]];


        minimalElapsedTimeString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
        [minimalElapsedTimeString replaceCharactersInRange:NSMakeRange(0, minimalElapsedTimeKey.length) withString:minimalElapsedTimeKey];
        [minimalElapsedTimeString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - minimalElapsedTimeValue.length, minimalElapsedTimeValue.length) withString:minimalElapsedTimeValue];


        maximalElapsedTimeString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
        [maximalElapsedTimeString replaceCharactersInRange:NSMakeRange(0, maximalElapsedTimeKey.length) withString:maximalElapsedTimeKey];
        [maximalElapsedTimeString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - maximalElapsedTimeValue.length, maximalElapsedTimeValue.length) withString:maximalElapsedTimeValue];
    }

#pragma mark Image requests

    NSDecimalNumber *imageRequestsNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataImageRequests] decimalValue]];
    NSString *imageRequestsValue = [imageRequestsNumber stringValue];
    BOOL atLeastOneImageRequestHasBeenMade = [imageRequestsNumber compare:[NSDecimalNumber zero]] == NSOrderedDescending;

    NSDecimalNumber *imageResponsesNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataImageResponses] decimalValue]];
    NSString *imageResponsesValue = [imageResponsesNumber stringValue];

    NSDecimalNumber *imageBytesReceivedNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataImageBytesReceived] decimalValue]];
    NSString *imageBytesReceivedValue = [imageBytesReceivedNumber stringValue];


    NSString *imageRequestsKey = @"Requests:";
    NSString *imageResponsesKey = @"Responses:";
    NSString *imageBytesReceivedKey = @"Data received (bytes):";


    imageRequestsString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [imageRequestsString replaceCharactersInRange:NSMakeRange(0, imageRequestsKey.length) withString:imageRequestsKey];
    [imageRequestsString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - imageRequestsValue.length, imageRequestsValue.length) withString:imageRequestsValue];


    imageResponsesString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [imageResponsesString replaceCharactersInRange:NSMakeRange(0, imageResponsesKey.length) withString:imageResponsesKey];
    [imageResponsesString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - imageResponsesValue.length, imageResponsesValue.length) withString:imageResponsesValue];


    imageBytesReceivedString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [imageBytesReceivedString replaceCharactersInRange:NSMakeRange(0, imageBytesReceivedKey.length) withString:imageBytesReceivedKey];
    [imageBytesReceivedString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - imageBytesReceivedValue.length, imageBytesReceivedValue.length) withString:imageBytesReceivedValue];

#pragma mark Server errors

    NSDecimalNumber *totalServerErrorsNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataTotalServerErrors] decimalValue]];
    NSString *totalServerErrorsValue = [totalServerErrorsNumber stringValue];
    BOOL atLeastOneServerErrorHasOccured = [totalServerErrorsNumber compare:[NSDecimalNumber zero]] == NSOrderedDescending;


    NSString *totalServerErrorsKey = @"Total:";
    NSMutableString *totalServerErrorsString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [totalServerErrorsString replaceCharactersInRange:NSMakeRange(0, totalServerErrorsKey.length) withString:totalServerErrorsKey];
    [totalServerErrorsString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - totalServerErrorsValue.length, totalServerErrorsValue.length) withString:totalServerErrorsValue];


    if (atLeastOneServerErrorHasOccured) {
        NSDictionary *serverErrorsValue = [data valueForKey:AFNetworkingMeterDataServerErrors];

        NSMutableArray *serverErrorsStringsArray = [NSMutableArray array];

        [serverErrorsValue enumerateKeysAndObjectsUsingBlock:^(NSString *statusCodeString, NSNumber *quantity, BOOL *stop) {
            NSString *quantityString = [quantity stringValue];

            NSMutableString *errorString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];

            [errorString replaceCharactersInRange:NSMakeRange(0, statusCodeString.length) withString:statusCodeString];
            [errorString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - quantityString.length, quantityString.length) withString:quantityString];

            [serverErrorsStringsArray addObject:errorString];
        }];

        serverErrorsString = [[serverErrorsStringsArray componentsJoinedByString:@"\n"] mutableCopy];
    }

#pragma mark Connection errors

    NSNumber *totalConnectionErrorsNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataTotalConnectionErrors] decimalValue]];

    NSString *totalConnectionErrorsValue = [totalConnectionErrorsNumber stringValue];
    BOOL atLeastOneConnectionErrorHasOccured = [totalConnectionErrorsNumber compare:[NSDecimalNumber zero]] == NSOrderedDescending;;
    
    NSString *totalConnectionErrorsKey = @"Total:";
    totalConnectionErrorsString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [totalConnectionErrorsString replaceCharactersInRange:NSMakeRange(0, totalConnectionErrorsKey.length) withString:totalConnectionErrorsKey];
    [totalConnectionErrorsString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - totalConnectionErrorsValue.length, totalConnectionErrorsValue.length) withString:totalConnectionErrorsValue];


    if (atLeastOneConnectionErrorHasOccured) {
        NSDictionary *connectionErrorsValue = [data valueForKey:AFNetworkingMeterDataConnectionErrors];

        NSMutableArray *connectionErrorsStringsArray = [NSMutableArray array];

        [connectionErrorsValue enumerateKeysAndObjectsUsingBlock:^(NSString *NSURLErrorString, NSNumber *quantity, BOOL *stop) {
            NSString *quantityString = [quantity stringValue];

            NSMutableString *errorString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];

            [errorString replaceCharactersInRange:NSMakeRange(0, NSURLErrorString.length) withString:NSURLErrorString];
            [errorString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - quantityString.length, quantityString.length) withString:quantityString];

            [connectionErrorsStringsArray addObject:errorString];
        }];

        connectionErrorsString = [[connectionErrorsStringsArray componentsJoinedByString:@"\n"] mutableCopy];
    }

#pragma mark Aggregation of a formatted report
    
    BOOL lazyReporting = [options.allKeys containsObject:AFNetworkingMeterOptionLazyReporting];

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
    [formattedDataComponents addObject:@"\n"];

    [formattedDataComponents addObject:@"\n"];
    [formattedDataComponents addObject:@"Elapsed time for request ..................."];
    [formattedDataComponents addObject:@"\n\n"];

    [formattedDataComponents addObject:minimalElapsedTimeString];
    [formattedDataComponents addObject:@"\n"];

    [formattedDataComponents addObject:maximalElapsedTimeString];
    [formattedDataComponents addObject:@"\n"];

    if (atLeastOneImageRequestHasBeenMade || lazyReporting == NO) {
        [formattedDataComponents addObject:@"\n"];
        [formattedDataComponents addObject:@"Images ....................................."];
        [formattedDataComponents addObject:@"\n\n"];

        [formattedDataComponents addObject:imageRequestsString];
        [formattedDataComponents addObject:@"\n"];

        [formattedDataComponents addObject:imageResponsesString];
        [formattedDataComponents addObject:@"\n"];

        [formattedDataComponents addObject:imageBytesReceivedString];
        [formattedDataComponents addObject:@"\n"];
    }

    if (atLeastOneServerErrorHasOccured || lazyReporting == NO) {
        [formattedDataComponents addObject:@"\n"];
        [formattedDataComponents addObject:@"Server errors .............................."];
        [formattedDataComponents addObject:@"\n\n"];

        [formattedDataComponents addObject:totalServerErrorsString];
        [formattedDataComponents addObject:@"\n"];

        if (atLeastOneServerErrorHasOccured) {
            [formattedDataComponents addObject:serverErrorsString];
            [formattedDataComponents addObject:@"\n"];
        }
    }

    if (atLeastOneConnectionErrorHasOccured || lazyReporting == NO) {
        [formattedDataComponents addObject:@"\n"];
        [formattedDataComponents addObject:@"Connection errors (NSURLError) ............."];
        [formattedDataComponents addObject:@"\n\n"];

        [formattedDataComponents addObject:totalConnectionErrorsString];
        [formattedDataComponents addObject:@"\n"];

        if (atLeastOneConnectionErrorHasOccured) {
            [formattedDataComponents addObject:connectionErrorsString];
            [formattedDataComponents addObject:@"\n"];
        }
    }

    [formattedDataComponents addObject:@"\n"];
    [formattedDataComponents addObject:@"============================================"];
    [formattedDataComponents addObject:@"\n\n"];

    return [formattedDataComponents componentsJoinedByString:@""];
}

@end

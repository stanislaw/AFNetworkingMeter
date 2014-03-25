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

@interface AFNetworkingMeterReportGenerator ()
@property (readonly) NSDictionary *dataKeysMapping;
@end

@implementation AFNetworkingMeterReportGenerator

@synthesize dataKeysMapping = _dataKeysMapping;

- (NSString *)generateFormattedReportForData:(AFNetworkingMeterData *)data options:(NSDictionary *)options {
    BOOL includeHTTPHeadersSize = [options.allKeys containsObject:AFNetworkingMeterOptionIncludesHTTPHeadersSize];

    NSMutableArray *formattedDataComponents = [NSMutableArray array];

    NSString *stringWithLengthEqualToReportWidthAndFilledWithSpaces = NSStringFromCharacterAndLength(@" ", REPORT_WIDTH);

    NSMutableString *requestsString,
                    *responsesString,
                    *minimalElapsedTimeString,
                    *maximalElapsedTimeString,
                    *totalConnectionErrorsString,
                    *connectionErrorsString,
                    *serverErrorsString;

#pragma mark Summary

    NSDecimalNumber *requestsNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataKeyRequests] decimalValue]];
    NSDecimalNumber *responsesNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataKeyResponses] decimalValue]];

    BOOL atLeastOneRequestHasBeenMade = [requestsNumber compare:[NSDecimalNumber zero]] == NSOrderedDescending;

    NSString *requestsValue = [requestsNumber stringValue];
    NSString *responsesValue = [responsesNumber stringValue];


    NSDecimalNumber *bodyBytesSentNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataKeyBodyBytesSent] decimalValue]];
    NSDecimalNumber *bodyBytesReceivedNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataKeyBodyBytesSent] decimalValue]];

    NSDecimalNumber *bytesSentNumber = [bodyBytesSentNumber copy];
    NSDecimalNumber *bytesReceivedNumber = [bodyBytesReceivedNumber copy];

    if (includeHTTPHeadersSize) {
        NSDecimalNumber *headerBytesSentNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataKeyHeaderBytesSent] decimalValue]];
        NSDecimalNumber *headerBytesReceivedNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataKeyHeaderBytesSent] decimalValue]];

        bytesSentNumber = [bytesSentNumber decimalNumberByAdding:headerBytesSentNumber];
        bytesReceivedNumber = [bytesReceivedNumber decimalNumberByAdding:headerBytesReceivedNumber];
    }

    NSString *bytesSentValue = [bytesSentNumber stringValue];
    NSString *bytesReceivedValue = [bytesReceivedNumber stringValue];

    
    NSString *requestsKey = self.dataKeysMapping[AFNetworkingMeterDataKeyRequests];
    NSString *responsesKey = self.dataKeysMapping[AFNetworkingMeterDataKeyResponses];
    NSString *bytesSentKey = self.dataKeysMapping[AFNetworkingMeterDataKeyBytesSent];
    NSString *bytesReceivedKey = self.dataKeysMapping[AFNetworkingMeterDataKeyBytesReceived];


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


        NSString *minimalElapsedTimeKey = self.dataKeysMapping[AFNetworkingMeterDataKeyMinimalElapsedTimeForRequest];
        NSString *maximalElapsedTimeKey = self.dataKeysMapping[AFNetworkingMeterDataKeyMaximalElapsedTimeForRequest];


        NSString *minimalElapsedTimeValue = [numberFormatter stringFromNumber:[data valueForKey:AFNetworkingMeterDataKeyMinimalElapsedTimeForRequest]];
        NSString *maximalElapsedTimeValue = [numberFormatter stringFromNumber:[data valueForKey:AFNetworkingMeterDataKeyMaximalElapsedTimeForRequest]];


        minimalElapsedTimeString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
        [minimalElapsedTimeString replaceCharactersInRange:NSMakeRange(0, minimalElapsedTimeKey.length) withString:minimalElapsedTimeKey];
        [minimalElapsedTimeString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - minimalElapsedTimeValue.length, minimalElapsedTimeValue.length) withString:minimalElapsedTimeValue];


        maximalElapsedTimeString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
        [maximalElapsedTimeString replaceCharactersInRange:NSMakeRange(0, maximalElapsedTimeKey.length) withString:maximalElapsedTimeKey];
        [maximalElapsedTimeString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - maximalElapsedTimeValue.length, maximalElapsedTimeValue.length) withString:maximalElapsedTimeValue];
    }

#pragma mark Server errors

    NSDecimalNumber *totalServerErrorsNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataKeyTotalServerErrors] decimalValue]];
    NSString *totalServerErrorsValue = [totalServerErrorsNumber stringValue];
    BOOL atLeastOneServerErrorHasOccured = [totalServerErrorsNumber compare:[NSDecimalNumber zero]] == NSOrderedDescending;


    NSString *totalServerErrorsKey = self.dataKeysMapping[AFNetworkingMeterDataKeyTotalServerErrors];
    NSMutableString *totalServerErrorsString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [totalServerErrorsString replaceCharactersInRange:NSMakeRange(0, totalServerErrorsKey.length) withString:totalServerErrorsKey];
    [totalServerErrorsString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - totalServerErrorsValue.length, totalServerErrorsValue.length) withString:totalServerErrorsValue];


    if (atLeastOneServerErrorHasOccured) {
        NSDictionary *serverErrorsValue = [data valueForKey:AFNetworkingMeterDataKeyServerErrors];

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

    NSNumber *totalConnectionErrorsNumber = [NSDecimalNumber decimalNumberWithDecimal:[[data valueForKey:AFNetworkingMeterDataKeyTotalConnectionErrors] decimalValue]];

    NSString *totalConnectionErrorsValue = [totalConnectionErrorsNumber stringValue];
    BOOL atLeastOneConnectionErrorHasOccured = [totalConnectionErrorsNumber compare:[NSDecimalNumber zero]] == NSOrderedDescending;;
    
    NSString *totalConnectionErrorsKey = self.dataKeysMapping[AFNetworkingMeterDataKeyTotalConnectionErrors];
    totalConnectionErrorsString = [stringWithLengthEqualToReportWidthAndFilledWithSpaces mutableCopy];
    [totalConnectionErrorsString replaceCharactersInRange:NSMakeRange(0, totalConnectionErrorsKey.length) withString:totalConnectionErrorsKey];
    [totalConnectionErrorsString replaceCharactersInRange:NSMakeRange(REPORT_WIDTH - totalConnectionErrorsValue.length, totalConnectionErrorsValue.length) withString:totalConnectionErrorsValue];


    if (atLeastOneConnectionErrorHasOccured) {
        NSDictionary *connectionErrorsValue = [data valueForKey:AFNetworkingMeterDataKeyConnectionErrors];

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

    if (atLeastOneRequestHasBeenMade) {
        [formattedDataComponents addObject:@"\n"];
        [formattedDataComponents addObject:@"Elapsed time for request ..................."];
        [formattedDataComponents addObject:@"\n\n"];

        [formattedDataComponents addObject:minimalElapsedTimeString];
        [formattedDataComponents addObject:@"\n"];

        [formattedDataComponents addObject:maximalElapsedTimeString];
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

- (NSDictionary *)dataKeysMapping {
    if (_dataKeysMapping == nil) {
        _dataKeysMapping = @{
            AFNetworkingMeterDataKeyRequests  : @"Requests:",
            AFNetworkingMeterDataKeyResponses : @"Responses:",

            AFNetworkingMeterDataKeyBytesReceived : @"Received (bytes):",
            AFNetworkingMeterDataKeyBytesSent :     @"Sent (bytes):",

            AFNetworkingMeterDataKeyMinimalElapsedTimeForRequest : @"Min (seconds):",
            AFNetworkingMeterDataKeyMaximalElapsedTimeForRequest : @"Max (seconds):",

            AFNetworkingMeterDataKeyTotalServerErrors : @"Total:",

            AFNetworkingMeterDataKeyTotalConnectionErrors : @"Total:",

            AFNetworkingMeterDataKeyImageRequests      : @"Requests:",
            AFNetworkingMeterDataKeyImageResponses     : @"Responses:",
            AFNetworkingMeterDataKeyImageBytesReceived : @"Data received (bytes):"
        };
    }

    return _dataKeysMapping;
}

@end

//
//  AFNetworkingMeterReportGenerator.m
//  AFNetworkingMeterApp
//
//  Created by Stanislaw Pankevich on 9/9/13.
//  Copyright (c) 2013 Stanislaw Pankevich. All rights reserved.
//

#import "AFNetworkingMeterReportGenerator.h"
#import "AFNetworkingMeterConstants.h"

@implementation AFNetworkingMeterReportGenerator

- (NSString *)formattedReportForData:(AFNetworkingMeterData *)data {
    NSMutableArray *formattedDataComponents = [NSMutableArray array];

    NSString *title = @"\n\nAFNetworkingMeter\n=================";
    [formattedDataComponents addObject:title];

    NSNumber *requests = [data valueForKey:AFNetworkingMeterDataRequests];
    NSString *requestsString = [NSString stringWithFormat:@"Requests: %@", requests];
    [formattedDataComponents addObject:requestsString];

    NSNumber *responses = [data valueForKey:AFNetworkingMeterDataResponses];
    NSString *responsesString = [NSString stringWithFormat:@"Responses: %@", responses];
    [formattedDataComponents addObject:responsesString];

    NSNumber *bytesSent = [data valueForKey:AFNetworkingMeterDataBytesSent];
    NSString *bytesSentString = [NSString stringWithFormat:@"Sent (bytes): %@", bytesSent];
    [formattedDataComponents addObject:bytesSentString];

    NSNumber *bytesReceived = [data valueForKey:AFNetworkingMeterDataBytesReceived];
    NSString *bytesReceivedString = [NSString stringWithFormat:@"Received (bytes): %@", bytesReceived];
    [formattedDataComponents addObject:bytesReceivedString];

    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.minimumFractionDigits = 0;
    numberFormatter.maximumFractionDigits = 7;
    numberFormatter.minimumIntegerDigits = 1;

    NSNumber *minimalElapsedTime = [data valueForKey:AFNetworkingMeterDataMinimalElapsedTimeForRequest];
    NSString *minimalElapsedTimeString = [NSString stringWithFormat:@"Minimal elapsed time for request (seconds): %@", [numberFormatter stringFromNumber:minimalElapsedTime]];
    [formattedDataComponents addObject:minimalElapsedTimeString];

    NSNumber *maximalElapsedTime = [data valueForKey:AFNetworkingMeterDataMaximalElapsedTimeForRequest];
    NSString *maximalElapsedTimeString = [NSString stringWithFormat:@"Maximal elapsed time for request (seconds): %@", [numberFormatter stringFromNumber:maximalElapsedTime]];
    [formattedDataComponents addObject:maximalElapsedTimeString];

    // AFImageRequestOperations
    NSNumber *imageRequests = [data valueForKey:AFNetworkingMeterDataImageRequests];
    NSString *imageRequestsString = [NSString stringWithFormat:@"Image requests: %@", imageRequests];
    [formattedDataComponents addObject:imageRequestsString];

    NSNumber *imageResponses = [data valueForKey:AFNetworkingMeterDataImageResponses];
    NSString *imageResponsesString = [NSString stringWithFormat:@"Image responses: %@", imageResponses];
    [formattedDataComponents addObject:imageResponsesString];

    NSNumber *imageBytesReceived = [data valueForKey:AFNetworkingMeterDataImageBytesReceived];
    NSString *imageBytesReceivedString = [NSString stringWithFormat:@"Image data received (bytes): %@", imageBytesReceived];
    [formattedDataComponents addObject:imageBytesReceivedString];

    // Server errors
    NSNumber *totalServerErrors = [data valueForKey:AFNetworkingMeterDataTotalServerErrors];
    NSString *totalServerErrorsString = [NSString stringWithFormat:@"Total server errors: %@", totalServerErrors];
    [formattedDataComponents addObject:totalServerErrorsString];

    NSNumber *serverErrors = [data valueForKey:AFNetworkingMeterDataServerErrors];
    NSString *serverErrorsString = [NSString stringWithFormat:@"Server errors: %@", serverErrors];
    [formattedDataComponents addObject:serverErrorsString];

    NSNumber *totalConnectionErrors = [data valueForKey:AFNetworkingMeterDataTotalConnectionErrors];
    NSString *totalConnectionErrorsString = [NSString stringWithFormat:@"Total connection errors: %@", totalConnectionErrors];
    [formattedDataComponents addObject:totalConnectionErrorsString];

    NSNumber *connectionErrors = [data valueForKey:AFNetworkingMeterDataConnectionErrors];
    NSString *connectionErrorsString = [NSString stringWithFormat:@"Connection errors: %@", connectionErrors];
    [formattedDataComponents addObject:connectionErrorsString];

    return [formattedDataComponents componentsJoinedByString:@"\n"];
}

@end

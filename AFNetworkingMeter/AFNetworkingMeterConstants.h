//
//  AFNetworkingMeterConstants.h
//  
//
//  Created by Stanislaw Pankevich on 9/9/13.
//  Copyright (c) 2013 Stanislaw Pankevich. All rights reserved.
//

#ifndef AFNetworkingMeterApp_AFNetworkingMeterConstants_h
#define AFNetworkingMeterApp_AFNetworkingMeterConstants_h

#pragma mark
#pragma mark AFNetworkingMeter options

static NSString * const AFNetworkingMeterOptionIncludesHTTPHeadersSize = @"AFNetworkingMeterOptionIncludesHTTPHeadersSize";
static NSString * const AFNetworkingMeterOptionLazyReporting = @"AFNetworkingMeterOptionLazyReporting";

#pragma mark
#pragma mark AFNetworkingMeter data

static NSString * const AFNetworkingMeterDataRequests = @"Requests";
static NSString * const AFNetworkingMeterDataResponses = @"Responses";

static NSString * const AFNetworkingMeterDataHeaderBytesReceived = @"Header data received (bytes)";
static NSString * const AFNetworkingMeterDataHeaderBytesSent = @"Header data sent (bytes)";

static NSString * const AFNetworkingMeterDataBodyBytesReceived = @"Body data received (bytes)";
static NSString * const AFNetworkingMeterDataBodyBytesSent = @"Body data sent (bytes)";

static NSString * const AFNetworkingMeterDataBytesReceived = @"Received (bytes)";
static NSString * const AFNetworkingMeterDataBytesSent = @"Sent (bytes)";


static NSString * const AFNetworkingMeterDataMinimalElapsedTimeForRequest = @"Minimal elapsed time for request (seconds)";
static NSString * const AFNetworkingMeterDataMaximalElapsedTimeForRequest = @"Maximal elapsed time for request (seconds)";


static NSString * const AFNetworkingMeterDataTotalServerErrors = @"Total server errors";
static NSString * const AFNetworkingMeterDataServerErrors = @"Server errors";

static NSString * const AFNetworkingMeterDataTotalConnectionErrors = @"Total connection errors";
static NSString * const AFNetworkingMeterDataConnectionErrors = @"Connection errors";


static NSString * const AFNetworkingMeterDataImageRequests = @"Image requests";
static NSString * const AFNetworkingMeterDataImageResponses = @"Image responses";
static NSString * const AFNetworkingMeterDataImageBytesReceived = @"Image data received (bytes)";

#pragma mark
#pragma mark RFC 2616 HTTP status codes and reason phrases

static NSDictionary * RFC2616_HTTPStatusCodesAndReasonPhrases() {
    static NSDictionary * RFC2616_HTTPStatusCodesAndReasonPhrases;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RFC2616_HTTPStatusCodesAndReasonPhrases = @{
            @(100): @"Continue",
            @(101): @"Switching Protocols",

            @(200): @"OK",
            @(201): @"Created",
            @(202): @"Accepted",
            @(203): @"Non-Authoritative Information",
            @(204): @"No Content",
            @(205): @"Reset Content",
            @(206): @"Partial Content",

            @(300): @"Multiple Choices",
            @(301): @"Moved Permanently",
            @(302): @"Found",
            @(303): @"See Other",
            @(304): @"Not Modified",
            @(305): @"Use Proxy",
            @(307): @"Temporary Redirect",

            @(400): @"Bad Request",
            @(401): @"Unauthorized",
            @(402): @"Payment Required",
            @(403): @"Forbidden",
            @(404): @"Not Found",
            @(405): @"Method Not Allowed",
            @(406): @"Not Acceptable",
            @(407): @"Proxy Authentication Required",
            @(408): @"Request Time-out",
            @(409): @"Conflict",
            @(410): @"Gone",
            @(411): @"Length Required",
            @(412): @"Precondition Failed",
            @(413): @"Request Entity Too Large",
            @(414): @"Request-URI Too Large",
            @(415): @"Unsupported Media Type",
            @(416): @"Requested range not satisfiable",
            @(417): @"Expectation Failed",

            @(500): @"Internal Server Error",
            @(501): @"Not Implemented",
            @(502): @"Bad Gateway",
            @(503): @"Service Unavailable",
            @(504): @"Gateway Time-out",
            @(505): @"HTTP Version not supported"
        };
    });

    return RFC2616_HTTPStatusCodesAndReasonPhrases;
};

#pragma mark
#pragma mark NSURLError humanized codes

#define NSStringFromMethodForEnumType(_name, _type, _components...) static inline NSString *NSStringFrom##_name(_type value) {    \
    NSArray *componentsStrings = [@(#_components) componentsSeparatedByString:@", "];    \
    \
    int N = (sizeof((_type[]){0, ##_components})/sizeof(_type) - 1);    \
    _type componentsCArray[] = { _components };    \
    \
    for (int i = 0; i < N; i++) {    \
        if (componentsCArray[i] == value) return [componentsStrings objectAtIndex:i];    \
    }    \
    \
    return nil;    \
}

NSStringFromMethodForEnumType(NSURLErrorCode,
                              NSInteger,

                              NSURLErrorCancelled,
                              NSURLErrorBadURL,
                              NSURLErrorTimedOut,
                              NSURLErrorUnsupportedURL,
                              NSURLErrorCannotFindHost,
                              NSURLErrorCannotConnectToHost,
                              NSURLErrorNetworkConnectionLost,
                              NSURLErrorDNSLookupFailed,
                              NSURLErrorHTTPTooManyRedirects,
                              NSURLErrorResourceUnavailable,
                              NSURLErrorNotConnectedToInternet,
                              NSURLErrorRedirectToNonExistentLocation,
                              NSURLErrorBadServerResponse,
                              NSURLErrorUserCancelledAuthentication,
                              NSURLErrorUserAuthenticationRequired,
                              NSURLErrorZeroByteResource,
                              NSURLErrorCannotDecodeRawData,
                              NSURLErrorCannotDecodeContentData,
                              NSURLErrorCannotParseResponse,
                              NSURLErrorFileIsDirectory,
                              NSURLErrorFileDoesNotExist,
                              NSURLErrorNoPermissionsToReadFile,
                              NSURLErrorDataLengthExceedsMaximum);

static inline NSString * NSStringFromNSURLError(NSError *error) {
    return NSStringFromNSURLErrorCode(error.code);
}

#endif

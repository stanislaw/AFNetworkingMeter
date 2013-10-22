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

static NSString * const AFNetworkingMeterDataKeyRequests = @"AFNetworkingMeterDataKeyRequests";
static NSString * const AFNetworkingMeterDataKeyResponses = @"AFNetworkingMeterDataKeyResponses";


static NSString * const AFNetworkingMeterDataKeyHeaderBytesReceived = @"AFNetworkingMeterDataKeyHeaderBytesReceived";
static NSString * const AFNetworkingMeterDataKeyHeaderBytesSent = @"AFNetworkingMeterDataKeyHeaderBytesSent";


static NSString * const AFNetworkingMeterDataKeyBodyBytesReceived = @"AFNetworkingMeterDataKeyBodyBytesReceived";
static NSString * const AFNetworkingMeterDataKeyBodyBytesSent = @"AFNetworkingMeterDataKeyBodyBytesSent";


static NSString * const AFNetworkingMeterDataKeyBytesReceived = @"AFNetworkingMeterDataKeyBytesReceived";
static NSString * const AFNetworkingMeterDataKeyBytesSent = @"AFNetworkingMeterDataKeyBytesSent";


static NSString * const AFNetworkingMeterDataKeyMinimalElapsedTimeForRequest = @"AFNetworkingMeterDataKeyMinimalElapsedTimeForRequest";
static NSString * const AFNetworkingMeterDataKeyMaximalElapsedTimeForRequest = @"AFNetworkingMeterDataKeyMaximalElapsedTimeForRequest";


static NSString * const AFNetworkingMeterDataKeyTotalServerErrors = @"AFNetworkingMeterDataKeyTotalServerErrors";
static NSString * const AFNetworkingMeterDataKeyServerErrors = @"AFNetworkingMeterDataKeyServerErrors";


static NSString * const AFNetworkingMeterDataKeyTotalConnectionErrors = @"AFNetworkingMeterDataKeyTotalConnectionErrors";
static NSString * const AFNetworkingMeterDataKeyConnectionErrors = @"AFNetworkingMeterDataKeyConnectionErrors";


static NSString * const AFNetworkingMeterDataKeyImageRequests = @"AFNetworkingMeterDataKeyImageRequests";
static NSString * const AFNetworkingMeterDataKeyImageResponses = @"AFNetworkingMeterDataKeyImageResponses";
static NSString * const AFNetworkingMeterDataKeyImageBytesReceived = @"AFNetworkingMeterDataKeyImageBytesReceived";

#pragma mark
#pragma mark RFC 2616 HTTP status codes and reason phrases

static inline NSDictionary * AFNM_RFC2616_HTTPStatusCodesAndReasonPhrases() {
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

// https://github.com/stanislaw/FoundationExtensions/blob/master/FoundationExtensions/NSObjCRuntime.h
#define AFNM_NSStringFromMethodForEnumType(_name, _type, _components...) static inline NSString *AFNM_NSStringFrom##_name(_type value) {    \
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

AFNM_NSStringFromMethodForEnumType(NSURLErrorCode,
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

static inline NSString * AFNM_NSStringFromNSURLError(NSError *error) {
    return AFNM_NSStringFromNSURLErrorCode(error.code);
}

#endif

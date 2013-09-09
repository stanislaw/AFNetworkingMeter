//
//  AFNetworkingMeterAppTests.m
//  AFNetworkingMeterAppTests
//
//  Created by Stanislaw Pankevich on 8/21/13.
//  Copyright (c) 2013 Stanislaw Pankevich. All rights reserved.
//

#import "TestHelpers.h"

#import "AFNetworkingMeter.h"

#import <AFNetworking/AFHTTPRequestOperation.h>
#import <AFNetworking/AFImageRequestOperation.h>

SPEC_BEGIN(AFNetworkingMeterAppSpec)

describe(@"...", ^{
    beforeAll(^{
        [[AFNetworkingMeter sharedMeter] startMeter];
    });

    afterAll(^{
        NSLog(@"AFNetworkingMeter.data: %@", [AFNetworkingMeter sharedMeter].formattedReport);
    });
    
    afterEach(^{
        [OHHTTPStubs removeAllRequestHandlers];
    });
    
    it (@"200 OK", ^{
        NSDictionary *dictionary = @{ @"KEY": @"VALUE" };
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithData:[dictionary JSONData] statusCode:200 responseTime:0 headers:nil];
        }];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"www.foo.bar"]];
        urlRequest.HTTPBody = [dictionary JSONData];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSLog(@"Received data: %@", [operation.responseData objectFromJSONData]);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            abort();
        }];

        [requestOperation start];

        runLoopIfNeeded();
    });

    it (@"404 Not Found", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithData:nil statusCode:404 responseTime:0 headers:nil];
        }];

        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"www.foo.bar"]];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];

        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];

        [requestOperation start];
        
        runLoopIfNeeded();
    });

    it (@"NSURLErrorNotConnectedToInternet 1009", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
            return [OHHTTPStubsResponse responseWithError:error];
        }];

        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"www.foo.bar"]];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];

        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];

        [requestOperation start];

        runLoopIfNeeded();
    });

    it (@"AFImageRequestOperation", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFile:@"apple.jpg" contentType:@"image/jpeg" responseTime:0];
        }];

        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"www.foo.bar/apple.jpg"]];
        AFImageRequestOperation *requestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:urlRequest imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSAssert(nil, nil);
        }];

        [requestOperation start];

        runLoopIfNeeded();
    });
});

SPEC_END

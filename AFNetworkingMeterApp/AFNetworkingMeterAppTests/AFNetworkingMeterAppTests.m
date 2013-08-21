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

SPEC_BEGIN(AFNetworkingMeterAppSpec)

describe(@"...", ^{
    beforeAll(^{
        [[AFNetworkingMeter sharedMeter] startMeter];
    });

    afterAll(^{
        NSLog(@"AFNetworkingMeter.data: %@", [AFNetworkingMeter sharedMeter].data.collectedData);
    });
    
    afterEach(^{
        [OHHTTPStubs removeAllRequestHandlers];
    });
    
    it (@"200 OK", ^{
        NSDictionary *responseDictionary = @{ @"KEY": @"VALUE" };
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithData:[responseDictionary JSONData] statusCode:200 responseTime:0 headers:nil];
        }];
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"www.foo.bar"]];
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
});

SPEC_END

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
        [OHHTTPStubs removeAllStubs];
    });
    
    it (@"200 OK", ^{
        NSDictionary *dictionary = @{ @"KEY": @"VALUE" };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];

        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithData:jsonData statusCode:200 headers:nil];
        }];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"www.foo.bar"]];
        urlRequest.HTTPBody = [jsonData copy];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

            id object = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            NSLog(@"Received data: %@", object);

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
            return [OHHTTPStubsResponse responseWithData:nil statusCode:404 headers:nil];
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
            NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"apple" ofType:@"jpg"];

            assert(imagePath != nil);

            return [OHHTTPStubsResponse responseWithFileAtPath:imagePath statusCode:200 headers:nil];
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

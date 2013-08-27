#import "AFNetworkingMeter.h"

#import <AFNetworking/AFHTTPRequestOperation.h>
#import <AFNetworking/AFImageRequestOperation.h>

#import "AFHTTPRequestOperation+StartDate.h"

extern void * AFNMHTTPRequestOperationStartDate;

#import <objc/runtime.h>

#if !__has_feature(objc_arc)
#error AFNetworkingMeter must be built with ARC.
// You can turn on ARC for only AFNetworkingMeter files by adding -fobjc-arc to the build phase for each of its files.
#endif

@implementation AFNetworkingMeter

+ (AFNetworkingMeter *)sharedMeter {
    static AFNetworkingMeter *_sharedMeter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMeter = [[self alloc] init];
    });
    
    return _sharedMeter;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.data = [[AFNetworkingMeterData alloc] init];
    
    return self;
}

- (void)dealloc {
    [self stopMeter];
}

- (void)startMeter {
    [self stopMeter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HTTPOperationDidStart:) name:AFNetworkingOperationDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HTTPOperationDidFinish:) name:AFNetworkingOperationDidFinishNotification object:nil];
}

- (void)stopMeter {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification

- (void)HTTPOperationDidStart:(NSNotification *)notification {
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[notification object];
    
    if ([operation isKindOfClass:[AFHTTPRequestOperation class]] == NO) {
        return;
    }
        
    if (self.filterPredicate && [self.filterPredicate evaluateWithObject:operation]) {
        return;
    }

    [operation setAFNMStartDate:[NSDate date]];

    if ([operation isKindOfClass:[AFImageRequestOperation class]]) {
        [self.data collectRequestDataFromAFImageRequestOperation:(AFImageRequestOperation *)operation];
    } else {
        [self.data collectRequestDataFromAFHTTPRequestOperation:operation];
    }
}

- (void)HTTPOperationDidFinish:(NSNotification *)notification {
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[notification object];

    if ([operation isKindOfClass:[AFHTTPRequestOperation class]] == NO) {
        return;
    }

    if (self.filterPredicate && [self.filterPredicate evaluateWithObject:operation]) {
        return;
    }

    if ([operation isKindOfClass:[AFImageRequestOperation class]]) {
        [self.data collectResponseDataFromAFImageRequestOperation:(AFImageRequestOperation *)operation];
    } else {
        [self.data collectResponseDataFromAFHTTPRequestOperation:operation];
    }
}

@end

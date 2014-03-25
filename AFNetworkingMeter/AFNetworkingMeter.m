#import "AFNetworkingMeter.h"
#import "AFNetworkingMeterReportGenerator.h"
#import "AFNetworkingMeterConstants.h"

#import <AFNetworking/AFHTTPRequestOperation.h>

#import "AFHTTPRequestOperation+AFNM.h"

extern void * AFNMHTTPRequestOperationStartDate;

#import <objc/runtime.h>

#if !__has_feature(objc_arc)
#error AFNetworkingMeter must be built with ARC.
// You can turn on ARC for only AFNetworkingMeter files by adding -fobjc-arc to the build phase for each of its files.
#endif

@interface AFNetworkingMeter ()
@property (strong, nonatomic) AFNetworkingMeterReportGenerator *reportGenerator;
@end

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

    if (self == nil) return nil;

    self.data = [[AFNetworkingMeterData alloc] init];

    self.includesHTTPHeadersSize = YES;
    self.lazyReporting = NO;
    
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

- (AFNetworkingMeterReportGenerator *)reportGenerator {
    if (_reportGenerator == nil) {
        _reportGenerator = [[AFNetworkingMeterReportGenerator alloc] init];
    }

    return _reportGenerator;
}

- (NSString *)formattedReport {
    NSMutableDictionary *reportOptions = [NSMutableDictionary dictionary];

    if (self.includesHTTPHeadersSize) {
        [reportOptions setValue:@(YES) forKey:AFNetworkingMeterOptionIncludesHTTPHeadersSize];
    }

    if (self.lazyReporting) {
        [reportOptions setValue:@(YES) forKey:AFNetworkingMeterOptionLazyReporting];
    }

    NSString *formattedReport = [self.reportGenerator generateFormattedReportForData:self.data options:reportOptions];

    return formattedReport;
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

    [self.data collectRequestDataFromAFHTTPRequestOperation:operation];
}

- (void)HTTPOperationDidFinish:(NSNotification *)notification {
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[notification object];

    if ([operation isKindOfClass:[AFHTTPRequestOperation class]] == NO) {
        return;
    }

    if (self.filterPredicate && [self.filterPredicate evaluateWithObject:operation]) {
        return;
    }

    [self.data collectResponseDataFromAFHTTPRequestOperation:operation];
}

@end

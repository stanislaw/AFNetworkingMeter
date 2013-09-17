#import <Foundation/Foundation.h>

#import "AFNetworkingMeterData.h"

@interface AFNetworkingMeter : NSObject

@property (nonatomic, strong) AFNetworkingMeterData *data;
@property (nonatomic, strong) NSPredicate *filterPredicate;

+ (AFNetworkingMeter *)sharedMeter;

- (void)startMeter;
- (void)stopMeter;

@property BOOL lazyReporting;
@property BOOL includesHTTPHeadersSize;

// TODO
// @property BOOL includesImageTrafficIntoOverallTraffic;

@property (readonly) NSString *formattedReport;

@end

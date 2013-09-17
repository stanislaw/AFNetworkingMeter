//
//  AFNetworkingMeterReportGenerator.h
//  AFNetworkingMeterApp
//
//  Created by Stanislaw Pankevich on 9/9/13.
//  Copyright (c) 2013 Stanislaw Pankevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkingMeterData.h"

@interface AFNetworkingMeterReportGenerator : NSObject

- (NSString *)generateFormattedReportForData:(AFNetworkingMeterData *)data options:(NSDictionary *)options;

@end

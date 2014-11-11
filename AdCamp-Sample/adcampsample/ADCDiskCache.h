//
//  ADCDiskCache.h
//  visdk
//
//  Created by Mikhail on 19.07.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^events_block_t)(NSArray *events);
typedef void (^cached_data_block_t)(NSData *data);

@class AdEvent;
@interface ADCDiskCache : NSObject

- (void)getAllEventsWithCallback:(events_block_t)block;
- (void)deleteEvents:(NSArray *)events;
- (void)trackEvent:(AdEvent *)event;

- (void)storeResponse:(NSData *)dataToCache forKey:(NSString *)key;
- (void)getResponseDataForKey:(NSString *)key withCallback:(cached_data_block_t)block;

@end

//
//  JSONable.h
//  adcampsdk
//
//  Created by Mikhail on 10.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONable <NSObject>

@required

- (NSDictionary *)JSONDictionary;


@optional

- (id)initWithDictionary:(NSDictionary *)obj;

- (NSData *)JSONData;
- (NSString *)JSONString;

@end
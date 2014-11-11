//
//  ADCAdsManager_Internal.h
//  adcampsdk
//
//  Created by Mikhail on 24.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import <ADCampSDK/ADCAdsManager.h>

#import "ADCDiskCache.h"

// https://tracker.setup-team.net/projects/adcamp/wiki/%D0%9E%D1%82%D0%BB%D0%B0%D0%B4%D0%BE%D1%87%D0%BD%D1%8B%D0%B9_%D1%80%D0%B5%D0%B6%D0%B8%D0%BC_%D0%B4%D0%BB%D1%8F_%D1%80%D0%B0%D0%B7%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%87%D0%B8%D0%BA%D0%BE%D0%B2
#define TEST_CLICKER_URL @"http://tst.adcamp.ru/auth/put/"
#define TEST_RTB_REQUEST_URL @"http://tst.adcamp.ru/auth/get/"
#define PROD_CLICKER_URL @"https://rtb.adcamp.ru/auth/put/"
#define PROD_RTB_REQUEST_URL @"https://rtb.adcamp.ru/auth/get/"

@interface ADCAdsManager ()

@property (readonly) NSBundle *resourcesBundle;

- (NSURL *)clickerURL;
- (NSString *)basicAuthHeaderValue;

- (void)trackURL:(NSURL *)url withContext:(NSString *)context;
- (void)forceClickerSending;

- (NSArray *)cookies;
- (void)putCookies:(NSArray *)cookies;

- (void)storeResponse:(NSData *)dataToCache forKey:(NSString *)key;
- (void)getResponseDataForKey:(NSString *)key withCallback:(cached_data_block_t)block;

- (void)addAdIdentifier:(NSString *)identifier;
- (NSArray *)getLastAdIddentifiers;
- (NSString *)getLastAdsString;


@end

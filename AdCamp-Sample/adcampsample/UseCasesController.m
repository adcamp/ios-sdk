//
//  UseCasesController.m
//  adcampsdk
//
//  Created by Mikhail on 14.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "UseCasesController.h"

#import "SimpleBannerViewController.h"
#import "TableBannerViewController.h"

#import "ORTBBannerViewController.h"
#import "InterstitialViewController.h"
#import "InterstitialRequestViewController.h"
#import "BannerRequestViewController.h"
#import "MixedAdViewController.h"
#import "FullscreenVideoViewController.h"

#import <ADCampSDK/ADCampSDK.h>

@implementation UseCasesController {
	NSArray *_samples;
	ADCAdvertising *_interstitialBannerAd;
}

- (id)init {
    self = [super init];
    if (self) {
		[self recreateSamples];
		self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
			self.edgesForExtendedLayout = UIRectEdgeNone;
		}
    }
    return self;
}

- (void)recreateSamples {
	_samples = @[
                 @{
                     @"section":@"Баннеры",
                     @"rows":@[
                             @{@"title": @"Статичный баннер", @"subtitle": @"Размещение баннера внизу контента", @"method":@"sampleSimple"},
                             @{@"title": @"Баннер в таблице", @"subtitle": @"Размещение баннера в таблице", @"method":@"sampleTable"},
                             @{@"title": @"Полноэкранный баннер", @"subtitle": @"Показ полноэкранной рекламы по факту её загрузки", @"method":@"sampleInterstitial"},
                             @{@"title": @"Полноэкранный баннер (предзагрузка)", @"subtitle": @"Показ полноэкранной рекламы перед очередным экраном. Реклама закеширована заранее", @"method":@"samplePreloadedInterstitial"},
                             @{@"title": @"Параметры OpenRTB", @"subtitle": @"Загрузка баннера с указанием дополнительных параметров OpenRTB", @"method":@"sampleOpenRTBBanner"},

                             @{@"title": @"Ротация баннера", @"subtitle": @"Демонстрация сменяющегося баннера. Период смены 15 секунд", @"method":@"sampleRotationBanner"}
                             ]},
                 @{
                     @"section":@"Видеореклама",
                     @"rows":@[
                             @{@"title": @"Полноэкранный видеоролик", @"subtitle": @"Показывается ранее полученный ролик", @"method":@"sampleVideoInterstitial"}
                             ]},
                 @{
                     @"section":@"Смешанная реклама",
                     @"rows":@[
                             @{@"title": @"Универсальный баннер", @"subtitle": @"Показ видео или баннера в зависимости от ответа сервера", @"method":@"mixedAd"},
                             ]}
                 ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _interstitialBannerAd = nil;
    ADCRequest *bannerRequest = [ADCRequest fullscreenBannerRequestWithPlacementID:@"393058cf-ea48-4ccb-8a05-d4fca4022f25"];
    bannerRequest.delegate = self;
    [bannerRequest run];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [_samples count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[_samples objectAtIndex:section] objectForKey:@"rows"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[_samples objectAtIndex:section] objectForKey:@"section"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.detailTextLabel.numberOfLines = 0;
		cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
	}
	NSDictionary *sample = [[[_samples objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row];
	cell.textLabel.text = sample[@"title"];
	cell.detailTextLabel.text = sample[@"subtitle"];
	[cell.detailTextLabel sizeToFit];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *methodName = [[[[_samples objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row] objectForKey:@"method"];
	SEL sampleMethod = NSSelectorFromString(methodName);
	if (sampleMethod) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[self performSelector:sampleMethod];
#pragma clang diagnostic pop
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAll;
}

#pragma mark - samples


// banner

- (void)sampleSimple {
    UIViewController *controller = [[SimpleBannerViewController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)sampleTable {
    UIViewController *controller = [[TableBannerViewController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)sampleInterstitial {
    UIViewController *controller = [[InterstitialRequestViewController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)samplePreloadedInterstitial {
    if ([_interstitialBannerAd isCached]) {
        UIViewController *controller = [[InterstitialViewController alloc] initWithAd:_interstitialBannerAd];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Полноэкранная реклама ещё не загружена" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)sampleOpenRTBBanner {
	UIViewController *controller = [[ORTBBannerViewController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)sampleRotationBanner {
	UIViewController *controller = [[BannerRequestViewController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}

// mixed

- (void)mixedAd {
	UIViewController *controller = [[MixedAdViewController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}


//video

- (void)sampleVideoInterstitial {
    UIViewController *controller = [[FullscreenVideoViewController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 

- (void)advertisingCachingFailed:(ADCAdvertising *)ad {
    _interstitialBannerAd = nil;
	NSLog(@"%@ caching failed", ad);
}

- (void)advertisingCached:(ADCAdvertising *)ad {
	NSLog(@"%@ cached", ad);
    _interstitialBannerAd = ad;
    [self.tableView reloadData];
}

- (void)advertising:(ADCAdvertising *)ad progressChanged:(double)progress {
//	NSLog(@"%@ caching progress changed %.2f%%", ad, progress * 100);
}

#pragma mark - ADCRequestDelegate

- (void)request:(ADCRequest *)request didReceiveBanner:(ADCAdvertising *)banner {
    NSLog(@"%@ received", banner);
    _interstitialBannerAd = banner;
    _interstitialBannerAd.delegate = self;
    [_interstitialBannerAd preload];
}

@end

//
//  UseCasesController.m
//  adcampsdk
//
//  Created by Mikhail on 14.06.13.
//  Copyright (c) 2013 Sebbia. All rights reserved.
//

#import "UseCasesController.h"

#import "SimpleBannerViewController.h"
#import "InterstitialRequestViewController.h"

@implementation UseCasesController {
	NSArray *_samples;
	ADCInterstitialViewController *_interstitialBannerAd;
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
                             @{@"title": @"Полноэкранный баннер", @"subtitle": @"Показ полноэкранной рекламы по факту её загрузки", @"method":@"sampleInterstitial"},
                           
                             ]},
                 ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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


- (void)sampleInterstitial {
    UIViewController *controller = [[InterstitialRequestViewController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}




@end

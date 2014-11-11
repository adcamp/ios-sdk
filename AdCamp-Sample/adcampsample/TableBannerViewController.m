//
//  TableBannerViewController.m
//  adcampsample
//
//  Created by Михаил Любимов on 04.07.14.
//  Copyright (c) 2014 Sebbia. All rights reserved.
//

#import "TableBannerViewController.h"

#import <ADCampSDK/ADCampSDK.h>

@interface TableBannerViewController () <ADCPlayerDelegate>

@end

@implementation TableBannerViewController {
    ADCBannerView *bannerView;
}

static CGSize bannerSize = {320, 50};
static int bannerIndex = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bannerView = [[ADCBannerView alloc] initWithFrame:CGRectMake(0, 0, bannerSize.width, bannerSize.height)];
    bannerView.delegate = self;
    bannerView.placementID = @"b7beb1fa-d12a-4528-aa5a-e53344ffc51b";
    [bannerView start];
}

- (void)dealloc {
    [bannerView finalize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 101;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    if (indexPath.row == bannerIndex) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.contentView addSubview:bannerView];
        return cell;
    } else {
        int row = (int)indexPath.row - (((int)indexPath.row > bannerIndex) ? 1 : 0);
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%d", row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == bannerIndex) {
        return bannerView.hidden ? 0 : bannerSize.height;
    }
    return bannerSize.height;
}

- (void)reloadBannerCell {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:bannerIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - ADCPlayerDelegate

- (void)player:(id<ADCPlayer>)player willStartAd:(ADCAdvertising *)ad {
    [self reloadBannerCell];
}

- (void)player:(id<ADCPlayer>)player didFinishAd:(ADCAdvertising *)ad {
    [self reloadBannerCell];
}

@end

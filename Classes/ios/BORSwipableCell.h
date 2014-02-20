//
// Created by Bohdan Orlov on 2/19/14.
// Copyright (c) 2014 BOrlov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BORSwipableView.h"

@interface BORSwipableCell : UITableViewCell <BORSwipableView>//Notice that all protocol messages forwarded to swipableView
@property (nonatomic, strong, readonly) BORSwipableView *swipableView;
@end
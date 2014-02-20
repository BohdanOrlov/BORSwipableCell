//
//  BORViewController.h
//  BORSwipableCellExample
//
//  Created by Bohdan Orlov on 2/18/14.
//  Copyright (c) 2014 BOrlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BORSwipableView;

@interface BORViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet BORSwipableView *swipableView;

@end

//
//  BORViewController.m
//  BORSwipableCellExample
//
//  Created by Bohdan Orlov on 2/18/14.
//  Copyright (c) 2014 BOrlov. All rights reserved.
//

#import "BORViewController.h"
#import "BORSwipableView.h"
#import "BORSwipableCell.h"

static NSString *const swipableCellIdentifier = @"fancyCell";

@interface BORViewController ()

@end

@implementation BORViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *leftHiddenView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, self.swipableView.frame.size.height)];
    leftHiddenView.backgroundColor = [UIColor redColor];
    leftHiddenView.text = @"Hi";
    leftHiddenView.textAlignment = NSTextAlignmentCenter;
    UILabel *rightHiddenView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, self.swipableView.frame.size.height)];
    rightHiddenView.backgroundColor = [UIColor blueColor];
    rightHiddenView.text = @"Hello";
    rightHiddenView.textAlignment = NSTextAlignmentCenter;

    self.swipableView.leftHiddenView = leftHiddenView;
    self.swipableView.rightHiddenView = rightHiddenView;
    self.swipableView.swipableDirections = BORSwipableViewSwipeDirectionBoth;
    self.swipableView.contentView.backgroundColor = [UIColor yellowColor];
    self.swipableView.backgroundColor = [UIColor greenColor];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableView protocols

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BORSwipableCell *cell = [tableView dequeueReusableCellWithIdentifier:swipableCellIdentifier forIndexPath:indexPath];

    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    leftButton.backgroundColor = [UIColor redColor];
    [leftButton setTitle:@"Decline" forState:UIControlStateNormal];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];
    rightButton.backgroundColor = [UIColor greenColor];
    [rightButton setTitle:@"Accept" forState:UIControlStateNormal];

    [cell setButton:leftButton asHiddenViewAtPosition:BORSwipableViewHiddenViewPositionLeft blockAction:^(id <BORSwipableView> buttonOwnerView, UIButton *button) {
        NSLog(@"Declined");
    }];
    [cell setButton:rightButton asHiddenViewAtPosition:BORSwipableViewHiddenViewPositionRight blockAction:^(id <BORSwipableView> buttonOwnerView, UIButton *button) {
        NSLog(@"Accepted");
    }];

    cell.swipableDirections = BORSwipableViewSwipeDirectionBoth;

    return cell;
}


@end

# BORSwipableCell

[![Version](http://cocoapod-badges.herokuapp.com/v/BORSwipableCell/badge.png)](http://cocoadocs.org/docsets/BORSwipableCell)
[![Platform](http://cocoapod-badges.herokuapp.com/p/BORSwipableCell/badge.png)](http://cocoadocs.org/docsets/BORSwipableCell)

A custom `UITableViewCell` and 'UIView' that supports cell dragging gesture to reveal a custom views or buttons in left and right parts of cell.

![image](http://s11.postimg.org/9z82zvrk3/Swipable_Cell.gif)


## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

1. If you're using Interface Builder, define the `Custom Class` of the cell as `BORSwipableCell`. If you're going by code, register `BORSwipableCell` with your `UITableView`.
2. Implement the `tableView:cellForRowAtIndexPath` method and configure the cell as desired:

```objective-c
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
```

## Requirements

## Installation

BORSwipableCell is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "BORSwipableCell"

## Author

BohdanOrlov, Bohdan.Orlov@gmail.com

## License

BORSwipableCell is available under the MIT license. See the LICENSE file for more info.


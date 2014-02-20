//
// Created by Bohdan Orlov on 2/19/14.
// Copyright (c) 2014 BOrlov. All rights reserved.
//

#import "BORSwipableCell.h"

@interface BORSwipableCell () <BORSwipableViewDelegate>
@end

@implementation BORSwipableCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [self makeCellSwipable];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self makeCellSwipable];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.swipableView moveSubviewsToContentViewFromSourceView:self.contentView];
}

#pragma mark - Public

- (void)makeCellSwipable {
    _swipableView = [BORSwipableView swipableViewWithFrame:self.contentView.frame];
    self.swipableView.buttonsOwnerView = self;
    [self.swipableView moveSubviewsToContentViewFromSourceView:self.contentView];
    [self.swipableView copyContentViewPropertiesFromView:self.contentView];
    self.swipableView.delegate = self;
    [self.contentView addSubview:self.swipableView];

}

#pragma mark - Private

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected)
        [self.swipableView coverHiddenViews];
}

#pragma mark BORSWipableViewDelegate
- (void)swipeDidBeganOnSwipeView:(BORSwipableView *)swipeView {
    [self setSelected:NO animated:NO];
}

#pragma mark MessageForwarding
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.swipableView respondsToSelector:aSelector]) {
        return self.swipableView;
    }
    return nil;
}
@end
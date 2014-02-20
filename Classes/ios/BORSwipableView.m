//
//  BORSwipableView.m
//  BORSwipableCellExample
//
//  Created by Bohdan Orlov on 2/18/14.
//  Copyright (c) 2014 BOrlov. All rights reserved.
//

#import "BORSwipableView.h"
#import <objc/runtime.h>


@interface BORSwipableView ()
@property (nonatomic) CGFloat leftSwipeOffsetLimit;
@property (nonatomic) CGFloat rightSwipeOffsetLimit;
@property (nonatomic) enum BORSwipableViewSwipeDirections lastSwipeDirection;
@end

@implementation BORSwipableView
@synthesize swipableDirections = _swipableDirections;
@synthesize contentView = _contentView;
@synthesize leftHiddenView = _leftHiddenView;
@synthesize rightHiddenView = _rightHiddenView;
@synthesize leftBlockAction = _leftBlockAction;
@synthesize rightBlockAction = _rightBlockAction;


#pragma mark - Convenience constructors

+ (instancetype)swipableViewWithFrame:(CGRect)rect {
    return [self swipableViewWithFrame:rect leftHiddenView:nil rightHiddenView:nil swipeDirections:BORSwipableViewSwipeDirectionNone];
}

+ (instancetype)swipableViewWithFrame:(CGRect)frame leftHiddenView:(UIView *)leftHiddenView rightHiddenView:(UIView *)rightHiddenView swipeDirections:(enum BORSwipableViewSwipeDirections)directions {
    BORSwipableView *swipableView = [[self alloc] initWithFrame:frame];
    if (!swipableView)
        return nil;


    swipableView.leftHiddenView = leftHiddenView;
    swipableView.rightHiddenView = rightHiddenView;
    swipableView.contentView = [[UIView alloc] initWithFrame:swipableView.bounds];

    swipableView.swipableDirections = directions;

    return swipableView;
}

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [self initialize];
}

- (void)initialize {
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.swipeVelocityThreshold = 500.0f;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initialize];
    return self;
}

- (void)layoutSubviews {
    [self moveSubviewsToContentViewFromSourceView:self];
}



#pragma mark - Custom Accessors

- (void)setContentView:(UIView *)contentView {
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [self.contentView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
    [self addSubview:contentView];
}

- (void)setLeftHiddenView:(UIView *)leftHiddenView {
    [_leftHiddenView removeFromSuperview];

    _leftHiddenView = leftHiddenView;
    CGRect frame = leftHiddenView.frame;
    frame.origin = CGPointZero;
    leftHiddenView.frame = frame;
    [self insertSubview:leftHiddenView belowSubview:self.contentView];

    self.rightSwipeOffsetLimit = frame.size.width;
}

- (void)setRightHiddenView:(UIView *)rightHiddenView {
    [_rightHiddenView removeFromSuperview];

    _rightHiddenView = rightHiddenView;
    CGRect frame = rightHiddenView.frame;
    frame.origin = CGPointMake(self.frame.size.width - frame.size.width, 0);
    rightHiddenView.frame = frame;
    [self insertSubview:rightHiddenView belowSubview:self.contentView];

    self.leftSwipeOffsetLimit = rightHiddenView.frame.size.width;
}

- (id <BORSwipableView>)buttonsOwnerView {
    if (_buttonsOwnerView)
        return _buttonsOwnerView;
    return self;
}

#pragma mark - Public

- (void)copyContentViewPropertiesFromView:(UIView *)view {
    self.contentView.frame = view.frame;
    self.contentView.backgroundColor = view.backgroundColor;
}

- (void)moveSubviewsToContentViewFromSourceView:(UIView *)sourceView {
    NSArray *constraints = [sourceView constraints];

    NSMutableArray *newConstraints = [NSMutableArray array];

    for (UIView *view in sourceView.subviews) {
        if (view == self || view == self.contentView || view == self.leftHiddenView || view == self.rightHiddenView) {
            continue;
        }

        for (NSLayoutConstraint *constraint in constraints) {

            UIView *firstItem = (UIView *) constraint.firstItem;
            UIView *secondItem = (UIView *) constraint.secondItem;

            //if view was added without attributes it generates constraint without second item, probably useless
            if (!firstItem || !secondItem)
                continue;

            if (firstItem == sourceView) {
                firstItem = self.contentView;
            }

            if (secondItem == sourceView) {
                secondItem = self.contentView;
            }

            NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                             attribute:constraint.firstAttribute
                                                                             relatedBy:constraint.relation
                                                                                toItem:secondItem
                                                                             attribute:constraint.secondAttribute
                                                                            multiplier:constraint.multiplier
                                                                              constant:constraint.constant];
            newConstraint.priority = constraint.priority;
            [newConstraints addObject:newConstraint];
        }

        [view removeFromSuperview];
        [self.contentView addSubview:view];

    }

    if (newConstraints.count) {
        [self.contentView addConstraints:newConstraints];
    }
}

- (void)setButton:(UIButton *)button asHiddenViewAtPosition:(enum BORSwipableViewHiddenViewPosition)borSwipableViewHiddenView blockAction:(void (^)(id <BORSwipableView>, UIButton *))action {
    if (borSwipableViewHiddenView & BORSwipableViewHiddenViewPositionLeft) {
        self.leftHiddenView = button;
        self.leftBlockAction = action;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    } else if (borSwipableViewHiddenView & BORSwipableViewHiddenViewPositionRight) {
        self.rightHiddenView = button;
        self.rightBlockAction = action;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)coverHiddenViews {
    [self changeContentViewOriginX:0 animated:YES completion:^(BOOL finished) {
        self.leftHiddenView.hidden = YES;
        self.rightHiddenView.hidden = YES;
    }];

    self.isHiddenViewRevealed = NO;
}

- (void)revealRightHiddenView {
    [self changeContentViewOriginX:-self.leftSwipeOffsetLimit animated:YES completion:^(BOOL finished) {
    }];
    self.isHiddenViewRevealed = YES;
}

- (void)revealLeftHiddenView {
    [self changeContentViewOriginX:self.rightSwipeOffsetLimit animated:YES completion:^(BOOL finished) {
    }];
    self.isHiddenViewRevealed = YES;
}


#pragma mark - Private

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    UIView *contentView = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [recognizer setTranslation:contentView.frame.origin inView:contentView];
        self.leftHiddenView.hidden = NO;
        self.rightHiddenView.hidden = NO;
        self.lastSwipeDirection = BORSwipableViewSwipeDirectionNone;
        id <BORSwipableViewDelegate> o = self.delegate;
        if ([o respondsToSelector:@selector(swipeDidBeganOnSwipeView:)]) {
            [o swipeDidBeganOnSwipeView:self];
        }
    }


    CGFloat translationX = [recognizer translationInView:contentView].x;


    if (translationX > 0 && self.leftHiddenView && self.swipableDirections & BORSwipableViewSwipeDirectionRight) {
        [self changeContentViewOriginX:MIN(translationX, self.rightSwipeOffsetLimit) animated:NO completion:^(BOOL finished) {
        }];
    } else if (translationX < 0 && self.rightHiddenView && self.swipableDirections & BORSwipableViewSwipeDirectionLeft) {
        [self changeContentViewOriginX:MAX(translationX, -self.leftSwipeOffsetLimit) animated:NO completion:^(BOOL finished) {
        }];

    }

    if (translationX > 0) {
        self.lastSwipeDirection = BORSwipableViewSwipeDirectionRight;
    }
    else {
        self.lastSwipeDirection = BORSwipableViewSwipeDirectionLeft;
    }

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self finalizeSwipeWithSwipeVelocity:[recognizer velocityInView:contentView].x];
    }

}

- (void)finalizeSwipeWithSwipeVelocity:(CGFloat)velocity {
    if (ABS(velocity) > self.swipeVelocityThreshold) {
        if (velocity > self.swipeVelocityThreshold) {
            if (self.isHiddenViewRevealed) {
                [self coverHiddenViews];
            }
            else {
                [self revealLeftHiddenView];
            }
        } else if (velocity < -self.swipeVelocityThreshold) {
            if (self.isHiddenViewRevealed) {
                [self coverHiddenViews];
            }
            else {
                [self revealRightHiddenView];
            }
        }

    }
    else if (self.lastSwipeDirection == BORSwipableViewSwipeDirectionRight) {
        if (self.contentView.frame.origin.x > self.rightSwipeOffsetLimit / 2.0) {
            [self revealLeftHiddenView];
        } else {
            [self coverHiddenViews];

        }
    } else if (self.lastSwipeDirection == BORSwipableViewSwipeDirectionLeft) {
        if (self.contentView.frame.origin.x < -self.leftSwipeOffsetLimit / 2.0) {
            [self revealRightHiddenView];
        } else {
            [self coverHiddenViews];

        }
    }
}


- (void)changeContentViewOriginX:(CGFloat)originX animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    void (^frameUpdate)() = ^{
        CGRect frame = self.contentView.frame;
        frame.origin.x = originX;
        self.contentView.frame = frame;
    };

    if (animated) {
        [UIView animateWithDuration:0.2 animations:frameUpdate completion:completion];
    } else {
        frameUpdate();
    }
}


- (void)buttonPressed:(id)buttonPressed {
    if (buttonPressed == self.leftHiddenView) {
        self.leftBlockAction(self.buttonsOwnerView, buttonPressed);
    } else if (buttonPressed == self.rightHiddenView) {
        self.rightBlockAction(self.buttonsOwnerView, buttonPressed);
    }
}

@end

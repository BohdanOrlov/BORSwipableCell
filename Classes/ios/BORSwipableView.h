//
//  BORSwipableView.h
//  BORSwipableCellExample
//
//  Created by Bohdan Orlov on 2/18/14.
//  Copyright (c) 2014 BOrlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BORSwipableView;

NS_OPTIONS(NSInteger, BORSwipableViewHiddenViewPosition){
    BORSwipableViewHiddenViewPositionNone = 1 << 0,
    BORSwipableViewHiddenViewPositionLeft = 1 << 1,
    BORSwipableViewHiddenViewPositionRight = 1 << 2,
    BORSwipableViewHiddenViewPositionBoth = ~0
};

NS_OPTIONS(NSInteger, BORSwipableViewSwipeDirections){
    BORSwipableViewSwipeDirectionNone = 1 << 0,
    BORSwipableViewSwipeDirectionLeft = 1 << 1,
    BORSwipableViewSwipeDirectionRight = 1 << 2,
    BORSwipableViewSwipeDirectionBoth = ~0
};

@protocol BORSwipableView <NSObject>
@property (nonatomic) enum BORSwipableViewSwipeDirections swipableDirections;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *leftHiddenView;
@property (nonatomic, strong) UIView *rightHiddenView;
@property (nonatomic, copy) void (^leftBlockAction)(id <BORSwipableView>, UIButton *);
@property (nonatomic, copy) void (^rightBlockAction)(id <BORSwipableView>, UIButton *);

@optional
- (void)setButton:(UIButton *)button asHiddenViewAtPosition:(enum BORSwipableViewHiddenViewPosition)position blockAction:(void (^)(id <BORSwipableView>, UIButton *))action;
@end

@protocol BORSwipableViewDelegate <NSObject>
@optional
- (void)swipeDidBeganOnSwipeView:(BORSwipableView *)swipeView;
@end

@interface BORSwipableView : UIView <BORSwipableView>
@property (nonatomic, weak) id <BORSwipableView> buttonsOwnerView; // this view or SwipableCell view(which used as container in case of tableview cells), thus you can find index path in block action.
@property (nonatomic, weak) id <BORSwipableViewDelegate> delegate;
@property (nonatomic) BOOL isHiddenViewRevealed;

@property (nonatomic) CGFloat swipeVelocityThreshold;

+ (BORSwipableView *)swipableViewWithFrame:(CGRect)rect;
+ (instancetype)swipableViewWithFrame:(CGRect)frame leftHiddenView:(UIView *)leftHiddenView rightHiddenView:(UIView *)rightHiddenView swipeDirections:(enum BORSwipableViewSwipeDirections)directions;
- (void)copyContentViewPropertiesFromView:(UIView *)view;
- (void)moveSubviewsToContentViewFromSourceView:(UIView *)sourceView;
- (void)coverHiddenViews;
- (void)revealRightHiddenView;
- (void)revealLeftHiddenView;
@end

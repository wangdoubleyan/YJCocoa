//
//  YJNavigationBar.m
//  YJNavigationBar
//
//  HomePage:https://github.com/937447974/YJCocoa
//  YJ技术支持群:557445088
//
//  Created by 阳君 on 16/7/6.
//  Copyright © 2016年 YJCocoa. All rights reserved.
//

#import "YJCNavigationBar.h"
#import "UIView+YJViewGeometry.h"

@interface YJCNavigationBar ()

@property (nonatomic, strong) UILabel *titleLabel; ///< 标题label

@end

@implementation YJCNavigationBar

#pragma mark - 共享
+ (instancetype)appearance {
    static YJCNavigationBar *nb;
    if (!nb) {
        nb = [[YJCNavigationBar alloc] initWithAppearance];
    }
    return nb;
}

- (instancetype)initWithAppearance {
    self = [super initWithFrame:CGRectZero];
    if (self) { // 默认共享
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:14];
        self.leftSpacing = 10;
        self.rightSpacing = 10;
        self.middle = YES;
    }
    return self;
}

#pragma mark - self
- (instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, 9999, 44);
    self = [super initWithFrame:frame];
    if (self) {
        YJCNavigationBar *nb = [YJCNavigationBar appearance];
        _titleColor = nb.titleColor;
        _titleFont = nb.titleFont;
        _leftSpacing = nb.leftSpacing;
        _rightSpacing = nb.rightSpacing;
        _middle = nb.middle;
        self.leftBarButtonView = [[YJCBarButtonView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        self.rightBarButtonView = [[YJCBarButtonView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat centerYFrame = self.heightFrame / 2;
    UIView *middleView = self.titleView ? self.titleView : self.titleLabel;
    // 竖直
    self.leftBarButtonView.centerYFrame = centerYFrame;
    middleView.centerYFrame = centerYFrame;
    self.rightBarButtonView.centerYFrame = centerYFrame;
    // 水平
    self.rightBarButtonView.leadingFrame = self.widthFrame - self.rightBarButtonView.widthFrame;
    if (self.middle) {
        middleView.centerXFrame = self.widthFrame / 2;
        CGFloat leftSpacing = middleView.centerXFrame - self.leftBarButtonView.trailingFrame - self.leftSpacing;
        CGFloat rightSpecing = self.rightBarButtonView.leadingFrame - middleView.centerXFrame - self.rightSpacing;
        middleView.widthFrame = leftSpacing < rightSpecing ? 2*leftSpacing : 2*rightSpecing;
        middleView.leadingFrame = (self.widthFrame - middleView.widthFrame) / 2;
    } else {
        middleView.leadingFrame = self.leftBarButtonView.trailingFrame + self.leftSpacing;
        middleView.widthFrame = self.rightBarButtonView.leadingFrame - middleView.leadingFrame - self.rightSpacing;
    }
}

#pragma mark - getter and setter
- (void)setLeftBarButtonView:(YJCBarButtonView *)leftBarButtonView {
    _leftBarButtonView = leftBarButtonView;
    [self setBarButtonView:_leftBarButtonView];
}

- (void)setRightBarButtonView:(YJCBarButtonView *)rightBarButtonView {
    _rightBarButtonView = rightBarButtonView;
    [self setBarButtonView:_rightBarButtonView];
}

- (void)setBarButtonView:(YJCBarButtonView *)barButtonView {
    if (barButtonView.superview) {
        [barButtonView removeFromSuperview];
    }
    [self addSubview:barButtonView];
    __weak YJCNavigationBar *weakSelf = self;
    barButtonView.reloadDataBlock = ^(BOOL animation) {
        [weakSelf layoutSubviews];
    };
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    [self layoutSubviews];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.heightFrame)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = self.titleColor;
        _titleLabel.font = self.titleFont;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setTitleView:(UIView *)titleView {
    if (_titleView.superview) {
        [_titleView removeFromSuperview];
    }
    _titleView = titleView;
    [self addSubview:_titleView];
    [self layoutSubviews];
}

@end


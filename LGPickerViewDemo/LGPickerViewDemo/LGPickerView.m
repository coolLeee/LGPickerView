//
//  LGPickerView.m
//  LGPickerView
//
//  Created by ligang on 2018/9/19.
//  Copyright © 2018年 xueersi. All rights reserved.
//

#import "LGPickerView.h"

static NSString * const contentOffsetPath = @"contentOffset";

@interface LGPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) NSInteger currentSelectedRow;
@property (nonatomic, strong) NSMutableArray * scrollViews;
@property (nonatomic, assign) NSInteger lg_numberOfRowsInComponent;
@property (nonatomic, strong) NSMutableArray <UIView *>* separatorLineViews;

@end

@implementation LGPickerView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config
{
    self.delegate = self;
    self.dataSource = self;
    _defaultSelectedRow = 0;
    _separatorHeight = 1;
    _separatorColor = [UIColor orangeColor];
    _separatorInset = UIEdgeInsetsZero;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    for (UIView * subView in [self lg_allSubViews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            UIScrollView * subScrollView = (UIScrollView *)subView;
            [subScrollView addObserver:self forKeyPath:contentOffsetPath
                               options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                               context:nil];
            self.startPoint = subScrollView.contentOffset;
            [self.scrollViews addObject:subScrollView];
        }
        if (subView.frame.size.height <= 1 &&
            (self.separatorColor != nil || self.separatorHeight > 0 )) {
            [self _setSeparatorLineView:subView];
        }
        if (subView.frame.size.height <= 1) { [self.separatorLineViews addObject:subView];}
    }
    [self selectRow:_defaultSelectedRow inComponent:0 animated:self.scrollingAnimation];
    [self lg_pickerView:self didScrollingRow:_defaultSelectedRow inComponent:0];
}

#pragma mark setter

- (void)setTDataSource:(id<LGPickerViewDataSource>)TDataSource
{
    _TDataSource = TDataSource;
    [self reloadAllComponents];
}

- (void)setDefaultSelectedRow:(NSInteger)defaultSelectedRow
{
    _defaultSelectedRow = defaultSelectedRow;
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    _separatorColor = separatorColor;
    [self.separatorLineViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = separatorColor;
    }];
}

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset
{
    _separatorInset = separatorInset;
    [self.separatorLineViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = obj.frame;
        frame.origin.x = separatorInset.left;
        frame.size.width = self.bounds.size.width - frame.origin.x - separatorInset.right;
        obj.frame = frame;
    }];
}

- (void)setSeparatorHeight:(CGFloat)separatorHeight
{
    _separatorHeight = separatorHeight;
    [self.separatorLineViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = obj.frame;
        frame.size.height = separatorHeight;
        obj.frame = frame;
    }];
}

- (void)_setSeparatorLineView:(UIView *)view
{
    CGRect frame = view.frame;
    view.backgroundColor = self.separatorColor;
    frame.origin.x = self.separatorInset.left;
    frame.size.height = self.separatorHeight;
    frame.size.width = self.bounds.size.width - frame.origin.x - self.separatorInset.right;
    view.frame = frame;
}

#pragma mark observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:contentOffsetPath] && [object isKindOfClass:[UIScrollView class]]) {
        CGFloat rowHeight = [self rowSizeForComponent:0].height;
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGPoint oldContentOffset = [change[NSKeyValueChangeOldKey] CGPointValue];
        CGFloat scrollingRow = fabs(self.startPoint.y - contentOffset.y) / rowHeight;
        CGFloat _y = contentOffset.y - oldContentOffset.y;
        if (_y > 0) {
            NSInteger row = ceil(scrollingRow);
            if (row >= self.lg_numberOfRowsInComponent) { row = self.lg_numberOfRowsInComponent - 1;}
            if (contentOffset.y <= self.startPoint.y) { row = 0;}
            [self lg_pickerView:self didScrollingRow:row inComponent:0];
        } else if (_y < 0) {
            NSInteger row = floor(scrollingRow);
            [self lg_pickerView:self didScrollingRow:row inComponent:0];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self lg_numberOfComponentsInPickerView:self];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self lg_pickerView:self numberOfRowsInComponent:component];
}


#pragma mark UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return [self lg_pickerView:self rowHeightForComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self lg_pickerView:self widthForComponent:component];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self pickerView:self titleForRow:row forComponent:component];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self lg_pickerView:self attributedTitleForRow:row forComponent:component];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    return [self lg_pickerView:self viewForRow:row forComponent:component reusingView:view];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self lg_pickerView:self didSelectRow:row inComponent:component];
}


#pragma mark HXPickerViewDataSource

- (NSInteger)lg_numberOfComponentsInPickerView:(LGPickerView *)pickerView
{
    if ([self.TDataSource respondsToSelector:_cmd]) {
        return [self.TDataSource lg_numberOfComponentsInPickerView:pickerView];
    }
    return 1;
}

- (NSInteger)lg_pickerView:(LGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([self.TDataSource respondsToSelector:_cmd]) {
        self.lg_numberOfRowsInComponent = [self.TDataSource lg_pickerView:pickerView numberOfRowsInComponent:component];
        return self.lg_numberOfRowsInComponent;
    }
    return 1;
}


#pragma mark  HXPickerViewDelegate

- (void)lg_pickerView:(LGPickerView *)pickerView didScrollingRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.TDelegate respondsToSelector:_cmd]) {
        [self.TDelegate lg_pickerView:pickerView didScrollingRow:row inComponent:component];
    }
}

- (CGFloat)lg_pickerView:(LGPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if ([self.TDelegate respondsToSelector:_cmd]) {
        return [self.TDelegate lg_pickerView:pickerView rowHeightForComponent:component];
    }
    return 44;
}

- (CGFloat)lg_pickerView:(LGPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if ([self.TDelegate respondsToSelector:_cmd]) {
        return [self.TDelegate lg_pickerView:pickerView widthForComponent:component];
    }
    return 0;
}

- (NSString *)lg_pickerView:(LGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.TDelegate respondsToSelector:_cmd]) {
        return [self.TDelegate lg_pickerView:pickerView titleForRow:row forComponent:component];
    }
    return nil;
}

- (NSAttributedString *)lg_pickerView:(LGPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.TDelegate respondsToSelector:_cmd]) {
        return [self.TDelegate lg_pickerView:pickerView attributedTitleForRow:row forComponent:component];
    }
    return nil;
}

- (UIView *)lg_pickerView:(LGPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if ([self.TDelegate respondsToSelector:_cmd]) {
        return [self.TDelegate lg_pickerView:pickerView viewForRow:row forComponent:component reusingView:view];
    }
    return nil;
}

- (void)lg_pickerView:(LGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentSelectedRow = row;
    [self lg_pickerView:pickerView didScrollingRow:row inComponent:component];
    if ([self.TDelegate respondsToSelector:_cmd]) {
        [self.TDelegate lg_pickerView:pickerView didSelectRow:row inComponent:component];
    }
}


#pragma mark  lazyload

- (NSMutableArray *)scrollViews
{
    if (!_scrollViews) {
        _scrollViews = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _scrollViews;
}

- (NSMutableArray *)separatorLineViews
{
    if (!_separatorLineViews) {
        _separatorLineViews = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _separatorLineViews;
}


#pragma mark dealloc

- (void)dealloc
{
    for (UIScrollView * scrollView in self.scrollViews) {
        [scrollView removeObserver:self forKeyPath:contentOffsetPath];
    }
}

@end

@implementation LGPickerView (LGAllSubViews)

- (NSArray *)lg_allSubViews
{
    NSMutableArray * views = [[NSMutableArray alloc] initWithCapacity:0];
    [self lg_ergodicSubView:self views:views];
    return views;
}

- (void)lg_ergodicSubView:(UIView *)view views:(NSMutableArray *)views
{
    for (UIView * subView in view.subviews) {
        [self lg_viewsWithSubView:subView views:views];
    }
}

- (NSMutableArray *)lg_viewsWithSubView:(UIView *)view views:(NSMutableArray *)views
{
    if (view == nil) {
        return views;
    } else if (!view.subviews.count) {
        [views addObject:view];
    } else {
        [views addObject:view];
        [self lg_ergodicSubView:view views:views];
    }
    return views;
}


@end

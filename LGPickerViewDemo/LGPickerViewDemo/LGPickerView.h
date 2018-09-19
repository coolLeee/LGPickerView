//
//  LGPickerView.h
//  LGPickerView
//
//  Created by ligang on 2018/9/19.
//  Copyright © 2018年 xueersi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPickerViewUnselectColor [UIColor colorFromHexRGB:@"666666"]

@protocol LGPickerViewDelegate;
@protocol LGPickerViewDataSource;

@interface LGPickerView : UIPickerView
@property (nonatomic, weak, nullable) id <LGPickerViewDelegate> TDelegate;
@property (nonatomic, weak, nullable) id <LGPickerViewDataSource> TDataSource;
/**
 分割线颜色
 */
@property (nonatomic, strong) UIColor * separatorColor;
/**
 分割线高度
 */
@property (nonatomic, assign) CGFloat separatorHeight;
/**
 分割线缩进
 */
@property (nonatomic, assign) UIEdgeInsets separatorInset;
/**
 默认的选中行
 */
@property (nonatomic, assign) NSInteger defaultSelectedRow;
/**
 是否有滚动动画
 */
@property (nonatomic, assign) BOOL scrollingAnimation;
@end

@protocol LGPickerViewDataSource <NSObject>

@required;

- (NSInteger)lg_numberOfComponentsInPickerView:(LGPickerView *)pickerView;
- (NSInteger)lg_pickerView:(LGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end


@protocol LGPickerViewDelegate <NSObject>

@optional;

/**
 设置pickerView的行高

 @param pickerView pickerView
 @param component component
 @return 行高
 */
- (CGFloat)lg_pickerView:(LGPickerView *)pickerView
   rowHeightForComponent:(NSInteger)component;

- (CGFloat)lg_pickerView:(LGPickerView *)pickerView
       widthForComponent:(NSInteger)component;

- (NSString *)lg_pickerView:(LGPickerView *)pickerView
                titleForRow:(NSInteger)row
               forComponent:(NSInteger)component;

- (NSAttributedString *)lg_pickerView:(LGPickerView *)pickerView
                attributedTitleForRow:(NSInteger)row
                         forComponent:(NSInteger)component;

- (UIView *)lg_pickerView:(LGPickerView *)pickerView
               viewForRow:(NSInteger)row
             forComponent:(NSInteger)component
              reusingView:(UIView *)view;

- (void)lg_pickerView:(LGPickerView *)pickerView
         didSelectRow:(NSInteger)row
          inComponent:(NSInteger)component;

- (void)lg_pickerView:(LGPickerView *)pickerView
      didScrollingRow:(NSInteger)row
          inComponent:(NSInteger)component;

@end

@interface LGPickerView (LGAllSubViews)

/**
 获取系统pickerView的所有子view

 @return 子view数组
 */
- (NSArray *)lg_allSubViews;

@end

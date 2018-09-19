//
//  ViewController.m
//  LGPickerView
//
//  Created by ligang on 2018/9/19.
//  Copyright © 2018年 xueersi. All rights reserved.
//

#import "ViewController.h"
#import "LGPickerView.h"

@interface ViewController ()<LGPickerViewDelegate,LGPickerViewDataSource>

@property (weak, nonatomic) IBOutlet LGPickerView *pickerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pickerView.TDelegate = self;
    self.pickerView.TDataSource = self;
    self.pickerView.defaultSelectedRow = 5;
//    self.pickerView.separatorColor = [UIColor blueColor];
}

- (NSInteger)lg_numberOfComponentsInPickerView:(LGPickerView *)pickerView
{
    return 1;
}

- (NSInteger)lg_pickerView:(LGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

- (NSString *)lg_pickerView:(LGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"北京";
}

- (UIView *)lg_pickerView:(LGPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat rowHeight = 40;
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, rowHeight)];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"北京";
    titleLabel.tag = row;
    return titleLabel;
}

- (void)lg_pickerView:(LGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"select %ld",row);
}

- (void)lg_pickerView:(LGPickerView *)pickerView didScrollingRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel * titleLabel = (UILabel *)[pickerView viewForRow:row forComponent:0];
    titleLabel.textColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

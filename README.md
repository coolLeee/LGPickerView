# LGPickerView
A pickerView based system UIPickerView which can custom the separatorColor and separatorHeight and so on...

How to use:

1)use storyboard or xib
  根据需求拖动一个view到sb或xib中，设置类型为LGPickerView
  在控制器中遵守LGPickerViewDelegate,LGPickerViewDataSource
  分别设置TDelegate、TDataSource
  ```
    self.pickerView.TDelegate = self;
    self.pickerView.TDataSource = self;
  //    self.pickerView.defaultSelectedRow = 5;
  //    self.pickerView.separatorColor = [UIColor blueColor];
  //    self.pickerView.separatorHeight = 2;
  ```
  同时也可以自定义分割线颜色和高度等等。
  然后就是实现datasource方法和需要的delegate方法
  做完这些大概就能获取一个既有系统音效和滚动触感同时又有自己UI风格的pickerView啦
  
2)使用纯代码
  自己创建一个LGPickerView，其他使用都与xib的相同。

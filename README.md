iOS - MJNIndexView
==================

MJNIndexView is a highly customizable UIControl which displays an alternative index for UITableView. I wanted to mimic the index designed by Jeremy Olson's Tapity for their Languages app. I think their idea of implementing index is brilliant and it is one of the best examples of great UX. I hope more apps are going to use similar indices instead of the generic ones.


![Screenshot](https://github.com/matthewfx/MJNIndexView/raw/master/MJNIndexView01.png)
![Screenshot](https://github.com/matthewfx/MJNIndexView/raw/master/MJNIndexView02.png)
![Screenshot](https://github.com/matthewfx/MJNIndexView/raw/master/MJNIndexView03.png)
![Screenshot](https://github.com/matthewfx/MJNIndexView/raw/master/MJNIndexView04.png)

### Youtube video

[![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/uV3bkPkC-GQ/0.jpg)](http://www.youtube.com/watch?v=uV3bkPkC-GQ)

### Example Code

```objective-c

@interface MJNIndexTestViewController () <MJNIndexViewDataSource>

@property (nonatomic, strong) MJNIndexView *indexView;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MJNIndexTestViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

	// initialise tableView
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds]	[self.tableView registerClass:[UITableViewCell
	class]forCellReuseIdentifier:@"cell"];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:self.tableView];

	// initialise MJNIndexView
	self.indexView = [[MJNIndexView alloc]initWithFrame:self.view.bounds];
	self.indexView.dataSource = self;
	self.indexView.fontColor = [UIColor blueColor];
	[self.view addSubview:self.indexView];
}

// two methods needed for MJNINdexView protocol
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
	return sectionArray;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 	inSection:index] atScrollPosition: UITableViewScrollPositionTop 	animated:NO];
}
.
.
.
@end
```

### Usage

Only two files are required for using MJNIndexView: `MJNindexView.h` & `MJNIndexView.m`.
Copy both of them into your Xcode Project.
Make sure to include QuartzCore framework in your target.

Your UIViewController must implement MJNIndexViewDataSource protocol methods. The first one of them is needed to provide the index with all section titles. The second one is needed to provide UIViewController with a title or index number selected by a user.

You can customize the look and behaviour of MJNIndex by tweaking more than 20 parameters. You can experiment with the most of them in the demo app.

If you want to change items in the index or most of its parameters after the MJNIndexView  was added to the superView you should use the method `– (void)refreshIndexItems` to recalculate every item position, size etc.

### To do

• Improve a curtain fade (it could behave strange when you use very large value for the right margin).

• Improve performance on older devices

• Cocoapod

### Credits

If you use this control in your app, please add  some credits.

## License

### MIT License

Copyright (c) 2013 Mateusz Nuckowski (http://mateusz.nuckowski.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


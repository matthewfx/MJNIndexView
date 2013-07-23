//
//  MJNIndexForTableDemoVC.m
//  MJNIndexForTableView
//
//  Created by mateusz on 12.07.2013.
//  Copyright (c) 2013 Mateusz Nuckowski. All rights reserved.
//

#import "MJNIndexForTableDemoVC.h"
#import "MJNIndexView.h"
#import "FontSettingsView.h"
#import "CurtainSettings.h"
#import "LayoutSettingsView.h"
#import "ExamplesSettings.h"
#import <QuartzCore/QuartzCore.h>

#define CRAYON_NAME(CRAYON)	[[CRAYON componentsSeparatedByString:@"#"] objectAtIndex:0]



@interface MJNIndexForTableDemoVC () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,
MJNIndexViewDataSource, FontSettingsViewDelegate, CurtainSettingsViewDelegate,
LayoutSettingsViewDelegate, ExampleSettingsViewDelegate>


// properties for section array
@property (nonatomic, strong) NSString *pathname;
@property (nonatomic, strong) NSArray *crayons;
@property (nonatomic, strong) NSString *alphaString;
@property (nonatomic, strong) NSMutableArray *sectionArray;

// properties for tableView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIColor *tableColor;
@property (nonatomic, strong) UIColor *tableTextColor;
@property (nonatomic, strong) UIColor *tableSeparatorColor;
@property (nonatomic, strong) UIColor *tableHeaderColor;
@property (nonatomic, strong) UIColor *tableHeaderTextColor;
@property (nonatomic, strong) UIFont *font;


// MJNIndexView
@property (nonatomic, strong) MJNIndexView *indexView;

// settings, scrollView
@property (nonatomic, strong) UIView *settingsView;
@property (nonatomic, assign) BOOL settingsAreVisible;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

// properties for exampleView delegate
@property (nonatomic, strong) NSArray * allExamples;



#pragma mark all properties from MJNIndexView

// set this to NO if you want to get selected items during the pan (default is YES)
@property (nonatomic, assign) BOOL getSelectedItemsAfterPanGestureIsFinished;

// set the font of the selected index item (usually you should choose the same font with a bold style and much larger)
// (default is the same font as previous one with size 40.0 points)
@property (nonatomic, strong) UIFont *selectedItemFont;

// set the color for index items
@property (nonatomic, strong) UIColor *fontColor;

// set if items in index are going to darken during a pan (default is YES)
@property (nonatomic, assign) BOOL darkening;

// set if items in index are going ti fade during a pan (default is YES)
@property (nonatomic, assign) BOOL fading;

// set the color for the selected index item
@property (nonatomic, strong) UIColor *selectedItemFontColor;

// set index items aligment (NSTextAligmentLeft, NSTextAligmentCenter or NSTextAligmentRight - default is NSTextAligmentCenter)
@property (nonatomic, assign) NSTextAlignment itemsAligment;

// set the right margin of index items (default is 10.0)
@property (nonatomic, assign) CGFloat rightMargin;

// set the upper margin of index items (default is 20.0)
// please remember that margins are set for the largest size of selected item font
@property (nonatomic, assign) CGFloat upperMargin;

// set the lower margin of index items (default is 20.0)
// please remember that margins are set for the largest size of selected item font
@property (nonatomic, assign) CGFloat lowerMargin;

// set the maximum amount for item deflection (default is 75.0)
@property (nonatomic,assign) CGFloat maxItemDeflection;

// set the number of items deflected below and above the selected one (default is 5)
@property (nonatomic, assign) int rangeOfDeflection;

// set the curtain color if you want a curtain to appear (default is none)
@property (nonatomic, strong) UIColor *curtainColor;

// set the amount of fading for the curtain between 0 to 1 (default is 0.2)
@property (nonatomic, assign) CGFloat curtainFade;

// set if you need a curtain not to hide completely
@property (nonatomic, assign) BOOL curtainStays;

// set if you want a curtain to move while panning (default is NO)
@property (nonatomic, assign) BOOL curtainMoves;

// set if you need curtain to have the same upper and lower margins (default is NO)
@property (nonatomic, assign) BOOL curtainMargins;

// set this property to YES and it will automatically set margins so that gaps between items are 5.0 points (default is YES)
@property BOOL ergonomicHeight;

@end

@implementation MJNIndexForTableDemoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark viewcontroller life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // adding swipe right gesture to open the settings
    UISwipeGestureRecognizer* gestureR;
    gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    gestureR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gestureR];

    
    // setting all examples for the first example
    self.allExamples = @[@(1), @(0), @(0), @(0), @(0)];

    // load first sit of data to table
    [self firstTableExample];
    //[self secondTableExample];
        
    // initialise tableView
  
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    // initialise MJNIndexView
    self.indexView = [[MJNIndexView alloc]initWithFrame:self.tableView.frame];
    self.indexView.dataSource = self;
    [self firstAttributesForMJNIndexView];
    [self readAttributes];
    [self.view addSubview:self.indexView];
   
    
    // adding settings button
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setImage:[UIImage imageNamed:@"settingsButton.png"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchDown];
    settingsButton.frame = CGRectMake(0.0, 0.0, 20.0, 40.0);
    settingsButton.center = CGPointMake(settingsButton.center.x, self.view.bounds.size.height / 2.0);
    [self.view addSubview:settingsButton];
    
    // adding view for settings
    self.settingsView = [[UIView alloc] initWithFrame:CGRectMake(-240.0, 0.0, 240.0, self.view.bounds.size.height)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0.0,0.0,240.0,self.settingsView.bounds.size.height);
    UIColor *firstColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    UIColor *secondColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.0];
    gradientLayer.colors = @[(id)firstColor.CGColor, (id)secondColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0.55, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 0.0);
    [self.settingsView.layer insertSublayer:gradientLayer atIndex:0];
    [self.view addSubview:self.settingsView];
    self.settingsAreVisible = NO;

    // adding scrollview to settings view
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, self.view.bounds.size.height)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    [self.settingsView addSubview:self.scrollView];
    
    // adding pagecontrol to setting view
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0.0, 0.0, 240.0, 5.0)];
    self.pageControl.center = CGPointMake(self.scrollView.center.x, self.settingsView.bounds.size.height - 15.0);
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0 green:105.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.pageControl.numberOfPages = 1;
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    [self.settingsView addSubview:self.pageControl];
    
    // adding close button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(200.0, 0.0, 40.0, 40.0);
    [closeButton setImage: [UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];

    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchDown];
    [self.settingsView addSubview:closeButton];
    
    // adding prev button
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.frame = CGRectMake(0.0, self.settingsView.bounds.size.height - 30.0, 40.0, 30.0);
    [prevButton setImage: [UIImage imageNamed:@"prevButton.png"] forState:UIControlStateNormal];
    [prevButton addTarget:self action:@selector(changeToPreviousPage) forControlEvents:UIControlEventTouchDown];
    [self.settingsView addSubview:prevButton];
    
    // adding next button
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(200.0, self.settingsView.bounds.size.height - 30.0, 40.0, 30.0);
    [nextButton setImage:[UIImage imageNamed:@"nextButton.png"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(changeToNextPage) forControlEvents:UIControlEventTouchDown];
    [self.settingsView addSubview:nextButton];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark reading/writting attributes for MJNIndexItemsForTableView

- (void)readAttributes
{
    self.getSelectedItemsAfterPanGestureIsFinished = self.indexView.getSelectedItemsAfterPanGestureIsFinished;
    self.font = self.indexView.font;
    self.selectedItemFont = self.indexView.selectedItemFont;
    self.fontColor = self.indexView.fontColor;
    self.selectedItemFontColor = self.indexView.selectedItemFontColor;
    self.darkening = self.indexView.darkening;
    self.fading = self.indexView.fading;
    self.itemsAligment = self.indexView.itemsAligment;
    self.rightMargin = self.indexView.rightMargin;
    self.upperMargin = self.indexView.upperMargin;
    self.lowerMargin = self.indexView.lowerMargin;
    self.maxItemDeflection = self.indexView.maxItemDeflection;
    self.rangeOfDeflection = self.indexView.rangeOfDeflection;
    self.curtainColor = self.indexView.curtainColor;
    self.curtainFade = self.indexView.curtainFade;
    self.curtainMargins = self.indexView.curtainMargins;
    self.curtainStays = self.indexView.curtainStays;
    self.curtainMoves = self.indexView.curtainMoves;
    self.ergonomicHeight = self.indexView.ergonomicHeight;
}

- (void)writeAttributes
{
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = self.getSelectedItemsAfterPanGestureIsFinished;
    self.indexView.font = self.font;
    self.indexView.selectedItemFont = self.selectedItemFont;
    self.indexView.fontColor = self.fontColor;
    self.indexView.selectedItemFontColor = self.selectedItemFontColor;
    self.indexView.darkening = self.darkening;
    self.indexView.fading = self.fading;
    self.indexView.itemsAligment = self.itemsAligment;
    self.indexView.rightMargin = self.rightMargin;
    self.indexView.upperMargin = self.upperMargin;
    self.indexView.lowerMargin = self.lowerMargin;
    self.indexView.maxItemDeflection = self.maxItemDeflection;
    self.indexView.rangeOfDeflection = self.rangeOfDeflection;
    self.indexView.curtainColor = self.curtainColor;
    self.indexView.curtainFade = self.curtainFade;
    self.indexView.curtainMargins = self.curtainMargins;
    self.indexView.curtainStays = self.curtainStays;
    self.indexView.curtainMoves = self.curtainMoves;
    self.indexView.ergonomicHeight = self.ergonomicHeight;
}


#pragma mark settigns examples of tableView and MJNIndexView


- (void)firstTableExample
{
    self.pathname = [[NSBundle mainBundle]  pathForResource:@"crayons" ofType:@"txt"];
    self.tableColor = [UIColor whiteColor];
    self.tableTextColor = [UIColor blackColor];
    self.tableSeparatorColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.tableHeaderColor = [UIColor colorWithRed:80.0/255.0 green:215.0/255.0 blue:250.0/255.0 alpha:1.0];
    self.tableHeaderTextColor = [UIColor whiteColor];
    [self refreshTable];
}

- (void)firstAttributesForMJNIndexView
{
    
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = YES;
    self.indexView.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = nil;
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = NO;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 22.0;
    self.indexView.lowerMargin = 22.0;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentCenter;
    self.indexView.maxItemDeflection = 100.0;
    self.indexView.rangeOfDeflection = 5;
    self.indexView.fontColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.indexView.selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
    
}

- (void)secondTableExample
{
    self.pathname = [[NSBundle mainBundle]  pathForResource:@"crayons2" ofType:@"txt"];
    // initialising of MJNIndexForTableView
    self.tableColor = [UIColor blackColor];
    self.tableTextColor = [UIColor whiteColor];
    self.tableSeparatorColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    self.tableHeaderColor = [UIColor orangeColor];
    self.tableHeaderTextColor = [UIColor blackColor];
    
    
    [self refreshTable];

}

- (void)secondAttributesForMJNIndexView
{
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = NO;
    self.indexView.font = [UIFont fontWithName:@"GillSans" size:19.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"GillSans-Bold" size:60.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = YES;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = YES;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 30.0;
    self.indexView.lowerMargin = 124.0;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentLeft;
    self.indexView.maxItemDeflection = 80.0;
    self.indexView.rangeOfDeflection = 3;
    self.indexView.fontColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.indexView.selectedItemFontColor = [UIColor orangeColor];
    self.indexView.darkening = YES;
    self.indexView.fading = NO;
}

- (void)thirdTableExample
{
    self.pathname = [[NSBundle mainBundle]  pathForResource:@"crayons" ofType:@"txt"];
    self.tableColor = [UIColor colorWithRed:230.0/255.0 green:245.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.tableTextColor = [UIColor colorWithRed:0.0/255.0 green:55.0/255.0 blue:85.0/255.0 alpha:1.0];
    self.tableSeparatorColor = [UIColor colorWithRed:90.0/255.0 green:195.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.tableHeaderColor = [UIColor colorWithRed:0.0/255.0 green:135.0/255.0 blue:215.0/255.0 alpha:1.0];
    self.tableHeaderTextColor = [UIColor whiteColor];
    [self refreshTable];
}

- (void)thirdAttributesForMJNIndexView
{
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = YES;
    self.indexView.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:17.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:30.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = [UIColor colorWithRed:230.0/255.0 green:245.0/255.0 blue:255.0/255.0 alpha:0.8];
    self.indexView.curtainFade = 0.2;
    self.indexView.curtainStays = YES;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 10.0;
    self.indexView.lowerMargin = 10.0;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentRight;
    self.indexView.maxItemDeflection = 100.0;
    self.indexView.rangeOfDeflection = 5;
    self.indexView.fontColor = [UIColor colorWithRed:0.0/255.0 green:105.0/255.0 blue:165.0/255.0 alpha:1.0];;
    self.indexView.selectedItemFontColor = [UIColor colorWithRed:0.0/255.0 green:35.0/255.0 blue:55.0/255.0 alpha:1.0];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
}

- (void)fourthTableExample
{
    self.pathname = [[NSBundle mainBundle]  pathForResource:@"crayons" ofType:@"txt"];
    self.tableColor = [UIColor whiteColor];
    self.tableTextColor = [UIColor colorWithRed:45.0/255.0 green:10.0/255.0 blue:125.0/255.0 alpha:1.0];
    self.tableSeparatorColor = [UIColor colorWithRed:235.0/255.0 green:205.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.tableHeaderColor = [UIColor colorWithRed:185.0/255.0 green:95.0/255.0 blue:250.0/255.0 alpha:1.0];
    self.tableHeaderTextColor = [UIColor colorWithRed:75.0/255.0 green:10.0/255.0 blue:120.0/255.0 alpha:1.0];
    [self refreshTable];
}


- (void)fourthAttributesForMJNIndexView
{
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = NO;
    self.indexView.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = YES;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 10.0;
    self.indexView.lowerMargin = 10.0;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentCenter;
    self.indexView.maxItemDeflection = 100.0;
    self.indexView.rangeOfDeflection = 5;
    self.indexView.fontColor = [UIColor colorWithRed:5.0/255.0 green:100.0/255.0 blue:90.0/255.0 alpha:1.0];;
    self.indexView.selectedItemFontColor = [UIColor colorWithRed:75.0/255.0 green:10.0/255.0 blue:120.0/255.0 alpha:1.0];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
}


- (void)fifthTableExample
{
    self.pathname = [[NSBundle mainBundle]  pathForResource:@"crayons2" ofType:@"txt"];
    self.tableColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.tableTextColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    self.tableSeparatorColor = [UIColor colorWithWhite:0.75 alpha:1.0];;
    self.tableHeaderColor = [UIColor colorWithWhite:0.5 alpha:1.0];;
    self.tableHeaderTextColor = [UIColor colorWithWhite:0.9 alpha:1.0];;
    [self refreshTable];
}


- (void)fifthAttributesForMJNIndexView
{
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = YES;
    self.indexView.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:17.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:40.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = nil;
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = NO;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 50.0;
    self.indexView.lowerMargin = 50.0;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentRight;
    self.indexView.maxItemDeflection = 140.0;
    self.indexView.rangeOfDeflection = 2;
    self.indexView.fontColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];;
    self.indexView.selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
}


// refreshing table with a contents of file stored in self.pathname
- (void)refreshTable
{
	NSArray *rawCrayons = [[NSString stringWithContentsOfFile:self.pathname encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
	NSMutableArray *crayonColors = [NSMutableArray new];
	
    for (NSString *string in rawCrayons) [crayonColors addObject:CRAYON_NAME(string)];
    
    self.alphaString = @"";
    self.crayons = crayonColors;
    self.sectionArray = [NSMutableArray array];
    
    
    int numberOfFirstLetters = [self countFirstLettersInArray:self.crayons];
    
    for (int i=0; i< numberOfFirstLetters; i++) {
        [self.sectionArray addObject:[self itemsInSection:i]];
    }
    [self.tableView setSeparatorColor:self.tableSeparatorColor];
    [self.tableView reloadData];
    [self.tableView reloadSectionIndexTitles];
    [self.indexView refreshIndexItems];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:[self.sectionArray count] -1] atScrollPosition:UITableViewScrollPositionTop animated:NO];

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


// initialising modules for settings
- (void) initSettingsModules
{
    ExamplesSettings *exampleSetting = [[ExamplesSettings alloc]initWithExamples:self.allExamples andGettingSelectedAfterPan:self.getSelectedItemsAfterPanGestureIsFinished];
    exampleSetting.frame = CGRectMake(0.0, 0.0, 240.0, self.settingsView.bounds.size.height);
    exampleSetting.delegate = self;
    
    
    FontSettingsView *fontSetting = [[FontSettingsView alloc]initWithFont:self.font fontColor:self.fontColor forSelectedItem:NO];
    fontSetting.frame = CGRectMake(0.0, 0.0, 240.0, self.settingsView.bounds.size.height);
    fontSetting.delegate = self;
    
    
    FontSettingsView *selectedFontSettings = [[FontSettingsView alloc]initWithFont:self.selectedItemFont fontColor:self.selectedItemFontColor forSelectedItem:YES];
    selectedFontSettings.frame = CGRectMake(0.0, 0.0, 240.0, self.settingsView.bounds.size.height);
    selectedFontSettings.delegate = self;
    
    
    CurtainSettings *curtainSettings = [[CurtainSettings alloc]initWithCurtainColor:self.curtainColor fade:self.curtainFade margins:self.curtainMargins stays:self.curtainStays];
    curtainSettings.delegate = self;
    curtainSettings.frame = CGRectMake(0.0, 0.0, 240.0, self.settingsView.bounds.size.height);
    
    LayoutSettingsView *layoutSettings = [[LayoutSettingsView alloc] initWithDeflectionRange:self.rangeOfDeflection maxDeflection:self.maxItemDeflection itemAligment:self.itemsAligment rightMargin:self.rightMargin upperMargin:self.upperMargin lowerMargin:self.lowerMargin darkening:self.darkening fading:self.fading ergoHeight:self.ergonomicHeight];
    layoutSettings.frame= CGRectMake(0.0, 0.0, 240.0, self.settingsView.bounds.size.height);
    layoutSettings.delegate = self;
    
    [self addSettingsModules:@[exampleSetting, layoutSettings, fontSetting, selectedFontSettings, curtainSettings]];
}


// adding modules for settings
- (void)addSettingsModules:(NSArray *)modules
{
    int count = 0;
    CGFloat width = self.settingsView.bounds.size.width;
    for (UIView *module in modules) {
        if ([module isMemberOfClass:[FontSettingsView class]] || [module isMemberOfClass:[CurtainSettings class]] || [module isMemberOfClass:[LayoutSettingsView class]] || [module isMemberOfClass:[ExamplesSettings class]]) {
            module.center = CGPointMake(width/2.0 + count * width, self.scrollView.center.y);
            [self.scrollView addSubview:module];
            count ++;
        }
        
    }
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    self.pageControl.numberOfPages = count;
    
}


// removin settings modules
- (void) removeSettingModules
{
    for (UIView *module in self.scrollView.subviews) {
        [module removeFromSuperview];
    }
}

// opening and closing of settings window
- (void)close
{
    [self readAttributes];
    if (!self.settingsAreVisible) {
        [self initSettingsModules];
        [UIView beginAnimations:@"animateSettingsOn" context:NULL];
        self.settingsView.frame = CGRectOffset(self.settingsView.frame, 240.0, 0.0);
        [UIView commitAnimations];
        self.settingsAreVisible = YES;
    } else {
        [UIView beginAnimations:@"animateSettingsOff" context:NULL];
        self.settingsView.frame = CGRectOffset(self.settingsView.frame, -240.0, 0.0);
        [UIView commitAnimations];
        [self removeSettingModules];
        self.settingsAreVisible = NO;
    }
}


// changing to the previous page of settings
- (void)changeToPreviousPage
{
    if (self.pageControl.currentPage !=0) {
        self.pageControl.currentPage --;
        [self changePage];
    }
}


// changing to the next page of settings
- (void)changeToNextPage
{
    if (self.pageControl.currentPage !=self.pageControl.numberOfPages) {
        self.pageControl.currentPage ++;
        [self changePage];
    }
}


// page changing for UIPageControl
- (void)changePage
{
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];

}


// refreshing MJNIndexView
- (void)refresh
{
    [self writeAttributes];
    [self.indexView refreshIndexItems];


}




# pragma mark TableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionArray[section]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont fontWithName:self.indexView.font.fontName size:20.0];
    cell.textLabel.text = [NSString stringWithFormat:@"     %@",[self categoryNameAtIndexPath:indexPath]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = self.tableTextColor;
    cell.contentView.backgroundColor = self.tableColor;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    headerView.tintColor = self.tableHeaderColor;
    headerView.textLabel.textColor = self.tableHeaderTextColor;
    headerView.textLabel.font = [UIFont fontWithName:self.indexView.selectedItemFont.fontName size:headerView.textLabel.font.pointSize];
    [[headerView textLabel] setText:[NSString stringWithFormat:@"     %@",[self firstLetter:section]]];
    return headerView;
}


#pragma mark building sectionArray for the tableView
- (NSString *)categoryNameAtIndexPath: (NSIndexPath *)path
{
    NSArray *currentItems = self.sectionArray[path.section];
    NSString *category = currentItems[path.row];
    return category;
}


- (int) countFirstLettersInArray:(NSArray *)categoryArray
{
    NSMutableArray *existingLetters = [NSMutableArray array];
    for (NSString *name in categoryArray){
        NSString *firstLetterInName = [name substringToIndex:1];
        NSCharacterSet *notAllowed = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
        NSRange range = [firstLetterInName rangeOfCharacterFromSet:notAllowed];
        
        if (![existingLetters containsObject:firstLetterInName] && range.location == NSNotFound ) {
            [existingLetters addObject:firstLetterInName];
            self.alphaString = [self.alphaString stringByAppendingString:firstLetterInName];
        }
    }
    return [existingLetters count];
}


- (NSArray *) itemsInSection: (NSInteger)section
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@",[self firstLetter:section]];
    return [self.crayons filteredArrayUsingPredicate:predicate];
}


- (NSString *) firstLetter: (NSInteger) section
{
    return [[self.alphaString substringFromIndex:section] substringToIndex:1];
}


#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    // in example 3 we want to show different index titles
    NSString *alpabeth = @"Ằdele Boss Cat Dog Egg Fog George Harry Idle Joke Key Luke Marry New Open Pot Rocket String Table Umbrella Violin Wind Xena Yellow Zyrro";
    
    NSMutableArray *results = [NSMutableArray array];
    
    for (int i = 0; i < [self.alphaString length]; i++)
    {
        NSString *substr = [self.alphaString substringWithRange:NSMakeRange(i,1)];
        [results addObject:substr];
    }
    
    if ([self.allExamples[2] boolValue]) return [alpabeth componentsSeparatedByString:@" "];
    else {
        if ([self.allExamples[3] boolValue]) {
            NSMutableArray *lowerCaseResults = [NSMutableArray new];
            for (NSString *letter in results) {
                [lowerCaseResults addObject:[letter lowercaseString]];
            }
            results = lowerCaseResults;
        }
        return results;
    }
}


- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.getSelectedItemsAfterPanGestureIsFinished];
}


#pragma mark settings modules delegate methods
- (void)fontForItem:(UIFont *)font
{
    self.font = font;
    [self refresh];
}

- (void)fontForSelectedItem:(UIFont *)font
{
    self.selectedItemFont = font;
    [self refresh];
}

- (void)colorForFont:(UIColor *)color
{
    self.fontColor = color;
    [self refresh];
}

- (void)colorForSelectedFont:(UIColor *)color
{
    self.selectedItemFontColor = color;
    [self refresh];
}

- (void)fadeForCurtain:(CGFloat)fade
{
    self.curtainFade = fade;
    [self refresh];
}

- (void)colorForCurtain:(UIColor *)color
{
    self.curtainColor = color;
    [self refresh];
}

- (void)marginsForCurtain:(BOOL)margins
{
    self.curtainMargins = margins;
    [self refresh];
}

- (void)staysForCurtain:(BOOL)stays
{
    self.curtainStays = stays;
    [self refresh];
}

- (void)layoutSettingForIndexItems:(NSDictionary *)settings
{    
    self.rangeOfDeflection = [settings[@"range"] integerValue];
    self.maxItemDeflection = [settings[@"maxDef"] floatValue];
    self.itemsAligment = [settings[@"aligment"] integerValue];
    self.rightMargin = [settings[@"rightMargin"] floatValue];
    self.upperMargin = [settings[@"upperMargin"] floatValue];
    self.lowerMargin = [settings[@"lowerMargin"] floatValue];
    self.darkening = [settings[@"darkening"] boolValue];
    self.fading = [settings[@"fading"] boolValue];
    self.ergonomicHeight = [settings[@"ergoHeight"] boolValue];
    [self refresh];
}

- (void)examplesSettingsForDemo:(NSArray *)examples andGettingSelectedAfterPan:(BOOL)after
{
    self.allExamples = examples;
    if ([examples[0] boolValue]) {
        [self firstAttributesForMJNIndexView];
        [self firstTableExample];
    } else if ([examples[1] boolValue]) {
        [self secondAttributesForMJNIndexView];
        [self secondTableExample];
    } else if ([examples[2] boolValue]) {
        [self thirdAttributesForMJNIndexView];
        [self thirdTableExample];
    } else if ([examples[3] boolValue]) {
        [self fourthAttributesForMJNIndexView];
        [self fourthTableExample];
    } else if ([examples[4] boolValue]) {
        [self fifthAttributesForMJNIndexView];
        [self fifthTableExample];
    }
    if (after != self.getSelectedItemsAfterPanGestureIsFinished) {
        self.indexView.getSelectedItemsAfterPanGestureIsFinished = after;
        
    }
    [self readAttributes];
    [self refresh];

}



@end

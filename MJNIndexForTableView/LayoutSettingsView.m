//
//  LayoutSettingsView.m
//  MJNIndexForTableView
//
//  Created by Mateusz Nuckowski on 14/07/13.
//  Copyright (c) 2013 Mateusz Nuckowski. All rights reserved.
//

#import "LayoutSettingsView.h"

@interface LayoutSettingsView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *rangeDeflectionValue;
@property (nonatomic, strong) UIStepper *rangeDeflectionStepper;
@property (nonatomic, strong) UITextField *itemsDeflectionValue;
@property (nonatomic, strong) UISlider *itemsDeflectionSlider;
@property (nonatomic, strong) UITextField *rightMarginValue;
@property (nonatomic, strong) UISlider *rightMarginSlider;
@property (nonatomic, strong) UITextField *upperMarginValue;
@property (nonatomic, strong) UISlider *upperMarginSlider;
@property (nonatomic, strong) UITextField *lowerMarginValue;
@property (nonatomic, strong) UISlider *lowerMarginSlider;


@property (nonatomic, assign) NSTextAlignment aligment;
@property (nonatomic, assign) BOOL darkening;
@property (nonatomic, assign) BOOL fading;
@property (nonatomic, assign) BOOL ergoHeight;
@property (nonatomic, assign) int rangeOfDeflection;
@property (nonatomic, assign) CGFloat maxDeflection;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat upperMargin;
@property (nonatomic, assign) CGFloat lowerMargin;

@property (nonatomic, assign) CGFloat prevX;

@end

@implementation LayoutSettingsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithDeflectionRange:(int)range
               maxDeflection:(CGFloat)maxDef
                itemAligment:(NSTextAlignment)aligment
                 rightMargin:(CGFloat)rightM
                 upperMargin:(CGFloat)upperM
                 lowerMargin:(CGFloat)lowerM
                   darkening:(BOOL)darkening
                      fading:(BOOL)fading
                  ergoHeight:(BOOL)ergo

{
    if (self = [super initWithFrame:CGRectZero]) {
        

        self.rangeOfDeflection = range;
        self.maxDeflection = maxDef;
        self.aligment = aligment;
        self.rightMargin = rightM;
        self.upperMargin = upperM;
        self.lowerMargin = lowerM;
        self.darkening = darkening;
        self.fading = fading;
        self.ergoHeight = ergo;
        
    }
    [self drawElements];
    [self enabledDisabled];
    
    return self;
}

- (void)updateLayout
{
    NSDictionary *settings = @{@"range":@(self.rangeOfDeflection), @"maxDef":@(self.maxDeflection), @"aligment":@(self.aligment), @"rightMargin":@(self.rightMargin), @"upperMargin":@(self.upperMargin), @"lowerMargin":@(self.lowerMargin), @"darkening":@(self.darkening), @"fading":@(self.fading), @"ergoHeight":@(self.ergoHeight)};
    [self.delegate layoutSettingForIndexItems:settings];
}

- (void) drawElements
{
    // title label
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 20.0, 210.0, 21.0)];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"Items aligment";
    [self addSubview:title];
    
    
    // font name segmented control
    NSArray *aligmentNames = @[@"Left",@"Center",@"Right"];
    
    
    UISegmentedControl *aligmentSelector = [[UISegmentedControl alloc]initWithItems:aligmentNames];
    UIFont *font = [UIFont boldSystemFontOfSize:10.0];
    NSDictionary *attributes = @{UITextAttributeFont:font};
    [aligmentSelector setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    aligmentSelector.frame = CGRectMake(20.0, 54.0, 200, 40);
    
    if (self.aligment == NSTextAlignmentLeft) aligmentSelector.selectedSegmentIndex = 0;
    else if (self.aligment == NSTextAlignmentRight) aligmentSelector.selectedSegmentIndex = 2;
    else aligmentSelector.selectedSegmentIndex = 1;
    
    [aligmentSelector addTarget:self action:@selector(changeAligment:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:aligmentSelector];
    
    // darkening label
    UILabel *darkeningLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 107.0, 90.0, 21.0)];
    darkeningLabel.backgroundColor = [UIColor clearColor];
    darkeningLabel.font = [UIFont fontWithName:darkeningLabel.font.fontName size:15.0];
    darkeningLabel.text = @"darkening";
    [self addSubview:darkeningLabel];
    
    // fading label
    UILabel *fadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 142.0, 90.0, 21.0)];
    fadingLabel.backgroundColor = [UIColor clearColor];
    fadingLabel.font = [UIFont fontWithName:darkeningLabel.font.fontName size:15.0];
    fadingLabel.text = @"fading";
    [self addSubview:fadingLabel];
    
    // ergo label
    UILabel *ergoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 177.0, 100.0, 21.0)];
    ergoLabel.backgroundColor = [UIColor clearColor];
    ergoLabel.font = [UIFont fontWithName:darkeningLabel.font.fontName size:15.0];
    ergoLabel.text = @"ergo height";
    [self addSubview:ergoLabel];
    
    
    // darkening switch
    UISwitch *darkeningSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(141.0, 105.0, 79.0, 27.0)];
    darkeningSwitch.on = self.darkening;
    [darkeningSwitch addTarget:self action:@selector(darkeningChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:darkeningSwitch];
    
    // fading switch
    UISwitch *fadingSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(141.0, 140.0, 79.0, 27.0)];
    fadingSwitch.on = self.fading;
    [fadingSwitch addTarget:self action:@selector(fadingChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:fadingSwitch];
    
    // ergo switch
    UISwitch *ergoSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(141.0, 175.0, 79.0, 27.0)];
    ergoSwitch.on = self.ergoHeight;
    [ergoSwitch addTarget:self action:@selector(ergoChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:ergoSwitch];
    
    
    // Range label
    UILabel *rangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 212.0, 163.0, 21.0)];
    rangeLabel.font = [UIFont fontWithName:rangeLabel.font.fontName size:15.0];
    rangeLabel.text = @"Range of deflection";
    rangeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:rangeLabel];
    
    // rangeValue textField
    self.rangeDeflectionValue = [[UITextField alloc]initWithFrame:CGRectMake(175.0, 210.0, 45.0, 25.0)];
    self.rangeDeflectionValue.borderStyle = UITextBorderStyleRoundedRect;
    [self.rangeDeflectionValue setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.rangeDeflectionValue.text = [NSString stringWithFormat:@"%d",self.rangeOfDeflection];
    [self.rangeDeflectionValue addTarget:self action:@selector(changeRangeValue:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.rangeDeflectionValue];
    
    // range stepper
    self.rangeDeflectionStepper = [[UIStepper alloc]initWithFrame:CGRectMake(126.0, 245.0, 94, 27.0)];
    self.rangeDeflectionStepper.minimumValue = 1;
    self.rangeDeflectionStepper.maximumValue = 10;
    self.rangeDeflectionStepper.stepValue = 1;
    self.rangeDeflectionStepper.value = [self.rangeDeflectionValue.text integerValue];
    [self.rangeDeflectionStepper addTarget:self action:@selector(rangePressed:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.rangeDeflectionStepper];
    
    
    // Max deflection label
    UILabel *maxDefLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 280.0, 140.0, 16.0)];
    maxDefLabel.font = [UIFont fontWithName:rangeLabel.font.fontName size:12.0];
    maxDefLabel.text = @"Max. items deflection";
    maxDefLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:maxDefLabel];
    
    // maxDeflection textField
    self.itemsDeflectionValue = [[UITextField alloc]initWithFrame:CGRectMake(150.0, 295.0, 70.0, 25.0)];
    self.itemsDeflectionValue.borderStyle = UITextBorderStyleRoundedRect;
    [self.itemsDeflectionValue setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.itemsDeflectionValue.text = [NSString stringWithFormat:@"%.2f",self.maxDeflection];
    [self.itemsDeflectionValue addTarget:self action:@selector(changeDeflectionValue:) forControlEvents:UIControlEventEditingDidEnd];
    [self.itemsDeflectionValue addTarget:self action:@selector(moveUp) forControlEvents:UIControlEventEditingDidBegin];

    [self addSubview:self.itemsDeflectionValue];
    
    // maxDeflection slider
    self.itemsDeflectionSlider = [[UISlider alloc]initWithFrame:CGRectMake(20.0, 296.0, 120.0, 23.0)];
    self.itemsDeflectionSlider.minimumValue = 0.0;
    self.itemsDeflectionSlider.maximumValue = 300.0;
    self.itemsDeflectionSlider.value = [self.itemsDeflectionValue.text floatValue];
    [self.itemsDeflectionSlider addTarget:self action:@selector(itemsDefSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.itemsDeflectionSlider];

    
    // rightMargin label
    UILabel *rightMarginLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 320.0, 140.0, 16.0)];
    rightMarginLabel.font = [UIFont fontWithName:rangeLabel.font.fontName size:12.0];
    rightMarginLabel.text = @"Right margin";
    rightMarginLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:rightMarginLabel];

    // rightMarginValue textField
    self.rightMarginValue = [[UITextField alloc]initWithFrame:CGRectMake(150.0, 335.0, 70.0, 25.0)];
    self.rightMarginValue.borderStyle = UITextBorderStyleRoundedRect;
    [self.rightMarginValue setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.rightMarginValue.text = [NSString stringWithFormat:@"%.2f",self.rightMargin];
    [self.rightMarginValue addTarget:self action:@selector(changerightMarginValue:) forControlEvents:UIControlEventEditingDidEnd];
    [self.rightMarginValue addTarget:self action:@selector(moveUp) forControlEvents:UIControlEventEditingDidBegin];

    [self addSubview:self.rightMarginValue];
    
    // rightMargin slider
    self.rightMarginSlider = [[UISlider alloc]initWithFrame:CGRectMake(20.0, 336.0, 120.0, 23.0)];
    self.rightMarginSlider.minimumValue = 0.0;
    self.rightMarginSlider.maximumValue = 50.0;
    self.rightMarginSlider.value = [self.rightMarginValue.text floatValue];
    [self.rightMarginSlider addTarget:self action:@selector(rightMarginSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.rightMarginSlider];
    
    
    // upperMargin label
    UILabel *upperMarginLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 360.0, 140.0, 16.0)];
    upperMarginLabel.font = [UIFont fontWithName:rangeLabel.font.fontName size:12.0];
    upperMarginLabel.text = @"Upper margin";
    upperMarginLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:upperMarginLabel];
    
    // upperMarginValue textField
    self.upperMarginValue = [[UITextField alloc]initWithFrame:CGRectMake(150.0, 375.0, 70.0, 25.0)];
    self.upperMarginValue.borderStyle = UITextBorderStyleRoundedRect;
    [self.upperMarginValue setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.upperMarginValue.text = [NSString stringWithFormat:@"%.2f",self.upperMargin];
    [self.upperMarginValue addTarget:self action:@selector(changeupperMarginValue:) forControlEvents:UIControlEventEditingDidEnd];
    [self.upperMarginValue addTarget:self action:@selector(moveUp) forControlEvents:UIControlEventEditingDidBegin];

    [self addSubview:self.upperMarginValue];
    
    // upperMargin slider
    self.upperMarginSlider = [[UISlider alloc]initWithFrame:CGRectMake(20.0, 376.0, 120.0, 23.0)];
    self.upperMarginSlider.minimumValue = 0.0;
    self.upperMarginSlider.maximumValue = 150.0;
    self.upperMarginSlider.value = [self.upperMarginValue.text floatValue];
    [self.upperMarginSlider addTarget:self action:@selector(upperMarginSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.upperMarginSlider];
    
    
    // lowerMargin label
    UILabel *lowerMarginLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 400.0, 140.0, 16.0)];
    lowerMarginLabel.font = [UIFont fontWithName:rangeLabel.font.fontName size:12.0];
    lowerMarginLabel.text = @"Lower margin";
    lowerMarginLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:lowerMarginLabel];
    
    // lowerMarginValue textField
    self.lowerMarginValue = [[UITextField alloc]initWithFrame:CGRectMake(150.0, 415.0, 70.0, 25.0)];
    self.lowerMarginValue.borderStyle = UITextBorderStyleRoundedRect;
    [self.lowerMarginValue setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.lowerMarginValue.text = [NSString stringWithFormat:@"%.2f",self.lowerMargin];
    [self.lowerMarginValue addTarget:self action:@selector(changelowerMarginValue:) forControlEvents:UIControlEventEditingDidEnd];
    [self.lowerMarginValue addTarget:self action:@selector(moveUp) forControlEvents:UIControlEventEditingDidBegin];

    [self addSubview:self.lowerMarginValue];
    
    // lowerMargin slider
    self.lowerMarginSlider = [[UISlider alloc]initWithFrame:CGRectMake(20.0, 416.0, 120.0, 23.0)];
    self.lowerMarginSlider.minimumValue = 0.0;
    self.lowerMarginSlider.maximumValue = 150.0;
    self.lowerMarginSlider.value = [self.lowerMarginValue.text floatValue];
    [self.lowerMarginSlider addTarget:self action:@selector(lowerMarginSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.lowerMarginSlider];

}


#pragma mark uisegmentedcontrol change methods
- (void)changeAligment:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) self.aligment = NSTextAlignmentLeft;
    else if (sender.selectedSegmentIndex == 1) self.aligment = NSTextAlignmentCenter;
    else self.aligment = NSTextAlignmentRight;
    [self updateLayout];
}


#pragma mark uiswitch change methods
- (void)darkeningChanged:(UISwitch *)sender
{
    self.darkening = sender.on;
    [self updateLayout];
}

- (void)fadingChanged:(UISwitch *)sender
{
    self.fading = sender.on;
    [self updateLayout];
}

- (void)ergoChanged:(UISwitch *)sender
{
    self.ergoHeight = sender.on;
    [self enabledDisabled];
    [self updateLayout];
}

#pragma mark range change methods
- (void)changeRangeValue:(UITextField *)sender
{
    if ([sender.text floatValue] < 0) sender.text = @"0";

    self.rangeOfDeflection = [sender.text integerValue];
    self.rangeDeflectionStepper.value = [sender.text integerValue];
    [self updateLayout];
}

- (void)rangePressed:(UIStepper *)sender
{
    self.rangeOfDeflection = (int)self.rangeDeflectionStepper.value;
    self.rangeDeflectionValue.text = [NSString stringWithFormat:@"%d",(int)self.rangeDeflectionStepper.value];
    [self updateLayout];
}

#pragma mark deflection settings
- (void)changeDeflectionValue:(UITextField *)sender
{
    if ([sender.text floatValue] > self.itemsDeflectionSlider.maximumValue) sender.text = [NSString stringWithFormat:@"%.2f",self.itemsDeflectionSlider.maximumValue];
    if ([sender.text floatValue] < self.itemsDeflectionSlider.minimumValue) sender.text = [NSString stringWithFormat:@"%.2f",self.itemsDeflectionSlider.minimumValue];

    self.maxDeflection = [sender.text floatValue];
    self.itemsDeflectionSlider.value = [sender.text floatValue];
    [self updateLayout];
}

- (void)itemsDefSliderChanged:(UISlider *)sender
{
    self.maxDeflection = sender.value;
    self.itemsDeflectionValue.text = [NSString stringWithFormat:@"%.2f",sender.value];
    [self updateLayout];
}


#pragma mark rightMargin settings
- (void)changerightMarginValue:(UITextField *)sender
{
    if ([sender.text floatValue] > self.rightMarginSlider.maximumValue) sender.text = [NSString stringWithFormat:@"%.2f",self.rightMarginSlider.maximumValue];
    if ([sender.text floatValue] < self.rightMarginSlider.minimumValue) sender.text = [NSString stringWithFormat:@"%.2f",self.rightMarginSlider.minimumValue];

    self.rightMargin = [sender.text floatValue];
    self.rightMarginSlider.value = [sender.text floatValue];
    [self updateLayout];
}

- (void)rightMarginSliderChanged:(UISlider *)sender
{
    self.rightMargin = sender.value;
    self.rightMarginValue.text = [NSString stringWithFormat:@"%.2f",sender.value];
    [self updateLayout];
}

#pragma mark upperMargin settings
- (void)changeupperMarginValue:(UITextField *)sender
{
    if ([sender.text floatValue] > self.upperMarginSlider.maximumValue) sender.text = [NSString stringWithFormat:@"%.2f",self.upperMarginSlider.maximumValue];
    if ([sender.text floatValue] < self.upperMarginSlider.minimumValue) sender.text = [NSString stringWithFormat:@"%.2f",self.upperMarginSlider.minimumValue];

    self.upperMargin = [sender.text floatValue];
    self.upperMarginSlider.value = [sender.text floatValue];
    [self updateLayout];
}

- (void)upperMarginSliderChanged:(UISlider *)sender
{
    self.upperMargin = sender.value;
    self.upperMarginValue.text = [NSString stringWithFormat:@"%.2f",sender.value];
    [self updateLayout];
}

#pragma mark lowerMargin settings
- (void)changelowerMarginValue:(UITextField *)sender
{
    if ([sender.text floatValue] > self.lowerMarginSlider.maximumValue) sender.text = [NSString stringWithFormat:@"%.2f",self.lowerMarginSlider.maximumValue];
    if ([sender.text floatValue] < self.lowerMarginSlider.minimumValue) sender.text = [NSString stringWithFormat:@"%.2f",self.lowerMarginSlider.minimumValue];

    self.lowerMargin = [sender.text floatValue];
    self.lowerMarginSlider.value = [sender.text floatValue];
    [self updateLayout];
}

- (void)lowerMarginSliderChanged:(UISlider *)sender
{
    self.lowerMargin = sender.value;
    self.lowerMarginValue.text = [NSString stringWithFormat:@"%.2f",sender.value];
    [self updateLayout];
}


- (void)enabledDisabled
{
    self.upperMarginSlider.enabled = !self.ergoHeight;
    self.lowerMarginSlider.enabled = !self.ergoHeight;
    self.upperMarginValue.enabled = !self.ergoHeight;
    self.lowerMarginValue.enabled = !self.ergoHeight;
}

#pragma mark moving view up and down
- (void) moveUp
{
    if (self.frame.origin.y == 0.0) {
        [UIView beginAnimations:@"moveUp" context:NULL];
        self.frame = CGRectOffset(self.frame, 0.0, -200.0);
        [UIView commitAnimations];
    }
}

- (void) moveDown
{
    if (self.frame.origin.y < 0.0) {
        [UIView beginAnimations:@"moveDown" context:NULL];
        self.frame = CGRectOffset(self.frame, 0.0, 200.0);
        [UIView commitAnimations];
    }
}


#pragma mark methods for keyboard dismissal
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint tappedPt = [[touches anyObject] locationInView: self];
    self.prevX = tappedPt.x;


    for (id subView in self.subviews) {
        if ([subView isMemberOfClass:[UITextField class]]) {
            UITextField *textField = subView;
            [textField resignFirstResponder];
        }
        
    }
    [self moveDown];
}


    


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self moveDown];
    return YES;
}

- (void) willMoveToSuperview:(UIView *)newSuperview
{
    for (id subView in self.subviews) {
        if ([subView isMemberOfClass:[UITextField class]]) {
            UITextField *textField = subView;
            textField.delegate = self;
        }
    }
    self.upperMarginSlider.maximumValue = self.bounds.size.height / 2.0 - 100.0;
    self.lowerMarginSlider.maximumValue = self.bounds.size.height / 2.0 - 100.0;
    
}

// method for swipe to close

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint tappedPt = [[touches anyObject] locationInView: self];
    CGFloat currentX = tappedPt.x;
    if (self.prevX - currentX > 20.0) [self.delegate close];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

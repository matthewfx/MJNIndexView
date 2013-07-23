//
//  CurtainSettings.m
//  MJNIndexForTableView
//
//  Created by Mateusz Nuckowski on 14/07/13.
//  Copyright (c) 2013 Mateusz Nuckowski. All rights reserved.
//

#import "CurtainSettings.h"

@interface CurtainSettings () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *curtainFadeValue;
@property (nonatomic, strong) UISlider *curtainFadeSlider;
@property (nonatomic, strong) UILabel *sampleColor;
@property (nonatomic, strong) UITextField *redValue;
@property (nonatomic, strong) UISlider *redValueSlider;
@property (nonatomic, strong) UITextField *greenValue;
@property (nonatomic, strong) UISlider *greenValueSlider;
@property (nonatomic, strong) UITextField *blueValue;
@property (nonatomic, strong) UISlider *blueValueSlider;
@property (nonatomic, strong) UITextField *alphaValue;
@property (nonatomic, strong) UISlider *alphaValueSlider;

@property (nonatomic, assign)BOOL curtainStays;
@property (nonatomic, assign)BOOL curtainMargins;
@property (nonatomic, assign) CGFloat fade;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat red;
@property (nonatomic, assign) CGFloat green;
@property (nonatomic, assign) CGFloat blue;
@property (nonatomic, assign) CGFloat alphaCh;

@property (nonatomic, assign) CGFloat prevX;

@property (nonatomic, strong) NSArray *disabledEnabledControls;

@end

@implementation CurtainSettings

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithCurtainColor:(UIColor *)color fade:(CGFloat)fade margins:(BOOL)margins stays:(BOOL)stays
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.curtainStays = stays;
        self.curtainMargins = margins;
        self.fade = fade;
        self.color = color;
        
        // Current color values
        
        if (color) {
            const CGFloat *colorComponents = CGColorGetComponents(self.color.CGColor);
            self.red = colorComponents[0];
            self.green = colorComponents[1];
            self.blue = colorComponents[2];
            self.alphaCh = colorComponents[3];
        } else {
            self.red = 1.0;
            self.green = 1.0;
            self.blue = 1.0;
            self.alphaCh = 1.0;
        }
        
        [self drawElements];
    }
    
    return self;
}


- (void) drawElements
{
    // title label
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 20.0, 210.0, 21.0)];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"Curtain settings";
    [self addSubview:title];
    
    
    // curtain switches
    
    // curtain on/off label
    UILabel *onOffLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 53.0, 80.0, 21.0)];
    onOffLabel.font = [UIFont fontWithName:onOffLabel.font.fontName size:15.0];
    onOffLabel.backgroundColor = [UIColor clearColor];
    onOffLabel.text = @"ON/OFF";
    [self addSubview:onOffLabel];
    
    // on/off switch
    UISwitch *onOffSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(141, 50.0, 79.0, 27.0)];
    if (!self.color) onOffSwitch.on = NO;
    else onOffSwitch.on = YES;
    [onOffSwitch addTarget:self action:@selector(onOffChanged:) forControlEvents:UIControlEventValueChanged];
    onOffSwitch.tag = 1;
    [self addSubview:onOffSwitch];
    
    // curtainStays label
    UILabel *curtainStaysLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 88.0, 100.0, 21.0)];
    curtainStaysLabel.font = [UIFont fontWithName:curtainStaysLabel.font.fontName size:15.0];
    curtainStaysLabel.backgroundColor = [UIColor clearColor];
    curtainStaysLabel.text = @"Curtain stays";
    [self addSubview:curtainStaysLabel];
    
    // curtainStays switch
    UISwitch *curtainStaysSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(141.0, 85.0, 79.0, 27.0)];
    curtainStaysSwitch.on = self.curtainStays;
    [curtainStaysSwitch addTarget:self action:@selector(curtainStaysChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:curtainStaysSwitch];
    
    // curtainMargins label
    UILabel *curtainMarginsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 123.0, 110.0, 21.0)];
    curtainMarginsLabel.font = [UIFont fontWithName:curtainMarginsLabel.font.fontName size:15.0];
    curtainMarginsLabel.backgroundColor = [UIColor clearColor];
    curtainMarginsLabel.text = @"Curtain margins";
    [self addSubview:curtainMarginsLabel];
    
    // curtainMargins switch
    UISwitch *curtainMarginsSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(141, 120.0, 79.0, 27.0)];
    curtainMarginsSwitch.on = self.curtainMargins;
    [curtainMarginsSwitch addTarget:self action:@selector(curtainMarginsChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:curtainMarginsSwitch];
    
    // curtain fade label
    UILabel *curtainFadeTitle = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 158.0, 100.0, 21.0)];
    curtainFadeTitle.font = [UIFont fontWithName:curtainFadeTitle.font.fontName size:15.0];
    curtainFadeTitle.backgroundColor = [UIColor clearColor];
    curtainFadeTitle.text = @"Curtain fade";
    [self addSubview:curtainFadeTitle];
    
    // curtainFadeValue text field
    self.curtainFadeValue = [[UITextField alloc]initWithFrame:CGRectMake(150.0, 155.0, 70.0, 25.0)];
    self.curtainFadeValue.borderStyle = UITextBorderStyleRoundedRect;
    [self.curtainFadeValue setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    CGFloat currentFade = self.fade;
    
    [self.curtainFadeValue addTarget:self action:@selector(changeFadeSize:) forControlEvents:UIControlEventEditingChanged];
    self.curtainFadeValue.text = [NSString stringWithFormat:@"%.2f",currentFade];
    
    
    [self addSubview:self.curtainFadeValue];
    
    // curtainFade Slider
    self.curtainFadeSlider = [[UISlider alloc]initWithFrame:CGRectMake(20.0, 185.0, 200.0, 23.0)];
    self.curtainFadeSlider.minimumValue = 0.0;
    self.curtainFadeSlider.maximumValue = 1.0;
    self.curtainFadeSlider.value = [self.curtainFadeValue.text floatValue];
    [self.curtainFadeSlider addTarget:self action:@selector(curtainFadeSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.curtainFadeSlider];
    
    // curtainColor title
    UILabel *curtainColorTitle = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 216.0, 100.0, 21.0)];
    curtainColorTitle.backgroundColor = [UIColor clearColor];
    curtainColorTitle.text = @"Curtain color";
    [self addSubview:curtainColorTitle];
    
    // fontColor sample color
    self.sampleColor = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 245.0, 100.0, 27.0)];
    if (self.color) self.sampleColor.backgroundColor = self.color;
    else self.sampleColor.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.sampleColor];
    
    // R label
    UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 280.0, 140.0, 16.0)];
    redLabel.font = [UIFont fontWithName:redLabel.font.fontName size:12.0];
    redLabel.text = @"Red";
    redLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:redLabel];
    
    // redValue textField
    self.redValue = [[UITextField alloc]initWithFrame:CGRectMake(175.0, 295.0, 45.0, 25.0)];
    self.redValue.borderStyle = UITextBorderStyleRoundedRect;
    [self.redValue setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.redValue.text = [NSString stringWithFormat:@"%d",(int)(self.red * 255.0)];
    [self.redValue addTarget:self action:@selector(changeRedValue:) forControlEvents:UIControlEventEditingDidEnd];
    [self.redValue addTarget:self action:@selector(moveUp) forControlEvents:UIControlEventEditingDidBegin];
    [self addSubview:self.redValue];
    
    // redValue slider
    self.redValueSlider = [[UISlider alloc]initWithFrame:CGRectMake(20.0, 296.0, 145.0, 23.0)];
    self.redValueSlider.minimumValue = 0.0;
    self.redValueSlider.maximumValue = 255.0;
    self.redValueSlider.value = [self.redValue.text floatValue];
    [self.redValueSlider addTarget:self action:@selector(redValueSlideChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.redValueSlider];
    
    // G label
    UILabel *greenLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 320.0, 140.0, 16.0)];
    greenLabel.font = [UIFont fontWithName:greenLabel.font.fontName size:12.0];
    greenLabel.text = @"Green";
    greenLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:greenLabel];
    
    // greenValue textField
    self.greenValue = [[UITextField alloc]initWithFrame:CGRectMake(175.0, 335.0, 45.0, 25.0)];
    self.greenValue.borderStyle = UITextBorderStyleRoundedRect;
    [self.greenValue setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.greenValue.text = [NSString stringWithFormat:@"%d",(int)(self.green * 255.0)];
    [self.greenValue addTarget:self action:@selector(changeGreenValue:) forControlEvents:UIControlEventEditingDidEnd];
    [self.greenValue addTarget:self action:@selector(moveUp) forControlEvents:UIControlEventEditingDidBegin];
    
    [self addSubview:self.greenValue];
    
    // greenValue slider
    self.greenValueSlider = [[UISlider alloc]initWithFrame:CGRectMake(20.0, 336.0, 145.0, 23.0)];
    self.greenValueSlider.minimumValue = 0.0;
    self.greenValueSlider.maximumValue = 255.0;
    self.greenValueSlider.value = [self.redValue.text floatValue];
    [self.greenValueSlider addTarget:self action:@selector(greenValueSlideChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.greenValueSlider];
    
    // B label
    UILabel *blueLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 360.0, 140.0, 16.0)];
    blueLabel.font = [UIFont fontWithName:blueLabel.font.fontName size:12.0];
    blueLabel.text = @"Blue";
    blueLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:blueLabel];
    
    // blueValue textField
    self.blueValue = [[UITextField alloc]initWithFrame:CGRectMake(175.0, 375.0, 45.0, 25.0)];
    self.blueValue.borderStyle = UITextBorderStyleRoundedRect;
    [self.blueValue setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.blueValue.text = [NSString stringWithFormat:@"%d",(int)(self.blue * 255.0)];
    [self.blueValue addTarget:self action:@selector(changeBlueValue:) forControlEvents:UIControlEventEditingDidEnd];
    [self.blueValue addTarget:self action:@selector(moveUp) forControlEvents:UIControlEventEditingDidBegin];
    
    [self addSubview:self.blueValue];
    
    // blueValue slider
    self.blueValueSlider = [[UISlider alloc]initWithFrame:CGRectMake(20.0, 376.0, 145.0, 23.0)];
    self.blueValueSlider.minimumValue = 0.0;
    self.blueValueSlider.maximumValue = 255.0;
    self.blueValueSlider.value = [self.blueValue.text floatValue];
    [self.blueValueSlider addTarget:self action:@selector(blueValueSlideChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.blueValueSlider];
    
    // A label
    UILabel *alphaLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 400.0, 140.0, 16.0)];
    alphaLabel.font = [UIFont fontWithName:alphaLabel.font.fontName size:12.0];
    alphaLabel.text = @"Alpha";
    alphaLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:alphaLabel];
    
    // alphaValue textField
    self.alphaValue = [[UITextField alloc]initWithFrame:CGRectMake(175.0, 415.0, 45.0, 25.0)];
    self.alphaValue.borderStyle = UITextBorderStyleRoundedRect;
    [self.alphaValue setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.alphaValue.text = [NSString stringWithFormat:@"%d",(int)(self.alphaCh * 100.0)];
    [self.alphaValue addTarget:self action:@selector(changeAlphaValue:) forControlEvents:UIControlEventEditingDidEnd];
    [self addSubview:self.alphaValue];
    
    // aplphaValue slider
    self.alphaValueSlider = [[UISlider alloc]initWithFrame:CGRectMake(20.0, 416.0, 145.0, 23.0)];
    self.alphaValueSlider.minimumValue = 0.0;
    self.alphaValueSlider.maximumValue = 100.0;
    self.alphaValueSlider.value = [self.alphaValue.text floatValue];
    [self.alphaValueSlider addTarget:self action:@selector(alphaValueSlideChanged:) forControlEvents:UIControlEventValueChanged];
    [self.alphaValue addTarget:self action:@selector(moveUp) forControlEvents:UIControlEventEditingDidBegin];
    [self addSubview:self.alphaValueSlider];
    
    self.disabledEnabledControls = @[self.curtainFadeValue, self.curtainFadeSlider, self.redValue, self.redValueSlider, self.greenValue, self.greenValueSlider, self.blueValue, self.blueValueSlider, self.alphaValue, self.alphaValueSlider];
    
    if (!self.color) [self enableDisable];
    
}

- (void)changeFadeSize:(UITextField *)sender
{
    if ([sender.text floatValue] > self.curtainFadeSlider.maximumValue) sender.text = [NSString stringWithFormat:@"%d",(int)self.curtainFadeSlider.maximumValue];
    if ([sender.text floatValue] < self.curtainFadeSlider.minimumValue) sender.text = [NSString stringWithFormat:@"%d",(int)self.curtainFadeSlider.minimumValue];
    self.fade = [sender.text floatValue];
    [self.delegate fadeForCurtain:self.fade];
    self.curtainFadeSlider.value = [sender.text floatValue];
}

- (void)curtainFadeSliderChanged:(UISlider *)sender
{
    self.curtainFadeValue.text = [NSString stringWithFormat:@"%.2f",sender.value];
    self.fade = sender.value;
    [self.delegate fadeForCurtain:self.fade];
}

- (void)changeRedValue:(UITextField *)sender
{
    if ([sender.text floatValue] > self.redValueSlider.maximumValue) sender.text = [NSString stringWithFormat:@"%d",(int)self.redValueSlider.maximumValue];
    if ([sender.text floatValue] < self.redValueSlider.minimumValue) sender.text = [NSString stringWithFormat:@"%d",(int)self.redValueSlider.minimumValue];
    self.red = [sender.text floatValue]/255.0;
    self.redValueSlider.value = [sender.text floatValue];
    [self changeColor];
}

- (void)redValueSlideChanged:(UISlider *)sender
{
    self.red = sender.value/255.0;
    self.redValue.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    [self changeColor];
}

- (void)changeGreenValue:(UITextField *)sender
{
    if ([sender.text floatValue] > self.greenValueSlider.maximumValue) sender.text = [NSString stringWithFormat:@"%d",(int)self.greenValueSlider.maximumValue];
    if ([sender.text floatValue] < self.greenValueSlider.minimumValue) sender.text = [NSString stringWithFormat:@"%d",(int)self.greenValueSlider.minimumValue];
    self.green = [sender.text floatValue]/255.0;
    self.greenValueSlider.value = [sender.text floatValue];
    [self changeColor];
}

- (void)greenValueSlideChanged:(UISlider *)sender
{
    self.green = sender.value/255.0;
    self.greenValue.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    [self changeColor];
}


- (void)changeBlueValue:(UITextField *)sender
{
    if ([sender.text floatValue] > self.blueValueSlider.maximumValue) sender.text = [NSString stringWithFormat:@"%d",(int)self.blueValueSlider.maximumValue];
    if ([sender.text floatValue] < self.blueValueSlider.minimumValue) sender.text = [NSString stringWithFormat:@"%d",(int)self.blueValueSlider.minimumValue];
    
    self.blue = [sender.text floatValue]/255.0;
    self.blueValueSlider.value = [sender.text floatValue];
    [self changeColor];
}

- (void)blueValueSlideChanged:(UISlider *)sender
{
    self.blue = sender.value/255.0;
    self.blueValue.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    [self changeColor];
}

- (void)changeAlphaValue:(UITextField *)sender
{
    if ([sender.text floatValue] > self.alphaValueSlider.maximumValue) sender.text = [NSString stringWithFormat:@"%d",(int)self.alphaValueSlider.maximumValue];
    if ([sender.text floatValue] < self.alphaValueSlider.minimumValue) sender.text = [NSString stringWithFormat:@"%d",(int)self.alphaValueSlider.minimumValue];
    
    self.alphaCh = [sender.text floatValue]/100.0;
    self.alphaValueSlider.value = [sender.text floatValue];
    [self changeColor];
}

- (void)alphaValueSlideChanged:(UISlider *)sender
{
    self.alphaCh = sender.value/100.0;
    self.alphaValue.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    [self changeColor];
}

- (void)changeColor
{
    self.color = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:self.alphaCh];
    self.sampleColor.backgroundColor = self.color;
    [self.delegate colorForCurtain:self.color];
}


- (void)onOffChanged:(UISwitch *)sender
{
    if (!sender.on) [self.delegate colorForCurtain:nil];
    else {
        [self changeColor];
        [self.delegate colorForCurtain:self.color];
    }
    [self enableDisable];
}


- (void)curtainMarginsChanged:(UISwitch *)sender
{
    self.curtainMargins = sender.on;
    [self.delegate marginsForCurtain:self.curtainMargins];
}

- (void)curtainStaysChanged:(UISwitch *)sender
{
    self.curtainStays = sender.on;
    [self.delegate staysForCurtain:self.curtainStays];
}


- (void)enableDisable
{
    for (id control in self.disabledEnabledControls) {
        if ([control isKindOfClass:[UISlider class]]) {
            UISlider *slider = control;
            slider.enabled = !slider.enabled;
        } else if ([control isKindOfClass:[UITextField class]]) {
            UITextField *textField = control;
            textField.enabled = !textField.enabled;
        } 
    }
    
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

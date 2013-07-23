//
//  FontSettingsView.m
//  MJNIndexForTableView
//
//  Created by Mateusz Nuckowski on 13/07/13.
//  Copyright (c) 2013 Mateusz Nuckowski. All rights reserved.
//

#import "FontSettingsView.h"

@interface FontSettingsView () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *fontSizeValue;
@property (nonatomic, strong) UISlider *fontSizeSlider;
@property (nonatomic, strong) UILabel *sampleColor;
@property (nonatomic, strong) UITextField *redValue;
@property (nonatomic, strong) UISlider *redValueSlider;
@property (nonatomic, strong) UITextField *greenValue;
@property (nonatomic, strong) UISlider *greenValueSlider;
@property (nonatomic, strong) UITextField *blueValue;
@property (nonatomic, strong) UISlider *blueValueSlider;
@property (nonatomic, strong) UITextField *alphaValue;
@property (nonatomic, strong) UISlider *alphaValueSlider;

@property (nonatomic, assign)BOOL selected;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat red;
@property (nonatomic, assign) CGFloat green;
@property (nonatomic, assign) CGFloat blue;
@property (nonatomic, assign) CGFloat alphaCh;

@property (nonatomic, assign) CGFloat prevX;

@end

@implementation FontSettingsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       

    }
    return self;
}

- (id)initWithFont:(UIFont *)font fontColor:(UIColor *)color forSelectedItem:(BOOL)selected
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.selected = selected;
        self.font = font;
        self.color = color;
        // Current color values
        const CGFloat *colorComponents = CGColorGetComponents(self.color.CGColor);
        self.red = colorComponents[0];
        self.green = colorComponents[1];
        self.blue = colorComponents[2];
        self.alphaCh = colorComponents[3];
        [self drawElements];
    }
    
    return self;
}



- (void) drawElements
{
    // title label
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 20.0, 210.0, 21.0)];
    title.font = [UIFont fontWithName:title.font.fontName size:15.0];
    title.backgroundColor = [UIColor clearColor];
    if (self.selected) title.text = @"Selected item font name";
    else title.text = @"Items font name";
    [self addSubview:title];
    
    
    // font name segmented control
    NSArray *fontNames = @[@"Helvetica",@"Times",@"Gill"];
    NSArray *fontNamesForItems = @[@"HelveticaNeue",@"TimesNewRomanPSMT",@"GillSans"];
    NSArray *fontNamesForSelectedItems = @[@"HelveticaNeue-Bold",@"TimesNewRomanPS-BoldMT",@"GillSans-Bold"];
    UISegmentedControl *fontNameSelector = [[UISegmentedControl alloc]initWithItems:fontNames];
    UIFont *font = [UIFont boldSystemFontOfSize:10.0];
    NSDictionary *attributes = @{UITextAttributeFont:font};
    [fontNameSelector setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    fontNameSelector.frame = CGRectMake(20.0, 54.0, 200, 40);
    
    if (!self.selected) {
        for (int num = 0 ; num < [fontNamesForItems count]; num++) {
            if ([self.font.fontName isEqualToString: fontNamesForItems[num]]) {
                fontNameSelector.selectedSegmentIndex = num;
            }
        }
    } else {
        for (int num = 0 ; num < [fontNamesForSelectedItems count]; num++) {
            if ([self.font.fontName isEqualToString: fontNamesForSelectedItems[num]]) {
                fontNameSelector.selectedSegmentIndex = num;
            }
        }
    }
    [fontNameSelector addTarget:self action:@selector(changeFontName:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:fontNameSelector];
    
    // fontSize label
    UILabel *fontSizeTitle = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 120.0, 70.0, 21.0)];
    fontSizeTitle.backgroundColor = [UIColor clearColor];
    fontSizeTitle.text = @"Font size";
    [self addSubview:fontSizeTitle];
    
    // fontSize text field
    self.fontSizeValue = [[UITextField alloc]initWithFrame:CGRectMake(150.0, 120.0, 70.0, 25.0)];
    self.fontSizeValue.borderStyle = UITextBorderStyleRoundedRect;
    [self.fontSizeValue setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    CGFloat currentFontSize = self.font.pointSize;
    
    [self.fontSizeValue addTarget:self action:@selector(changeFontSize:) forControlEvents:UIControlEventEditingChanged];
    self.fontSizeValue.text = [NSString stringWithFormat:@"%.2f",currentFontSize];
    
    
    [self addSubview:self.fontSizeValue];
    
    // fontSize slider
    self.fontSizeSlider = [[UISlider alloc]initWithFrame:CGRectMake(20.0, 150.0, 200.0, 23.0)];
    self.fontSizeSlider.minimumValue = 4.0;
    self.fontSizeSlider.maximumValue = 100.0;
    self.fontSizeSlider.value = [self.fontSizeValue.text floatValue];
    [self.fontSizeSlider addTarget:self action:@selector(fontSizeSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.fontSizeSlider];
    
    // fontColor title
    UILabel *fontColorTitle = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 185.0, 150.0, 21.0)];
    fontColorTitle.backgroundColor = [UIColor clearColor];
    fontColorTitle.text = @"Font color";
    [self addSubview:fontColorTitle];
    
    // fontColor sample color
    self.sampleColor = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 180.0, 200.0, 100.0)];
    self.sampleColor.backgroundColor = [UIColor clearColor];
    self.sampleColor.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:80.0];
    self.sampleColor.text = @"a";
    self.sampleColor.textColor = self.color;
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
    


}

- (void)changeFontName:(UISegmentedControl *)sender
{
    NSArray *fontNamesForItems = @[@"HelveticaNeue",@"TimesNewRomanPSMT",@"GillSans"];
    NSArray *fontNamesForSelectedItems = @[@"HelveticaNeue-Bold",@"TimesNewRomanPS-BoldMT",@"GillSans-Bold"];
    
    
    if (!self.selected) {
        self.font = [UIFont fontWithName:fontNamesForItems[sender.selectedSegmentIndex] size:self.font.pointSize];
        [self.delegate fontForItem:self.font];
    }else {
        self.font = [UIFont fontWithName:fontNamesForSelectedItems[sender.selectedSegmentIndex] size:self.font.pointSize];
        [self.delegate fontForSelectedItem:self.font];
    }
}

- (void)changeFontSize:(UITextField *)sender
{
    if ([sender.text floatValue] > self.fontSizeSlider.maximumValue) sender.text = [NSString stringWithFormat:@"%.2f",self.fontSizeSlider.maximumValue];
    if ([sender.text floatValue] < self.fontSizeSlider.minimumValue) sender.text = [NSString stringWithFormat:@"%.2f",self.fontSizeSlider.minimumValue];
    if (!self.selected) {
        self.font = [UIFont fontWithName:self.font.fontName size:[sender.text floatValue]];
        [self.delegate fontForItem:self.font];
    }else {
        self.font = [UIFont fontWithName:self.font.fontName size:[sender.text floatValue]];
        [self.delegate fontForSelectedItem:self.font];
    }

    self.fontSizeSlider.value = [sender.text floatValue];
}

- (void)fontSizeSliderChanged:(UISlider *)sender
{
    self.fontSizeValue.text = [NSString stringWithFormat:@"%.2f",sender.value];
    if (!self.selected) {
        self.font = [UIFont fontWithName:self.font.fontName size:sender.value];
        [self.delegate fontForItem:self.font];
    }else {
        self.font = [UIFont fontWithName:self.font.fontName size:sender.value];
        [self.delegate fontForSelectedItem:self.font];
    }

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
    if (!self.selected) [self.delegate colorForFont:self.color];
    else [self.delegate colorForSelectedFont:self.color];
    self.sampleColor.textColor = self.color;
    
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

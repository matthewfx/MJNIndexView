//
//  ExamplesSettings.m
//  MJNIndexForTableView
//
//  Created by Mateusz Nuckowski on 18/07/13.
//  Copyright (c) 2013 Mateusz Nuckowski. All rights reserved.
//

#import "ExamplesSettings.h"

@interface ExamplesSettings ()

@property (nonatomic, strong) UISwitch *example1;
@property (nonatomic, strong) UISwitch *example2;
@property (nonatomic, strong) UISwitch *example3;
@property (nonatomic, strong) UISwitch *example4;
@property (nonatomic, strong) UISwitch *example5;

@property (nonatomic, assign) BOOL after;

@property(nonatomic, strong) NSMutableArray *allExamples;

@property (nonatomic, assign) CGFloat prevX;

@end

@implementation ExamplesSettings

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithExamples:(NSArray *)examples andGettingSelectedAfterPan:(BOOL)after
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.allExamples = [examples mutableCopy];
        self.after = after;
        [self drawElements];
    }
    
    
    
    return self;
}

- (void) drawElements
{
    // title label
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 20.0, 210.0, 21.0)];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"Choose example";
    [self addSubview:title];
    
    
    // examples switches
    
    // ex1 label
    UILabel *example1Label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 53.0, 80.0, 21.0)];
    example1Label.font = [UIFont fontWithName:example1Label.font.fontName size:15.0];
    example1Label.backgroundColor = [UIColor clearColor];
    example1Label.text = @"Example 1";
    [self addSubview:example1Label];
    
    // ex1 switch
    self.example1 = [[UISwitch alloc]initWithFrame:CGRectMake(141, 50.0, 79.0, 27.0)];
    self.example1.on = [self.allExamples[0] boolValue];
    self.example1.tag = 1;
    [self.example1 addTarget:self action:@selector(exChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.example1];
    
    // ex2 label
    UILabel *example2Label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 88.0, 100.0, 21.0)];
    example2Label.font = [UIFont fontWithName:example2Label.font.fontName size:15.0];
    example2Label.backgroundColor = [UIColor clearColor];
    example2Label.text = @"Example 2";
    [self addSubview:example2Label];
    
    // ex2 switch
    self.example2 = [[UISwitch alloc]initWithFrame:CGRectMake(141.0, 85.0, 79.0, 27.0)];
    self.example2.on = [self.allExamples[1] boolValue];
    self.example2.tag = 2;
    [self.example2 addTarget:self action:@selector(exChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.example2];
    
    // ex3 label
    UILabel *example3Label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 123.0, 110.0, 21.0)];
    example3Label.font = [UIFont fontWithName:example3Label.font.fontName size:15.0];
    example3Label.backgroundColor = [UIColor clearColor];
    example3Label.text = @"Example 3";
    [self addSubview:example3Label];
    
    // ex3 switch
    self.example3 = [[UISwitch alloc]initWithFrame:CGRectMake(141, 120.0, 79.0, 27.0)];
    self.example3.on = [self.allExamples[2] boolValue];
    self.example3.tag = 3;
    [self.example3 addTarget:self action:@selector(exChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.example3];
    
    // ex4 label
    UILabel *example4Label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 158.0, 110.0, 21.0)];
    example4Label.font = [UIFont fontWithName:example4Label.font.fontName size:15.0];
    example4Label.backgroundColor = [UIColor clearColor];
    example4Label.text = @"Example 4";
    [self addSubview:example4Label];
    
    // ex4 switch
    self.example4 = [[UISwitch alloc]initWithFrame:CGRectMake(141, 155.0, 79.0, 27.0)];
    self.example4.on = [self.allExamples[3] boolValue];
    self.example4.tag = 4;
    [self.example4 addTarget:self action:@selector(exChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.example4];
    
    // ex5 label
    UILabel *example5Label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 193.0, 110.0, 21.0)];
    example5Label.font = [UIFont fontWithName:example5Label.font.fontName size:15.0];
    example5Label.backgroundColor = [UIColor clearColor];
    example5Label.text = @"Example 5";
    [self addSubview:example5Label];
    
    // ex5 switch
    self.example5 = [[UISwitch alloc]initWithFrame:CGRectMake(141, 190.0, 79.0, 27.0)];
    self.example5.on = [self.allExamples[4] boolValue];
    self.example5.tag = 5;
    [self.example5 addTarget:self action:@selector(exChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.example5];
    
    // getSelected title label
    UILabel *getSelTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 240.0, 100.0, 152.0)];
    getSelTitleLabel.font = [UIFont fontWithName:getSelTitleLabel.font.fontName size:15.0];
    getSelTitleLabel.numberOfLines = 7;
    getSelTitleLabel.backgroundColor = [UIColor clearColor];
    getSelTitleLabel.text = @"Getting the selected index item after the panning is finished";
    [self addSubview: getSelTitleLabel];

    
    // getSelected switch
    UISwitch *getSel = [[UISwitch alloc]initWithFrame:CGRectMake(141, 300.0, 79.0, 27.0)];
    getSel.on = self.after;
    [getSel addTarget:self action:@selector(selectedChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:getSel];

    
}

- (void)enabledDisabled
{
    [self.delegate close];
    [self.example1 setOn:[self.allExamples[0] boolValue] animated:YES];
    [self.example2 setOn:[self.allExamples[1] boolValue] animated:YES];
    [self.example3 setOn:[self.allExamples[2] boolValue] animated:YES];
    [self.example4 setOn:[self.allExamples[3] boolValue] animated:YES];
    [self.example5 setOn:[self.allExamples[4] boolValue] animated:YES];
    
    BOOL allOff;
    for (NSNumber *ex in self.allExamples) {
        allOff = [ex boolValue];
        if ([ex boolValue]) break;
    }
    if (!allOff) {
        [self.example1 setOn:YES animated:YES];
        self.allExamples[0] = @(1);
    }
}

- (void)exChange:(UISwitch *)sender
{
    self.allExamples = [@[@(0),@(0),@(0),@(0),@(0)] mutableCopy];
    self.allExamples[sender.tag -1] = @(sender.on);
    [self enabledDisabled];
    [self.delegate examplesSettingsForDemo:self.allExamples andGettingSelectedAfterPan:self.after];
    
}

- (void)selectedChange:(UISwitch *)sender
{
    self.after = sender.on;
    [self.delegate examplesSettingsForDemo:self.allExamples andGettingSelectedAfterPan:self.after];

}


// method for swipe to close

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint tappedPt = [[touches anyObject] locationInView: self];
    self.prevX = tappedPt.x;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint tappedPt = [[touches anyObject] locationInView: self];
    CGFloat currentX = tappedPt.x;
    if (self.prevX - currentX > 20.0) [self.delegate close];
}
@end

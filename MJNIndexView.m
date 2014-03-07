/*
 Copyright (c) 2013, Mateusz Nuckowski.
 www.mateusz.nuckowski.com
 www.appcowboys.com
 All rights reserved.
 
 This UIControl was inspired by Languages app by Jeremy's Olson Tapity.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of the source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */

#import "MJNIndexView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>




@interface MJNIndexView ()

// item properties
@property (nonatomic, strong) NSArray *indexItems;
@property (nonatomic, strong) NSArray *itemsAtrributes;

@property (nonatomic, strong) NSNumber *section;

// sizes for items
@property (nonatomic) CGFloat itemsOffset;
@property (nonatomic) CGPoint firstItemOrigin;
@property (nonatomic) CGSize indexSize;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic) BOOL animate;
@property (nonatomic) int actualRangeOfDeflection;

// curtain properties
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic) BOOL curtain;
@property (nonatomic, assign) CGFloat curtainFadeFactor;

// easter eggs properties
@property (nonatomic, assign) BOOL dot;
@property (nonatomic, assign) int times;


@end

@implementation MJNIndexView
// we need to synthetise fontColor because we need our own setter and getter methods
@synthesize fontColor = _fontColor;

#define debug 0

#pragma mark getters

- (UIColor *)fontColor
{
//    if (debug == 1) {
//        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
//    }
    
    if (!_fontColor) {
        self.fontColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    }
    return _fontColor;
}


- (UIColor *)selectedItemFontColor
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    if (!_selectedItemFontColor) {
        _selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        
    }
    return _selectedItemFontColor;
}


#pragma mark setters


- (void)setCurtainColor:(UIColor *)curtainColor
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    _curtainColor = curtainColor;
    
}



- (void)setFontColor:(UIColor *)fontColor
{
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    // we need to convert grayColor, whiteColor and blackColor to RGB;
    if ([fontColor isEqual:[UIColor grayColor]]) {
        _fontColor = [UIColor colorWithRed:0.5
                                     green:0.5
                                      blue:0.5
                                     alpha:1.0];
    } else if ([fontColor isEqual:[UIColor blackColor]]) {
        _fontColor = [UIColor colorWithRed:0.0
                                     green:0.0
                                      blue:0.0
                                     alpha:1.0];
    } else if ([fontColor isEqual:[UIColor whiteColor]]) {
        _fontColor = [UIColor colorWithRed:1.0
                                     green:1.0
                                      blue:1.0
                                     alpha:1.0];
    } else _fontColor = fontColor;
}

- (void)setCurtainFade:(CGFloat)curtainFade
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.gradientLayer) {
        [self.gradientLayer removeFromSuperlayer];
        self.gradientLayer = nil;
    }
    _curtainFade = curtainFade;
}


- (void)setDataSource:(id<MJNIndexViewDataSource>)dataSource
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    _dataSource = dataSource;
    self.indexItems = [dataSource sectionIndexTitlesForMJNIndexView:self];
}


#pragma mark view lifecycle methods

- (id)initWithFrame:(CGRect)frame
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        // initialising all default values
        self.backgroundColor = [UIColor clearColor];
        self.darkening = YES;
        self.fading = YES;
        self.itemsAligment = NSTextAlignmentCenter;
        self.upperMargin = 20.0;
        self.lowerMargin = 20.0;
        self.rightMargin = 10.0;
        self.maxItemDeflection = 100.0;
        self.rangeOfDeflection = 3;
        self.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        self.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue" size:50.0];
        self.ergonomicHeight = YES;
        self.maxValueForErgonomicHeight = 400.0;
        self.minimumGapBetweenItems = 5.0;
        self.getSelectedItemsAfterPanGestureIsFinished = YES;
    }
    return self;
}


- (id)init
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    self = [self initWithFrame:CGRectZero];
    return self;
}


- (void)didMoveToSuperview
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    [self getAllItemsSize];
    [self initialiseAllAttributes];
    [self resetPosition];
}

// refreshing our index items
- (void)refreshIndexItems
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    // if items existed we have to remove all sublayers from main layer
    if (self.itemsAtrributes) {
        for (NSDictionary *item in self.itemsAtrributes) {
            CALayer *layer = item[@"layer"];
            [layer removeFromSuperlayer];
        }
        self.itemsAtrributes = nil;
    }
    
//    if (self.gradientLayer) [self.gradientLayer removeFromSuperlayer];
    
    
    self.indexItems = [self.dataSource sectionIndexTitlesForMJNIndexView:self];
    [self getAllItemsSize];
    [self initialiseAllAttributes];
    [self resetPosition];
}


#pragma mark calculating initial values and sizes then setting them
// calculating all necessary sizes and values to draw index items
- (void)getAllItemsSize
{
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    CGSize indexSize = CGSizeZero;
    
    // determining font sizes
    CGFloat lineHeight = self.font.lineHeight;
    CGFloat maxlineHeight = self.selectedItemFont.capHeight;
    CGFloat capitalLetterHeight = self.font.capHeight;
    CGFloat ascender = self.font.ascender;
    CGFloat descender = - self.font.descender;
    CGFloat entireHeight = ascender;
    
    // checking for upper and lower case letters and setting entireHeight value accordingly
    if ([self checkForLowerCase] && [self checkForUpperCase]) {
        entireHeight = lineHeight;
        maxlineHeight = self.selectedItemFont.lineHeight;
    } else if ([self checkForLowerCase] && ![self checkForUpperCase]) {
        entireHeight = capitalLetterHeight + descender;
        maxlineHeight = self.selectedItemFont.lineHeight;
    }
    
    // calculating size of all index items
    for (NSString *item in self.indexItems) {
        CGSize currentItemSize = [item sizeWithFont:self.font];
        
        // if index items are smaller than 5.0 points display alert and do not display index at all
        if (currentItemSize.height < 5.0) {
            //[NSException raise:@"Too many items in index" format:@"Items are to small to be legible"];
            NSLog(@" ******* Too many items in index. Items are too small to be legible. Index won't be displayed. *******");
            return;
        }
        indexSize.height += entireHeight;
        if (currentItemSize.width > indexSize.width) {
            indexSize.width = currentItemSize.width;
        }
    }
    
    // calculating if deflectionRange is not too small based on the width of the longest index item using the font for selected item
    for (NSString *item in self.indexItems) {
        CGSize currentItemSize = [item sizeWithFont:self.selectedItemFont];
        if (currentItemSize.width > self.maxWidth) {
            self.maxWidth = currentItemSize.width;
        }
        if (currentItemSize.width > self.maxItemDeflection) {
            self.maxItemDeflection = currentItemSize.width;
        }
        if (currentItemSize.height > self.maxHeight) {
            self.maxHeight = currentItemSize.height;
        }
    }
    
    // ajdusting margins to ensure that minimum offset is 5.0 points
    CGFloat optimalIndexHeight = indexSize.height;
    if (optimalIndexHeight > self.maxValueForErgonomicHeight) optimalIndexHeight = self.maxValueForErgonomicHeight;
    CGFloat offsetRatio = self.minimumGapBetweenItems * (float)([self.indexItems count]-1) + optimalIndexHeight + maxlineHeight / 1.5;
    if (self.ergonomicHeight && (self.bounds.size.height - offsetRatio > 0.0)) {
        self.upperMargin = (self.bounds.size.height - offsetRatio)/2.0;
        self.lowerMargin = self.upperMargin;
    }
    
    // checking if self.font size is not to large to draw entire index - if it's calculating the largest possible using recurency
    if (indexSize.height  > self.bounds.size.height - (self.upperMargin + self.lowerMargin) - (self.minimumGapBetweenItems * [self.indexItems count])) {
        self.font = [self.font fontWithSize:(self.font.pointSize - 0.1)];
        [self getAllItemsSize];
        
    } else {
        // calculating an offset between index items
        self.itemsOffset = ((self.bounds.size.height - (self.upperMargin + self.lowerMargin + maxlineHeight / 1.5)) - indexSize.height) / (float)([self.indexItems count]-1);
        
        


        // calculating the first item origin based on the offset, an items aligment and marging
        if (self.itemsAligment == NSTextAlignmentRight) {
            self.firstItemOrigin = CGPointMake(self.bounds.size.width - self.rightMargin,
                                               self.upperMargin + maxlineHeight / 2.5 + entireHeight / 2.0);
            
        } else if (self.itemsAligment == NSTextAlignmentCenter) {
            self.firstItemOrigin = CGPointMake(self.bounds.size.width - self.rightMargin - indexSize.width/2,
                                               self.upperMargin + maxlineHeight / 2.5 + entireHeight / 2.0);
            
        } else self.firstItemOrigin = CGPointMake(self.bounds.size.width - self.rightMargin - indexSize.width,
                                                  self.upperMargin + maxlineHeight / 2.5 + entireHeight / 2.0);
        
        // 
        self.itemsOffset += entireHeight;
        self.indexSize = indexSize;
    }
    
    // checking if range of items to deflect is not too big
    if (self.indexItems.count == 1) {
        // if there is only one item in index there is no need to animate index
        self.actualRangeOfDeflection = 0;
    } else if (self.rangeOfDeflection > ([self.indexItems count]/2 - 1)) { // if items range of deflection is bigger than half of items in index we should set it to exact half of items number
        self.actualRangeOfDeflection = [self.indexItems count]/2;
    } else self.actualRangeOfDeflection = self.rangeOfDeflection;
}


// checking if there are any items with lower case
- (BOOL)checkForLowerCase
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    NSCharacterSet *lowerCaseSet = [NSCharacterSet lowercaseLetterCharacterSet];
    for (NSString *item in self.indexItems) {
        if ([item rangeOfCharacterFromSet:lowerCaseSet].location != NSNotFound) return YES;
    }
    return NO;
}


// checking ig there are any items with upper case
- (BOOL)checkForUpperCase
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    NSCharacterSet *upperCaseSet = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSString *item in self.indexItems) {
        if ([item rangeOfCharacterFromSet:upperCaseSet].location != NSNotFound) return YES;
    }
    return NO;
}


- (void) initialiseAllAttributes
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    CGFloat verticalPos = self.firstItemOrigin.y;
    NSMutableArray *newItemsAttributes = [NSMutableArray new];
    
    int count = 0;
    
    for (NSString *item in self.indexItems) {
        
        // calculating items origins based on items aligment and firstItemOrigin
        CGPoint point;
        
        if (self.itemsAligment == NSTextAlignmentCenter){
            
            CGSize itemSize = [item sizeWithFont:self.font];
            point.x = self.firstItemOrigin.x - itemSize.width/2;
        } else if (self.itemsAligment == NSTextAlignmentRight) {
            
            CGSize itemSize = [item sizeWithFont:self.font];
            point.x = self.firstItemOrigin.x - itemSize.width;
        } else point.x = self.firstItemOrigin.x;
        
        point.y = verticalPos;
        NSValue *newValueForPoint = [NSValue valueWithCGPoint:point];
        
        
        if (!self.itemsAtrributes) {
            CATextLayer * singleItemTextLayer = [CATextLayer layer];
            
            NSNumber *alpha = @(CGColorGetAlpha([self.fontColor CGColor]));
            
            // setting zPosition a little above because we might need to put something below
            NSNumber *zPosition = @(5.0);
            
            NSCache *itemAttributes = [@{@"item":item,
                                                   @"origin":newValueForPoint,
                                                   @"position":newValueForPoint,
                                                   @"font":(__bridge_transfer id)CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL),
                                                   @"color":self.fontColor,
                                                   @"alpha":alpha,
                                                   @"zPosition":zPosition,
                                                   @"layer":singleItemTextLayer}mutableCopy];
            
            [newItemsAttributes addObject:itemAttributes];
        } else {
            self.itemsAtrributes[count][@"origin"] = newValueForPoint;
            self.itemsAtrributes[count][@"position"] = newValueForPoint;
        }
        
        verticalPos += self.itemsOffset;
        count ++;
        
        
    }
    if (self.curtainColor) [self addCurtain];
    if (!self.itemsAtrributes) self.itemsAtrributes = newItemsAttributes;
}


// reseting positions of index items
- (void) resetPosition
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    for (NSCache *itemAttributes in self.itemsAtrributes){
        CGPoint origin = [[itemAttributes objectForKey:@"origin"] CGPointValue];
        [itemAttributes setObject:[NSValue valueWithCGPoint:origin] forKey:@"position"];
        [itemAttributes setObject:(__bridge_transfer id)CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL) forKey:@"font"];
        [itemAttributes setObject:@(1.0) forKey:@"alpha"];
        [itemAttributes setObject:self.fontColor forKey:@"color"];
        [itemAttributes setObject:@(5.0) forKey:@"zPosition"];

    }
    
    [self drawIndex];
    [self setNeedsDisplay];
    
    self.animate = YES;
}


#pragma mark calculating item position during the pan gesture
- (void) positionForIndexItemsWhilePanLocation:(CGPoint)location
{    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    CGFloat verticalPos = self.firstItemOrigin.y;
  
    int section = 0;
    for (NSCache *itemAttributes in self.itemsAtrributes) {
        
        CGFloat alpha = [[itemAttributes objectForKey: @"alpha"] floatValue];
        CGPoint point = [[itemAttributes objectForKey:@"position"] CGPointValue];
        CGPoint origin = [[itemAttributes objectForKey:@"origin"] CGPointValue];
        CGFloat fontSize = [[itemAttributes objectForKey:@"fontSize"] floatValue];
        UIColor *fontColor;
        
        BOOL inRange = NO;
        
        // we have to map amplitude of deflection
        
        float mappedAmplitude = self.maxItemDeflection / self.itemsOffset / ((float)self.actualRangeOfDeflection);
        
        // now we are checking if touch is within the range of items we would like to deflect
        BOOL min = location.y > point.y - ((float)self.actualRangeOfDeflection * self.itemsOffset);
        BOOL max = location.y < point.y + ((float)self.actualRangeOfDeflection * self.itemsOffset);
        
        if (min && max) {
            
            // these calculations are necessary to make our deflection not linear
            float differenceMappedToAngle = 90.0 / (self.itemsOffset * (float)self.actualRangeOfDeflection);
            float angle = (fabs(point.y - location.y)* differenceMappedToAngle);
            float angleInRadians = angle * (M_PI/180);
            float arcusTan = fabs(atan(angleInRadians));
            
            // now we have to calculate the deflected position of an item
            point.x = origin.x - (self.maxItemDeflection) + (fabsf(point.y - location.y) * mappedAmplitude) * (arcusTan);
            
            point.x = MIN(point.x, origin.x);
            
            // we have to map difference to range in order to determine right zPosition
            float differenceMappedToRange = self.actualRangeOfDeflection / (self.actualRangeOfDeflection * self.itemsOffset);
    
            CGFloat zPosition = self.actualRangeOfDeflection - fabs(point.y - location.y) * differenceMappedToRange;
            
            [itemAttributes setObject:@(5.0 + zPosition) forKey:@"zPosition"];
            
            // calculating a fontIncrease factor of the deflected item
            CGFloat fontIncrease = (self.maxItemDeflection - (fabs(point.y - location.y)) *
                                    mappedAmplitude) / (self.maxItemDeflection / (self.selectedItemFont.pointSize - self.font.pointSize));
            
            fontIncrease = MAX(fontIncrease, 0.0);
            
            fontSize = self.font.pointSize + fontIncrease;
            
            // calculating a color darkening factor
            float differenceMappedToColorChange = 1.0 / (self.actualRangeOfDeflection * self.itemsOffset);
            CGFloat colorChange = fabs(point.y - location.y) * differenceMappedToColorChange;
            
            if (self.darkening) {
                fontColor = [self darkerColor:self.fontColor by: colorChange];
            } else fontColor = self.fontColor;
            
            // we're using the same factor for alpha (fading)
            if (self.fading) {
                alpha = colorChange;
            } else alpha = 1.0;
           
            [itemAttributes setObject:(__bridge_transfer id)CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, fontSize, NULL) forKey:@"font"];
            
            [itemAttributes setObject:fontColor forKey:@"color"];
            
            // checking if the item is the most deflected one -> it means it is the selected one 
            BOOL selectedInRange  = location.y > point.y - self.itemsOffset / 2.0 && location.y < point.y + self.itemsOffset / 2.0;
            // we need also to check if the selected item is the first or the last one in the index
            BOOL firstItemInRange = (section == 0 && (location.y < self.upperMargin + self.selectedItemFont.pointSize / 2.0));
            BOOL lastItemInRange = (section == [self.itemsAtrributes  count] - 1 &&
                                    location.y > self.bounds.size.height - (self.lowerMargin + self.selectedItemFont.pointSize / 2.0));
            
            // if our location is pointing to the selected item we have to change this item's font, color and make it's zPosition the largest to be sure it's on the top
            if (selectedInRange || firstItemInRange || lastItemInRange) {
                alpha = 1.0;
                
                [itemAttributes setObject:(__bridge_transfer id)CTFontCreateWithName((__bridge CFStringRef)self.selectedItemFont.fontName, fontSize, NULL) forKey:@"font"];
                [itemAttributes setObject:self.selectedItemFontColor forKey:@"color"];
                [itemAttributes setObject:@(10.0) forKey:@"zPosition"];
                if (!self.getSelectedItemsAfterPanGestureIsFinished && [self.section integerValue] != section) {
                    [self.dataSource sectionForSectionMJNIndexTitle:self.indexItems[section] atIndex:section];
                }
                self.section = @(section);

            }
            
            // we're marking these items as inRange items
            inRange = YES;

        }
        
        // if item is not in range we have to reset it's x position, alpha value, font name, size and color, zPosition
        if (!inRange) {
            
            point.x = origin.x;
            alpha = 1.0;
            [itemAttributes setObject:(__bridge_transfer id)CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL) forKey:@"font"];
            fontColor = self.fontColor;
            [itemAttributes setObject:self.fontColor forKey:@"color"];
            [itemAttributes setObject:@(5.0) forKey:@"zPosition"];
        }
        
        // we have to store some values in itemAtrributes array
        point.y = verticalPos;
        NSValue *newValueForPoint = [NSValue valueWithCGPoint:point];
        [itemAttributes setObject:newValueForPoint forKey:@"position"];
        [itemAttributes setObject:@(alpha) forKey:@"alpha"];
        verticalPos += self.itemsOffset;
        section ++;
    }
    
    // when are calculations are over we can redraw all items
    [self drawIndex];
    // we set this to NO because we want the animation duration to be as short as possible
    self.animate = NO;
}


// calculating darker color to the given one
- (UIColor *)darkerColor:(UIColor *)color by:(float)value
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    float h, s, b, a;
    if ([color getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * value
                               alpha:a];
    return nil;
}


#pragma mark drawing CATextLayers with indexitems
- (void) drawIndex
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    for (NSCache *itemAttributes in self.itemsAtrributes) {
        // getting attributes necessary to check if we need to animate
        
        CTFontRef currentFont = (__bridge CTFontRef)[itemAttributes objectForKey:@"font"];
        CATextLayer * singleItemTextLayer = [itemAttributes objectForKey:@"layer"];
        
        // checking if all CATexts exists
        if ([self.itemsAtrributes count] != [self.layer.sublayers count] - 1) {
            [self.layer addSublayer:singleItemTextLayer];
        }
        
        // checking if font size is different if it's different we have to animate CALayer
        if (singleItemTextLayer.fontSize != CTFontGetSize(currentFont)) {
            // we have to animate several CALayers at once
            [CATransaction begin];
            
            // if we need to animate faster we're changing the duration to be as short as possible
            
            if (!self.animate) [CATransaction setAnimationDuration:0.005];
            else [CATransaction setAnimationDuration:0.2];
            
            // getting other attributes and updading CALayer
            CGPoint point = [[itemAttributes objectForKey:@"position"] CGPointValue];
            NSString *currentItem = [itemAttributes objectForKey:@"item"];
            
            CFStringRef stringRef = (__bridge CFStringRef)currentItem;
            CFMutableAttributedStringRef attrStr = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
            CFAttributedStringReplaceString (attrStr, CFRangeMake(0, 0), stringRef);
            CTTextAlignment alignment = kCTJustifiedTextAlignment;
            CTParagraphStyleSetting _settings[] = { {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment} };
            CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(_settings, sizeof(_settings) / sizeof(_settings[0]));
            CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTParagraphStyleAttributeName, paragraphStyle);
            CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, currentFont);
            CFRelease(paragraphStyle);
            
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrStr);
            CFRelease(attrStr);
            
            CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, currentItem.length), NULL, CGSizeMake(self.maxWidth, self.maxHeight*2.0), NULL);
            CFRelease(framesetter);
            UIColor *fontColor = [itemAttributes objectForKey:@"color"];
            
            singleItemTextLayer.zPosition = [[itemAttributes objectForKey:@"zPosition"] floatValue];
            singleItemTextLayer.font = currentFont;
            singleItemTextLayer.fontSize = CTFontGetSize(currentFont);
            singleItemTextLayer.opacity = [[itemAttributes objectForKey:@"alpha"] floatValue];
            singleItemTextLayer.string = currentItem;
            singleItemTextLayer.backgroundColor = [UIColor clearColor].CGColor;
            singleItemTextLayer.foregroundColor = fontColor.CGColor;
            singleItemTextLayer.bounds = CGRectMake(0.0,
                                                    0.0,
                                                    textSize.width,
                                                    textSize.height);
            singleItemTextLayer.position = CGPointMake(point.x + textSize.width/2.0,
                                                       point.y);
            singleItemTextLayer.contentsScale = [[UIScreen mainScreen]scale];
            
            [CATransaction commit];
        
        }
    }
}


#pragma mark managing touch events

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    int section = 0;
    
    // checking if item any item is touched
    for (NSCache *itemAttributes in self.itemsAtrributes) {
        CGPoint point = [[itemAttributes objectForKey:@"position"] CGPointValue];
        CGPoint location = [touch locationInView:self];
        if (location.y > point.y - self.itemsOffset / 2.0  &&
            location.y < point.y + self.itemsOffset / 2.0) {
            self.section = @(section);
        }
        section ++;
    }
    self.dot = NO;
    return YES;
}


- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    CGFloat currentY = [touch locationInView:self].y;
    CGFloat prevY = [touch previousLocationInView:self].y;
    
    
    if (self.curtainColor) {
        [self showCurtain];
    }
    
        
    // if pan is longer than three pixel we need to accelerate animation by setting self.animate to NO
    if (fabs(currentY - prevY) > 3.0) {
        self.animate = NO;
    }
    // drawing deflection
    [self positionForIndexItemsWhilePanLocation:[touch locationInView:self]];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.indexItems && [self.indexItems count] > 0) {
        // sending selected items to dataSource
        [self.dataSource sectionForSectionMJNIndexTitle:self.indexItems[[self.section integerValue]] atIndex:[self.section integerValue]];
        
        
        // some easter eggs ;)
        if ([self.section integerValue] == 3 * self.times) {
            self.times ++;
            if (self.times == 5) {
                self.dot = YES;
                [self setNeedsDisplay];
            }
        } else self.times = 0;
        
        // if pan stopped we can deacellerate animation, reset position and hide curtain
        self.animate = YES;
        [self resetPosition];
        if (self.curtainColor) {
            [self hideCurtain];
        }
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    // if touch was canceled we reset everything
    self.animate = YES;
    [self resetPosition];
    if (self.curtainColor) {
        [self hideCurtain];
    }
    }

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    // UIView will be "transparent" for touch events if we return NO
    // we are going to return YES only if items or area right to them is being touched
    if ((point.x > self.bounds.size.width - (self.indexSize.width + self.rightMargin + 10.0)) &&
        point.y > 0.0 && point.y < self.bounds.size.height) return YES;
    //if (point.y > self.bounds.size.height) return NO;
    return NO;
}


#pragma drawing curtain with CAGradientLayer or CALayer

- (void)addCurtain
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    // if we want a curtain to fade we have to use CAGradientLayer
    if (self.curtainFade != 0.0) {
        if (self.curtainFade > 1) self.curtainFade = 1;
        if (!self.gradientLayer) {
            self.gradientLayer = [CAGradientLayer layer];
            [self.layer insertSublayer:self.gradientLayer atIndex:0];
        }
        
        // we have to read color components
        const CGFloat * colorComponents = CGColorGetComponents(self.curtainColor.CGColor);
        self.gradientLayer.colors = @[(id)[[UIColor colorWithRed:colorComponents[0]
                                                           green:colorComponents[1]
                                                            blue:colorComponents[2]
                                                           alpha:0.0] CGColor],(id)[self.curtainColor CGColor]];
        
        // calculating endPoint for gradient based on maxItemDeflection and maxWidth of longest selected item
        self.curtainFadeFactor = (self.bounds.size.width - self.rightMargin - self.maxItemDeflection - 0.25 * self.maxWidth - 15.0) / self.bounds.size.width;
        self.gradientLayer.startPoint = CGPointMake(self.curtainFadeFactor - (self.curtainFade * self.curtainFadeFactor),
                                                    0.0);
        self.gradientLayer.endPoint = CGPointMake(MAX(self.curtainFadeFactor,0.02),
                                                  0.0);
        
        
    } else {
        
        // if we do not need the fading curtain we can use simple CALayer
        if (!self.gradientLayer) {
            self.gradientLayer = [CALayer layer];
            [self.layer insertSublayer:self.gradientLayer atIndex:0];
        }
        self.gradientLayer.backgroundColor = self.curtainColor.CGColor;
    }
   
    // curtain is added now we have to hide it first
    self.curtain = YES;
    if (self.curtainColor) {
        [self hideCurtain];
    }
}

// hiding the curtain
- (void)hideCurtain
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    // first we have to check if the curtain is shown and a color for it is set
    if (self.curtain && self.curtainColor) {
        CGRect curtainBoundsRect;
        CGFloat curtainVerticalCenter;
        CGFloat curtainHorizontalCenter;
        CGFloat multiplier = 2.0;
        
        if (!self.curtainMargins) {
            curtainBoundsRect = CGRectMake(0.0,
                                           0.0,
                                           self.indexSize.width * multiplier + self.rightMargin,
                                           self.bounds.size.height);
            curtainVerticalCenter = self.bounds.size.height / 2.0;
        }
        else {
            // if we need cutain to have the same margins as index items we have to change its height and its vertical center
            curtainBoundsRect = CGRectMake(0.0,
                                           0.0,
                                           self.indexSize.width * multiplier + self.rightMargin,
                                           self.bounds.size.height - (self.upperMargin + self.lowerMargin));
            curtainVerticalCenter = self.upperMargin + curtainBoundsRect.size.height / 2.0;
        }
        
        
        if (!self.curtainStays) {
            curtainHorizontalCenter = self.bounds.size.width + self.bounds.size.width / 2.0;
         
        } else {
            // if we don't want the curtain to hide completely we have again to check if we need margins or not and change its height respectively
            if (self.curtainMargins) curtainBoundsRect = CGRectMake(0.0,
                                                                    0.0,
                                                                    self.bounds.size.width,
                                                                    self.bounds.size.height - (self.upperMargin + self.lowerMargin));
            else curtainBoundsRect = self.bounds;
            
            
            // now we need to calculate an offset needed to position curtain not entirely outside the screen
            // to do this we must check items aligment and calculate horizontal center for its position
            CGFloat offset;
            if (self.itemsAligment == NSTextAlignmentRight) offset = self.bounds.size.width - (self.firstItemOrigin.x  - self.indexSize.width/2.0);
            else if (self.itemsAligment == NSTextAlignmentCenter) offset =  (self.bounds.size.width - self.firstItemOrigin.x);
            else offset = (self.bounds.size.width - (self.firstItemOrigin.x +  self.indexSize.width/2.0));
            
            curtainHorizontalCenter = (self.bounds.size.width + self.bounds.size.width / 2.0) -  2 * offset;
            
            // if we are using CAGradientLayer we have to change horizonl center value and recalculate the start and endpoint for gradient
            if ([self.gradientLayer.class isSubclassOfClass:[CAGradientLayer class]]) {
                
                curtainHorizontalCenter = (self.bounds.size.width + self.bounds.size.width / 2.0) -  (2.0  * offset + self.curtainFade * offset);
                
                self.gradientLayer.startPoint = CGPointMake(0.001,
                                                            0.0);
                
                self.gradientLayer.endPoint = CGPointMake(MAX(self.curtainFade,
                                                              300.0 * self.gradientLayer.startPoint.x) * 00.1, 0.0);
            }
        }
        
        // now we can set the courtain bounds and position andset the BOOL self.curtain to NO which meanse the curtain is hidden
        self.gradientLayer.bounds = curtainBoundsRect;
        self.gradientLayer.position = CGPointMake(curtainHorizontalCenter, curtainVerticalCenter);
        self.curtain = NO;
    }
}


// showing the curtain
- (void)showCurtain
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    // first we have to check if the curtain is shown and a color for it is set
    if (!self.curtain && self.curtainColor && self.curtainMoves && self.actualRangeOfDeflection > 0) {
        CGFloat curtainVerticalCenter;
        CGRect curtainBoundsRect;
        
        // again like in case for hideCurtain we must calculate position and size for all possible configurations
        if (!self.curtainMargins) {
            curtainBoundsRect = self.bounds;
            curtainVerticalCenter = self.bounds.size.height / 2.0;
        } else {
            curtainBoundsRect = CGRectMake(0.0, self.upperMargin, self.bounds.size.width, self.bounds.size.height - (self.upperMargin + self.lowerMargin));
            curtainVerticalCenter = self.upperMargin + curtainBoundsRect.size.height / 2.0;
        }
        
        if ([self.gradientLayer.class isSubclassOfClass:[CAGradientLayer class]]) {
            // we need to use CATransaction because we need the animation to bee faster
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.075];
            
            self.gradientLayer.bounds = curtainBoundsRect;
            self.gradientLayer.startPoint = CGPointMake(MAX(self.curtainFadeFactor - (self.curtainFade * self.curtainFadeFactor),0.001), 0.0);
            self.gradientLayer.endPoint = CGPointMake(MAX(self.curtainFadeFactor,0.3), 0.0);
                        self.gradientLayer.position = CGPointMake(self.bounds.size.width / 2.0, curtainVerticalCenter);
            [CATransaction commit];
        } else {
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.075];
            
            self.gradientLayer.bounds = curtainBoundsRect;
            self.gradientLayer.position = CGPointMake((self.bounds.size.width - self.rightMargin - self.maxItemDeflection - 0.25 * self.maxWidth - 15.0) + self.bounds.size.width / 2.0, curtainVerticalCenter);
            [CATransaction commit];
        };
        
        self.curtain = YES;
    }

    
}

// drawing text labels for test purposes only
- (void)drawLabel:(NSString *)label withFont:(UIFont *)font forSize:(CGSize)size
          atPoint:(CGPoint)point withAlignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreak color:(UIColor *)color
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    // obtain current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // save context state first
    CGContextSaveGState(context);
    
    
    // obtain size of drawn label
    CGSize newSize = [label sizeWithFont:font
                       constrainedToSize:size
                           lineBreakMode:lineBreak];
    
    // determine correct rect for this label
    CGRect rect = CGRectMake(point.x, point.y,
                             newSize.width, newSize.height);
    
    // set text color in context
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    // draw text
    [label drawInRect:rect
             withFont:font
        lineBreakMode:lineBreak
            alignment:alignment];
    
    // restore context state
    CGContextRestoreGState(context);
}


// drawing rectangles - for test purposes only
- (void)drawTestRectangleAtPoint:(CGPoint)p withSize:(CGSize)size red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(p.x, p.y, size.width, size.height);
    CGContextAddRect(context, rect);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
}

// our drawRect - for test purposee only
- (void)drawRect:(CGRect)rect
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'",self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.dot) {
        [self drawTestRectangleAtPoint:CGPointMake(self.bounds.size.width / 2.0 - 100.0, self.bounds.size.height / 2.0 - 100.0)
                              withSize:CGSizeMake(200.0, 200.0)
                                   red:1.0
                                 green:1.0
                                  blue:1.0
                                 alpha:1.0];
        
        [self drawLabel:@"Index for tableView designed by mateusz@ nuckowski.com"
               withFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25.0]
                forSize:CGSizeMake(175.0, 150.0)
                atPoint:CGPointMake(self.bounds.size.width / 2.0 - 78.0, self.bounds.size.height / 2.0 - 80.0)
          withAlignment:NSTextAlignmentCenter
          lineBreakMode:NSLineBreakByWordWrapping
                  color:[UIColor colorWithRed:0.0 green:105.0/255.0 blue:240.0/255.0 alpha:1.0]];
    }

}


@end

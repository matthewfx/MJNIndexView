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

#import <UIKit/UIKit.h>

@class MJNIndexView;

@protocol MJNIndexViewDataSource

// you have to implement this method to provide this UIControl with NSArray of items you want to display in your index
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView;

// you have to implement this method to get the selected index item 
- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index;

@end


@interface MJNIndexView : UIControl

@property (nonatomic, weak) id <MJNIndexViewDataSource> dataSource;


// FOR ALL COLORS USE RGB MODEL - DON'T USE whiteColor, blackColor, grayColor or colorWithWhite, colorWithHue

// set this to NO if you want to get selected items during the pan (default is YES)
@property (nonatomic, assign) BOOL getSelectedItemsAfterPanGestureIsFinished;

/* set the font and size of index items (if font size you choose is too large it will be automatically adjusted to the largest possible)
(default is HelveticaNeue 15.0 points)*/
@property (nonatomic, strong) UIFont *font;

/* set the font of the selected index item (usually you should choose the same font with a bold style and much larger)
(default is the same font as previous one with size 40.0 points) */
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

// set the right margin of index items (default is 10.0 points)
@property (nonatomic, assign) CGFloat rightMargin;

/* set the upper margin of index items (default is 20.0 points)
please remember that margins are set for the largest size of selected item font*/
@property (nonatomic, assign) CGFloat upperMargin;

// set the lower margin of index items (default is 20.0 points)
// please remember that margins are set for the largest size of selected item font
@property (nonatomic, assign) CGFloat lowerMargin;

// set the maximum amount for item deflection (default is 75.0 points)
@property (nonatomic,assign) CGFloat maxItemDeflection;

// set the number of items deflected below and above the selected one (default is 3 items)
@property (nonatomic, assign) int rangeOfDeflection;

// set the curtain color if you want a curtain to appear (default is none)
@property (nonatomic, strong) UIColor *curtainColor;

// set the amount of fading for the curtain between 0 to 1 (default is 0.2)
@property (nonatomic, assign) CGFloat curtainFade;

// set if you need a curtain not to hide completely (default is NO)
@property (nonatomic, assign) BOOL curtainStays;

// set if you want a curtain to move while panning (default is NO)
@property (nonatomic, assign) BOOL curtainMoves;

// set if you need a curtain to have the same upper and lower margins (default is NO)
@property (nonatomic, assign) BOOL curtainMargins;

// set the minimum gap between item (default is 5.0 points)
@property (nonatomic, assign) CGFloat minimumGapBetweenItems;

// set this property to YES and it will automatically set margins so that gaps between items are set to the minimumItemGap value (default is YES)
@property BOOL ergonomicHeight;

// set the maximum height for index egronomicHeight - it might be useful for iPad (default is 400.0 ponts)
@property (nonatomic, assign) CGFloat maxValueForErgonomicHeight;



// use this method if you want to change index items or change some properties for layout
- (void)refreshIndexItems;


@end

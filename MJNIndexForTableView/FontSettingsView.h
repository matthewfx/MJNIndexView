//
//  FontSettingsView.h
//  MJNIndexForTableView
//
//  Created by Mateusz Nuckowski on 13/07/13.
//  Copyright (c) 2013 Mateusz Nuckowski. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FontSettingsView;

@protocol FontSettingsViewDelegate <NSObject>

- (void)fontForItem:(UIFont *)font;
- (void)fontForSelectedItem:(UIFont *)font;
- (void)colorForFont:(UIColor *)color;
- (void)colorForSelectedFont:(UIColor *)color;
- (void)close;

@end



@interface FontSettingsView : UIView

@property (nonatomic, weak) id <FontSettingsViewDelegate> delegate;


-(id)initWithFont:(UIFont *)font fontColor:(UIColor *)color forSelectedItem:(BOOL)selected;


@end

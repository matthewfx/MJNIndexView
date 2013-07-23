//
//  LayoutSettingsView.h
//  MJNIndexForTableView
//
//  Created by Mateusz Nuckowski on 14/07/13.
//  Copyright (c) 2013 Mateusz Nuckowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LayoutSettingsView;

@protocol LayoutSettingsViewDelegate <NSObject>

- (void)layoutSettingForIndexItems:(NSDictionary *)settings;
- (void)close;

@end

@interface LayoutSettingsView : UIView

@property (nonatomic, weak) id <LayoutSettingsViewDelegate> delegate;

-(id)initWithDeflectionRange:(int)range
               maxDeflection:(CGFloat)maxDef
                itemAligment:(NSTextAlignment)aligment
                 rightMargin:(CGFloat)rightM
                 upperMargin:(CGFloat)upperM
                 lowerMargin:(CGFloat)lowerM
                   darkening:(BOOL)darkening
                      fading:(BOOL)fading
                  ergoHeight:(BOOL)ergo;

@end

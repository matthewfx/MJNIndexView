//
//  ExamplesSettings.h
//  MJNIndexForTableView
//
//  Created by Mateusz Nuckowski on 18/07/13.
//  Copyright (c) 2013 Mateusz Nuckowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExamplesSettings;

@protocol ExampleSettingsViewDelegate <NSObject>

- (void)examplesSettingsForDemo:(NSArray *)examples andGettingSelectedAfterPan:(BOOL)after;
- (void)close;

@end

@interface ExamplesSettings : UIView

@property (nonatomic, weak) id <ExampleSettingsViewDelegate> delegate;


- (id)initWithExamples:(NSArray *)examples andGettingSelectedAfterPan:(BOOL)after;

@end

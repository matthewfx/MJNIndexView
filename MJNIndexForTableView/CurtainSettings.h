//
//  CurtainSettings.h
//  MJNIndexForTableView
//
//  Created by Mateusz Nuckowski on 14/07/13.
//  Copyright (c) 2013 Mateusz Nuckowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CurtainSettings;

@protocol CurtainSettingsViewDelegate <NSObject>

- (void)fadeForCurtain: (CGFloat) fade;
- (void)colorForCurtain:(UIColor *)color;
- (void)marginsForCurtain:(BOOL) margins;
- (void)staysForCurtain:(BOOL) stays;
- (void)close;

@end

@interface CurtainSettings : UIView

@property (nonatomic, weak) id <CurtainSettingsViewDelegate> delegate;





-(id)initWithCurtainColor:(UIColor *)color fade:(CGFloat)fade margins:(BOOL)margins stays:(BOOL)stays;

@end

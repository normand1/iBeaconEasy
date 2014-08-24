//
//  coloredCircleView.h
//  iBeaconEasy
//
//  Created by davinorm on 8/24/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface coloredCircleView : UIView

@property(nonatomic, strong)UIColor *colorForCircle;

-(void)drawRect:(CGRect)rect;

@end

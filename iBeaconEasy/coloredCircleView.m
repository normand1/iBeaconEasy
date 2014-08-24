//
//  coloredCircleView.m
//  iBeaconEasy
//
//  Created by davinorm on 8/24/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#import "coloredCircleView.h"

@implementation coloredCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* color = self.colorForCircle;
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(1, .5, 40, 40)];
    [color setFill];
    [ovalPath fill];
    [[UIColor blackColor] setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];

}


@end

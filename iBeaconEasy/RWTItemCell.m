//
//  RWTItemCell.m
//  ForgetMeNot
//
//  Created by Chris Wagner on 1/30/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "RWTItemCell.h"
#import "RWTItem.h"

@implementation RWTItemCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.item = nil;
}

- (void)setItem:(RWTItem *)item {
    if (_item) {
        [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
    }
    
    _item = item;
    [_item addObserver:self forKeyPath:@"lastSeenBeacon" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.item] && [keyPath isEqualToString:@"lastSeenBeacon"]) {
        self.beaconLocation.text = [NSString stringWithFormat:@"Location: %@ ~%.2f meters", [self nameForProximity:self.item.lastSeenBeacon.proximity], self.item.lastSeenBeacon.accuracy];
        self.beaconName.text = _item.name;
        self.beaconMessage.text = self.item.message;
        
    }
}

- (NSString *)nameForProximity:(CLProximity)proximity {
    switch (proximity) {
        case CLProximityUnknown:
            self.coloredCircle.colorForCircle = [UIColor blackColor];
            [self.coloredCircle setNeedsDisplay];
            return @"Unknown";
            break;
        case CLProximityImmediate:
            self.coloredCircle.colorForCircle = [UIColor greenColor];
                        [self.coloredCircle setNeedsDisplay];
            return @"Immediate";
            break;
        case CLProximityNear:
            self.coloredCircle.colorForCircle = [UIColor yellowColor];
                        [self.coloredCircle setNeedsDisplay];
            return @"Near";
            break;
        case CLProximityFar:
            self.coloredCircle.colorForCircle = [UIColor redColor];
                        [self.coloredCircle setNeedsDisplay];
            return @"Far";
            break;
    }
}

@end

//
//  KeyCapView.m
//  activegs
//
//  Created by Yoshi Sugawara on 4/9/16.
//
//

#import "KeyCapView.h"

@implementation KeyCapView

-(void) setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0.0f;
}

-(CGFloat) cornerRadius {
    return self.layer.cornerRadius;
}

-(void) setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

-(UIColor*) borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (CGFloat) borderWidth {
    return self.layer.borderWidth;
}

-(void) setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}


+ (instancetype)createViewWithKeyDef:(NSArray*)keyDef
{
    KeyCapView *keyCapView = [[[UINib nibWithNibName:@"KeyCapView" bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
    
    if ([keyCapView isKindOfClass:[KeyCapView class]]) {
        keyCapView.keyDef = keyDef;
        return keyCapView;
    } else {
        return nil;
    }
}

- (void)setupWithKeyMapper:(KeyMapper*)keyMapper {
    if ( ![[self.keyDef objectAtIndex:KeyCapIndexShiftedKey] isEqualToString:@""] ) {
        self.keyLabel.text = [self.keyDef objectAtIndex:KeyCapIndexShiftedKey];
        self.keyLabelAlt.text = [self.keyDef objectAtIndex:KeyCapIndexKey];
    } else {
        self.keyLabel.text = [self.keyDef objectAtIndex:KeyCapIndexKey];
        self.keyLabelAlt.text = @"";
    }
    self.mappedButtonLabel.text = @"";
    NSArray *mappedButtons = [keyMapper getControlsForMappedKey:[[self.keyDef objectAtIndex:KeyCapIndexCode] integerValue]];
    if ( mappedButtons.count > 0 ) {
        NSMutableString *displayText = [NSMutableString string];
        int index = 0;
        for (NSNumber *button in mappedButtons) {
            if ( index++ > 0 ) {
                [displayText appendString:@","];
            }
            [displayText appendString:[NSString stringWithFormat:@"%@",[KeyMapper controlToDisplayName:button.integerValue]]];
        }
        self.mappedButtonLabel.text = displayText;
    }
}

@end

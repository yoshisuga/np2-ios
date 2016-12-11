//
//  KeyCapView.h
//  activegs
//
//  Created by Yoshi Sugawara on 4/9/16.
//
//

#import <UIKit/UIKit.h>
#import "KeyMapper.h"

IB_DESIGNABLE
@interface KeyCapView : UIControl

@property (nonatomic, strong) IBOutlet UILabel *keyLabel;
@property (nonatomic, strong) IBOutlet UILabel *keyLabelAlt;
@property (nonatomic, strong) IBOutlet UILabel *mappedButtonLabel;
@property (nonatomic, strong) NSArray *keyDef;

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

+ (instancetype)createViewWithKeyDef:(NSArray*)keyDef;
- (void)setupWithKeyMapper:(KeyMapper*)keyMapper;

@end

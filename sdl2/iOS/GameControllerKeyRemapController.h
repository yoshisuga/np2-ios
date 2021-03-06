//
//  GameControllerKeyRemapController.h
//  activegs
//
//  Created by Yoshi Sugawara on 4/8/16.
//
//

#import <UIKit/UIKit.h>
#import "KeyMapper.h"

@interface GameControllerKeyRemapController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *keyboardContainerView;
@property (nonatomic, strong) IBOutlet UIView *altKeyboardContainerView;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *defaultsButton;
@property (retain, nonatomic) IBOutlet UIButton *remapButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *saveStateSelector;
@property (retain, nonatomic) IBOutlet UISlider *transparencySlider;
@property (nonatomic, strong) KeyMapper *keyMapper;

@property(nonatomic, copy) void (^onDismissal)();
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *remapControls;

@end

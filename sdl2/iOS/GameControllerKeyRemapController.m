//
//  GameControllerKeyRemapController.m
//  activegs
//
//  Created by Yoshi Sugawara on 4/8/16.
//
//

#import <GameController/GameController.h>
#import "GameControllerKeyRemapController.h"
#import "KeyCapView.h"
#import "KeyMapper.h"
#import "MfiGameControllerHandler.h"

#include "keystat.h"
#include	"vramhdl.h"
#include	"menubase.h"
#include	"sysmenu.h"
#include    "dosio.h"
#include    "statsave.h"


const CGFloat NUMBER_OF_KEYS_IN_ROW = 15.0f;

const CGFloat KEYCAP_WIDTH_PCT = 1.0f / NUMBER_OF_KEYS_IN_ROW;

const CGFloat KEYCAP_HORIZONTAL_PADDING = 2.0f;
const CGFloat KEYCAP_VERTICAL_PADDING = 2.0f;
const CGFloat KEYCAP_HEIGHT = 40.0f;


// Using a C struct here for really just convenience of typing the definitions out
// This gets converted into an obj-c object later
struct KeyCap {
    CGFloat widthMultiplier;
    const char* key1;
    int code1;
    const char* key2;
};

struct KeyCap keyCapDefinitions[] = {
    { 2.7,"fn",KEY_FN,0 },
    { 1.0,"alt",KEY_ALT,0 },
    { 1.0,"`",KEY_TILDE,0 },
    { 6.3," ",KEY_SPACE,0 },
    { 1.0,"←",KEY_LEFT_CURSOR,0 },
    { 1.0,"→",KEY_RIGHT_CURSOR,0 },
    { 1.0,"↑",KEY_UP_CURSOR,0 },
    { 1.0,"↓",KEY_DOWN_CURSOR,0 },
    { -1,0,0,0 },
    { 2.5,"shift",KEY_SHIFT,0 },
    { 1.0,"Z",KEY_Z,0 },
    { 1.0,"X",KEY_X,0 },
    { 1.0,"C",KEY_C,0 },
    { 1.0,"V",KEY_V,0 },
    { 1.0,"B",KEY_B,0 },
    { 1.0,"N",KEY_N,0 },
    { 1.0,"M",KEY_M,0 },
    { 1.0,",",KEY_COMMA,"<" },
    { 1.0,".",KEY_PERIOD,">" },
    { 1.0,"/",KEY_FSLASH,"?" },
    { 1.0,"_",KEY_UNDERSCORE,0 },
    { 1.5,"shift",KEY_SHIFT,0 },
    { -1,0,0,0 },
    { 1.0,"control",KEY_CTRL,0 },
    { 1.0,"caps", KEY_CAPS, 0 },
    { 1.0,"A",KEY_A,0 },
    { 1.0,"S",KEY_S,0 },
    { 1.0,"D",KEY_D,0 },
    { 1.0,"F",KEY_F,0 },
    { 1.0,"G",KEY_G,0 },
    { 1.0,"H",KEY_H,0 },
    { 1.0,"J",KEY_J,0 },
    { 1.0,"K",KEY_K,0 },
    { 1.0,"L",KEY_L,0 },
    { 1.0,";",KEY_SEMICOLON,":" },
    { 1.0,":",KEY_COLON,"\""},
    { 2.0,"return",KEY_RETURN,0 },
    { -1,0,0,0 },
    { 2.0,"tab",KEY_TAB,0 },
    { 1.0,"Q",KEY_Q,0 },
    { 1.0,"W",KEY_W,0 },
    { 1.0,"E",KEY_E,0 },
    { 1.0,"R",KEY_R,0 },
    { 1.0,"T",KEY_T,0 },
    { 1.0,"Y",KEY_Y,0 },
    { 1.0,"U",KEY_U,0 },
    { 1.0,"I",KEY_I,0 },
    { 1.0,"O",KEY_O,0 },
    { 1.0,"P",KEY_P,0 },
    { 1.5,"[",KEY_LEFT_BRACKET,"{" },
    { 1.5,"]",KEY_RIGHT_BRACKET,"}" },
    { -1,0,0,0 },
    { 1.0,"esc",KEY_ESC,0 },
    { 1.0,"1",KEY_1,"!" },
    { 1.0,"2",KEY_2,"\"" },
    { 1.0,"3",KEY_3,"#" },
    { 1.0,"4",KEY_4,"$" },
    { 1.0,"5",KEY_5,"%" },
    { 1.0,"6",KEY_6,"&" },
    { 1.0,"7",KEY_7,"'" },
    { 1.0,"8",KEY_8,"(" },
    { 1.0,"9",KEY_9,")" },
    { 1.0,"0",KEY_0,0 },
    { 1.0,"-",KEY_MINUS,"_" },
    { 1.0,"^",KEY_CARET,"+" },
    { 2.0,"delete",KEY_DELETE,0 },
    { 0,0,0,0 }
};

struct KeyCap altKeyDefs[] = {
    { 1.0, "fn", KEY_FN, 0 },
    { 1.0, "0", KEY_NUMPAD_0, 0 },
    { 1.0, ",", KEY_COMMA, 0 },
    { 1.0, ".", KEY_NUMPAD_PERIOD, 0 },
    { 1.0, "ret", KEY_RETURN, 0 },
    { 10.0, "", KEY_BLANK, 0 },
    { -1,0,0,0 },
    { 1.0, "", KEY_BLANK, 0 },
    { 1.0, "1", KEY_NUMPAD_1, 0 },
    { 1.0, "2", KEY_NUMPAD_2, 0 },
    { 1.0, "3", KEY_NUMPAD_3, 0 },
    { 1.0, "=", KEY_NUMPAD_EQUALS, 0 },
    { 10.0, "", KEY_BLANK, 0 },
    { -1,0,0,0 },
    { 1.0, "", KEY_BLANK, 0 },
    { 1.0, "4", KEY_NUMPAD_4, 0 },
    { 1.0, "5", KEY_NUMPAD_5, 0 },
    { 1.0, "6", KEY_NUMPAD_6, 0 },
    { 1.0, "+", KEY_NUMPAD_PLUS, 0 },
    { 10.0, "", KEY_BLANK, 0 },
    { -1,0,0,0 },
    { 1.0, "", KEY_BLANK, 0 },
    { 1.0, "7", KEY_NUMPAD_7, 0 },
    { 1.0, "8", KEY_NUMPAD_8, 0 },
    { 1.0, "9", KEY_NUMPAD_9, 0 },
    { 1.0, "*", KEY_NUMPAD_MULTIPLY, 0 },
    { 1.0, "", KEY_BLANK, 0 },
    { 1.0, "F9", KEY_F9, 0 },
    { 1.0, "F10", KEY_F10, 0 },
    { 1.0, "", KEY_BLANK, 0 },
    { 1.0, "end", KEY_END, 0 },
    { 1.0, "pause", KEY_PAUSE, 0 },
    { 1.0, "pgup", KEY_PAGEUP, 0 },
    { 1.0, "pgdwn", KEY_PAGEDWN, 0 },
    { 2.0, "", KEY_BLANK, 0 },
    { -1,0,0,0 },
    { 1.0, "menu", KEY_NP2_MENU, 0 },
    { 1.0, "home", KEY_HOME, 0 },
    { 1.0, "help", KEY_PAUSE, 0 },
    { 1.0, "-", KEY_NUMPAD_MINUS, 0 },
    { 1.0, "/", KEY_NUMPAD_DIVIDE, 0 },
    { 1.0, "", KEY_BLANK, 0 },
    { 1.0, "F1", KEY_F1, 0 },
    { 1.0, "F2", KEY_F2, 0 },
    { 1.0, "F3", KEY_F3, 0 },
    { 1.0, "F4", KEY_F4, 0 },
    { 1.0, "F5", KEY_F5, 0 },
    { 1.0, "F6", KEY_F6, 0 },
    { 1.0, "F7", KEY_F7, 0 },
    { 1.0, "F8", KEY_F8, 0 },
    { 1.0, "", KEY_BLANK, 0 },
    { 0,0,0,0 }
};

void get_save_state_filename(char *path, int saveSlot) {
    char filename[32];
    sprintf(filename, "sav%i.sav",saveSlot);
    file_cpyname(path, file_getcd(filename), 255);
}

@interface GameControllerKeyRemapController () <UIAlertViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *keyCapViews;
@property (nonatomic, strong) NSMutableArray *altKeyCapViews;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) KeyMapper *keyMapperWorkingCopy;
@property (nonatomic, strong) MfiGameControllerHandler *controllerHandler;
@property (nonatomic, strong) UITextField *textFieldForICadeInput;
@property (nonatomic, strong) NSNumber *currentlyMappingKey;
@property (nonatomic) BOOL isRemapControlsMode;
@end

@implementation GameControllerKeyRemapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isRemapControlsMode = NO;
    [self.remapControls enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.hidden = YES;
    }];
    self.keyMapper = [[KeyMapper alloc] init];
    [self.keyMapper loadFromDefaults];
    self.keyMapperWorkingCopy = [self.keyMapper copy];
    self.controllerHandler = [[MfiGameControllerHandler alloc] init];
    [self.controllerHandler discoverController:^(GCController *gameController) {
        [self setupMfiController:gameController];
    } disconnectedCallback:^{
    }];
    self.keyCapViews = [NSMutableArray array];
    self.altKeyCapViews = [NSMutableArray array];
    self.saveButton.layer.borderWidth = 1.0f;
    self.saveButton.layer.borderColor = [self.view.tintColor CGColor];
    self.cancelButton.layer.borderWidth = 1.0f;
    self.cancelButton.layer.borderColor = [[UIColor redColor] CGColor];
    self.defaultsButton.layer.borderWidth = 1.0f;
    self.defaultsButton.layer.borderColor = [self.view.tintColor CGColor];
    
    // for detecting icade input
    self.textFieldForICadeInput = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.textFieldForICadeInput.delegate = self;
    self.textFieldForICadeInput.autocapitalizationType= UITextAutocorrectionTypeNo;

    self.altKeyboardContainerView.hidden = YES;
    self.currentlyMappingKey = nil;
    [self constructKeyboard];
    [self constructAltKeyboard];
    self.view.alpha = self.transparencySlider.value;
}

-(void) setupMfiController:(GCController*)controller {
    GCControllerButtonInput *buttonX = controller.extendedGamepad ? controller.extendedGamepad.buttonX : controller.gamepad.buttonX;
    GCControllerButtonInput *buttonA = controller.extendedGamepad ? controller.extendedGamepad.buttonA : controller.gamepad.buttonA;
    GCControllerButtonInput *buttonY = controller.extendedGamepad ? controller.extendedGamepad.buttonY : controller.gamepad.buttonY;
    GCControllerButtonInput *buttonB = controller.extendedGamepad ? controller.extendedGamepad.buttonB : controller.gamepad.buttonB;
    GCControllerButtonInput *buttonRS = controller.extendedGamepad ? controller.extendedGamepad.rightShoulder : controller.gamepad.rightShoulder;
    GCControllerButtonInput *buttonLS = controller.extendedGamepad ? controller.extendedGamepad.leftShoulder : controller.gamepad.leftShoulder;
    GCControllerButtonInput *buttonRT = controller.extendedGamepad ? controller.extendedGamepad.rightTrigger : nil;
    GCControllerButtonInput *buttonLT = controller.extendedGamepad ? controller.extendedGamepad.leftTrigger : nil;
    GCControllerDirectionPad *dpad = controller.extendedGamepad ? controller.extendedGamepad.dpad : controller.gamepad.dpad;
    
//    if ( controller.extendedGamepad ) {
//        controller.extendedGamepad.leftThumbstick.valueChangedHandler = appleJoystickhHandler;
//    }
    
    //
    // mapped keys
    KeyboardKey mappedKey = [self.keyMapper getMappedKeyForControl:MFI_BUTTON_X];
    if ( mappedKey != NSNotFound ) {
        buttonX.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
            if ( pressed ) {
                keystat_senddata((int)mappedKey);
            } else {
                keystat_senddata( (UINT8) ((int)mappedKey | 0x80));
            }
        };
    }
    
    mappedKey = [self.keyMapper getMappedKeyForControl:MFI_BUTTON_Y];
    if ( mappedKey != NSNotFound ) {
        buttonY.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
            if ( pressed ) {
                keystat_senddata((int)mappedKey);
            } else {
                keystat_senddata( (UINT8) ((int)mappedKey | 0x80));
            }
        };
    }
    
    mappedKey = [self.keyMapper getMappedKeyForControl:MFI_BUTTON_A];
    if ( mappedKey != NSNotFound ) {
        buttonA.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
            if ( pressed ) {
                keystat_senddata((int)mappedKey);
            } else {
                keystat_senddata( (UINT8) ((int)mappedKey | 0x80));
            }
        };
    }
    
    mappedKey = [self.keyMapper getMappedKeyForControl:MFI_BUTTON_B];
    if ( mappedKey != NSNotFound ) {
        buttonB.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
            if ( pressed ) {
                keystat_senddata((int)mappedKey);
            } else {
                keystat_senddata( (UINT8) ((int)mappedKey | 0x80));
            }
        };
    }
    
    mappedKey = [self.keyMapper getMappedKeyForControl:MFI_BUTTON_LS];
    if ( mappedKey != NSNotFound ) {
        buttonLS.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
            if ( pressed ) {
                keystat_senddata((int)mappedKey);
            } else {
                keystat_senddata( (UINT8) ((int)mappedKey | 0x80));
            }
        };
    }
    
    mappedKey = [self.keyMapper getMappedKeyForControl:MFI_BUTTON_RS];
    if ( mappedKey != NSNotFound ) {
        buttonRS.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
            if ( pressed ) {
                keystat_senddata((int)mappedKey);
            } else {
                keystat_senddata( (UINT8) ((int)mappedKey | 0x80));
            }
        };
    }
    
    mappedKey = [self.keyMapper getMappedKeyForControl:MFI_BUTTON_LT];
    if ( mappedKey != NSNotFound && buttonLT != nil ) {
        buttonLT.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
            if ( pressed ) {
                keystat_senddata((int)mappedKey);
            } else {
                keystat_senddata( (UINT8) ((int)mappedKey | 0x80));
            }
        };
    }
    
    mappedKey = [self.keyMapper getMappedKeyForControl:MFI_BUTTON_RT];
    if ( mappedKey != NSNotFound && buttonLT != nil ) {
        buttonRT.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
            if ( pressed ) {
                keystat_senddata((int)mappedKey);
            } else {
                keystat_senddata( (UINT8) ((int)mappedKey | 0x80));
            }
        };
    }
    
    KeyboardKey mappedKeyDpadUp = [self.keyMapper getMappedKeyForControl:MFI_DPAD_UP];
    KeyboardKey mappedKeyDpadDown = [self.keyMapper getMappedKeyForControl:MFI_DPAD_DOWN];
    KeyboardKey mappedKeyDpadLeft = [self.keyMapper getMappedKeyForControl:MFI_DPAD_LEFT];
    KeyboardKey mappedKeyDpadRight = [self.keyMapper getMappedKeyForControl:MFI_DPAD_RIGHT];
    if ( mappedKeyDpadUp != NSNotFound || mappedKeyDpadDown != NSNotFound || mappedKeyDpadLeft != NSNotFound || mappedKeyDpadRight != NSNotFound ) {
        dpad.valueChangedHandler = ^(GCControllerDirectionPad *gcdpad, float xvalue, float yvalue) {
            if ( mappedKeyDpadUp != NSNotFound && yvalue > 0.0 ) {
                keystat_senddata((int)mappedKeyDpadUp);
            } else if ( mappedKeyDpadUp != NSNotFound && yvalue <= 0.0 ) {
                keystat_senddata( (UINT8) ((int)mappedKeyDpadUp | 0x80));
            }
            
            if ( mappedKeyDpadDown != NSNotFound && yvalue < 0.0 ) {
                keystat_senddata((int)mappedKeyDpadDown);
            } else if ( mappedKeyDpadDown != NSNotFound && yvalue >= 0.0 ) {
                keystat_senddata( (UINT8) ((int)mappedKeyDpadDown | 0x80));
            }
            
            if ( mappedKeyDpadRight != NSNotFound && xvalue > 0.0 ) {
                keystat_senddata((int)mappedKeyDpadRight);
            } else if ( mappedKeyDpadRight != NSNotFound && xvalue <= 0.0 ) {
                keystat_senddata( (UINT8) ((int)mappedKeyDpadRight | 0x80));
            }
            
            if ( mappedKeyDpadLeft != NSNotFound && xvalue < 0.0 ) {
                keystat_senddata((int)mappedKeyDpadLeft);
            } else if ( mappedKeyDpadLeft != NSNotFound && xvalue >= 0.0 ) {
                keystat_senddata( (UINT8) ((int)mappedKeyDpadLeft | 0x80));
            }
            
        };
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// convert the above c struct array into an objective c object to make it easier to deal with (for me, personally)
-(NSArray*) objc_keyCapsDefinitions {
    NSMutableArray *keyDefs = [NSMutableArray array];
    NSMutableArray *keyDefsRow = [NSMutableArray array];
    int i = 0;
    while (keyCapDefinitions[i].widthMultiplier) {
        struct KeyCap keyCap = keyCapDefinitions[i];
        if ( keyCap.widthMultiplier == -1.0 ) {
            [keyDefs addObject:[keyDefsRow copy]];
            [keyDefsRow removeAllObjects];
            i++;
            continue;
        }
        [keyDefsRow addObject:@[ [NSNumber numberWithFloat:keyCap.widthMultiplier],
                                 [NSString stringWithUTF8String:keyCap.key1],
                                 [NSNumber numberWithInt:keyCap.code1],
                                 keyCap.key2 != 0 ? [NSString stringWithUTF8String:keyCap.key2] : @""
                                 ]];
        i++;
    }
    [keyDefs addObject:keyDefsRow];
    return [keyDefs copy];
}

-(NSArray*) objc_keyCapsDefs:(struct KeyCap[])defs {
    NSMutableArray *keyDefs = [NSMutableArray array];
    NSMutableArray *keyDefsRow = [NSMutableArray array];
    int i = 0;
    while (defs[i].widthMultiplier) {
        struct KeyCap keyCap = defs[i];
        if ( keyCap.widthMultiplier == -1.0 ) {
            [keyDefs addObject:[keyDefsRow copy]];
            [keyDefsRow removeAllObjects];
            i++;
            continue;
        }
        [keyDefsRow addObject:@[ [NSNumber numberWithFloat:keyCap.widthMultiplier],
                                 [NSString stringWithUTF8String:keyCap.key1],
                                 [NSNumber numberWithInt:keyCap.code1],
                                 keyCap.key2 != 0 ? [NSString stringWithUTF8String:keyCap.key2] : @""
                                 ]];
        i++;
    }
    [keyDefs addObject:keyDefsRow];
    return [keyDefs copy];
    
}

- (void)populateKeyboardKeysInContainerView:(UIView *)keyboardContainer keyDefinitions:(NSArray *)keyDefinitions keyCapViews:(NSMutableArray*)keyCapViews {
  UIView *lastVerticalView = nil;
    UIView *lastHorizontalView = nil;
    NSUInteger keyboardRow = 0;

    for (NSArray *keyDefsRow in keyDefinitions) {
       
        KeyCapView *keyCapView = nil;
        
        NSUInteger keyIndex = 0;
        
        for (NSArray *keyDef in keyDefsRow) {
            keyCapView = [KeyCapView createViewWithKeyDef:keyDef];
            keyCapView.translatesAutoresizingMaskIntoConstraints = NO;
            keyCapView.layer.borderWidth = 1.0f;
            keyCapView.layer.borderColor = [[UIColor blackColor] CGColor];
            [keyCapView setupWithKeyMapper:self.keyMapperWorkingCopy];
            
            [keyCapView addTarget:self action:@selector(onKeyDown:) forControlEvents:UIControlEventTouchDown];
            [keyCapView addTarget:self action:@selector(onKeyUp:) forControlEvents:UIControlEventTouchUpInside];
            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onKeyTap:)];
//            [keyCapView addGestureRecognizer:tap];
            [keyCapViews addObject:keyCapView];
            
            CGFloat widthMultiplier = [[keyDef objectAtIndex:KeyCapIndexWidthMultiplier] floatValue] * KEYCAP_WIDTH_PCT;
            
            NSDictionary *metrics = @{@"height" : @(KEYCAP_HEIGHT), @"padding" : @(KEYCAP_HORIZONTAL_PADDING)};
            [keyboardContainer addSubview:keyCapView];
            
            // vertical
            if ( keyboardRow == 0 ) {
                NSDictionary *bindings = NSDictionaryOfVariableBindings(keyCapView);
                // pin to super view bottom
                [keyboardContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[keyCapView(height)]-0@750-|" options:0 metrics:metrics views:bindings]];
            } else {
                NSDictionary *bindings = NSDictionaryOfVariableBindings(keyCapView,lastVerticalView);
                // pin bottom to last vertical view
                [keyboardContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[keyCapView(height)]-4@750-[lastVerticalView]" options:0 metrics:metrics views:bindings]];
            }
            
            // horizontal
            NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:keyCapView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:keyboardContainer attribute:NSLayoutAttributeWidth multiplier:widthMultiplier constant:KEYCAP_HORIZONTAL_PADDING * -1.0];
            
            if ( lastHorizontalView == nil ) {
                NSDictionary *bindings = NSDictionaryOfVariableBindings(keyCapView);
                [keyboardContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding@750-[keyCapView]" options:0 metrics:metrics views:bindings]];
            } else {
                NSDictionary *bindings = NSDictionaryOfVariableBindings(keyCapView,lastHorizontalView);
                if ( keyIndex ==  (int)NUMBER_OF_KEYS_IN_ROW-1 ) {
                    // last key in row
                    [keyboardContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastHorizontalView]-padding@750-[keyCapView]-padding@750-|" options:0 metrics:metrics views:bindings]];
                } else {
                    [keyboardContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastHorizontalView]-padding@750-[keyCapView]" options:0 metrics:metrics views:bindings]];
                }
            }
            if ( keyIndex != (int)NUMBER_OF_KEYS_IN_ROW-1 ) {
                [keyboardContainer addConstraint:widthConstraint];
            }
            
            keyIndex++;
            lastHorizontalView = keyCapView;
        }
        
        lastVerticalView = keyCapView;
        lastHorizontalView = nil;
        keyboardRow++;
    }
}

// Construct the keyboard key views using auto layout constraints entirely
// It gets constructed from the bottom up (pinned to the bottom)
-(void) constructKeyboard {    
    NSArray *keyDefinitions = [self objc_keyCapsDefs:keyCapDefinitions];
    UIView *keyboardContainer = self.keyboardContainerView;
    [self populateKeyboardKeysInContainerView:keyboardContainer keyDefinitions:keyDefinitions keyCapViews:self.keyCapViews];
}

-(void) constructAltKeyboard {
    NSArray *keyDefinitions = [self objc_keyCapsDefs:altKeyDefs];
    UIView *keyboardContainer = self.altKeyboardContainerView;
    [self populateKeyboardKeysInContainerView:keyboardContainer keyDefinitions:keyDefinitions keyCapViews:self.altKeyCapViews];
}


- (void) refreshAllKeyCapViews {
    for (KeyCapView *view in self.keyCapViews) {
        [view setupWithKeyMapper:self.keyMapperWorkingCopy];
    }
    for (KeyCapView *view in self.altKeyCapViews) {
        [view setupWithKeyMapper:self.keyMapperWorkingCopy];
    }
}

- (void) remapKeyWithKeyCapView:(KeyCapView*)view {
    self.alertView = [[UIAlertView alloc] initWithTitle:@"Remap Key" message:[NSString stringWithFormat:@"Press a button to map the [%@] key",[view.keyDef objectAtIndex:KeyCapIndexKey]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Unbind",nil];
    [self.alertView show];
    self.alertView.tag = [[view.keyDef objectAtIndex:KeyCapIndexCode] integerValue];
    [self startRemappingControlsForMfiControllerForKey:[view.keyDef objectAtIndex:KeyCapIndexCode]];
    self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.alertView textFieldAtIndex:0].delegate = self;
    [self.alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocorrectionTypeNo;
    // start icade detection
    self.currentlyMappingKey = [view.keyDef objectAtIndex:KeyCapIndexCode];
}

- (void) onKeyDown:(KeyCapView*)sender {
    if ( self.isRemapControlsMode ) {
        return;
    }
    NSInteger keyCode = [[sender.keyDef objectAtIndex:KeyCapIndexCode] integerValue];
    NSLog(@"on key down, key: %li",(long)keyCode);
    if ( keyCode == KEY_FN || keyCode == KEY_NP2_MENU) {
        return;
    }
    keystat_senddata(keyCode);
}

- (void) onKeyUp:(KeyCapView*)sender {
    NSInteger keyCode = [[sender.keyDef objectAtIndex:KeyCapIndexCode] integerValue];
    if ( keyCode == KEY_FN ) {
        [self switchKeyboardViews];
        return;
    }
    if ( keyCode == KEY_NP2_MENU ) {
        if ( menuvram == NULL ) {
            sysmenu_menuopen(0, 0, 0);
        } else {
            menubase_close();
        }
        self.view.hidden = YES;
    }
    if ( self.isRemapControlsMode ) {
        [self remapKeyWithKeyCapView:sender];
        return;
    }
    NSLog(@"on key up, key: %li",(long)keyCode);
    keystat_senddata( (UINT8) (keyCode | 0x80));
}

- (void)switchKeyboardViews {
    [self refreshAllKeyCapViews];
    self.keyboardContainerView.hidden = !self.keyboardContainerView.hidden;
    self.altKeyboardContainerView.hidden = !self.altKeyboardContainerView.hidden;
}

- (void) startRemappingControlsForMfiControllerForKey:(NSNumber*)keyCode {
    KeyboardKey keyboardKey = [keyCode intValue];
    if ( [[GCController controllers] count] == 0 ) {
        NSLog(@"Could not find any mfi controllers!");
        return;
    }
    GCController *controller = [[GCController controllers] firstObject];
    
    if ( controller.extendedGamepad ) {
        controller.extendedGamepad.valueChangedHandler = ^(GCExtendedGamepad *gamepad, GCControllerElement *element) {
            if ( gamepad.buttonA.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_A];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.buttonB.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_B];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.buttonX.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_X];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.buttonY.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_Y];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.leftShoulder.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_LS];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.rightShoulder.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_RS];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.dpad.xAxis.value > 0.0f ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_DPAD_RIGHT];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.dpad.xAxis.value < 0.0f ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_DPAD_LEFT];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.dpad.yAxis.value > 0.0f ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_DPAD_UP];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.dpad.yAxis.value < 0.0f ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_DPAD_DOWN];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.rightTrigger.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_RT];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.leftTrigger.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_LT];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
        };
    } else {
        controller.gamepad.valueChangedHandler = ^(GCGamepad *gamepad, GCControllerElement *element) {
            if ( gamepad.buttonA.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_A];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.buttonB.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_B];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.buttonX.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_X];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.buttonY.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_Y];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];;
                return;
            }
            if ( gamepad.leftShoulder.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_LS];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.rightShoulder.pressed ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_BUTTON_RS];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.dpad.xAxis.value > 0.0f ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_DPAD_RIGHT];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.dpad.xAxis.value < 0.0f ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_DPAD_LEFT];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.dpad.yAxis.value > 0.0f ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_DPAD_UP];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
            if ( gamepad.dpad.yAxis.value < 0.0f ) {
                [self.keyMapperWorkingCopy mapKey:keyboardKey ToControl:MFI_DPAD_DOWN];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
        };
    }
}

-(void) stopRemappingControls {
    if ( [[GCController controllers] count] == 0 ) {
        return;
    }
    GCController *controller = [[GCController controllers] firstObject];
    if ( controller.extendedGamepad ) {
        controller.extendedGamepad.valueChangedHandler = nil;
    } else {
        controller.gamepad.valueChangedHandler = nil;
    }
    self.currentlyMappingKey = nil;
}

-(IBAction) remapButtonPressed:(id)sender {
    [self.remapControls enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.hidden = NO;
    }];
    self.isRemapControlsMode = YES;
}

-(IBAction)saveButtonTapped:(id)sender {
    self.keyMapper = [self.keyMapperWorkingCopy copy];
    [self.keyMapper saveKeyMapping];
    self.keyMapperWorkingCopy = nil;
    [self setupMfiController:[[GCController controllers] firstObject]];
    self.isRemapControlsMode = NO;
    [self.remapControls enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.hidden = YES;
    }];
}

-(IBAction)cancelButtonTapped:(id)sender {
    if ( self.isRemapControlsMode ) {
        self.isRemapControlsMode = NO;
        [self.remapControls enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            button.hidden = YES;
        }];
        self.keyMapperWorkingCopy = nil;
        self.keyMapperWorkingCopy = [self.keyMapper copy];
        return;
    }
    self.view.hidden = YES;
}

-(IBAction) defaultsButtonTapped:(id)sender {
    [self.keyMapperWorkingCopy resetToDefaults];
    [self refreshAllKeyCapViews];
    self.isRemapControlsMode = NO;
    [self.remapControls enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.hidden = YES;
    }];
}

-(IBAction) saveStateButtonTapped:(id)sender {
    NSUInteger saveSlot = [self.saveStateSelector selectedSegmentIndex];
    int ret;
    char path[255];
    get_save_state_filename(path, (int) saveSlot);
    ret = statsave_save(path);
    if ( ret ) {
        // show error
        file_delete(path);
    }
    self.view.hidden = YES;
}

-(IBAction) loadStateButtonTapped:(id)sender {
    NSUInteger saveSlot = [self.saveStateSelector selectedSegmentIndex];
    int ret;
    char path[255];
    char buf[1024];
    char buf2[1024 + 256];
    get_save_state_filename(path, (int)saveSlot);
    NSString *objc_path = [NSString stringWithCString:path encoding:NSUTF8StringEncoding];
    ret = statsave_check(path, buf, sizeof(path));
    self.view.hidden = YES;
    if (ret & (~STATFLAG_DISKCHG)) {
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Cannot load state"                                                                message:@""
            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else if ( ret & STATFLAG_DISKCHG ) {
        sprintf(buf2, "Conflict: %s",buf);
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Could not find disk image"                                                                message:[NSString stringWithCString:buf2 encoding:NSASCIIStringEncoding]
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cont = [UIAlertAction actionWithTitle:@"Continue"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           statsave_load([objc_path UTF8String]);
                                                       }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        [alert addAction:cont];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    statsave_load(path);
    self.view.hidden = YES;
}

-(IBAction)adjustTransparency:(id)sender {
    self.view.alpha = self.transparencySlider.value;
}

#
# pragma mark - UIAlertViewDelegate
#

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self stopRemappingControls];
    if ( buttonIndex == 1 ) {
        KeyboardKey mappedKey = alertView.tag;
        [self.keyMapperWorkingCopy unmapKey:mappedKey];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self stopRemappingControls];
    [self refreshAllKeyCapViews];
}

#
# pragma mark - UITextFieldDelegate
#
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ( self.currentlyMappingKey == nil ) {
        return NO;
    }
    const char* s = [string UTF8String];
    char c;
    int i=0;
    while( (c = s[i++]) != 0)
    {
        switch(c) {
            case 'e': // up released
                [self.keyMapperWorkingCopy mapKey:self.currentlyMappingKey.integerValue ToControl:ICADE_DPAD_UP];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 'z': // down released
                [self.keyMapperWorkingCopy mapKey:self.currentlyMappingKey.integerValue ToControl:ICADE_DPAD_DOWN];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 'q': // left released
                [self.keyMapperWorkingCopy mapKey:self.currentlyMappingKey.integerValue ToControl:ICADE_DPAD_LEFT];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 'c': // right released
                [self.keyMapperWorkingCopy mapKey:self.currentlyMappingKey.integerValue ToControl:ICADE_DPAD_RIGHT];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 't': // button 1 released
                [self.keyMapperWorkingCopy mapKey:self.currentlyMappingKey.integerValue ToControl:ICADE_BUTTON_1];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 'r': // button 2 released
                [self.keyMapperWorkingCopy mapKey:self.currentlyMappingKey.integerValue ToControl:ICADE_BUTTON_2];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 'f': // button 3 released
                [self.keyMapperWorkingCopy mapKey:self.currentlyMappingKey.integerValue ToControl:ICADE_BUTTON_3];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 'n': // button 4 released
                [self.keyMapperWorkingCopy mapKey:self.currentlyMappingKey.integerValue ToControl:ICADE_BUTTON_4];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 'm': // button 5 released
                [self.keyMapperWorkingCopy mapKey:self.currentlyMappingKey.integerValue ToControl:ICADE_BUTTON_5];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 'p': // button 6 released
                [self.keyMapperWorkingCopy mapKey:self.currentlyMappingKey.integerValue ToControl:ICADE_BUTTON_6];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 'g': // button 7 released
                [self.keyMapperWorkingCopy mapKey:self.currentlyMappingKey.integerValue ToControl:ICADE_BUTTON_7];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 'v': // button 8 released
                [self.keyMapperWorkingCopy mapKey:self.currentlyMappingKey.integerValue ToControl:ICADE_BUTTON_8];
                [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
                break;
            default:
                break;
        }
    }
    return NO;
}

- (void)dealloc {
    [_remapControls release];
    [_remapButton release];
    [_saveStateSelector release];
    [_transparencySlider release];
    [super dealloc];
}
@end

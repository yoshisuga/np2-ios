//
//  KeyMapper.h
//  activegs
//
//  Created by Yoshi Sugawara on 4/9/16.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KeyboardKey) {
    KEY_FN = 0xff,    // special! to show alternate keys
    KEY_BLANK = 0xfe, // special! blank placeholder key
    KEY_CAPS = 0x71,
    KEY_OPTION = 0x37,
    KEY_ALT = 0x73,
    KEY_TILDE = 0x12,
    KEY_SPACE = 0x34,
    KEY_RIGHT_CURSOR = 0x3C,
    KEY_LEFT_CURSOR = 0x3B,
    KEY_UP_CURSOR = 0x3A,
    KEY_DOWN_CURSOR = 0x3D,
    KEY_SHIFT = 0x70,
    KEY_Z = 0x29,
    KEY_X = 0x2A,
    KEY_C = 0x2B,
    KEY_V = 0x2C,
    KEY_B = 0x2D,
    KEY_N = 0x2E,
    KEY_M = 0x2F,
    KEY_COMMA = 0x30,
    KEY_PERIOD = 0x31,
    KEY_FSLASH = 0x32,
    KEY_CTRL = 0x74,
    KEY_A = 0x1D,
    KEY_S = 0x1E,
    KEY_D = 0x1F,
    KEY_F = 0x20,
    KEY_G = 0x21,
    KEY_H = 0x22,
    KEY_J = 0x23,
    KEY_K = 0x24,
    KEY_L = 0x25,
    KEY_SEMICOLON = 0x26, 
    KEY_SQUOTE = 0x27,
    KEY_RETURN = 0x1C,
    KEY_TAB = 0x0f,
    KEY_Q = 0x10,
    KEY_W = 0x11,
    KEY_E = 0x12,
    KEY_R = 0x13,
    KEY_T = 0x14,
    KEY_Y = 0x15,
    KEY_U = 0x16,
    KEY_I = 0x17,
    KEY_O = 0x18,
    KEY_P = 0x19,
    KEY_LEFT_BRACKET = 0x1B,
    KEY_RIGHT_BRACKET = 0x28,
    KEY_ESC = 0x00,
    KEY_1 = 0x01,
    KEY_2 = 0x02,
    KEY_3 = 0x03,
    KEY_4 = 0x04,
    KEY_5 = 0x05,
    KEY_6 = 0x06,
    KEY_7 = 0x07,
    KEY_8 = 0x08,
    KEY_9 = 0x09,
    KEY_0 = 0x0A,
    KEY_MINUS = 0x40,
    KEY_EQUALS = 0x0C,
    KEY_DELETE = 0x0E,
    KEY_NUMPAD_7 = 0x42,
    KEY_NUMPAD_8 = 0x43,
    KEY_NUMPAD_9 = 0x44,
    KEY_NUMPAD_MULTIPLY = 0x45,
    KEY_NUMPAD_4 = 0x46,
    KEY_NUMPAD_5 = 0x47,
    KEY_NUMPAD_6 = 0x48,
    KEY_NUMPAD_PLUS = 0x49,
    KEY_NUMPAD_1 = 0x4a,
    KEY_NUMPAD_2 = 0x4b,
    KEY_NUMPAD_3 = 0x4c,
    KEY_NUMPAD_EQUALS = 0x4d,
    KEY_NUMPAD_0 = 0x4e,
    KEY_PAGEUP = 0x36,
    KEY_PAGEDWN = 0x37,
    KEY_INSERT = 0x38,
    KEY_DEL = 0x39,
    KEY_HOME = 0x3e,
    KEY_END = 0x3f,
    KEY_NUMPAD_MINUS = 0x40,
    KEY_NUMPAD_DIVIDE = 0x41,
    KEY_COLON = 0x27,
    KEY_NUMPAD_PERIOD = 0x50,
    KEY_PAUSE = 0x60,
    KEY_PRNTSCRN = 0x61,
    KEY_F1 = 0x62,
    KEY_F2 = 0x63,
    KEY_F3 = 0x64,
    KEY_F4 = 0x65,
    KEY_F5 = 0x66,
    KEY_F6 = 0x67,
    KEY_F7 = 0x68,
    KEY_F8 = 0x69,
    KEY_F9 = 0x6a,
    KEY_F10 = 0x6b,
    KEY_UNDERSCORE = 0x33,
    KEY_CARET = 0x0c
};

typedef NS_ENUM(NSInteger, KeyMapMappableButton) {
    MFI_BUTTON_X,
    MFI_BUTTON_A,
    MFI_BUTTON_B,
    MFI_BUTTON_Y,
    MFI_BUTTON_LT,
    MFI_BUTTON_RT,
    MFI_BUTTON_LS,
    MFI_BUTTON_RS,
    MFI_DPAD_UP,
    MFI_DPAD_DOWN,
    MFI_DPAD_LEFT,
    MFI_DPAD_RIGHT,
    ICADE_BUTTON_1,
    ICADE_BUTTON_2,
    ICADE_BUTTON_3,
    ICADE_BUTTON_4,
    ICADE_BUTTON_5,
    ICADE_BUTTON_6,
    ICADE_BUTTON_7,
    ICADE_BUTTON_8,
    ICADE_DPAD_UP,
    ICADE_DPAD_DOWN,
    ICADE_DPAD_LEFT,
    ICADE_DPAD_RIGHT
};

typedef NS_ENUM(NSInteger, KeyCapIndex) {
    KeyCapIndexWidthMultiplier = 0,
    KeyCapIndexKey = 1,
    KeyCapIndexCode = 2,
    KeyCapIndexShiftedKey = 3
};

@interface KeyMapper : NSObject<NSCopying>

-(void)loadFromDefaults;
-(void) resetToDefaults;
-(void) saveKeyMapping;
-(void) mapKey:(KeyboardKey)keyboardKey ToControl:(KeyMapMappableButton)button;
-(void) unmapKey:(KeyboardKey)keyboardKey;
-(KeyboardKey) getMappedKeyForControl:(KeyMapMappableButton)button;
+(NSString*) controlToDisplayName:(KeyMapMappableButton)button;
-(NSArray*) getControlsForMappedKey:(KeyboardKey) keyboardKey;

@end

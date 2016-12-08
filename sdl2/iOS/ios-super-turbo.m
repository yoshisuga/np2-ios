//
//  ios-super-turbo.m
//  np2sdl2
//
//  Created by Yoshi Sugawara on 12/4/16.
//
//

#import "ios-super-turbo.h"

#include "../scrnmng.h"
#include "SDL_syswm.h"
#import "GameControllerKeyRemapController.h"
#import "KeyMapper.h"
#import "MfiGameControllerHandler.h"

@implementation ios_super_turbo
@end

UIViewController* GetSDLViewController(SDL_Window *sdlWindow) {
    SDL_SysWMinfo systemWindowInfo;
    SDL_VERSION(&systemWindowInfo.version);
    if ( ! SDL_GetWindowWMInfo(sdlWindow, &systemWindowInfo)) {
        // error handle?
        return nil;
    }
    UIWindow *appWindow = systemWindowInfo.info.uikit.window;
    UIViewController *rootVC = appWindow.rootViewController;
    return rootVC;
}

void scrnmng_aftercreate(SDL_Window *sdlWindow) {
    UIViewController *rootVC = GetSDLViewController(sdlWindow);
    NSLog(@"root VC = %@",rootVC);
    GameControllerKeyRemapController *keyController = [[GameControllerKeyRemapController alloc] init];
    [rootVC addChildViewController:keyController];
    [keyController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rootVC.view addSubview:keyController.view];
    [keyController didMoveToParentViewController:rootVC];
    UIView *keyControllerView = keyController.view;
    keyControllerView.alpha = 0.5f;
    keyControllerView.tag = IOS_KB_VIEW_TAG;
    NSDictionary *viewBindings = NSDictionaryOfVariableBindings(keyControllerView);
    [rootVC.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[keyControllerView]-0-|" options:0 metrics:nil views:viewBindings]];
    [rootVC.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[keyControllerView]-0-|" options:0 metrics:nil views:viewBindings]];
    [rootVC.view bringSubviewToFront:keyControllerView];
    keyControllerView.hidden = YES;    
}

void scrnmng_ios_toggle_keyboard_view(SDL_Window *sdlWindow) {
    UIViewController *rootVC = GetSDLViewController(sdlWindow);
    UIView *kbview = [rootVC.view viewWithTag:IOS_KB_VIEW_TAG];
    kbview.hidden = !kbview.hidden;
}

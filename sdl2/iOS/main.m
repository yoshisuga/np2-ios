/*
 *	@file	main.m
 */

#import "compiler.h"
#include "../np2.h"
#include "../dosio.h"
#include "../scrnmng.h"

#include "SDL_syswm.h"
#import "SDL2/include/SDL_uikitappdelegate.h"

// Add a 'category' to the SDL app delegate class
@interface SDLUIKitDelegate (plusalpha)
@end

@implementation SDLUIKitDelegate (plusalpha)

@end



int SDL_main(int argc, char *argv[])
{
	NSArray *paths;
	NSString *DocumentsDirPath;

	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	DocumentsDirPath = [paths objectAtIndex:0];

	NSString *current = [DocumentsDirPath stringByAppendingString:@"/"];
	file_setcd([current UTF8String]);

	return np2_main(argc, argv);
}


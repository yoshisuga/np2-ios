#include	"compiler.h"
#include	"inputmng.h"
#include	"taskmng.h"
#include	"sdlkbd.h"
#include	"vramhdl.h"
#include	"menubase.h"
#include	"sysmenu.h"
#include	"scrnmng.h"
#include    "mousemng.h"


	BOOL	task_avail;


void sighandler(int signo) {

	(void)signo;
	task_avail = FALSE;
}


void taskmng_initialize(void) {

	task_avail = TRUE;
}

void taskmng_exit(void) {

	task_avail = FALSE;
}

void taskmng_rol(void) {

	SDL_Event	e;
    
    // to account for high DPI screens
    float xScale = 1.0;
    float yScale = 1.0;
    int xOffset = 0;
    int yOffset = 0;
    scrnmng_get_scale(&xScale, &yScale);
    scrnmng_get_offset(&xOffset, &yOffset);
    
    int motionX;
    int motionY;
    int buttonX;
    int buttonY;

	if ((!task_avail) || (!SDL_PollEvent(&e))) {
		return;
	}
	switch(e.type) {
		case SDL_MOUSEMOTION:
            if ( 1 ) {}
            motionX = (int) e.motion.x * xScale + xOffset;
            motionY = (int) e.motion.y * yScale + yOffset;
			if (menuvram == NULL) {
                mousemng_onmove(&e.motion);
			}
			else {
				menubase_moving(motionX, motionY, 0);
			}
            fprintf(stderr, "orig mouse pos: %i, %i\n",e.motion.x,e.motion.y);
            fprintf(stderr, "scaled mouse pos: %i, %i\n",motionX, motionY);
			break;

		case SDL_MOUSEBUTTONUP:
            if ( 1 ) {}
            buttonX = (int) e.button.x * xScale + xOffset;
            buttonY = (int) e.button.y * yScale + yOffset;
            
			switch(e.button.button) {
				case SDL_BUTTON_LEFT:
					if (menuvram != NULL)
					{
						menubase_moving(buttonX, buttonY, 2);
					}
#if defined(__IPHONEOS__)
					else if (SDL_IsTextInputActive())
					{
						SDL_StopTextInput();
					}
					else if (buttonY >= 320)
					{
                        scrnmng_toggle_keyboard();
//						SDL_StartTextInput();
                        
					}
#endif
					else
					{
						sysmenu_menuopen(0, buttonX, buttonY);
					}
					break;

				case SDL_BUTTON_RIGHT:
					break;
			}
			break;

		case SDL_MOUSEBUTTONDOWN:
            if ( 1 ) {}
            buttonX = (int) e.button.x * xScale + xOffset;
            buttonY = (int) e.button.y * yScale + yOffset;

			switch(e.button.button) {
				case SDL_BUTTON_LEFT:
					if (menuvram != NULL)
					{
                        
						menubase_moving(buttonX, buttonY, 1);
					}
					break;

				case SDL_BUTTON_RIGHT:
					break;
			}
			break;

		case SDL_KEYDOWN:
			if (e.key.keysym.sym == SDLK_F11) {
				if (menuvram == NULL) {
					sysmenu_menuopen(0, 0, 0);
				}
				else {
					menubase_close();
				}
			}
			else {
				sdlkbd_keydown(e.key.keysym.sym);
			}
			break;

		case SDL_KEYUP:
			sdlkbd_keyup(e.key.keysym.sym);
			break;

		case SDL_QUIT:
			task_avail = FALSE;
			break;
        
	}
}

BOOL taskmng_sleep(UINT32 tick) {

	UINT32	base;

	base = GETTICK();
	while((task_avail) && ((GETTICK() - base) < tick)) {
		taskmng_rol();
		SDL_Delay(1);
	}
	return(task_avail);
}


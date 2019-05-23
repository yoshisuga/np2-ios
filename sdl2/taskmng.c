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

BOOL did_click;
BOOL is_right_click;
BOOL is_triple_touch;
BOOL is_click_dragging;
UINT8 cycles_after_click = 0;


void sighandler(int signo) {

	(void)signo;
	task_avail = FALSE;
}


void taskmng_initialize(void) {

	task_avail = TRUE;
    did_click = FALSE;
    is_right_click = FALSE;
    is_click_dragging = FALSE;
    cycles_after_click = 0;
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
    
    if ( did_click ) {
//        fprintf(stderr,"cycles after click = %i \n",cycles_after_click);
        if ( cycles_after_click++ > 120 ) {
//            fprintf(stderr,"cycles met, lifting mouse button! \n");
//            if ( is_right_click ) {
//                fprintf(stderr, "Doing right click! \n");
//            }
            is_right_click ? mousemng_right_buttonup() : mousemng_left_buttonup();
            did_click = FALSE;
            is_right_click = FALSE;
            cycles_after_click = 0;
        }
    }

	if ((!task_avail) || (!SDL_PollEvent(&e))) {
		return;
	}
	switch(e.type) {
        case SDL_FINGERMOTION:
//            fprintf(stderr, "on finger motion! rel motion x = %f , y = %f , click dragging = %s \n", e.tfinger.dx, e.tfinger.dy,is_click_dragging ? "yes" : "no");
            if ( menuvram == NULL ) {
                
                if ( fabsf(e.tfinger.dx) >= 0.01 || fabsf(e.tfinger.dy) >= 0.01 ) {
                    did_click = FALSE;
                }
                
                if ( fabsf(e.tfinger.dx) >= 0.001 || fabsf(e.tfinger.dy) >= 0.001 ) {
                    mousemng_onfingermove(&e.tfinger);
                }
                
            }
            break;
            
		case SDL_MOUSEMOTION:
            if ( 1 ) {}
            motionX = (int) e.motion.x * xScale + xOffset;
            motionY = (int) e.motion.y * yScale + yOffset;
			if (menuvram == NULL) {
//                mousemng_onmove(&e.motion);
			}
			else {
				menubase_moving(motionX, motionY, 0);
			}
			break;

        case SDL_FINGERUP:
//            fprintf(stderr, "on finger up   ! \n");
            if ( menuvram == NULL ) {
//                fprintf(stderr, "finger rel motion x = %f , y = %f \n",e.tfinger.dx, e.tfinger.dy);
                if ( is_triple_touch ) {
                    scrnmng_toggle_keyboard();
                    is_triple_touch = FALSE;
                } else if ( did_click ) {
                    is_right_click ? mousemng_right_buttondown() : mousemng_left_buttondown();
                    cycles_after_click = 0;
                } else if ( is_click_dragging ) {
                    mousemng_left_buttonup();
                    is_click_dragging = FALSE;
                }
            }
            break;
            
        case SDL_FINGERDOWN:
            if ( menuvram == NULL ) {
//                fprintf(stderr, "did touch down! \n");
                did_click = TRUE;
            }
            break;
            
        case SDL_MULTIGESTURE:
            if ( menuvram == NULL ) {
//                fprintf(stderr, "did multi touch! \n");
                if ( e.mgesture.numFingers == 3 ) {
                    is_triple_touch = TRUE;
                } else if ( e.mgesture.numFingers == 2 ) {
                    is_right_click = TRUE;
                }
            }
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
#endif
					else
					{
//                        mousemng_buttonevent(&e.button);
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
                    } else {
                        if ( e.button.clicks == 2 ) {
//                            fprintf(stderr, "double click detected! \n");
                            is_click_dragging = TRUE;
                            mousemng_left_buttondown();
                            did_click = FALSE;
                        }
//                        mousemng_buttonevent(&e.button);
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


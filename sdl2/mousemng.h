
enum {
    uPD8255A_LEFTBIT	= 0x80,
    uPD8255A_RIGHTBIT	= 0x20
};

#ifdef __cplusplus
extern "C" {
#endif
    
    void mousemng_initialize(void);
    UINT8 mousemng_getstat(SINT16 *x, SINT16 *y, int clear);
    void mousemng_hidecursor();
    void mousemng_showcursor();
    void mousemng_onmove(SDL_MouseMotionEvent *motion);
    void mousemng_onfingermove(SDL_TouchFingerEvent *touch);
    void mousemng_left_buttonup();
    void mousemng_left_buttondown();
    void mousemng_right_buttonup();
    void mousemng_right_buttondown(); 
    void mousemng_buttonevent(SDL_MouseButtonEvent *button);
    
#ifdef __cplusplus
}
#endif

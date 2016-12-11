np2-ios - Neko Project II, a PC-9801 emulator for iOS
=====================================================

This is a port/fork of Neko Project II, a PC-9801 emulator, made specifically for iOS devices. The original source is [here](http://www.yui.ne.jp/np2/).

The original source included a functional iOS port already, thanks to being built on top of SDL. I wanted to have better support for an on-screen keyboard and remapping controls to an mFi controller, and it was just easier for me to use UIKit instead of having to write something on top of SDL. I know it makes it less platform independent, but hey I am lazy and selfish and just want to get this running on my iPhone :)

How to build
------------
You need to build the required SDL library, `libSDL2.a`, in Xcode first. [SDL source](https://www.libsdl.org/download-2.0.php) includes an Xcode project with a libSDL2 target that you can use for an iOS device or Simulator. Put the `libSDL2.a` file in `sdl2/iOS/SDL2/lib/libSDL2.a`.

Running
-------
Copy the included `font.tmp` file to the Documents directory of the app, using iTunes or iExplorer. This is so that the text is rendered on the screen correctly.

Controls
--------

- Tap near the bottom of the screen to show an onscreen keyboard.
- Onscreen keyboard includes an option to Remap keyboard controls to mFi controller
- Mouse left click: tap on screen
- Mouse movement: drag finger on screen
- Mouse click-drag: double tap, hold, and drag finger
- Mouse right click: tap with 2 fingers
- The config menu is opened via the "menu" button on the onscreen keyboard (use the "fn" key for more keys)
- Use the config menu to open a disk image, and then go to Emulate -> Reset


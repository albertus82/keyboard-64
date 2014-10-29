Keyboard64
==========

This program emulates a digital music keyboard for the Commodore 64 Personal Computer, which is based on the MOS SID 6581/8580 sound chip. It is freely inspired by a sample program presented in the C64 User's manual.

You can play notes by using your computer keyboard; the mapping between the musical keyboard and the computer keys is displayed on the screen.

When you start the program, it asks you to choose the concert pitch (default A=440 Hz) and one out of 4 kinds of temperament:
* Meantone 1/4 comma
* Kirnberger III
* Werckmeister I (III)
* Equal (obviously)

While the program is running, you can switch between the octaves by using function keys F1, F2, F3 & F4, and choose waveform using F5, F6, F7 & F8 (the latter being a near-useless "white noise"). You can also adjust the sustain effect using the cursor keys (left/down).

This Eclipse project is set up to use VICE (the Versatile Commodore Emulator), so if you want to use the Ant build.xml, you have to create a build.properties file and set "vice.dir" and "vice.exec" properties according to your VICE installation.
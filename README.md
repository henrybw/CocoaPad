In all honesty, CocoaPad was really more of an exercise for me to get familiar with Cocoa. I doubt there's much practical use for it, but it was a fun little thing to write, and I definitely learned a lot by doing it. However, I was pretty young and n00bish back then, so a lot of my coding "techniques" are, well, sucky.

Building CocoaPad
=================

If you attempt to build CocoaPad on Jaguar (using the source files—the project is Xcode and therefore Panther only), you will get about 10 compiler warnings saying that the Panther-specific methods won't work. Ignore these. CocoaPad already has a system of using Panther-specific methods only if they can be used.

Unfortunately, because of lack of weak-linking support, CocoaPad cannot built on Mac OS X 10.1 or earlier (unless you remove the Find panel and Word code, which could be a tad messy).

#import <Kiwi/Kiwi.h>

#import <OHHTTPStubs.h>

static inline void runLoopIfNeeded() {
    // https://developer.apple.com/library/mac/#documentation/CoreFOundation/Reference/CFRunLoopRef/Reference/reference.html

    while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, YES) == kCFRunLoopRunHandledSource);
}

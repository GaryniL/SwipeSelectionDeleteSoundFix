#include <substrate.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@interface UIKBKey : NSObject
@property(copy) NSString *representedString;
@end

@interface UIKeyboardLayout : UIView
- (UIKBKey *)keyHitTest:(CGPoint)point;
@end

@interface UIKeyboardLayoutStar : UIKeyboardLayout
- (UIKBKey *)keyHitTest:(CGPoint)arg1;
@end

%hook UIKeyboardLayoutStar
- (void)playKeyClickSound { nil; }
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	UIKBKey *keyObject = [self keyHitTest:[touch locationInView:touch.view]];
	NSString *key = [[keyObject representedString] lowercaseString];
	// NSLog(@"[GGGGG]  key=[%@]", key);

	%orig;
	if ([key isEqualToString:@"delete"]) {
		AudioServicesPlaySystemSound(1155);
 	}
}
%end

%ctor {
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_MSEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        %init;
    });
}
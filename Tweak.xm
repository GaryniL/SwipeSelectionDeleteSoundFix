#include <substrate.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@interface UIKBKey : NSObject
@property(copy) NSString * representedString;
@end

@interface UIKeyboardLayout : UIView
-(UIKBKey*)keyHitTest:(CGPoint)point;
@end

@interface UIKeyboardLayoutStar : UIKeyboardLayout
-(id)keyHitTest:(CGPoint)arg1;
@end



%hook UIKeyboardLayoutStar
- (void)playKeyClickSound { }
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];

	UIKBKey *keyObject = [self keyHitTest:[touch locationInView:touch.view]];
	NSString *key = [[keyObject representedString] lowercaseString];
	// NSLog(@"[GGGGG]  key=[%@]", key);

	if ([key isEqualToString:@"delete"]) {
		%orig();
		AudioServicesPlaySystemSound(1155);

	} else{
		%orig;
	}
}

%end
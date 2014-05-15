#import "SIMButton.h"
#import "UIColor+Simplify.h"
#import <QuartzCore/QuartzCore.h>

@implementation SIMButton

- (instancetype)initWithFrame:(CGRect)frame primaryColor:(UIColor *)primaryColor {
    self = [super initWithFrame:frame];

    if (self) {
        NSString *defaultText = @"Charge Card";
        [self setTitle:defaultText forState:UIControlStateNormal];
        [self setTitle:defaultText forState:UIControlStateDisabled];
        
        self.primaryColor = primaryColor ? primaryColor : [UIColor buttonBackgroundColorEnabled];
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        
    }
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame primaryColor:[UIColor buttonBackgroundColorEnabled]];
}


- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * fillColor;
    UIColor * bottomLine;
    
    UIColor *accentColor = [UIColor darkerColorThanColor:self.primaryColor];
    
    if (self.state == UIControlStateNormal) {
        fillColor = self.primaryColor;
        bottomLine = accentColor;
    } else if (self.state == UIControlStateDisabled) {
        fillColor = [UIColor buttonBackgroundColorDisabled];
        bottomLine = [UIColor buttonHighlightColorDisabled];
        
    }

    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextAddRect(context, rect);
    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context, bottomLine.CGColor);
    CGFloat lineWidth = 2.0;
    CGContextFillRect(context, CGRectMake(0, rect.size.height - lineWidth, rect.size.width, lineWidth));
    CGContextRestoreGState(context);

}

@end

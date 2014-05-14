#import "SIMButton.h"
#import <Simplify/UIColor+Simplify.h>
#import <QuartzCore/QuartzCore.h>

@implementation SIMButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *defaultText = @"Charge Card";
        [self setTitle:defaultText forState:UIControlStateNormal];
        [self setTitle:defaultText forState:UIControlStateDisabled];
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * fillColor;
    UIColor * bottomLine;
    
    if (self.state == UIControlStateNormal) {
        fillColor = [UIColor buttonBackgroundColorEnabled];
        bottomLine = [UIColor buttonHighlightColorEnabled];
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

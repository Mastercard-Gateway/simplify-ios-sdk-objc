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
        fillColor = [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:4.0/255.0 alpha:1.0];
        bottomLine = [UIColor colorWithRed:207.0/255.0 green:82.0/255.0 blue:4.0/255.0 alpha:1.0];
    } else if (self.state == UIControlStateDisabled) {
        fillColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
        bottomLine = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1.0];
        
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

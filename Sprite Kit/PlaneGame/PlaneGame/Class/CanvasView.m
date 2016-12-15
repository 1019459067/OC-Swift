//
//  CanvasView.m
//  Created by sluin on 15/7/1.
//  Copyright (c) 2015年 SunLin. All rights reserved.
//

#import "CanvasView.h"

@implementation CanvasView
{
    CGContextRef _context ;
}

- (void)drawRect:(CGRect)rect {
    [self drawPointWithPoints:self.arrPersons] ;
}

-(void)drawPointWithPoints:(NSArray *)arrPersons
{
    if (_context) {
        CGContextClearRect(_context, self.bounds);
    }
    _context = UIGraphicsGetCurrentContext();
    
    for (NSDictionary *dicPerson in self.arrPersons)
    {
        if ([dicPerson objectForKey:RECT_KEY])
        {
            [self drawFaceRect:CGRectFromString([dicPerson objectForKey:RECT_KEY]) context:_context];
        }
    }

    [[CanvasView st_colorWithRGBHex:0x21b3f3] set];
    CGContextSetLineWidth(_context, 2);
    CGContextStrokePath(_context);
}
+ (UIColor *)st_colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}
- (void)drawFaceRect:(CGRect)rect context:(CGContextRef)ctx
{
    float rectWH = rect.size.width;
    float xStart = rect.origin.x-rectWH*(fScaleFaceRect-1)/2.0;
    float yStart = rect.origin.y-rectWH*(fScaleFaceRect-1)/2.0;
    rectWH = rectWH*fScaleFaceRect;
    
    float fRadiu = rectWH*1/4*1/10.;
    //A1
    [self drawBrokenLineWithPoint1:CGPointMake(xStart, yStart+rectWH*1/4.)
                            point2:CGPointMake(xStart, yStart+fRadiu)
                            point3:CGPointMake(xStart, yStart)
                            point4:CGPointMake(xStart+fRadiu, yStart)
                            point5:CGPointMake(xStart+rectWH*1/4., yStart)
                          arcRadiu:fRadiu
                           context:ctx];
    
    //A2
    [self drawBrokenLineWithPoint1:CGPointMake(xStart+rectWH*3/4., yStart)
                            point2:CGPointMake(xStart+rectWH*3/4.+fRadiu, yStart)
                            point3:CGPointMake(xStart+rectWH, yStart)
                            point4:CGPointMake(xStart+rectWH, yStart+fRadiu)
                            point5:CGPointMake(xStart+rectWH, yStart+rectWH*1/4.)
                          arcRadiu:fRadiu
                           context:ctx];
    
    //A3
    [self drawBrokenLineWithPoint1:CGPointMake(xStart+rectWH, yStart+rectWH*3/4.)
                            point2:CGPointMake(xStart+rectWH, yStart+rectWH*3/4.+fRadiu)
                            point3:CGPointMake(xStart+rectWH, yStart+rectWH)
                            point4:CGPointMake(xStart+rectWH-fRadiu, yStart+rectWH)
                            point5:CGPointMake(xStart+rectWH*3/4., yStart+rectWH)
                          arcRadiu:fRadiu
                           context:ctx];
    
    //A4
    [self drawBrokenLineWithPoint1:CGPointMake(xStart+rectWH*1/4., yStart+rectWH)
                            point2:CGPointMake(xStart+rectWH*1/4.-fRadiu, yStart+rectWH)
                            point3:CGPointMake(xStart, yStart+rectWH)
                            point4:CGPointMake(xStart, yStart+rectWH-fRadiu)
                            point5:CGPointMake(xStart, yStart+rectWH*3/4.)
                          arcRadiu:fRadiu
                           context:ctx];
}
- (void)drawBrokenLineWithPoint1:(CGPoint)point1
                          point2:(CGPoint)point2
                          point3:(CGPoint)point3
                          point4:(CGPoint)point4
                          point5:(CGPoint)point5
                        arcRadiu:(CGFloat)arcRadiu
                         context:(CGContextRef)ctx
{
    CGContextMoveToPoint(ctx, point1.x, point1.y);
    CGContextAddLineToPoint(ctx, point2.x, point2.y);
    CGContextAddArcToPoint(ctx, point3.x, point3.y, point4.x, point4.y, arcRadiu);
    CGContextMoveToPoint(ctx, point4.x, point4.y);
    CGContextAddLineToPoint(ctx, point5.x, point5.y);
}

@end

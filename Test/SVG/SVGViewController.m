//
//  ViewController.m
//  SVG
//
//  Created by yubinqiang on 16/8/29.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "SVGViewController.h"

#import "SVGPolygon.h"

@interface SVGViewController ()
@property (strong, nonatomic) NSMutableArray<SVGPolygon *> *polygons;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation SVGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self drawPolygons];
}

- (IBAction)handleTouchUpInside:(id)sender {
    [self drawPolygons];
}



- (void)drawPolygons {
    // Drawing lines with a white stroke color
    CGFloat width = 200;
    CGFloat height = 200;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, CGRectMake(0, 0, width, height));
//    UIRectFillUsingBlendMode(CGRectMake(0, 0, width, height), kCGBlendModeOverlay);
    for (SVGPolygon *p in self.polygons) {
//        CGContextSetRGBStrokeColor(context, p.rgba.r, p.rgba.g, p.rgba.b, p.rgba.a);
        
        // Drawing with a blue fill color
        CGContextSetRGBFillColor(context,  p.rgba.r, p.rgba.g, p.rgba.b, 1-p.rgba.a);
        
        CGContextSetFillColorWithColor(context,p.fillColor.CGColor);
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        CGContextSetLineWidth(context, 2.0);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, p.points.firstObject.x, p.points.firstObject.y);
        for(int i = 1; i < 4; ++i)
        {
            CGContextAddLineToPoint(context, p.points[i].x, p.points[i].y);
        }

        // And close the subpath.
        CGContextClosePath(context);
        // Now draw the star & hexagon with the current drawing mode.
        CGContextDrawPath(context, kCGPathFill);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = image;
    NSURL *url=[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask].firstObject;
    NSLog(@"url:%@",url.absoluteString);
    NSData *pngImageData = UIImagePNGRepresentation(image);
    [pngImageData writeToURL:[url URLByAppendingPathComponent:@"lisa.png"] atomically:YES];
}


- (void)setup {
    self.polygons = [NSMutableArray array];
    NSArray<SVGPoint *> *offsets = @[[[SVGPoint alloc] initWithX:0 y:0],
                                     [[SVGPoint alloc] initWithX:200 y:0],
                                     [[SVGPoint alloc] initWithX:0 y:200],
                                     [[SVGPoint alloc] initWithX:200 y:200]];
    NSMutableArray<NSString *> *newLines = [NSMutableArray array];
    for (NSUInteger i = 0; i < 1; i++) {
        NSArray<NSString *> *polygons = [self filePathOfSVGIndex:i];
        for (NSString *stringOfPolygon in polygons) {
            SVGPolygon *p = [[SVGPolygon alloc] initWithString:stringOfPolygon offset:offsets[i]];
            [self.polygons addObject:p];
            [newLines addObject:[p line]];
        }
    }
    NSURL *url=[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask].firstObject;
    NSLog(@"url:%@",url.absoluteString);
    [newLines writeToURL:[url URLByAppendingPathComponent:@"test.txt"] atomically:YES];
}

- (NSArray<NSString *> *)filePathOfSVGIndex:(NSUInteger)index {
    NSString *name = [NSString stringWithFormat:@"Avatar%@",@(index+1).stringValue];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    NSError *error = nil;
    NSString *stringOfContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSArray<NSString *> *lines = [stringOfContent componentsSeparatedByString:@"\n"];
    NSArray<NSString *> *polygons = [lines subarrayWithRange:NSMakeRange(6, lines.count - 2 - 6)];// 6 in head and last one.
    return polygons;
}

@end

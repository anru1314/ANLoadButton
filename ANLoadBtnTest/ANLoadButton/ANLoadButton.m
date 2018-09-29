//
//  ANLoadButton.m
//  ALLoadingView
//
//  Created by AnRu on 2018/8/24.
//  Copyright © 2018年 asm. All rights reserved.
//

#import "ANLoadButton.h"

@interface ANLoadButton()

@property(nullable, nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, weak) CAShapeLayer *loadlayer;
@property (nonatomic, weak) CAShapeLayer *successlayer;
@property (nonatomic, assign) BOOL isLoad;
@end

@implementation ANLoadButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setEdgeInsets:self.edgeInsets];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat top = edgeInsets.top<0?0:edgeInsets.top;
    CGFloat left = edgeInsets.left<0?0:edgeInsets.left;
    CGFloat right = edgeInsets.right<0?0:edgeInsets.right;
    CGFloat bottom = edgeInsets.bottom<0?0:edgeInsets.bottom;
    self.titleLabel.frame = CGRectMake(left, top, w-left-right, h-top-bottom);
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.titleLabel.text = text;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.titleLabel.textColor = textColor;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
    if (!self.isLoad) {
        [self radius];
    }
    return YES;
}

- (void)show:(ANLoadResultType)type
{
    switch (type) {
        case ANLoadNormal:
        {
            if (self.isLoad) {
                [self normal];
            }
        }
        case ANLoadSuccess:
        {
            if (self.isLoad) {
                [self success];
            }
        }
            break;
        case ANLoadError:
        {
            [self error];
        }
            break;
            
        default:
            break;
    }
}

- (void)radius
{
    CAAnimationGroup *groupAni = [CAAnimationGroup animation];
    
    CABasicAnimation *sizeAni = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    sizeAni.toValue = [NSValue valueWithCGSize:CGSizeMake(self.bounds.size.height, self.bounds.size.height)];

    CABasicAnimation *radiusAni = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    radiusAni.toValue = @(self.bounds.size.height/2);
    
    CABasicAnimation *opacityAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAni.fromValue = @(1);
    opacityAni.toValue = @(0.8);
    opacityAni.autoreverses = YES;
 
    groupAni.animations = @[sizeAni, radiusAni];
    groupAni.beginTime = CACurrentMediaTime();
    groupAni.fillMode = kCAFillModeForwards;
    groupAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    groupAni.duration = 0.1;
    groupAni.removedOnCompletion = false;
    [self.layer addAnimation:groupAni forKey:nil];
    
    [self loading];
}
- (void)normal
{
    self.isLoad = NO;
    self.titleLabel.hidden = NO;
    [self.successlayer removeFromSuperlayer];
    [self.loadlayer removeFromSuperlayer];
    [self.layer removeAllAnimations];
}
- (void)loading
{
    self.isLoad = YES;
    self.titleLabel.hidden = YES;
    
    CGFloat radius = self.bounds.size.height/2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius-3 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer * shapelayer = [CAShapeLayer layer];
    shapelayer.frame = self.bounds;
    shapelayer.path = path.CGPath;
    self.loadlayer = shapelayer;
    //填充色
    shapelayer.fillColor = [UIColor clearColor].CGColor;
    // 设置线的颜色
    shapelayer.strokeColor = [UIColor whiteColor].CGColor;
    //线的宽度
    shapelayer.lineWidth = 2;
    [self.layer addSublayer:shapelayer];
    
    CABasicAnimation * anima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anima.fromValue = [NSNumber numberWithFloat:0.f];
    anima.toValue = [NSNumber numberWithFloat:1.f];
    anima.duration = 1.0f;
    anima.repeatCount = MAXFLOAT;
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anima.autoreverses = YES;
    [shapelayer addAnimation:anima forKey:@"strokeEndAniamtion"];
    
    CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima3.toValue = [NSNumber numberWithFloat:-M_PI*2];
    anima3.duration = 1.0f;
    anima3.repeatCount = MAXFLOAT;
    anima3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:anima3 forKey:@"rotaionAniamtion"];
    
}

- (void)success
{
    self.isLoad = NO;
    
    self.titleLabel.hidden = YES;
    [self.loadlayer removeAllAnimations];
    [self.layer removeAnimationForKey:@"rotaionAniamtion"];
    
    CGFloat radius = self.bounds.size.height/2;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    self.successlayer = layer;
    [self.layer addSublayer:layer];

    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint centerPoint = CGPointMake(radius,radius);
    CGPoint firstPoint = centerPoint;
    firstPoint.x -= radius / 2;
    [path moveToPoint:firstPoint];
    CGPoint secondPoint = centerPoint;
    secondPoint.x -= radius / 8;
    secondPoint.y += radius / 2;
    [path addLineToPoint:secondPoint];
    CGPoint thirdPoint = centerPoint;
    thirdPoint.x += radius / 2;
    thirdPoint.y -= radius / 2;
    [path addLineToPoint:thirdPoint];
    
    layer.path = path.CGPath;
    layer.lineWidth = 2.0;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = nil;
    
    layer.strokeEnd = 1;
    CABasicAnimation * anima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anima.fromValue = [NSNumber numberWithFloat:0.f];
    anima.toValue = [NSNumber numberWithFloat:1.f];
    anima.duration = 0.8f;
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:anima forKey:nil];
}

- (void)error
{
    self.isLoad = NO;
    
    self.titleLabel.hidden = NO;
    [self.successlayer removeFromSuperlayer];
    [self.loadlayer removeFromSuperlayer];
    [self.layer removeAllAnimations];
    
    //给按钮添加左右摆动的效果(路径动画)
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint point = self.layer.position;
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:point]];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyFrame.duration = 0.5f;
    [self.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
}

@end

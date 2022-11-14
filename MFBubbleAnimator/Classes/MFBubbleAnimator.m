//
//  MFBubbleAnimator.m
//  MFBubbleAnimator
//
//  Created by xkjuan on 2022/9/21.
//

#import "MFBubbleAnimator.h"

@implementation MFBubbleAnimator
/**
 添加环形波纹
 */
+ (void)mf_addAnnularRippleAtView:(UIView *)aniView rippleColor:(UIColor *)rippleColor{
    for (int i = 0; i<4; i++) {
        CALayer *animLayer = [CALayer new];
        animLayer.frame = aniView.bounds;
        animLayer.cornerRadius = aniView.frame.size.width/2;
        animLayer.borderColor = rippleColor.CGColor;
        animLayer.borderWidth = 1;
        animLayer.backgroundColor = UIColor.clearColor.CGColor;
        [aniView.layer addSublayer:animLayer];
        
        [MFBubbleAnimator addAnimateTolayer:animLayer delay:i*0.7];
    }
}

+(void)addAnimateTolayer:(CALayer *)layer delay:(CGFloat)delay{
    CABasicAnimation*scaleAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @(1.67);
    scaleAnimation.beginTime = CACurrentMediaTime()+delay;
    scaleAnimation.duration = 2.8;
    scaleAnimation.repeatCount = HUGE;// 重复次数设置为无限
    scaleAnimation.autoreverses = NO;
    
    [layer addAnimation:scaleAnimation forKey:@"plulsingAni"];
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.toValue = @0.0;
    opacityAnim.fromValue = @1;
    opacityAnim.beginTime = CACurrentMediaTime()+delay;
    opacityAnim.duration = 2.8;
    opacityAnim.repeatCount = HUGE;// 重复次数设置为无限
    opacityAnim.autoreverses = NO;
    
    [layer addAnimation:opacityAnim forKey:@"opacityAni"];
}


/**
 气泡动画
 */
+ (void)mf_anchorZanBubbleWithImgArr:(NSArray <UIImage *>*)imgArr
                              onView:(UIView *)onView
                             atPoint:(CGPoint)point{
    for (int i = 0; i<imgArr.count; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self repeatBubbleAtPoint:point times:i image:imgArr[i] onView:onView];
        });
    }
}

+ (void)repeatBubbleAtPoint:(CGPoint)point times:(int)times image:(UIImage *)image onView:(UIView *)onView{
    UIImage *loveImage = [UIImage imageNamed:[NSString stringWithFormat:@"live_zan_anim_%d",times]];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:loveImage];
    bubbleImageView.frame = CGRectMake(point.x, point.y, loveImage.size.width, loveImage.size.height);
    [onView addSubview:bubbleImageView];
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    CGFloat oX = bubbleImageView.frame.origin.x;
    CGFloat oY = bubbleImageView.frame.origin.y;
    CGFloat eX = oX;
    CGFloat eY = oY - 130;
    CGFloat t = 30;
    CGPoint cp1 = CGPointMake(oX - t, ((oY + eY) / 2));
    CGPoint cp2 = CGPointMake(oX + t, cp1.y);
    
    // randomly switch up the control points so that the bubble
    // swings right or left at random
    NSInteger r = arc4random() % 2;
    if (r == 1) {
        CGPoint temp = cp1;
        cp1 = cp2;
        cp2 = temp;
    }
    
    // the moveToPoint method sets the starting point of the line
    [bezierPath moveToPoint:CGPointMake(oX, oY)];
    // add the end point and the control points
    [bezierPath addCurveToPoint:CGPointMake(eX, eY) controlPoint1:cp1 controlPoint2:cp2];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        // transform the image to be 1.3 sizes larger to
        // give the impression that it is popping
        [UIView transitionWithView:bubbleImageView
                          duration:0.1f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            bubbleImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                        } completion:^(BOOL finished) {
                            [bubbleImageView removeFromSuperview];
                        }];
    }];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = 1.2;
    pathAnimation.path = bezierPath.CGPath;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    
    [bubbleImageView.layer addAnimation:pathAnimation forKey:@"movingAnimation"];
    
    [CATransaction commit];
}

@end

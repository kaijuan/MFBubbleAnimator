//
//  MFBubbleAnimator.h
//  MFBubbleAnimator
//
//  Created by xkjuan on 2022/9/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFBubbleAnimator : NSObject

/**
 添加环形波纹

 @param aniView 要产生波纹的view
 @param rippleColor 波纹颜色
 */
+ (void)mf_addAnnularRippleAtView:(UIView *)aniView
                      rippleColor:(UIColor *)rippleColor;

/**
 气泡动画

 @param imgArr 气泡小图集合
 @param onView 气泡添加位置
 @param point 动画在onView上的起点

 */
+ (void)mf_anchorZanBubbleWithImgArr:(NSArray <UIImage *>*)imgArr
                              onView:(UIView *)onView
                             atPoint:(CGPoint)point;


@end

NS_ASSUME_NONNULL_END

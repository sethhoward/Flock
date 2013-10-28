//
//  Vector2D.h
//  Boids
//
//  Created by David Nolen on 11/3/09.
//  Updated by Seth Howard
//  Copyright 2009 David Nolen. All rights reserved.
//

#define kEpsilon    1.0e-6f
#define kPI         3.1415926535897932384626433832795f
#define kHalfPI     1.5707963267948966192313216916398f
#define kTwoPI      2.0f*kPI

@interface Vector2D : NSObject <NSCopying>
{
  CGFloat _x;
  CGFloat _y;
}

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

// Class Methods

+ (Vector2D*) withX:(CGFloat)x Y:(CGFloat)y;
+ (Vector2D*) newWithX:(CGFloat)x Y:(CGFloat)y;

+ (Vector2D*) add:(Vector2D*)v1 to:(Vector2D*)v2;
+ (Vector2D*) sub:(Vector2D*)v1 with:(Vector2D*)v2;
+ (Vector2D*) mult:(Vector2D*)v with:(CGFloat)scalar;
+ (Vector2D*) div:(Vector2D*)v with:(CGFloat)scalar;
+ (CGFloat) dot:(Vector2D*)v1 with:(Vector2D*)v2;

+ (Vector2D*) xAxis;
+ (Vector2D*) yAxis;
+ (Vector2D*) origin;
+ (Vector2D*) xy;
+ (Vector2D*) zero;
+ (Vector2D*) randomInside:(CGRect)rect;

// Instance Methods

- (Vector2D*) initWithX:(CGFloat)x Y:(CGFloat)y;
- (Vector2D*) copyWithZone:(NSZone *)zone;

- (NSString*) description;

- (CGFloat) length;
- (CGFloat) lengthSquared;

- (BOOL) isEqual:(Vector2D*)other;
- (BOOL) isZero;

- (Vector2D*) clean;
- (Vector2D*) zero;
- (Vector2D*) normalize;
- (Vector2D*) limit:(CGFloat)limit;

- (Vector2D*) add:(Vector2D*)other;
- (Vector2D*) sub:(Vector2D*)other;
- (Vector2D*) mult:(CGFloat)scalar;
- (Vector2D*) div:(CGFloat)scalar;

- (CGFloat) dot:(Vector2D*)other;
- (Vector2D*) perp;
- (CGFloat) perpDot:(Vector2D*)other;

@end
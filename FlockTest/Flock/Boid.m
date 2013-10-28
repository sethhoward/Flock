//
//  Boid.m
//  FlockTest
//
//  Created by Seth Howard on 7/3/13.
//  Copyright (c) 2013 Seth howard. All rights reserved.
//

#import "Boid.h"
#import "Vector2D.h"

#define kDesiredSeparation 25.
#define kNeighborDistance 50.
#define kAlignmentWeight 1.
#define kCohesionWeight 1.
#define kSeparationWeight 2.

@interface Boid ()
@property (nonatomic, strong) Vector2D *acceleration;
@property (nonatomic, strong) Vector2D *velocity;
@end

@implementation Boid {
    @private
    CGFloat _maxForce;
    CGFloat _maxSpeed;
}

- (id)init
{
    self = [super init];
    if (self) {
        _acceleration = [Vector2D withX:0 Y:0];
        
        NSInteger x = (arc4random() % 100 / 100.) * 2 - 1;
        NSInteger y = (arc4random() % 100 / 100.) * 2 - 1;
        
        _velocity = [Vector2D withX:x Y:y];
        
        _maxForce = 0.05;
        _maxSpeed = 2.;
    }
    return self;
}

- (void)checkBorders {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
   // float radius = 2.;
    
    NSInteger x = self.position.x;
    NSInteger y = self.position.y;
    
    if (x <= 0) {
        x = width;
    }
    
    if (y <= 0) {
        y = height;
    }
    
    if (x > width) {
        x = 0;
    }
    
    if (y > height) {
        y = 0;
    }
    
    self.position = CGPointMake(x, y);
}

- (void)updateWithNeighboringBoids:(NSArray *)neighboids {
    // set the acceleration (yes we should be handing the value around)
    self.acceleration = [self flockWithNeighbors:neighboids];
    [self.velocity add:self.acceleration];
    [self.velocity limit:_maxSpeed];
    
    Vector2D *location = [Vector2D withX:self.position.x Y:self.position.y];
    [location add:self.velocity];
    
    self.position = CGPointMake(location.x, location.y);
    [self checkBorders];
}

// return the acceleration
- (Vector2D *)flockWithNeighbors:(NSArray *)neighboids {
    // We accumulate a new acceleration each time based on three rules
    // Seperation, alignment, cohesion
    Vector2D *separation = [self separateBoids:neighboids];
    Vector2D *align = [self alignWithBoids:neighboids];
    Vector2D *cohesion = [self cohesionWithBoids:neighboids];
    Vector2D *acceleration = [Vector2D withX:0 Y:0];
    
    [separation mult:kSeparationWeight];
    [align mult:kAlignmentWeight];
    [cohesion mult:kCohesionWeight];
    
    [acceleration add:separation];
    [acceleration add:align];
    [acceleration add:cohesion];
    
    return acceleration;
}

- (Vector2D *)separateBoids:(NSArray *)boids {
    Vector2D *mean = [Vector2D withX:0 Y:0];
    NSInteger count = 0;
    
    for (Boid *boid in boids) {
        CGFloat distance = [self distanceBetweenPoint:self.position andOtherPoint:boid.position];
        
        // if the distance is zero then we're dealing with this boid
        if (distance > 0 && distance < kDesiredSeparation) {
            // calc the vector pointing away from neighbor
            Vector2D *location = [Vector2D withX:self.position.x Y:self.position.y];
            Vector2D *otherLocation = [Vector2D withX:boid.position.x Y:boid.position.y];
            
            //vDSP_vsub(location, 1, otherLocation, 1, difference, 1, 2);
            Vector2D *difference = [Vector2D sub:location with:otherLocation];
            
            // this is now the differenct between our location and the other boid
            [difference normalize];
            [difference div:distance];
            [mean add:difference];
            
            count++;
        }
    }
    
    // average
    if (count) {
        [mean div:(float)count];
    }
    
    return mean;    
}

// For every nearby boid in the system, calculate the average velocity
- (Vector2D *)alignWithBoids:(NSArray *)boids {
    Vector2D *mean = [Vector2D withX:0 Y:0];
    NSInteger count = 0;
    
    for (Boid *boid in boids) {
        CGFloat distance = [self distanceBetweenPoint:self.position andOtherPoint:boid.position];
        
        if (distance > 0 && distance < kNeighborDistance) {
            [mean add:boid.velocity];
            count++;
        }
    }
    
    if (count) {
        [mean div:(float)count];
        [mean limit:_maxForce];
    }
    
    return mean;
}

// For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
- (Vector2D *)cohesionWithBoids:(NSArray *)boids {
    Vector2D *mean = [Vector2D withX:0 Y:0];
    NSInteger count = 0;
    
    for (Boid *boid in boids) {
        float distance = [self distanceBetweenPoint:self.position andOtherPoint:boid.position];
        
        if (distance > 0 && distance < kNeighborDistance) {
            Vector2D *location = [Vector2D withX:boid.position.x Y:boid.position.y];
            [mean add:location];
            count++;
        }
    }
    
    if (count) {
        [mean div:(float)count];
        
        return [self steerWithTargetVector:mean andDampen:NO];
    }
    
    return mean;
}

- (Vector2D *)steerWithTargetVector:(Vector2D *)target andDampen:(BOOL)slowdown {
    Vector2D *steer = [Vector2D withX:0 Y:0];
    
    Vector2D *location = [Vector2D withX:self.position.x Y:self.position.y];
    Vector2D *desired = [Vector2D sub:target with:location];
    
    CGFloat magnitude = [desired length];
    
    if (magnitude > 0) {
        [desired normalize];
        
        if (slowdown && magnitude < 100.) {
            [desired mult:(_maxSpeed * (magnitude/100.))];
        }
        else {
            [desired mult:_maxSpeed];
        }
        
        steer = [Vector2D sub:desired with:self.velocity];
        [steer limit:_maxForce];
    }
    
    return steer;
}

#pragma mark - Helper

- (CGFloat)distanceBetweenPoint:(CGPoint)point1 andOtherPoint:(CGPoint)point2 {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx * dx + dy * dy);
}

@end

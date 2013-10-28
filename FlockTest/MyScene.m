//
//  MyScene.m
//  FlockTest
//
//  Created by Seth Howard on 7/3/13.
//  Copyright (c) 2013 Seth howard. All rights reserved.
//

#import "MyScene.h"
#import "Flock.h"
#import "Boid.h"

@interface MyScene ()
@property (nonatomic, strong) Flock *flock;
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor blackColor];
        
        self.flock = [[Flock alloc] init];
        Boid *boid = [self createBoidWithVelocity:NO];
        [self.flock addBoid:boid];
        [self addChild:boid];
    }
    return self;
}

- (UIColor *)randomColor {
    UIColor *color = [UIColor colorWithRed:(arc4random() % 255) / 255. green:(arc4random() % 255) / 255. blue:(arc4random() % 255) / 255. alpha:1.];
    return color;
}

- (Boid *)createBoidWithVelocity:(BOOL)hasVeclocity {
    Boid *boid = [[Boid alloc] init];
    boid.color = [self randomColor];
    boid.size = CGSizeMake(10, 10);
    
    if (hasVeclocity) {
        
    }
    
    return boid;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        Boid *boid = [self createBoidWithVelocity:NO];
        boid.position = location;
        [self.flock addBoid:boid];
        [self addChild:boid];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self.flock update];
}

@end

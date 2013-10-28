//
//  Boid.h
//  FlockTest
//
//  Created by Seth Howard on 7/3/13.
//  Copyright (c) 2013 Seth howard. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Vector2D;
@interface Boid : SKSpriteNode

/**
 * Update vel, speed, direction of this boid based on it's neighbors
 *
 * @params The neighbors to update against. The larger the list the longer it takes to update.
 */
- (void)updateWithNeighboringBoids:(NSArray *)neighboids;

@property (nonatomic, readonly) Vector2D *velocity;

@end

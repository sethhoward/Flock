//
//  Flock.h
//  FlockTest
//
//  Created by Seth Howard on 7/3/13.
//  Copyright (c) 2013 Seth howard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Boid;
@interface Flock : NSObject

/**
 * Put a boid into the flock.
 *
 * @param The Boid to add to the flock.
 */
- (void)addBoid:(Boid *)boid;

/**
 * Call to update position, velocity, etc of the flock
 */
- (void)update;

/// Collection of Boids
@property (nonatomic, readonly) NSMutableArray *boids;

@end

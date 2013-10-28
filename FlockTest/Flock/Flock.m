//
//  Flock.m
//  FlockTest
//
//  Created by Seth Howard on 7/3/13.
//  Copyright (c) 2013 Seth howard. All rights reserved.
//

#import "Flock.h"
#import "Boid.h"

@interface Flock ()
@property (nonatomic, strong) NSMutableArray *boids;
@end

@implementation Flock

- (id)init
{
    self = [super init];
    if (self) {
        _boids = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)addBoid:(Boid *)boid {
    [self.boids addObject:boid];
}

- (void)update {
    // TODO: We can speed things up by handing in the closest neihbors instead of all
    for (Boid *boid in self.boids) {
        [boid updateWithNeighboringBoids:self.boids];
    }
}

@end

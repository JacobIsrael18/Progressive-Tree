//
//  ProgressiveLeafNode.h
//  MachineLearning
//
//  Created by newcomp on 3/14/18.
//  Copyright © 2018 JacobIsrael. All rights reserved.
//

#import "ProgressiveNode.h"

@interface ProgressiveLeafNode : ProgressiveNode

-(instancetype) initWithObject:(NSObject*) object andValue:(uint64_t) value;

-(NSObject*) object;
@end

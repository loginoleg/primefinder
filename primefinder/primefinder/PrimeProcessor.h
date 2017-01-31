//
//  PrimeProcessor.h
//  primefinder
//
//  Created by IOS on 1/31/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrimeProcessor : NSObject

- (instancetype)initWithDirectoryPath:(NSString *)baseDirectory;
- (void)start;

@end

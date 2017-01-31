//
//  main.m
//  primefinder
//
//  Created by IOS on 1/31/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrimeProcessor.h"

static const NSString *kCurrentDirectory = @"./";

void showHelp();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSLog(@"primefinder started.");
        
        NSString *filesPath;
        if (argc == 1) {
            showHelp();
            filesPath = (NSString *)kCurrentDirectory;
        } else if (argc > 1) {
            filesPath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        }
        
        PrimeProcessor *processor = [[PrimeProcessor alloc] initWithDirectoryPath:filesPath];
        [processor start];
                
        NSLog(@"primefinder finished.");
    }
    return 0;
}



void showHelp() {
    NSLog(@"It uses current directory");
    NSLog(@"You can set path for files by first argument");
}

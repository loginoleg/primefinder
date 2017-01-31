//
//  main.m
//  randomgenerator
//
//  Created by IOS on 1/31/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *kCurrentDirectory = @".";

static const NSString *kFileBaseName = @"filewithnaturalnumbers";
static const NSString *kFileExtension = @"csv";

static const NSString *kFileFullPathTemplate = @"%@/%@%ld.%@";
static const NSString *kFileFullNameTemplate = @"File with name: %@%ld.%@ %@";

static const NSString *kSuccess = @"success";
static const NSString *kFail = @"fail";

void showHelp();
void generateFilesWithPath(NSString *filePath);
BOOL writeNaturalToFile(NSString *filePath);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"File generator started.");
        if (argc == 1) {
            showHelp();
            generateFilesWithPath(kCurrentDirectory);
        } else if (argc > 1) {
            NSString *filesPath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
            generateFilesWithPath(filesPath);
        }
        NSLog(@"File generator finished.");
    }
    return 0;
}

void generateFilesWithPath(NSString *filesPath) {
    NSUInteger numbersOfFiles = arc4random() % CHAR_MAX;
    for (NSUInteger index = 0; index < numbersOfFiles; index++) {
        NSString *filePath = [NSString stringWithFormat:(NSString *)kFileFullPathTemplate,
                              filesPath, kFileBaseName, (long)index, kFileExtension];
        [[NSFileManager defaultManager] createFileAtPath: filePath contents:nil attributes:nil];
        
        if (writeNaturalToFile(filePath)) {
            NSLog(kFileFullNameTemplate, kFileBaseName, (long)index, kFileExtension, kSuccess);
        } else {
            NSLog(kFileFullNameTemplate, kFileBaseName, (long)index, kFileExtension, kFail);
        }
    }
}

BOOL writeNaturalToFile(NSString *filePath) {
    NSUInteger numberOfNaturalNumbers = arc4random() % CHAR_MAX;
    NSMutableString *stringToWrite = [[NSMutableString alloc] init];
    
    for (NSUInteger index = 0; index < numberOfNaturalNumbers; index++) {
        NSUInteger randomNumber = arc4random() % CHAR_MAX;
        [stringToWrite appendString:[NSString stringWithFormat:@"%ld,", (long)randomNumber]];
    }
    NSUInteger randomNumber = arc4random() % CHAR_MAX;
    [stringToWrite appendString:[NSString stringWithFormat:@"%ld", (long)randomNumber]];
    
    NSError *error;
    [stringToWrite writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    return (error == nil) ? YES : NO;
}

void showHelp() {
    NSLog(@"It uses current directory");
    NSLog(@"You can set path for files by first argument");
}

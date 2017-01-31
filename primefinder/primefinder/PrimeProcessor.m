//
//  PrimeProcessor.m
//  primefinder
//
//  Created by IOS on 1/31/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

#import "PrimeProcessor.h"

static const NSString *kFileBaseName = @"filewithprimenumbers";
static const NSString *kFileExtension = @"csv";
static const NSString *kStringSeparator = @",";

@implementation PrimeProcessor {
    NSString *_baseDirecotry;
    NSMutableArray *_cachedPrimaryNumbers;
}

- (instancetype)initWithDirectoryPath:(NSString *)baseDirectory {
    self = [super init];
    if (self) {
        _baseDirecotry = baseDirectory;
        _cachedPrimaryNumbers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)processDirectory:(NSString *)baseDirectory {
    NSMutableArray *primeNumbers = [[NSMutableArray alloc] init];
    
    NSArray *files = [self findFilesWithNaturalNumbersInDirectory:baseDirectory];
    for (NSString *filePath in files) {
        [primeNumbers addObjectsFromArray:[self findPrimeNumbersInFile:filePath]];
    }
    
    [self writeArray:primeNumbers toFile:[NSString stringWithFormat:@"%@/%@.%@", _baseDirecotry, (NSString *)kFileBaseName, (NSString *)kFileExtension]];
}

- (NSArray<NSString *>*)findFilesWithNaturalNumbersInDirectory:(NSString *)baseDirectory {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSArray *contentsOfDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:baseDirectory error:nil];
    [contentsOfDirectory enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:(NSString *)kFileExtension]) {
            [result addObject:[baseDirectory stringByAppendingString:filename]];
        }
    }];
    
    return (result.count == 0) ? nil : (NSArray<NSString *>*)result;
}

- (NSArray<NSNumber *>*)findPrimeNumbersInFile:(NSString *)filePath {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray<NSString *> *splittedFileContent = [fileContent componentsSeparatedByString:(NSString *)kStringSeparator];
    
    for (NSString *number in splittedFileContent) {
        NSUInteger numberInt = [number integerValue];
        if ([self isPrimeNumber:numberInt]) {
            [result addObject:@(numberInt)];
        }
    }

    return (result.count == 0) ? nil : (NSArray<NSNumber *>*)result;
}

- (BOOL)writeArray:(NSArray<NSNumber *> *)result toFile:(NSString *)filePath {
    NSString *stringToWrite = [result componentsJoinedByString:@","];
    NSError *error;
    [stringToWrite writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    return (error == nil) ? YES : NO;
}

#pragma mark Helpers

- (void)start {
    [self processDirectory:_baseDirecotry];
}

- (BOOL)isPrimeNumber:(NSUInteger)natural {
    BOOL decision = YES;
    
    if ([self isPrimeNumberCheckCache:natural]) {
        decision = YES;
    } else {
        // Calculate is prime
        if (natural <= 1) {
            decision = NO;
        } else if (natural <= 3) {
            decision = YES;
        } else {
            for (NSUInteger i = 2; i < natural; i++) {
                if (natural % i == 0) {
                    decision = NO;
                    break;
                }
            }
        }
        
        if (decision == YES) {
            [self savePrimeToCache:natural];
        }
    }
    
    return decision;
}


- (BOOL)isPrimeNumberCheckCache:(NSUInteger)natural {
    BOOL decision = NO;
    
    for (NSNumber *number in _cachedPrimaryNumbers) {
        if ([number integerValue] == natural) {
            decision = YES;
            break;
        }
    }

    return decision;
}

- (void)savePrimeToCache:(NSUInteger)prime {
    [_cachedPrimaryNumbers addObject:@(prime)];
}



@end

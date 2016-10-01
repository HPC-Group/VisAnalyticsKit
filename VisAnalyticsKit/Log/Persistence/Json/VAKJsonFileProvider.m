//
//  VAKJsonFileProvider.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 10.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

// Custom
#import "VAKJsonFileProvider.h"
#import "VAKFileWriterConstants.h"
#import "VAKSession.h"

static NSString *const VAKJsonExtension = @"json";

// --
// \cond HIDDEN_SYMBOLS
@interface VAKJsonFileProvider ()

@property(nonatomic) id<VAKFileWriterProtocol> writer;
@property(nonatomic) id<VAKFileReaderProtocol> reader;
@property(nonatomic) NSArray *sessionData;

@end
// \endcond

#pragma mark public

@implementation VAKJsonFileProvider

@synthesize folder = _folder;
@synthesize storageType = _storageType;

// -

+ (instancetype)createWithIOComponents:(id<VAKFileWriterProtocol>)writer reader:(id<VAKFileReaderProtocol>)reader folder:(NSString *)folder {
    return [[VAKJsonFileProvider alloc] initWithIOComponents:writer reader:reader folder:folder];
}

/**
 *  helper init
 *
 *  @param id<VAKFileWriterProtocol>writer writer
 *  @param id<VAKFileReaderProtocol>reader reader
 *  @param Nullable|NSString folder folder
 *
 *  @return VAKJsonFileProvider
 */
- (id)initWithIOComponents:(id<VAKFileWriterProtocol>)writer reader:(id<VAKFileReaderProtocol>)reader folder:(NSString *)folder {
    self = [[VAKJsonFileProvider alloc] init];
    
    if (folder) {
        [self addSubfolder:folder];
    }
    
    _writer = writer;
    _reader = reader;
    
    return self;
}

- (id)init {
    if (self = [super init])  {
        _folder = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@/%@", kVAKStatesFolderName, VAKJsonExtension]];
        _storageType = VAKStorageFile;
    }
    return self;
}

#pragma mark JsonProvider Interface

- (BOOL)save:(NSString *)saveId dataToSave:(NSDictionary<NSString *, id> *)dataToSave {
    NSString *filename;
    NSString *folder;
    [self getPathChunks:saveId folder:&folder filename:&filename];
    
    BOOL isSaved = NO;
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataToSave options:NSJSONWritingPrettyPrinted error:&error];
    isSaved = [_writer write:@{
        VAKFileWriterDataKey:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding],
        VAKFileWriterFolderKey:folder,
        VAKFileWriterFileKey:filename,
        VAKFileWriterExtensionKey:VAKJsonExtension
    }];
    
    return isSaved;
}

- (NSDictionary<NSString *, id> *)find:(NSString *)retrieveId objectType:(NSString *)type {
    NSString *filename;
  
    NSError *error;
    NSDictionary<NSString *, id> *object;
    
    @try {
       object = [NSJSONSerialization JSONObjectWithData:[_reader readAsData:retrieveId]
            options:NSJSONReadingAllowFragments
            error:&error
        ];
    } @catch(id ex) {
        NSLog(@"- VAKError: File %@ not found in %@ %@", filename, NSStringFromClass(self.class), NSStringFromSelector(_cmd));
        object = @{ @"error": error };
    }
    
    if (!object) {
       object = @{ @"error": @"something went wrong" };
    }
    
    return object;
}

- (NSArray *)findAllSessions:(NSUInteger)limit offset:(NSUInteger)offset {
    if (!_sessionData) {
        _sessionData = [_reader scanFolderForSessionFiles:nil];
    }

    int appliedOffset = [_sessionData count] - offset;
    int zeroBasedLimit = limit - 1 > 0 ? limit - 1 : 0;

    // if there was no offset subtract one otherwise we will get an out of bounds
    // error
    if (appliedOffset == [_sessionData count]) {
        appliedOffset -= 1;
    }

    int limitSession = appliedOffset - zeroBasedLimit > 0 ? appliedOffset - zeroBasedLimit : 0;
    NSLog(@"limit: %i, offset: %i", limitSession, appliedOffset);

    NSMutableArray *sessions = [[NSMutableArray alloc] init];

    for (int i = appliedOffset; i >= limitSession; i--) {
        VAKSession *session = [VAKSession vak_createWithDictionary:[self find:_sessionData[i] objectType:kVAKSessionType]];
        [sessions addObject:session];
    }
    
    return sessions;
}

- (NSNumber *)countSessions {
    return @([[_reader scanFolderForSessionFiles:nil] count]);
}

- (NSArray *_Nonnull)findStatesWithSession:(NSString *)sessionId limit:(NSUInteger)limit offset:(NSUInteger)offset {
    return @[];
}

#pragma mark FileProviderProtocol

- (void)addSubfolder:(NSString *)subfolder {
    // reset folder structure to prevent infinite folders
    if ([[_folder componentsSeparatedByString:@"/"] count] > 1) {
        _folder = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@/%@", kVAKStatesFolderName, VAKJsonExtension]];
    }
  
    [_folder appendFormat:@"/%@", subfolder];
}

#pragma mark JsonProvider Helpers

/**
 * Checks if the requestedFilename is actually a parentDir/file relationship.
 * Sideeffects: Sets default values for the folder to save the json files and sets the filename itself.
 *
 * @param NSString requestedFilename the filename that's to be saved or retrieved cann also be a dir/file relationship
 *
 * @param NSString folder the base folder where all files are stored
 *
 * @param NSString filename the actual file name to be working on
 */
- (void)getPathChunks:(NSString *)requestedFileName folder:(NSString **)folder filename:(NSString **)filename {
    *filename = requestedFileName;
    *folder = _folder;
    
    if ([requestedFileName containsString:@"/"]) {
        NSMutableArray *pathChunks = [NSMutableArray arrayWithArray:[requestedFileName componentsSeparatedByString:@"/"]];
        *filename = [pathChunks lastObject];
        [pathChunks removeObjectAtIndex: [pathChunks count]-1];
        
        [pathChunks insertObject:*folder atIndex:0];
        *folder = [pathChunks componentsJoinedByString:@"/"];
    }
}

@end

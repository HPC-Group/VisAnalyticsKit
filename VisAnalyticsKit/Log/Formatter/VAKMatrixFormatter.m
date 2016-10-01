//
// Created by VisAnalyticsKit on 12.04.16.
//

#import "VAKMatrixFormatter.h"

@implementation VAKMatrixFormatter

+ (NSString *)vak_formatData:(NSDictionary *)data {
    NSString *formatted = [[NSString alloc] init];

    @try {
        NSArray *matrix = data[kVAKStateDataMatrix];
        NSMutableArray *matrixRows = [[NSMutableArray alloc] init];

        for (NSArray *row in matrix) {
            [matrixRows addObject:[row componentsJoinedByString:@"\t"]];
        }

        formatted = [NSString stringWithFormat:@"\n\t%@\n", [matrixRows componentsJoinedByString:@"\n\t"]];

    } @catch (NSException *e) {
        NSLog(@"- VAKError: %@: %@", NSStringFromClass(self.class), e.reason);
    }

    return formatted;
}

@end

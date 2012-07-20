
#import <Foundation/Foundation.h>

@interface Metadata : NSObject


+(void)setMetadataForFile:(UIImage *)img;
+(NSDictionary *)printMetadataForUIImage:(UIImage *)img;
@end



#import "Metadata.h"
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>


@implementation Metadata

+(void)setMetadataForFile:(UIImage *)image
{
    NSMutableData *dest_data = [NSMutableData data];
    //pngs or compression of 1 would be nice, but file i/o is so slow it's not worth it. .9 is a good spot
    CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)UIImageJPEGRepresentation(image, .9), NULL);
    
    // CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)UIImagePNGRepresentation(img), NULL);
    
    CFStringRef UTI = CGImageSourceGetType(source); //this is the type of image (e.g., public.jpeg)
    //not sure this flag will work, but it may help with memory 
    CFDictionaryRef options = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:(id)kCFBooleanFalse, (id)kCGImageSourceShouldCache,
                                                         nil];
    
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data,UTI,1,options);
    
    if(!destination) {
        NSLog(@"***Could not create image destination ***");
    }
    
    //get all the metadata in the image
    NSDictionary *metadata = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source,0,NULL);    
    
    NSMutableDictionary *metadataAsMutable = [metadata mutableCopy];
    
    metadata = nil;
    
     
   
    //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination,source,0, (__bridge CFDictionaryRef) metadataAsMutable);
    
    //tell the destination to write the image data and metadata into our data object.
    //It will return false if something goes wrong
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    
    if(!success) {
        NSLog(@"***Could not create data from image destination ***");
    }
    
    NSString *documentdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *jpegPath = [documentdir stringByAppendingPathComponent:@"newfile.jpg"]; 
    NSLog(@"Path %@",jpegPath);
    
    //now we have the data ready to go, so do whatever you want with it
    //here we just write it to disk at the same path we were passed
    
    BOOL didWrite = [dest_data writeToFile:jpegPath atomically:YES];

    if (!didWrite) {
        NSLog(@"Failed to write");
    }
    else {
        NSLog(@"File writing Success");
    }
    
    //cleanup
    
    CFRelease(destination);
    CFRelease(source);
}

+(NSDictionary *)printMetadataForUIImage:(UIImage *)img
{
    NSMutableData *dest_data = [NSMutableData data];
    //pngs or compression of 1 would be nice, but file i/o is so slow it's not worth it. .9 is a good spot
    CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)UIImageJPEGRepresentation(img, .9), NULL);

    // CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)UIImagePNGRepresentation(img), NULL);

    CFStringRef UTI = CGImageSourceGetType(source); //this is the type of image (e.g., public.jpeg)
    //not sure this flag will work, but it may help with memory 
    CFDictionaryRef options = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:(id)kCFBooleanFalse, (id)kCGImageSourceShouldCache,
                                                         nil];


    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data,UTI,1,options);

    if(!destination) {
        NSLog(@"***Could not create image destination ***");
    }

    //get all the metadata in the image
    NSDictionary *metadata = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source,0,NULL);
    return metadata;
}
@end

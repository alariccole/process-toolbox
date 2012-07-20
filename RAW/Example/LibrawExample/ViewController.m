
#import "ViewController.h"
#import "RAW.h"
#import "Metadata.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize imageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getMetadata];
    [self setMetadata];
    
    
}

- (void)viewDidUnload
{
	[self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)getMetadata
{
    UIImage *image = [UIImage imageWithContentsOfFile:[self getFullPath]];
    
    NSDictionary *metadata = [Metadata printMetadataForUIImage:image];
    NSLog(@"\n Metadata:\n %@",metadata);
}

-(void)setMetadata
{
    UIImage *image = [UIImage imageWithContentsOfFile:[self getFullPath]];
    
   [Metadata setMetadataForFile:image];
}

-(NSString *)filePath
{
    NSString *rawFileName;
    
    switch (1) {
        case 0:
            rawFileName = @"canon-5DMarkIII.cr2";//big sized thumbnail
            break;
        case 1:
            rawFileName = @"adobe.dng";//works
            break;
        case 2:
            rawFileName = @"RAW_NIKON_D1.NEF";//works
            break;
        case 3:
            rawFileName = @"RAW_LEICA_VLUX1.RAW";//fails to unpack.Maybe error with file
            break;
        case 4:
            rawFileName = @"s3pro_007785.raf";//thumbnail works
            break;
        case 5:
            rawFileName = @"nikond200.NEF";//thumbnail works
            break;
        case 6:
            rawFileName = @"testpattern.DNG";
            break;
            
        default:
            break;
    }
    return rawFileName;
    
}
-(NSString *)getFullPath
{
    NSString *rawFileName;
    
    NSString *file, *filename,*extension;
    
    rawFileName = [self filePath];
    
    filename  = [rawFileName stringByDeletingPathExtension];
    extension = [rawFileName pathExtension];
    
    file = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    return file;
    
}
- (IBAction)loadThumbnailPreviewWithMaxSize:(CGSize)maxSize
{
    
    NSString *file, *filename,*extension;
    NSString *rawFileName;
    
    rawFileName = [self filePath];
    
    filename  = [rawFileName stringByDeletingPathExtension];
    extension = [rawFileName pathExtension];
    
    file = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
	
	//how to pass in max size requested for thumbnail?
	UIImage *img = [RAW getThumbnailFromFile:file];
	
	NSLog(@"thumbnail size: %@", NSStringFromCGSize(img.size));
    imageView.image = img;

	
}

- (IBAction)loadRawImage:(id)sender {
	NSString *file = [[NSBundle mainBundle] pathForResource:@"nikond200" ofType:@"NEF"];
    // NSString *file = [[NSBundle mainBundle] pathForResource:@"RAW_NIKON_D1" ofType:@"NEF"];
    // NSString *file = [[NSBundle mainBundle] pathForResource:@"--1011" ofType:@"cr2"];
	
	
	UIImage *img = [RAW getUIImageFromFile:file];
	NSLog(@"image size: %@", NSStringFromCGSize(img.size));
    imageView.image = img;

}

//this method is incorrect, as I do not know the api for writing to a raw file

- (IBAction)writeToRAWFile:(id)sender {
	
	NSString *documentdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *destPath = [documentdir stringByAppendingPathComponent:@"newfile.tiff"];

	NSString *file = [[NSBundle mainBundle] pathForResource:@"canon-5DMarkIII" ofType:@"cr2"];
	
	BOOL success = [RAW writeRawData:file toDisk:destPath];
	
	
	NSLog(@"write to TIFF %@", success ? @"Yes" : @"No");
}

- (IBAction)writeToTIFF:(id)sender {
	
	NSString *documentdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSString *destPath = [documentdir stringByAppendingPathComponent:@"newfile.tiff"];
	
	NSString *file = [[NSBundle mainBundle] pathForResource:@"canon-5DMarkIII" ofType:@"cr2"];
	
	BOOL success = [RAW writeRawData:file toDisk:destPath];
	
	NSLog(@"write to TIFF %@", success ? @"Yes" : @"No");
}


@end

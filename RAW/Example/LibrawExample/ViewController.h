#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)loadThumbnailPreviewWithMaxSize:(CGSize)maxSize;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)loadRawImage:(id)sender;
- (IBAction)writeToTIFF:(id)sender;
- (IBAction)writeToRAWFile:(id)sender;

@end

#import "InfoView.h"

@implementation InfoView
@synthesize textView = _textView;
@synthesize titleLabel = _titleLabel;
@synthesize imageView = _imageView;
@synthesize timesTextView = _timesTextView;
@synthesize view = _view;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        [[NSBundle mainBundle] loadNibNamed:@"InfoView" owner:self options:nil];
    }
    return self;
}

@end

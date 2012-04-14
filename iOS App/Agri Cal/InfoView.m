#import "InfoView.h"

@implementation InfoView
@synthesize textView = _textView;
@synthesize titleLabel = _titleLabel;
@synthesize imageView = _imageView;
@synthesize timesTextView = _timesTextView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"infoimage.png"];
        self.imageView = [[UIImageView alloc] initWithImage:image]; 
        CGRect frame = self.imageView.frame;
        frame.origin.x += 4;
        frame.origin.y += 4;
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 114, 320, self.frame.size.height-114)];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.textColor = [UIColor lightGrayColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(118, 4, 320-114, 20)];
        self.titleLabel.text = @"title";
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.timesTextView = [[UITextView alloc] initWithFrame:CGRectMake(114, 28, 320-114, self.frame.size.height-self.textView.frame.size.height-self.titleLabel.frame.size.height-8)];
        self.timesTextView.backgroundColor = [UIColor clearColor];
        self.timesTextView.textColor = [UIColor lightGrayColor];
        
        [self addSubview:self.timesTextView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageView];
        [self addSubview:self.textView];
    }
    return self;
}

@end

//
// Copyright (c) 2016 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PictureView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface PictureView()
{
	UIImage *picture;
	BOOL statusBarIsHidden;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *buttonDone;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation PictureView

@synthesize imageView, buttonDone;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWith:(UIImage *)picture_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super init];
	picture = picture_;
	return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
	[self.view addGestureRecognizer:panGestureRecognizer];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	statusBarIsHidden = [UIApplication sharedApplication].isStatusBarHidden;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	imageView.image = picture;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	statusBarIsHidden = YES;
	[self setNeedsStatusBarAppearanceUpdate];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLayoutSubviews
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLayoutSubviews];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self updatePictureDetails];
	[self updateHideDetails];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)prefersStatusBarHidden
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return statusBarIsHidden;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UIStatusBarStyle)preferredStatusBarStyle
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return UIStatusBarStyleLightContent;
}

#pragma mark - UIPanGestureRecognizer methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CGFloat moveY = [gestureRecognizer translationInView:self.view].y;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	switch (gestureRecognizer.state)
	{
		case UIGestureRecognizerStateChanged:
		{
			self.imageView.center = CGPointMake(self.view.center.x, self.view.center.y + moveY);
			break;
		}
		case UIGestureRecognizerStateEnded:
		{
			[self gestureEnded:moveY];
			break;
		}
		case UIGestureRecognizerStateBegan:
		case UIGestureRecognizerStatePossible:
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed:
			break;
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)gestureEnded:(CGFloat)moveY
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (fabs(moveY) < 80)
	{
		[UIView animateWithDuration:0.3 animations:^{
			self.imageView.center = self.view.center;
		}];
	}
	else [self actionDismiss:moveY];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionDismiss:(CGFloat)moveY
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	moveY = 600 * (moveY / fabs(moveY));
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[UIView animateWithDuration:0.3 animations:^{
		self.imageView.center = CGPointMake(self.imageView.center.x, self.imageView.center.y + moveY);
	} completion:^(BOOL complete) {
		imageView.hidden = YES;
		[self dismissViewControllerAnimated:NO completion:nil];
	}];
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionDone:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)updatePictureDetails
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CGFloat xpos, ypos, width, height;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ((picture.size.width / picture.size.height) > (SCREEN_WIDTH / SCREEN_HEIGHT))
	{
		width = SCREEN_WIDTH;
		height = picture.size.height * width / picture.size.width;
		xpos = 0; ypos = (SCREEN_HEIGHT - height) / 2;
	}
	else
	{
		height = SCREEN_HEIGHT;
		width = picture.size.width * height / picture.size.height;
		ypos = 0; xpos = (SCREEN_WIDTH - width) / 2;
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	imageView.frame = CGRectMake(xpos, ypos, width, height);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)updateHideDetails
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	BOOL landscape = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	buttonDone.hidden = landscape;
}

@end


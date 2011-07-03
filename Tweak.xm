#import <SBAwayView.h>
#import <SBAwayChargingView.h>
#import <SBBatteryChargingView.h>
#define PATH @"/System/Library/CoreServices/SpringBoard.app"

static BOOL enableAnimateBattery=YES;
static BOOL animateFullStatus=YES;

static void getSettings(){
	NSDictionary *defaults=[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/net.limneos.animatebattery.plist"];
	enableAnimateBattery=[defaults objectForKey:@"enabled"] ?  [[defaults objectForKey:@"enabled"] boolValue] : YES;
	animateFullStatus=[defaults objectForKey:@"allTiles"] ?  [[defaults objectForKey:@"allTiles"] boolValue] : YES;
}

%hook SBAwayView
-(void)showChargingView{
	%orig;
	getSettings();
	if (!enableAnimateBattery)
		return;
	SBBatteryChargingView *chargingView=[[self chargingView] chargingView];
	UIImageView *battView=MSHookIvar<UIImageView *>(chargingView,"_topBatteryView");
	if (chargingView.alpha>0 && ![battView isAnimating] ){
		[chargingView setShowsReflection:NO];
		NSMutableArray *images=[NSMutableArray array];
		int startImage=animateFullStatus ? 1 : ([chargingView _currentBatteryIndex]-1>0 ? [chargingView _currentBatteryIndex]-1 : [chargingView _currentBatteryIndex]) ;
		for (int i=startImage; i<=[chargingView _currentBatteryIndex]; i++){
			[images addObject:[UIImage imageNamed:[NSString stringWithFormat:[chargingView _imageFormatString],i]]];
		}
		battView.animationImages = images;
		battView.animationDuration = images.count>4 ? images.count/4 : 1;
		battView.animationRepeatCount = 0;
		[battView startAnimating];
	}
}
-(void)hideChargingView{
	if (!enableAnimateBattery){
		%orig;
		return;
	}
	UIImageView *charginView=[[self chargingView] chargingView];
	UIImageView *battView=MSHookIvar<UIImageView *>(charginView,"_topBatteryView");
	[battView stopAnimating];
	%orig;
}
%end
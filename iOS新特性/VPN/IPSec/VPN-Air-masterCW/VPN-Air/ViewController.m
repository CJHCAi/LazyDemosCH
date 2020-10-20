#import "ConfigVPN.h"
#import "ViewController.h"
#import "VPNAccount.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property(nonatomic,strong)UILabel * stateLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //监测是否连接VPN
    [[ConfigVPN shareManager] connected:^(BOOL connected) {
        self.switchBtn.on = connected;
        if (connected) {
            self.stateLabel.text=@"已连接VPN";
        }else{
            self.stateLabel.text=@"未连接VPN";
        }
    }];

    [[ConfigVPN shareManager] removeVPNProfile];
    //配置参数
    [VPNAccount shareManager].vpnUserName = @"vpnuser";
    [VPNAccount shareManager].vpnUserPassword =@"a3ztPw4mJdGoAffn";
    [VPNAccount shareManager].severAddress = @"207.148.89.94";
    [VPNAccount shareManager].sharePsk = @"85i72626K467wwFR";


}

- (IBAction)switchAction:(UISwitch *)sender{
    if (sender.isOn)
    {
        [[ConfigVPN shareManager] connectVPN];
    }else
    {
        [[ConfigVPN shareManager] disconnectVPN];
    }
    
}

-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel=[UILabel new];
        _stateLabel.frame=CGRectMake(50,100,200,20);
        _stateLabel.font=[UIFont systemFontOfSize:18];
        _stateLabel.textColor=[UIColor blackColor];
        _stateLabel.textAlignment=NSTextAlignmentLeft;
        _stateLabel.backgroundColor=[UIColor redColor];
        [self.view addSubview:_stateLabel];
    }
    return _stateLabel;
}

@end

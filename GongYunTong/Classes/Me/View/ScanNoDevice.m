//
//  ScanNoDevice.m
//  GongYunTong
//
//  Created by pingjun lin on 16/10/31.
//  Copyright © 2016年 vhs_health. All rights reserved.
//

#import "ScanNoDevice.h"

@interface ScanNoDevice ()

@property (weak, nonatomic) IBOutlet UIButton *helpBtn;

@end

@implementation ScanNoDevice

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.helpBtn addTarget:self action:@selector(getHelpClick) forControlEvents:UIControlEventTouchUpInside];
}

+ (ScanNoDevice *)scanNoDeviceFromNib {
    ScanNoDevice *noDeviceView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    return noDeviceView;
}

- (void)getHelpClick {
    if (!self.getHelpBlock) {
        return;
    }
    self.getHelpBlock();
}

- (IBAction)researchBle:(id)sender {
    [VHSToast toast:@"research"];
}

@end

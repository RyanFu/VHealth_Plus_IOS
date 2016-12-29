require('UIView,UIColor,UILabel');
defineClass('VHSTestController', {
    viewWillAppear: function(animated) {
        self.super().viewWillAppear(animated);
        
        var yellowView = UIView.alloc().initWithFrame({x:10, y:380, width:300, height:100});
        yellowView.setBackgroundColor(UIColor.blueColor());
        self.view().addSubview(yellowView);
    },
    viewDidAppear: function(animated) {
        self.super().viewDidAppear(animated);
            
        var textLabel = UILabel.alloc().initWithFrame({x:10, y:490, width:300, height:100});
        textLabel.setBackgroundColor(UIColor.yellowColor());
        textLabel.setTextColor(UIColor.blackColor());
        textLabel.setText("这个是JS产生的Label");
        self.view().addSubview(textLabel);
    },
});



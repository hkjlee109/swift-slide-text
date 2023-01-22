import UIKit
import QuartzCore

public class UISlideTextLabel: UILabel {

    private var label1 = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // Todo: Support Storyboard
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open class var layerClass: AnyClass {
        return CAReplicatorLayer.self
    }
    
    public override var bounds: CGRect {
        didSet {
            label1.frame = self.bounds
        }
    }

    public override var text: String? {
        didSet {
            label1.text = text
        }
    }
    
    private func setup() {
        super.clipsToBounds = true
        super.numberOfLines = 1
        
        syncLabel()
    
        (self.layer as? CAReplicatorLayer)?.instanceCount = 2
        (self.layer as? CAReplicatorLayer)?.instanceTransform = CATransform3DMakeTranslation(140, 0.0, 0.0)

        addSubview(label1)
        
//        UIView.animate(withDuration: 8.0, delay:0, options: [.repeat], animations: {
//            self.label1.frame = CGRectMake(self.label1.frame.origin.x - 500, self.label1.frame.origin.y - 0, self.label1.frame.size.width, self.label1.frame.size.height)
//        }, completion: nil)
        
    }
    
    private func syncLabel() {
        label1.text = super.text
        label1.font = super.font
        label1.textColor = super.textColor
//        label1.frame = self.bounds
        label1.layer.anchorPoint = CGPoint.zero
    }
    
    override open func draw(_ layer: CALayer, in ctx: CGContext) {
        if let bgColor = backgroundColor {
            ctx.setFillColor(bgColor.cgColor)
            ctx.fill(layer.bounds)
        }
    }
}

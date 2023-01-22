import UIKit

public class UISlideTextLabel: UILabel {

    private var mainLabel = UILabel()

    public var blankWidth: CGFloat = 20
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open class var layerClass: AnyClass {
        return CAReplicatorLayer.self
    }
    
    public override var bounds: CGRect {
        didSet {
            mainLabel.frame = self.bounds
            
            let intrinsicLabelWidth = mainLabel.sizeThatFits(
                CGSize(
                    width: CGFloat.greatestFiniteMagnitude,
                    height: CGFloat.greatestFiniteMagnitude
                )
            ).width
            
            print("#bounds.size.width: ", bounds.size.width)
            print("#intrinsicLabelWidth: ", intrinsicLabelWidth)
            
            guard intrinsicLabelWidth > bounds.size.width else { return }
            
            (self.layer as? CAReplicatorLayer)?.instanceCount = 2
            (self.layer as? CAReplicatorLayer)?.instanceTransform = CATransform3DMakeTranslation(intrinsicLabelWidth + blankWidth, 0.0, 0.0)
        }
    }

    public override var text: String? {
        didSet {
            mainLabel.text = text
        }
    }
    
    override open func draw(_ layer: CALayer, in ctx: CGContext) {
        if let bgColor = backgroundColor {
            ctx.setFillColor(bgColor.cgColor)
            ctx.fill(layer.bounds)
        }
    }
    
    private func setup() {
        super.clipsToBounds = true
        super.numberOfLines = 1
        
        configureMainLabel()

        addSubview(mainLabel)
        
//        UIView.animate(withDuration: 8.0, delay:0, options: [.repeat], animations: {
//            self.label1.frame = CGRectMake(self.label1.frame.origin.x - 500, self.label1.frame.origin.y - 0, self.label1.frame.size.width, self.label1.frame.size.height)
//        }, completion: nil)
        
    }
    
    private func configureMainLabel() {
        mainLabel.text = super.text
        mainLabel.font = super.font
        mainLabel.textColor = super.textColor
        mainLabel.layer.anchorPoint = CGPoint.zero
    }
}

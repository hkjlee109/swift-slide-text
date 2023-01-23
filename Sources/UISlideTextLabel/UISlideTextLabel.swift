import UIKit

public class UISlideTextLabel: UILabel {

    private var mainLabel = UILabel()

    public var blankWidth: CGFloat = 40
    public var pauseDuration: NSNumber = 5
    
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
            self.mainLabel.frame = bounds
            
            let intrinsicLabelWidth = mainLabel.sizeThatFits(
                CGSize(
                    width: CGFloat.greatestFiniteMagnitude,
                    height: CGFloat.greatestFiniteMagnitude
                )
            ).width

            guard intrinsicLabelWidth > bounds.size.width else { return }
            
            self.mainLabel.frame = CGRect(x: bounds.minX, y: bounds.minY, width: intrinsicLabelWidth, height: bounds.height)
            
            (self.layer as? CAReplicatorLayer)?.instanceCount = 2
            (self.layer as? CAReplicatorLayer)?.instanceTransform = CATransform3DMakeTranslation(intrinsicLabelWidth + blankWidth, 0.0, 0.0)

            let gradientLayer = CAGradientLayer()
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

            gradientLayer.bounds = self.layer.bounds
            gradientLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            
            let transparent = UIColor.clear.cgColor
            let opaque = UIColor.black.cgColor
            
            gradientLayer.colors = [ opaque, opaque, opaque, opaque, transparent ]
            self.layer.mask = gradientLayer
            
            let scrollAnimation = CAKeyframeAnimation()
            scrollAnimation.keyPath = "position.x"
            scrollAnimation.keyTimes = [ 0, 0.5, 1 ]
            scrollAnimation.values = [0, 0, -(intrinsicLabelWidth + blankWidth)]
            scrollAnimation.duration = 10
            scrollAnimation.isAdditive = true
            scrollAnimation.repeatCount = .infinity

            let maskAnimation = CAKeyframeAnimation()
            maskAnimation.keyPath = "colors"
            maskAnimation.keyTimes = [ 0, 0.5, 0.52, 0.95, 1 ]
            maskAnimation.values = [
                [ opaque, opaque, opaque, opaque, transparent ],
                [ opaque, opaque, opaque, opaque, transparent ],
                [ transparent, opaque, opaque, opaque, transparent ],
                [ transparent, opaque, opaque, opaque, transparent ],
                [ opaque, opaque, opaque, opaque, transparent ]
            ]
            maskAnimation.duration = 10
            maskAnimation.repeatCount = .infinity
        
            self.mainLabel.layer.add(scrollAnimation, forKey: "scroll")
            self.layer.mask?.add(maskAnimation, forKey: "mask")
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
    }
    
    private func configureMainLabel() {
        mainLabel.text = super.text
        mainLabel.font = super.font
        mainLabel.textColor = super.textColor
    }
}

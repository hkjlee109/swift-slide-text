import UIKit

public class UISlideLabel: UILabel {

    private var mainLabel = UILabel()

    public var speed: Double = 1
    public var secondsPerScreen: Double = 5
    public var pauseDuration: Double = 2
    public var blankWidth: CGFloat = 40
    
    private var scrollDuration: Double {
        return mainLabel.intrinsicContentSize.width / self.bounds.width * secondsPerScreen
    }
    
    private var pauseDurationRatio: Double {
        return self.pauseDuration / (self.scrollDuration + self.pauseDuration)
    }
    
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
            guard mainLabel.intrinsicContentSize.width > bounds.size.width else {
                self.mainLabel.frame = bounds
                (self.layer as? CAReplicatorLayer)?.instanceCount = 1
                removeScrollAnimation()
                removeFadeAnimation()
                return
            }
            
            self.mainLabel.frame = CGRect(
                x: bounds.minX,
                y: bounds.minY,
                width: mainLabel.intrinsicContentSize.width,
                height: bounds.height)
            
            (self.layer as? CAReplicatorLayer)?.instanceCount = 2
            (self.layer as? CAReplicatorLayer)?.instanceTransform = CATransform3DMakeTranslation(
                mainLabel.intrinsicContentSize.width + blankWidth,
                0.0,
                0.0
            )

            addFadeAnimation()
            addScrollAnimation(
                distance: mainLabel.intrinsicContentSize.width + blankWidth
            )
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
        self.mainLabel.text = super.text
        self.mainLabel.font = super.font
        self.mainLabel.textColor = super.textColor
    }
    
    private func addScrollAnimation(distance: CGFloat) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.keyTimes = [ 0, pauseDurationRatio as NSNumber, 1 ]
        animation.values = [0, 0, -distance]
        animation.isAdditive = true
        animation.duration = pauseDuration + scrollDuration
        animation.repeatCount = .infinity
        
        self.mainLabel.layer.add(animation, forKey: "scroll")
    }
    
    private func removeScrollAnimation() {
        self.mainLabel.layer.removeAnimation(forKey: "scroll")
    }
        
    private func addFadeAnimation() {
        let x = UIColor.clear.cgColor
        let o = UIColor.black.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.bounds = self.layer.bounds
        gradientLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        gradientLayer.colors = [ o, o, o, o, o ]
        
        let maskAnimation = CAKeyframeAnimation()
        maskAnimation.keyPath = "colors"
        maskAnimation.keyTimes = [
            0,
            pauseDurationRatio as NSNumber,
            (pauseDurationRatio + 0.04) as NSNumber,
            0.9,
            1
        ]
        maskAnimation.values = [
            [ o, o, o, o, x ],
            [ o, o, o, o, x ],
            [ x, o, o, o, x ],
            [ x, o, o, o, x ],
            [ o, o, o, o, x ]
        ]
        maskAnimation.duration = pauseDuration + scrollDuration
        maskAnimation.repeatCount = .infinity
    
        self.layer.mask = gradientLayer
        self.layer.mask?.add(maskAnimation, forKey: "fade")
    }
    
    private func removeFadeAnimation() {
        self.layer.mask?.removeAnimation(forKey: "fade")
        self.layer.mask = nil
    }
}

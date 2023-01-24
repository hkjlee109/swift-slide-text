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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open override var bounds: CGRect {
        didSet {
            invalidate()
        }
    }

    open override var text: String? {
        didSet {
            guard mainLabel.text != text else { return }
            mainLabel.text = text
            invalidate()
        }
    }
    
    open override var font: UIFont! {
        didSet {
            guard mainLabel.font != font else { return }
            mainLabel.font = font
            invalidate()
        }
    }
    
    open override var textColor: UIColor! {
        didSet {
            guard mainLabel.textColor != textColor else { return }
            mainLabel.textColor = textColor
        }
    }
    
    open override func didMoveToWindow() {
        guard let _ = self.window else {
            deactivate()
            return
        }
        activateIfNeeded()
    }
    
    open override class var layerClass: AnyClass {
        return CAReplicatorLayer.self
    }
    
    open override func draw(_ layer: CALayer, in ctx: CGContext) {
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(activateIfNeeded),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deactivate),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    private func configureMainLabel() {
        self.mainLabel.text = super.text
        self.mainLabel.font = super.font
        self.mainLabel.textColor = super.textColor
    }
    
    private func invalidate() {
        guard mainLabel.intrinsicContentSize.width > bounds.size.width else {
            mainLabel.frame = bounds
            deactivate()
            return
        }
        
        mainLabel.frame = CGRect(
            x: bounds.minX,
            y: bounds.minY,
            width: mainLabel.intrinsicContentSize.width,
            height: bounds.height
        )

        activateIfNeeded()
    }

    private func addReplication() {
        (self.layer as? CAReplicatorLayer)?.instanceCount = 2
        (self.layer as? CAReplicatorLayer)?.instanceTransform = CATransform3DMakeTranslation(
            mainLabel.intrinsicContentSize.width + blankWidth,
            0.0,
            0.0
        )
    }
    
    private func removeReplication() {
        (self.layer as? CAReplicatorLayer)?.instanceCount = 1
    }
    
    private func addScrollAnimation(distance: CGFloat) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.keyTimes = [ 0, pauseDurationRatio as NSNumber, 1 ]
        animation.values = [0, 0, -distance]
        animation.isAdditive = true
        animation.duration = (pauseDuration + scrollDuration) * speed
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
        let fadeAnimation = CAKeyframeAnimation()
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.bounds = self.layer.bounds
        gradientLayer.locations = [ 0.0, 0.05, 0.95, 1.0 ]
        gradientLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        gradientLayer.colors = [ o, o, o, o ]
        
        fadeAnimation.keyPath = "colors"
        fadeAnimation.keyTimes = [
            0,
            pauseDurationRatio as NSNumber,
            (pauseDurationRatio + 0.04) as NSNumber,
            0.9,
            1
        ]
        fadeAnimation.values = [
            [ o, o, o, x ],
            [ o, o, o, x ],
            [ x, o, o, x ],
            [ x, o, o, x ],
            [ o, o, o, x ]
        ]
        fadeAnimation.duration = (pauseDuration + scrollDuration) * speed
        fadeAnimation.repeatCount = .infinity
    
        self.layer.mask = gradientLayer
        self.layer.mask?.add(fadeAnimation, forKey: "fade")
    }
    
    private func removeFadeAnimation() {
        self.layer.mask?.removeAnimation(forKey: "fade")
        self.layer.mask = nil
    }
    
    @objc private func activateIfNeeded() {
        guard mainLabel.intrinsicContentSize.width > bounds.size.width else {
            return
        }

        addReplication()
        addFadeAnimation()
        addScrollAnimation(
            distance: mainLabel.intrinsicContentSize.width + blankWidth
        )
    }
    
    @objc private func deactivate() {
        removeReplication()
        removeScrollAnimation()
        removeFadeAnimation()
    }
}

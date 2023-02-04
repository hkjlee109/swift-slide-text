import SwiftUI

public struct SlideText: View {
    
    public var secondsPerScreen: Double = 7
    public var blankWidth: CGFloat = 40
    
    private let text: String
    private let speed: Double
    private let pauseDuration: Double
    
    @State private var textWidth: Double = .zero
    @State private var viewWidth: Double = .zero
    @State private var xOffset: CGFloat = 0
    
    private var gapWidth: Double  {
        get {
            return (textWidth > viewWidth) ? blankWidth : viewWidth - textWidth
        }
    }
    
    private var needSliding: Bool {
        get {
            return textWidth > viewWidth
        }
    }
    
    private var animationDuration: Double {
        get {
            return textWidth / viewWidth * (secondsPerScreen / speed)
        }
    }

    public init(_ text: String, speed: Double = 1, pauseDuration: Double = 4) {
        self.text = text
        self.speed = speed
        self.pauseDuration = pauseDuration
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                Text(text)
                    .fixedSize(horizontal: true, vertical: false)
                    .readWidth { width in
                        self.textWidth = width
                    }
                
                    Spacer(minLength: gapWidth)
                    
                    Text(text)
                        .fixedSize(horizontal: true, vertical: false)
            }
            .offset(x: xOffset, y: 0)
            .onAppear {
                if needSliding {
                    withAnimation(
                        .linear(duration: animationDuration)
                        .delay(pauseDuration)
                        .repeatForever(autoreverses: false)
                    ) {
                        xOffset = -(textWidth + gapWidth)
                    }
                }
            }
        }
        .disabled(true)
        .clipped()
        .mask(
            HStack(spacing:0) {
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.black.opacity(0), Color.black]
                    ),
                    startPoint: .leading,
                    endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/
                )
                .modifier(FrameWidthOnOffSwitch(for: xOffset, onRange: (-textWidth, 0)))
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.black, Color.black]),
                    startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/,
                    endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/
                )
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.black, Color.black.opacity(0)]),
                    startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/,
                    endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/
                )
                .frame(width: needSliding ? 12 : 0)
            }
        )
        .readWidth { width in
            self.viewWidth = width
        }
    }
}

fileprivate struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: Double = .zero
    static func reduce(value: inout Double, nextValue: () -> Double) {}
}

fileprivate extension View {
    func readWidth(onChange: @escaping (Double) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: WidthPreferenceKey.self, value: proxy.size.width)
            }
        )
        .onPreferenceChange(WidthPreferenceKey.self, perform: onChange)
    }
}

fileprivate struct FrameWidthOnOffSwitch: AnimatableModifier {
    private var value: CGFloat
    private var onRange: (CGFloat, CGFloat)
    
    var animatableData: CGFloat {
        get { value }
        set { value = newValue }
    }
    
    init(for value: CGFloat, onRange: (CGFloat, CGFloat)) {
        self.value = value
        self.onRange = onRange
    }
    
    func body(content: Content) -> some View {
        content.frame(width: (onRange.0 < value && value < onRange.1) ? 12 : 0)
    }
}

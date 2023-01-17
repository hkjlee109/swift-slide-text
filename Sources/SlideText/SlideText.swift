import SwiftUI

public struct SlideText: View {
    private let text: String
    private let delay: Double
    
    @State private var textWidth: Double = .zero
    @State private var viewWidth: Double = .zero
    @State private var xOffset: CGFloat = 0
    
    private var gapWidth: Double  {
        get {
            return (textWidth > viewWidth) ? viewWidth / 3 : viewWidth - textWidth
        }
    }
    
    private var needSliding: Bool {
        get {
            return textWidth > viewWidth
        }
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
                        .linear(duration: 5)
                        .delay(delay)
                        .repeatForever(autoreverses: false)
                    ) {
                        xOffset = -(textWidth + gapWidth)
                    }
                }
            }
        }
        .disabled(true)
        .clipped()
        .readWidth { width in
            self.viewWidth = width
        }
    }
    
    public init(_ text: String, delay: Double = 3) {
        self.text = text
        self.delay = delay
    }
}

extension SlideText {
    public func delay(_ delay: Double) -> SlideText {
        SlideText(self.text, delay: delay)
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

import SwiftUI

public struct SlideText: View {
    private let text: String
    
    @State private var textWidth: Double = .zero
    @State private var viewWidth: Double = .zero
    
    @State private var xOffset: CGFloat = 0
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                Text(text)
                    .fixedSize(horizontal: true, vertical: false)
                    .readWidth { width in
                        self.textWidth = width
                    }
                
                Spacer(minLength: (textWidth < viewWidth) ?  viewWidth - textWidth : textWidth / 10)
                
                Text(text)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .offset(x: xOffset, y: 0)
            .onAppear {
                if(textWidth > viewWidth) {
                    withAnimation(.linear(duration: 5).delay(3).repeatForever(autoreverses: false)) {
                        xOffset = -textWidth * 1.1
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
    
    public init(_ text: String) {
        self.text = text
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

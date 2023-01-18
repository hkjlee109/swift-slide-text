import SwiftUI

public struct SlideText: View {
    private let text: String
    private let speed: Double
    private let delay: Double
    private let blurPadding: CGFloat
    
    
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

    public init(_ text: String, speed: Double = 1, delay: Double = 3, blurPadding: CGFloat = 4) {
        self.text = text
        self.speed = speed
        self.delay = delay
        self.blurPadding = blurPadding
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
            .padding(.horizontal, blurPadding)
            .offset(x: xOffset, y: 0)
            .onAppear {
                if needSliding {
                    withAnimation(
                        .linear(duration: textWidth / viewWidth * (5 / speed)) 
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
        .mask(
            HStack(spacing:0) {
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.black.opacity(0), Color.black]
                    ),
                    startPoint: .leading,
                    endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/
                )
                .frame(width: blurPadding)
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
                .frame(width: blurPadding)
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

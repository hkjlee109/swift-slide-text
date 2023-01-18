import UIKit
import SwiftUI

public struct SecondView: View {
  public var body: some View {
      VStack {
          Text("Second View").font(.system(size: 36))
          Text("Loaded by SecondView").font(.system(size: 14))
      }
  }
}

public class UISlideTextController: UIHostingController<SecondView> {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SecondView())
    }

    public init() {
        super.init(rootView: SecondView())
    }
}


//public class UISlideText: UIView {
//
//    let childView = UIHostingController(rootView: SecondView())
//
//    public init() {
//        super.init(frame: .zero)
//
//        backgroundColor = .cyan
//
////        addChild(childView)
//        childView.view.frame = frame
//        addSubview(childView.view)
//    }
//
//    @available(*, unavailable)
//    public required init?(coder _: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

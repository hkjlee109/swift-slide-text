import UIKit
import UISlideText


//import SlideText
//
//class ViewController: UIViewController {
//
//    private let slideText = UISlideTextController("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla diam eros, mollis nec faucibus ac, fermentum eu augue.")
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        addChild(slideText)
//        view.addSubview(slideText.view)
//
//        slideText.view.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            slideText.view.topAnchor.constraint(equalTo: view.topAnchor),
//            slideText.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            slideText.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            slideText.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        ])
//    }
//
//}


class ViewController: UIViewController {

    private let slideText = UISlideText()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(slideText)

        slideText.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            slideText.topAnchor.constraint(equalTo: view.topAnchor),
            slideText.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            slideText.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slideText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

}

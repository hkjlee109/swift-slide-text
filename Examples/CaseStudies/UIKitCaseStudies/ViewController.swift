import UIKit
import UISlideTextLabel

class ViewController: UIViewController {

    private let slideTextLabel = UISlideTextLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideTextLabel.translatesAutoresizingMaskIntoConstraints = false
        slideTextLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        
        view.addSubview(slideTextLabel)

        NSLayoutConstraint.activate([
            slideTextLabel.topAnchor.constraint(equalTo: view.topAnchor),
            slideTextLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            slideTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slideTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

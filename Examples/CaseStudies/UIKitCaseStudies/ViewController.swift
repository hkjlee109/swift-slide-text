import UIKit
import UISlideTextLabel

class ViewController: UIViewController {

    private let slideTextLabel = UISlideTextLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideTextLabel.translatesAutoresizingMaskIntoConstraints = false
        slideTextLabel.text = "Lorem ipsum"//dolor sit amet, consectetur adipiscing elit"
        
        view.addSubview(slideTextLabel)

        let padding: CGFloat = 12
        NSLayoutConstraint.activate([
            slideTextLabel.topAnchor.constraint(equalTo: view.topAnchor),
            slideTextLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            slideTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            slideTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

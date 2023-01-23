import UIKit
import UISlideTextLabel

class ViewController: UIViewController {

    private let demoLabel1 = UISlideTextLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        demoLabel1.translatesAutoresizingMaskIntoConstraints = false
        demoLabel1.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        
        view.addSubview(demoLabel1)

        let padding: CGFloat = 12
        NSLayoutConstraint.activate([
            demoLabel1.topAnchor.constraint(equalTo: view.topAnchor),
            demoLabel1.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            demoLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            demoLabel1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

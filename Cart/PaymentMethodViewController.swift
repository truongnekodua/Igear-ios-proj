import UIKit

class PaymentMethodViewController: UIViewController {

    
    var onSelectMethod: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chọn phương thức"
    }

    
    @IBAction func methodSelected(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        
        onSelectMethod?(title)
        
        
        self.navigationController?.popViewController(animated: true)
    }
}

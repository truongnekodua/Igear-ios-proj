import UIKit

class AddressViewController: UIViewController {

    var cartItems: [CartItem] = []
    var orderTotal: Double = 0
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var wardTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    
    
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var phoneErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var cityErrorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thêm địa chỉ"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        resetErrors()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func createAddressTapped(_ sender: UIButton) {
        resetErrors()
        var isValid = true
        
        
        if isFieldEmpty(nameTextField) {
            showError(for: nameTextField, label: nameErrorLabel, message: "* Bắt buộc nhập họ tên")
            isValid = false
        }
        
        
        let phoneText = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if phoneText.isEmpty {
            showError(for: phoneTextField, label: phoneErrorLabel, message: "* Bắt buộc nhập SĐT")
            isValid = false
        } else if !isValidPhone(phoneText) {
            showError(for: phoneTextField, label: phoneErrorLabel, message: "* SĐT phải đúng 10 số")
            isValid = false
        }
        
        
        let emailText = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if emailText.isEmpty {
            showError(for: emailTextField, label: emailErrorLabel, message: "* Bắt buộc nhập Email")
            isValid = false
        } else if !isValidEmail(emailText) {
            showError(for: emailTextField, label: emailErrorLabel, message: "* Email sai định dạng (vd: abc@gmail.com)")
            isValid = false
        }
        
        
        if isFieldEmpty(cityTextField) {
            showError(for: cityTextField, label: cityErrorLabel, message: "* Bắt buộc nhập Tỉnh/Thành")
            isValid = false
        }
        
        
        if isFieldEmpty(districtTextField) {
            showBorderErrorOnly(for: districtTextField)
            isValid = false
        }
        if isFieldEmpty(wardTextField) {
            showBorderErrorOnly(for: wardTextField)
            isValid = false
        }
        if isFieldEmpty(streetTextField) {
            showBorderErrorOnly(for: streetTextField)
            isValid = false
        }
        
        
        if isValid {
            let newAddress = Address(fullName: nameTextField.text!,
                                     phone: phoneText,
                                     email: emailText,
                                     city: cityTextField.text!,
                                     district: districtTextField.text!,
                                     ward: wardTextField.text!,
                                     street: streetTextField.text!)
            
            let currentOrder = OrderInfo(cartItems: cartItems, totalAmount: orderTotal, address: newAddress, paymentMethod: "Thanh toán khi nhận hàng")
            
            performSegue(withIdentifier: "toConfirmOrder", sender: currentOrder)
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConfirmOrder", let currentOrder = sender as? OrderInfo {
            let confirmVC = segue.destination as! ConfirmOrderViewController
            confirmVC.orderInfo = currentOrder
        }
    }
    
   
    func isFieldEmpty(_ textField: UITextField) -> Bool {
        return (textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "").isEmpty
    }
    
    func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
 
    
    func showError(for textField: UITextField, label: UILabel, message: String) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        
        label.text = message
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = false
    }
    
    
    func showBorderErrorOnly(for textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
    }
    
    func resetErrors() {
        let textFields = [nameTextField, phoneTextField, emailTextField, cityTextField, districtTextField, wardTextField, streetTextField]
        let labels = [nameErrorLabel, phoneErrorLabel, emailErrorLabel, cityErrorLabel]
        
        for tf in textFields {
            tf?.layer.borderColor = UIColor.systemGray5.cgColor
            tf?.layer.borderWidth = 1.0
            tf?.layer.cornerRadius = 5.0
        }
        for lbl in labels {
            lbl?.isHidden = true
            lbl?.text = ""
        }
    }
}

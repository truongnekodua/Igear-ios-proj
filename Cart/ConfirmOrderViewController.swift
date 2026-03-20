import UIKit

class ConfirmOrderViewController: UIViewController {

    var orderInfo: OrderInfo?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var paymentMethodLabel: UILabel!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var bottomTotalLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Xác nhận đơn hàng"
        setupData()
    }
    
    func setupData() {
        guard let order = orderInfo else { return }
        
        if let addr = order.address {
            nameLabel.text = addr.fullName
            phoneLabel.text = addr.phone
            addressLabel.text = "\(addr.street), \(addr.ward), \(addr.district), \(addr.city)"
        }
        
        paymentMethodLabel.text = order.paymentMethod
        
        let totalString = formatVNĐ(order.totalAmount)
        totalAmountLabel.text = totalString
        bottomTotalLabel.text = totalString
    }
    
    func formatVNĐ(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return (formatter.string(from: NSNumber(value: price)) ?? "0") + "đ"
    }

    
    
    
    @IBAction func changePaymentMethodTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toPaymentMethodScreen", sender: nil)
    }

    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        if orderInfo?.paymentMethod == "Thanh toán VNPAY-QR" {
            
            performSegue(withIdentifier: "toQRCodeScreen", sender: nil)
        } else {
            
            let method = orderInfo?.paymentMethod ?? "Tiền mặt"
            let alert = UIAlertController(title: "Đặt hàng thành công", message: "Đơn hàng của bạn sẽ được thanh toán qua: \(method)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tuyệt vời", style: .default, handler: { _ in
                
                self.navigationController?.popToRootViewController(animated: true)
            }))
            present(alert, animated: true)
        }
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQRCodeScreen" {
            let qrVC = segue.destination as! QRCodeViewController
            qrVC.orderTotal = orderInfo?.totalAmount ?? 0
            
        } else if segue.identifier == "toPaymentMethodScreen" {
            let paymentVC = segue.destination as! PaymentMethodViewController
            
            
            paymentVC.onSelectMethod = { [weak self] selectedMethod in
                self?.orderInfo?.paymentMethod = selectedMethod
                self?.paymentMethodLabel.text = selectedMethod
            }
        }
    }
}

import UIKit
import FirebaseFirestore

class QRCodeViewController: UIViewController {

    var orderTotal: Double = 0
    var orderInfo: OrderInfo? 
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thanh toán quét mã"
        
        amountLabel.text = formatVNĐ(orderTotal)
        
        setupVietQR()
    }
    
    func setupVietQR() {
        let bankID = "MB"
        let accountNo = "5741234567890"
        let accountName = "DANG NGUYEN DUY TRUONG"
        let amount = Int(orderTotal)
        let description = "Thanh toan don hang iGear"
        
        let baseURLString = "https://img.vietqr.io/image/\(bankID)-\(accountNo)-compact2.png"
      
        var urlComponents = URLComponents(string: baseURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "amount", value: String(amount)),
            URLQueryItem(name: "addInfo", value: description),
            URLQueryItem(name: "accountName", value: accountName)
        ]
        
        if let finalURL = urlComponents?.url {
            print("Link VietQR: \(finalURL.absoluteString)")
            loadQRImage(from: finalURL)
        } else {
            print("Lỗi: Không thể tạo URL hợp lệ.")
        }
    }
    
    func loadQRImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self else { return }

            if let error = error {
                print("Lỗi mạng: \(error.localizedDescription)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Không thể tạo hình ảnh từ dữ liệu.")
                return
            }

            DispatchQueue.main.async {
                self.qrImageView.image = image
            }
        }.resume()
    }
    
    func formatVNĐ(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return (formatter.string(from: NSNumber(value: price)) ?? "0") + "đ"
    }
    
    
    @IBAction func finishTapped(_ sender: UIButton) {
        
        
        guard let order = orderInfo else {
            print("❌ Lỗi: Không tìm thấy dữ liệu giỏ hàng để lưu")
            return
        }
        
        let db = Firestore.firestore()
        
        
        var addressDict: [String: Any] = [:]
        if let addr = order.address {
            addressDict = [
                "fullName": addr.fullName,
                "phone": addr.phone,
                "email": addr.email,
                "city": addr.city,
                "district": addr.district,
                "ward": addr.ward,
                "street": addr.street
            ]
        }
        
        
        let itemsArrayForFirebase = order.cartItems.map { $0.toDictionary() }
        
        
        let orderData: [String: Any] = [
            "address": addressDict,
            "cartItems": itemsArrayForFirebase,
            "totalAmount": order.totalAmount,
            "paymentMethod": order.paymentMethod,
            "orderDate": FieldValue.serverTimestamp(),
            "status": "Đã thanh toán QR"
        ]
        
        
        db.collection("Orders").addDocument(data: orderData) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Lỗi lưu đơn hàng QR: \(error.localizedDescription)")
                let errorAlert = UIAlertController(title: "Lỗi mạng", message: "Không thể lưu đơn hàng, vui lòng thử lại.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Đóng", style: .cancel))
                self.present(errorAlert, animated: true)
                
            } else {
                print("✅ Đã lưu đơn hàng VNPAY-QR lên Firebase thành công!")
                
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Tuyệt vời!", message: "Bạn đã thanh toán thành công đơn hàng iGear.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Về trang chủ", style: .default, handler: { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

import UIKit

class QRCodeViewController: UIViewController {

    var orderTotal: Double = 0
    
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
        let alert = UIAlertController(title: "Tuyệt vời!", message: "Bạn đã thanh toán thành công đơn hàng iGear.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Về trang chủ", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}

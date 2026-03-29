import UIKit

class VoucherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var codeTextField: UITextField!
    
    weak var delegate: VoucherDelegate?
    
    let listVouchers = [
        ("PVINTEL09", "Giảm 10% cho Laptop Acer", 0.1, "Acer", "Áp dụng cho dòng Acer Nitro. Tối đa 3 triệu. HSD: 2026."),
        ("APPLE50", "Giảm 5% cho đồ Apple", 0.05, "Apple", "Chỉ áp dụng cho iPhone/MacBook chính hãng."),
        ("FREESHIP", "Miễn phí vận chuyển", 0.0, "ALL", "Áp dụng cho mọi đơn hàng toàn quốc.")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    @IBAction func applyManualCode(_ sender: Any) {
        let typed = codeTextField.text?.uppercased() ?? ""
        if let found = listVouchers.first(where: { $0.0 == typed }) {
            delegate?.didSelectVoucher(code: found.0, discount: found.2, applicableItem: found.3)
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Lỗi", message: "Mã không hợp lệ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel))
            present(alert, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVouchers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherCell", for: indexPath) as! VoucherCell
        let v = listVouchers[indexPath.row]
        cell.codeLabel.text = v.0
        cell.descLabel.text = v.1
        
        
        cell.onTermsTapped = {
            let alert = UIAlertController(title: "Điều kiện mã \(v.0)", message: v.4, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đã hiểu", style: .default))
            self.present(alert, animated: true)
        }
        
        cell.onSelectTapped = {
            self.delegate?.didSelectVoucher(code: v.0, discount: v.2, applicableItem: v.3)
            self.navigationController?.popViewController(animated: true)
        }
        return cell
    }
}

class VoucherCell: UITableViewCell {
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    var onTermsTapped: (() -> Void)?
    var onSelectTapped: (() -> Void)?
    
    @IBAction func termsBtnAction(_ sender: Any) { onTermsTapped?() }
    @IBAction func useBtnAction(_ sender: Any) { onSelectTapped?() }
}

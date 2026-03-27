import UIKit

struct CartItem: Codable{
    var name: String
    var price: Double
    var quantity: Int
    var imageName: String
    var isSelected: Bool
    var gifts: [String]
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var cartItems: [CartItem] = [
        CartItem(name: "Laptop Acer Nitro 16 Phoenix...", price: 29990000.0, quantity: 1, imageName: "acer_nitro", isSelected: true, gifts: ["Ba lô Acer Gaming SUV", "Bàn phím cơ Acer PREDATOR", "Mã giảm 150.000đ cho chuột"]),
        CartItem(name: "RAM Desktop Corsair Dominator 32GB...", price: 4500000.0, quantity: 1, imageName: "corsair_ram", isSelected: false, gifts: [])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateTotal()
    }

    func formatVNĐ(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return (formatter.string(from: NSNumber(value: price)) ?? "0") + "đ"
    }

    func updateTotal() {
        let total = cartItems.filter { $0.isSelected }.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        totalPriceLabel.text = formatVNĐ(total)
    }
    
    @IBAction func trashButtonTapped(_ sender: UIBarButtonItem) {
        cartItems.removeAll { $0.isSelected }
        tableView.reloadData()
        updateTotal()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        let item = cartItems[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.priceLabel.text = formatVNĐ(item.price)
        cell.quantityLabel.text = "\(item.quantity)"
        cell.configureCheck(isSelected: item.isSelected)
        
        cell.productImageView.image = UIImage(named: item.imageName) ?? UIImage(systemName: "laptopcomputer")
        
        if item.gifts.isEmpty {
            cell.giftBoxView.isHidden = true
            cell.giftTextLabel.text = ""
        } else {
            cell.giftBoxView.isHidden = false
            cell.giftTextLabel.text = item.gifts.map { "🎁 \($0)" }.joined(separator: "\n")
        }
        
        cell.toggleCheckAction = {
            self.cartItems[indexPath.row].isSelected.toggle()
            self.tableView.reloadData()
            self.updateTotal()
        }
        
        cell.plusAction = {
            self.cartItems[indexPath.row].quantity += 1
            self.tableView.reloadData()
            self.updateTotal()
        }
        
        cell.minusAction = {
            if self.cartItems[indexPath.row].quantity > 1 {
                self.cartItems[indexPath.row].quantity -= 1
                self.tableView.reloadData()
                self.updateTotal()
            }
        }
        
        cell.showGiftAction = {
            let giftDetails = item.gifts.joined(separator: "\n\n")
            let alert = UIAlertController(title: "Chi tiết quà tặng", message: giftDetails, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: .default))
            self.present(alert, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateTotal()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = cartItems[indexPath.row]
        
        if item.gifts.isEmpty {
            return 140
        } else {
            return 230
        }
    }
    
    // MARK: - Điều hướng (Navigation)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddressScreen" {
            let addressVC = segue.destination as! AddressViewController
            
            
            let selectedItems = cartItems.filter { $0.isSelected }
            
            
            addressVC.cartItems = selectedItems
            addressVC.orderTotal = selectedItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        }
    }
}

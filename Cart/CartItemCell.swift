import UIKit

class CartItemCell: UITableViewCell {
    
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var giftBoxView: UIView!
    @IBOutlet weak var giftTextLabel: UILabel!
    
    
    var plusAction: (() -> Void)?
    var minusAction: (() -> Void)?
    var toggleCheckAction: (() -> Void)?
    var showGiftAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        

        checkboxImageView.isUserInteractionEnabled = true
        let tapCheck = UITapGestureRecognizer(target: self, action: #selector(checkTapped))
        checkboxImageView.addGestureRecognizer(tapCheck)
        
        
        if let giftBox = giftBoxView {
            giftBox.isUserInteractionEnabled = true
            let tapGift = UITapGestureRecognizer(target: self, action: #selector(giftTapped))
            giftBox.addGestureRecognizer(tapGift)
        }
    }

    @IBAction func plusTapped(_ sender: UIButton) { plusAction?() }
    @IBAction func minusTapped(_ sender: UIButton) { minusAction?() }
    
    @objc func checkTapped() { toggleCheckAction?() }
    @objc func giftTapped() { showGiftAction?() }
    
    
    func configureCheck(isSelected: Bool) {
        let imageName = isSelected ? "checkmark.square.fill" : "square"
        checkboxImageView.image = UIImage(systemName: imageName)
        checkboxImageView.tintColor = isSelected ? UIColor(red: 36/255, green: 52/255, blue: 185/255, alpha: 1) : .lightGray
    }
}

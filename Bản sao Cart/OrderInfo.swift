import Foundation

struct Address: Codable{
    var fullName: String
    var phone: String
    var email: String
    var city: String
    var district: String
    var ward: String
    var street: String
}

struct OrderInfo: Codable{
    var cartItems: [CartItem]
    var totalAmount: Double
    var address: Address?
    var paymentMethod: String = "Thanh toán khi nhận hàng"
}

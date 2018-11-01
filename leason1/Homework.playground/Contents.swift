import UIKit
import Foundation

//PriceBook: Defination of Items and Price
struct Item {
    let name: String
    let unit: String
    let price: Float
}

struct PriceBook {
    var book = [String : Item]()
    init() {
        book = ["ITEM000000" : Item(name: "可口可乐", unit: "瓶", price: 3.00),
               "ITEM000001" : Item(name: "雪碧", unit: "瓶", price: 3.00),
               "ITEM000002" : Item(name: "苹果", unit: "斤", price: 5.50),
               "ITEM000003" : Item(name: "荔枝", unit: "斤", price: 15.00),
               "ITEM000004" : Item(name: "电池", unit: "个", price: 2.00),
               "ITEM000005" : Item(name: "方便面", unit: "袋", price: 4.50)]
    }
    func getName(code:String) -> String {
        return book[code]!.name
    }
    
    func getUnit(code:String) -> String {
        return book[code]!.unit
    }
    
    func getPrice(code:String) -> Float {
        return book[code]!.price
    }
    
    func containx(code:String) -> Bool {
        return book.keys.contains(code)
    }
}
let PRICE_BOOK = PriceBook()

//PurchaseRecords: Defination about the Purchase records
struct Record {
    var barcode: String
    var amount: Int
    var price: Float
    var discount: Float
}
class PurchaseRecords {
    var records: [String : Record]
    init() {
        records = [String : Record]()
    }

    func addRecord(code:String, amount:Int) {
        if PRICE_BOOK.containx(code: code) {
            if records.keys.contains(code) {
                records[code]?.amount = records[code]!.amount + 1
                records[code]?.price = records[code]!.price + PRICE_BOOK.getPrice(code: code)
            } else {
                records[code] = Record(barcode: code, amount: 1, price: PRICE_BOOK.getPrice(code: code), discount: 0.00)
            }
        }
    }
}

//Promotion: Modifier for Discount
struct Discount {
    var type: String
    var barcodes: [ String ]
}

class Promotion {
    var DISCOUNT_RULE: [Discount]
    init() {
        DISCOUNT_RULE = [ Discount(type: "BUY_TWO_GET_ONE_FREE",
        barcodes: [
        "ITEM000000",
        "ITEM000001",
        "ITEM000005"]) ]
    }
    func apply(purchaseRecords: PurchaseRecords) -> PurchaseRecords {
        for rule in DISCOUNT_RULE {
            if rule.type == "BUY_TWO_GET_ONE_FREE" {
                freeOne(codes: rule.barcodes, purchaseRecords: purchaseRecords)
            }
        }
        return purchaseRecords
    }
    
    func freeOne(codes: [String], purchaseRecords: PurchaseRecords) -> PurchaseRecords{
        for code in codes {
            if  purchaseRecords.records.keys.contains(code){
                
                var oRecord = purchaseRecords.records[code]!
                oRecord.discount = PRICE_BOOK.getPrice(code: code) * Float(Int(oRecord.amount / 2))
                oRecord.price = oRecord.price - oRecord.discount
                purchaseRecords.records[code] = oRecord
            }
        }
        return purchaseRecords
    }
}
let PROMOTION_BOOK = Promotion()
//Recipt: Instance to contain Calculate and Output Logic
class Recipt {
    func load(inputs:Cart) -> PurchaseRecords {
        let purchaseRecords = PurchaseRecords()
        for barcode in inputs.originalItems {
            let code:String = String(barcode.prefix(10))
            var amount = 1
            var numarray = barcode.split(separator: "-", maxSplits: 1).map(String.init)
            if numarray.count > 1 {
                amount = Int(numarray[1])!
            }
            purchaseRecords.addRecord(code: code, amount:amount)
        }
        return purchaseRecords
    }
    
    func discount(purchaseRecords: PurchaseRecords) -> PurchaseRecords {
        return PROMOTION_BOOK.apply(purchaseRecords: purchaseRecords)
    }
    
    func calculateAll(purchaseRecords: PurchaseRecords) -> [String : Float] {
        var totalPrice:Float = 0.00
        var totalDicount:Float = 0.00
        for purchaseRecord in purchaseRecords.records {
            totalPrice = totalPrice + purchaseRecord.value.price
            totalDicount = totalDicount + purchaseRecord.value.discount
        }
        return ["totalPrice" : totalPrice,
                "totalDicount" : totalDicount]
    }

    func print(purchaseRecords: PurchaseRecords) {
        var output:String = "***<没钱赚商店>收据***\n"
        for purchaseRecord in purchaseRecords.records {
            var code:String = purchaseRecord.key
            var record:Record = purchaseRecord.value
            output.append(String(format:"名称：%@，数量：%d%@，单价：%.2f(元)，小计：%.2f(元)\n",
                                 arguments:[
                                    PRICE_BOOK.getName(code: code),
                                    record.amount,
                                    PRICE_BOOK.getUnit(code: code),
                                    PRICE_BOOK.getPrice(code: code),
                                    record.price]))
        }
        output.append("----------------------\n")
        var allMoney = calculateAll(purchaseRecords: purchaseRecords)
        output.append(String(format:"总计：%.2f(元)\n节省：%.2f(元)\n**********************",
                             arguments:[allMoney["totalPrice"]!,
                                        allMoney["totalDicount"]!]))
        Swift.print(output)
    }
}
//Cart Defination of the mixed Item and Number
struct Cart {
    var originalItems: [String]
}


//Main Process
var myRecipt:Recipt = Recipt()
var myCart:Cart = Cart(originalItems: [
    "ITEM000001",
    "ITEM000001",
    "ITEM000001",
    "ITEM000001",
    "ITEM000001",
    "ITEM000003-2",
    "ITEM000005",
    "ITEM000005",
    "ITEM000005"
    ])
var purchaseRecords = myRecipt.load(inputs: myCart)
myRecipt.print(purchaseRecords: myRecipt.discount(purchaseRecords: purchaseRecords))

// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
cell.textLabel?.text = "Text test"
cell.detailTextLabel?.text = "Hi test"
cell.detailTextLabel?.textColor = UIColor.redColor()
cell

var button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 35))

button.setTitle("Click", forState: UIControlState.Normal)
button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)

button

var tmp2 = [String]()
tmp2.append("qwe1")
tmp2.append("gghy2")
tmp2 += ["test3", "test4"]

tmp2 += ["test5", "test6", "test7", "test8"]
//tmp2 [4...6] = ["test9", "test10"]

//var dictinary = Dictionary<String, String>()
var dictinary = [String: String]()

dictinary = ["index1" : "value1", "index2" : "value2", "index3" : "value3"]

//if let oldValue = dictinary.updateValue("Dublin Airport", forKey: "index1") {
//    println("The old value for index1 was \(oldValue).")
//}

tmp2
dictinary




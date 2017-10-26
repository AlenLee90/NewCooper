//
//  ReportViewController.swift
//  DailyFinance
//
//  Created by 李亚男 on 2017/10/18.
//  Copyright © 2017年 李亚男. All rights reserved.
//

import UIKit
import Charts
import SQLite

class ReportViewController: UIViewController {


    @IBOutlet weak var paymentPie: PieChartView!
    
    @IBOutlet weak var incomePie: PieChartView!
    //    @IBOutlet weak var barChart: BarChartView!
    
    var database : Connection!
    
    let deleteFlag = Expression<Int>("delete_flag")
    let createTime = Expression<Date>("create_time")
    
    var selectedDatas :AnySequence<Row>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        selectData()
//        barChartUpdate()
        pieChartUpdate()
    }

//    func barChartUpdate () {
//        let entry1 = BarChartDataEntry(x: 1.0, y: Double(19.0))
//        let entry2 = BarChartDataEntry(x: 2.0, y: Double(50.0))
//        let entry3 = BarChartDataEntry(x: 3.0, y: Double(88.7))
//        let dataSet = BarChartDataSet(values: [entry1, entry2, entry3], label: "Widgets Type")
//        let data = BarChartData(dataSets: [dataSet])
//        barChart.data = data
//        barChart.chartDescription?.text = "Number of Widgets by Type"
//
//        //All other additions to this function will go here
//        dataSet.colors = ChartColorTemplates.joyful()
//        dataSet.valueColors = [UIColor.black]
//        //This must stay at end of function
//        barChart.notifyDataSetChanged()
//    }
    
    func pieChartUpdate () {
        self.database = DatabaseHelper.postRequest()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myString = "2017-10-25"
        
        var paymentEntryArray = [PieChartDataEntry]()

        do{
            let stmt = try self.database.prepare("SELECT sum(a.amount) as amount,b.category_name FROM input_detail as a left join common_category as b on a.category_id = b.category_id where a.type_flag = '0' and a.create_time like '\(myString)%' group by a.category_id")
            for row in stmt {
                var label :String?
                var amount :String?
                
                for (index, name) in stmt.columnNames.enumerated() {
                    if name == "category_name" {
                        label = row[index]! as? String
                    }
                    if name == "amount" {
                        amount = String(describing: row[index]!)
                    }
                }
                if amount!.isEmpty {
                    amount = "0"
                }
                
                let entry = PieChartDataEntry(value: Double(amount!)!, label: label)
                paymentEntryArray.append(entry)
            }
            
        }catch{
            print(error)
        }
        
        

        
//        let entry1 = PieChartDataEntry(value: Double(19.0), label: "#1")
//        let entry2 = PieChartDataEntry(value: Double(50.0), label: "#2")
//        let entry3 = PieChartDataEntry(value: Double(88.7), label: "#3")
//
//        entryArray.append(entry1)
//        entryArray.append(entry2)
//        entryArray.append(entry3)
        
        let paymentDataSet = PieChartDataSet(values: paymentEntryArray, label: "Payments")
        let paymentData = PieChartData(dataSet: paymentDataSet)
        paymentPie.data = paymentData
        paymentPie.chartDescription?.text = "Share of Widgets by Payments"
        
        //All other additions to this function will go here
        paymentDataSet.colors = ChartColorTemplates.joyful()
        paymentDataSet.valueColors = [UIColor.black]
        paymentPie.backgroundColor = UIColor.white
        paymentPie.holeColor = UIColor.clear
        paymentPie.chartDescription?.textColor = UIColor.blue
        paymentPie.legend.textColor = UIColor.darkGray
        
        paymentPie.legend.font = UIFont(name: "Futura", size: 10)!
//        pieChart.chartDescription?.font = UIFont(name: "Futura", size: 12)!
//        pieChart.chartDescription?.xOffset = pieChart.frame.width + 30
//        pieChart.chartDescription?.yOffset = pieChart.frame.height * (2/3)
        paymentPie.chartDescription?.textAlign = NSTextAlignment.left
        
        //This must stay at end of function
        paymentPie.notifyDataSetChanged()
        
        
        
        var incomeEntryArray = [PieChartDataEntry]()
        
        do{
            let stmt = try self.database.prepare("SELECT sum(a.amount) as amount,b.category_name FROM input_detail as a left join common_category as b on a.category_id = b.category_id where a.type_flag = '1' and a.create_time like '\(myString)%' group by a.category_id")
            for row in stmt {
                var label :String?
                var amount :String?
                
                for (index, name) in stmt.columnNames.enumerated() {
                    if name == "category_name" {
                        label = row[index]! as? String
                    }
                    if name == "amount" {
                        amount = String(describing: row[index]!)
                    }
                }
                if amount!.isEmpty {
                    amount = "0"
                }
                
                let entry = PieChartDataEntry(value: Double(amount!)!, label: label)
                incomeEntryArray.append(entry)
            }
            
        }catch{
            print(error)
        }
        
        let incomeDataSet = PieChartDataSet(values: incomeEntryArray, label: "Incomes")
        let incomeData = PieChartData(dataSet: incomeDataSet)
        incomePie.data = incomeData
        incomePie.chartDescription?.text = "Share of Widgets by Income"
        
        //All other additions to this function will go here
        incomeDataSet.colors = ChartColorTemplates.joyful()
        incomeDataSet.valueColors = [UIColor.black]
        incomePie.backgroundColor = UIColor.white
        incomePie.holeColor = UIColor.clear
        incomePie.chartDescription?.textColor = UIColor.blue
        incomePie.legend.textColor = UIColor.darkGray
        
        incomePie.legend.font = UIFont(name: "Futura", size: 10)!
        //        pieChart.chartDescription?.font = UIFont(name: "Futura", size: 12)!
        //        pieChart.chartDescription?.xOffset = pieChart.frame.width + 30
        //        pieChart.chartDescription?.yOffset = pieChart.frame.height * (2/3)
        incomePie.chartDescription?.textAlign = NSTextAlignment.left
        
        //This must stay at end of function
        incomePie.notifyDataSetChanged()
    }
    
//    func selectData() {
//        self.database = DatabaseHelper.postRequest()
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let myString = formatter.string(from: Date())
//        do{
//            let stmt = try self.database.prepare("SELECT amount,type_flag FROM input_detail where create_time like '\(myString)%'")
//            for row in stmt {
//                for (index, name) in stmt.columnNames.enumerated() {
//                    if name == "amount" {
//                        print ("\(name)=\(row[index]!)")
//                    }
////                    print ("\(name)=\(row[index]!)")
//                    // id: Optional(1), email: Optional("alice@mac.com")
//                }
//            }
//
//        }catch{
//            print(error)
//        }
//    }
}

//
//  DetailTableViewCell.swift
//  DailyFinance
//
//  Created by 李亚男 on 2017/10/21.
//  Copyright © 2017年 李亚男. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

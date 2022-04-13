//
//  weatherTableViewCell.swift
//  WeatherNow
//
//  Created by Mwangi Gituathi on 4/13/22.
//

import UIKit

class weatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbmin: UILabel!
    @IBOutlet weak var imgweather: UIImageView!
    @IBOutlet weak var lbmax: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

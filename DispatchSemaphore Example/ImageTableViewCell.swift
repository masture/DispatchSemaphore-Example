//
//  ImageTableViewCell.swift
//  DispatchSemaphore Example
//
//  Created by Pankaj Kulkarni on 28/09/20.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var dogNoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

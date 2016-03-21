//
//  FooterWithTertiaryInfoViewCell.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 18/2/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class InstructionsFooterWithTertiaryInfoViewCell: UITableViewCell, InstructionsFillmentDelegate {

    @IBOutlet weak var clockIcon: UIImageView!
    
    @IBOutlet weak var secondaryInfoTitle: UILabel!
    @IBOutlet weak var secondaryInfoSubtitle: UILabel!
    @IBOutlet weak var secondayInfoComment: UILabel!
    @IBOutlet weak var acreditationMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let tintedImage = self.clockIcon.image?.imageWithRenderingMode(.AlwaysTemplate)
        self.clockIcon.image = tintedImage
        self.clockIcon.tintColor = UIColor().UIColorFromRGB(0xB29054)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(instruction: Instruction) -> UITableViewCell {
        if instruction.secondaryInfo != nil && instruction.secondaryInfo!.count > 0 {
            self.secondaryInfoTitle.text = instruction.secondaryInfo![0]
        }
        
        if instruction.tertiaryInfo != nil && instruction.tertiaryInfo!.count > 0 {
            self.secondaryInfoSubtitle.text = instruction.tertiaryInfo![0]
            
            if instruction.tertiaryInfo!.count > 1 {
                self.secondayInfoComment.text = instruction.tertiaryInfo![1]
            } else {
                self.secondayInfoComment.text = ""
            }
        }

        self.acreditationMessage.text = instruction.accreditationMessage
        return self
    }
}
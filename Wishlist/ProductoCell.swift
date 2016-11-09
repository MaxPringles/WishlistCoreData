//
//  ProductoCell.swift
//  Wishlist
//
//  Created by Vanessa on 13/10/16.
//  Copyright © 2016 Telstock. All rights reserved.
//

import UIKit

class ProductoCell: UITableViewCell {

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var detalle: UILabel!
    @IBOutlet weak var departamento: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureCell(item: Item) {
        titulo.text = item.title
        precio.text = "$ \(item.price)"
        detalle.text = item.detail
        imagen.image = item.toImage?.image as? UIImage
        departamento.text = item.toItemType?.type
    }
}

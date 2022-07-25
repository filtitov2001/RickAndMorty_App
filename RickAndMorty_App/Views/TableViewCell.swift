//
//  TableViewCell.swift
//  RickAndMorty_App
//
//  Created by Felix Titov on 7/26/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView! {
        didSet {
            characterImageView.contentMode = .scaleAspectFit
            characterImageView.clipsToBounds = true
            characterImageView.layer.cornerRadius = characterImageView.frame.height / 2
            characterImageView.backgroundColor = .white
        }
    }
    
    func configure(with character: Character?) {
        nameLabel.text = character?.name
        DispatchQueue.global().async {
            guard let stringUrl = character?.image else { return }
            guard let imageUrl = URL(string: stringUrl) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                self.characterImageView.image = UIImage(data: imageData)
            }
        }
    }
}

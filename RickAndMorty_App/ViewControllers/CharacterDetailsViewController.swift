//
//  CharacterDetailsViewController.swift
//  RickAndMorty_App
//
//  Created by Felix Titov on 7/26/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class CharacterDetailsViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var characterImageView: CharacterImageView! {
        didSet {
            characterImageView.layer.cornerRadius = characterImageView.frame.width / 2
        }
    }
    
    var character: Character!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
       
        title = character.name
        descriptionLabel.text = character.description
        characterImageView.fetchImage(from: character.image)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController else { return }
        guard let episodesVC = navigationController.topViewController as? EpisodesViewController else { return }
        episodesVC.character = character
    }
    
}

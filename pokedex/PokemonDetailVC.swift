//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Christian Buendia on 02/09/17.
//  Copyright © 2017 Christian Buendia. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var evolution1Img: UIImageView!
    @IBOutlet weak var evolution2Img: UIImageView!
    @IBOutlet weak var evolutionLbl: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImage.image = img
        pokedexIdLbl.text = "\(pokemon.pokedexId)"
        pokemon.downloadPokemonDetails{

            self.updateUI()
        }

    }
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        baseAttackLbl.text = "\(pokemon.attack)"
        defenseLbl.text = "\(pokemon.defense)"
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvolutionId == "" {
            evolutionLbl.text = ""
            evolution2Img.isHidden = true
        } else {
            evolution2Img.isHidden = false
            evolution2Img.image = UIImage(named: pokemon.nextEvolutionId)
            evolutionLbl.text = "\(pokemon.nextEvolutionName):\(pokemon.nextEvolutionLvl)"
        }
    }
}

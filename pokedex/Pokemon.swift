//
//  Pokemon.swift
//  pokedex
//
//  Created by Christian Buendia on 07/08/17.
//  Copyright © 2017 Christian Buendia. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {

    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: Int!
    private var _height: String!
    private var _weight: String!
    private var _attack: Int!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    var attack: Int {
        if _attack == nil {
            _attack = 0
        }
        return _attack
    }
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var defense: Int {
        if _defense == nil {
            _defense = 0
        }
        return _defense
    }
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name:String, pokedexId:Int) {
    
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(BASE_URL)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonUrl).responseJSON { (response) in

            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = attack
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = defense
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let descriptionUrl = "\(BASE_URL)\(url)"
                        Alamofire.request(descriptionUrl).responseJSON(completionHandler: { (response) in
                            if let descDict = response.result.value as? Dictionary <String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(description)
                                }
                            }
                        })
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary <String, AnyObject>], evolutions.count > 0 {
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        if nextEvolution.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvolution
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                if let levelExist = evolutions[0]["level"] {
                                    if let level = levelExist as? Int {
                                        self._nextEvolutionLvl = "\(level)"
                                    }
                                } else {
                                    self._nextEvolutionLvl = ""
                                }
                            }
                        }
                    }
                    print(self._nextEvolutionLvl)
                    print(self._nextEvolutionName)
                    print(self._nextEvolutionTxt)
                    print(self._nextEvolutionId)
                }
            }
            completed()
        }
    }
}

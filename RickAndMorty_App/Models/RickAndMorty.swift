//
//  RickAndMorty.swift
//  RickAndMorty_App
//
//  Created by Felix Titov on 7/25/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

struct RickAndMorty: Codable {
    let info: Info
    let results: [Character]
}

struct Info: Codable {
    let pages: Int
    let next: String?
    let prev: String?
}

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    
    var description: String {
        """
    Name: \(name)
    Status: \(status)
    Species: \(species)
    Gender: \(gender)
    Origin: \(origin.name)
    Location: \(location.name)
    """
    }
}

struct Location: Codable {
    let name: String
}

struct Episode: Codable {
    let name: String
    let date: String
    let episode: String
    let characters: [String]
    
    var description: String {
        """
    Title: \(name)
    Date: \(date)
    """
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case date = "air_date"
        case episode = "episode"
        case characters = "characters"
    }
}

enum Link: String {
    case rickAndMortyApi = "https://rickandmortyapi.com/api/character"
}

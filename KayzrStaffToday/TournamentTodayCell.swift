//
//  TournamentTodayCell.swift
//  KayzrStaffToday
//
//  Created by Jens Leirens on 05/12/2017.
//  Copyright © 2017 Jens Leirens. All rights reserved.
//

import UIKit
import KayzrStaff_Shared

class TournamentTodayCell : UITableViewCell {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starthourLabel: UILabel!
    
    
    
    var tournament: Tournament! {
        didSet{
            
            if tournament.name.starts(with: "PS:") {
                tournament.name = String(tournament.name.dropFirst(4))
            } else if tournament.name.starts(with: "Fun:") {
                tournament.name = String(tournament.name.dropFirst(5))
            }
            
            nameLabel.text = tournament.name
            if tournament.hour == "" {
                starthourLabel.text = ""
            } else {
                starthourLabel.text = "Starts at:" + tournament.hour
            }
            
            if tournament.nameShort.contains("CS:GO"){
                gameImage.image = #imageLiteral(resourceName: "csgoToday")
            } else if tournament.nameShort.contains("LoL"){
                gameImage.image = #imageLiteral(resourceName: "LOLToday")
            } else if tournament.nameShort.contains("RL") {
                gameImage.image = #imageLiteral(resourceName: "RLToday")
            } else if tournament.nameShort.contains("HS") {
                gameImage.image = #imageLiteral(resourceName: "HSToday")
            } else if tournament.nameShort.contains("FIFA") {
                gameImage.image = #imageLiteral(resourceName: "FifaToday")
            }else if tournament.nameShort.contains("R6") {
                gameImage.image = #imageLiteral(resourceName: "R6Today")
            } else if tournament.nameShort.contains("SC II") {
                gameImage.image = #imageLiteral(resourceName: "SCIIToday")
            } else if tournament.nameShort.contains("COD") {
                gameImage.image = #imageLiteral(resourceName: "CODToday")
            }else if tournament.nameShort.contains("BR") {
                gameImage.image = #imageLiteral(resourceName: "battleriteToday")
            } else if tournament.nameShort.contains("BH") {
                gameImage.image = #imageLiteral(resourceName: "brawlhallaToday")
            } else if tournament.nameShort.contains("Dota") {
                gameImage.image = #imageLiteral(resourceName: "dotaToday")
            } else if tournament.nameShort.contains("OW") {
                gameImage.image = #imageLiteral(resourceName: "overwatchToday")
            } else {
                gameImage.image = #imageLiteral(resourceName: "iconToday")
            }
            
            
        }
    }
}


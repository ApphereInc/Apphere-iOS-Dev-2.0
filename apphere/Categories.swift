//
//  Categories.swift
//  apphere
//
//  Created by Tony Mann on 4/18/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import Foundation

extension Category {
    static var home = Category(
        title: "",
        subtitle: "",
        prompt: "Where's the best _________ near me?",
        color: "#000000",
        subcategories: [
            Category(
                title: "Food",
                subtitle: "Restaurants",
                prompt: "Where's the best pizza near me?",
                color: "#539EF6",
                subcategories: [
                    Category(
                        title: "Italian",
                        subtitle: "Pasta and gelato",
                        prompt: "Where's the best Italian food near me?",
                        color: "#539EF6",
                        subcategories: [],
                        featuredIds: [5],
                        allIds: [4, 2]
                    ),
                    Category(
                        title: "American",
                        subtitle: "Burgers & fries",
                        prompt: "Where's the American food near me?",
                        color: "#539EF6",
                        subcategories: [],
                        featuredIds: [2],
                        allIds: [4, 5]
                    ),
                    Category(
                        title: "Tex-Mex",
                        subtitle: "Tacos and churros",
                        prompt: "Where's the best Tex-Mex food near me?",
                        color: "#539EF6",
                        subcategories: [],
                        featuredIds: [],
                        allIds: []
                    ),
                    Category(
                        title: "Seafood",
                        subtitle: "Fish and lobster",
                        prompt: "Where's the best seafood near me?",
                        color: "#539EF6",
                        subcategories: [],
                        featuredIds: [],
                        allIds: []
                    ),
                    Category(
                        title: "Steak",
                        subtitle: "Beef and lamb",
                        prompt: "Where's the steak near me?",
                        color: "#539EF6",
                        subcategories: [],
                        featuredIds: [],
                        allIds: []
                    ),
                    Category(
                        title: "Barbeque",
                        subtitle: "Ribs and collard greens",
                        prompt: "Where's the best BBQ near me?",
                        color: "#539EF6",
                        subcategories: [],
                        featuredIds: [],
                        allIds: []
                    )
                ],
                featuredIds: [2],
                allIds: [4, 5]
            ),
            Category(
                title: "Drinks",
                subtitle: "Cafes & Bars",
                prompt: "Where's the best bar near me?",
                color: "#2A23D2",
                subcategories: [
                    
                ],
                featuredIds: [],
                allIds: []
            ),
            Category(
                title: "Health",
                subtitle: "Med & Gyms",
                prompt: "Where's the best doctor near me?",
                color: "#CF06BE",
                subcategories: [
                    
                ],
                featuredIds: [],
                allIds: []
            ),
            Category(
                title: "Fun",
                subtitle: "Fun & Movies",
                prompt: "Where's the most fun place near me?",
                color: "#FAA13A",
                subcategories: [
                    
                ],
                featuredIds: [],
                allIds: []
            ),
            Category(
                title: "Services",
                subtitle: "Banks & Gas",
                prompt: "Where's the best bank near me?",
                color: "#27AA16",
                subcategories: [
                    
                ],
                featuredIds: [],
                allIds: []
            ),
            Category(
                title: "Shopping",
                subtitle: "Retail & Malls",
                prompt: "Where's the best clothing store near me?",
                color: "#B87CFF",
                subcategories: [
                    
                ],
                featuredIds: [],
                allIds: []
            )
        ],
        featuredIds: [1],
        allIds: [2]
    )
}

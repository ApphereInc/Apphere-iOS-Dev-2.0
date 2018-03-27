//
//  BusinessDirectory.swift
//  apphere
//
//  Created by Tony Mann on 2/14/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import Foundation

class BusinessDirectory {
    static func get(withID id: NSNumber) -> Business? {
        return get(withID: id.intValue)
    }
    
    static func get(withID id: Int) -> Business? {
        return businesses.first { $0.id == id }
    }
    
    static var businesses: [Business] = [
        Business(
            id: 1,
            name: "Santander Arena",
            description: "TODO: add description",
            photo: "san",
            address1: "700 Penn St",
            address2: nil,
            city: "Reading",
            state: "PA",
            zip: "19602",
            phoneNumber: "(610) 898-7469",
            url: URL(string: "https://santander-arena.com/")!,
            webCamId: "8UAZ9c",
            contentStyle: .light,
            promotion: Promotion(
                name: "Free Reading Royals Hat",
                description: StyledText(text: "FREE READING ROYALS HAT TODAY ONLY", color: "#FFFFFF"),
                footer: StyledText(text: "ticket sales and promotions are for entertainment purposes only. we are not sure what we want to say here so I will just keep typing as much as I feel like it.", color: "#FFFFFF"),
                backgroundColor: "#8856ED",
                logo: "sanlogo",
                image: "san",
                isImageFullSize: false,
                url: nil
            )
        ),
       
        Business(
            id: 2,
            name: "Sweet Ride Ice Cream",
            description: "TODO: add description",
            photo: "sweet2",
            address1: "542 Penn Ave",
            address2: nil,
            city: "West Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(484) 987-7338",
            url: URL(string: "https://sweetrideicecream.com/")!,
            webCamId: nil,
            contentStyle: .light,
            promotion: Promotion(
                name: "free small vanilla scoop",
                description: StyledText(text: "enjoy one free ice cream sundae", color: "#FFFFFF"),
                footer: StyledText(text: "while supplies last and purchased before 8PA with order. not redeemable on weekend or holidays. does not include extra cherry or whipped cream.", color: "#FFFFFF"),
                backgroundColor: "#ACD0E4",
                logo: "sweetlogo",
                image: "sweet2",
                isImageFullSize: false,
                url: nil
            )
        ),
        Business(
            id: 3,
            name: "5th and Penn Street",
            description: "TODO: add description",
            photo: "5",
            address1: "5th and Penn Street",
            address2: nil,
            city: "Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(484) 987-7338",
            url: URL(string: nil,
            webCamId: nil,
            contentStyle: .light,
            promotion: Promotion(
                name: "learn about reading",
                description: StyledText(text: "5th and Penn Street", color: "#FFFFFF"),
                footer: StyledText(text: "Footer", color: "#FFFFFF"),
                backgroundColor: "#000000",
                logo: nil,
                image: "sweet",
                isImageFullSize: false,
                url: nil
            )
        ),
        Business(
            id: 4,
            name: "Judy’s On Cherry",
            description: "TODO: add description",
            photo: "judy2",
            address1: "332 Cherry St",
            address2: nil,
            city: "Reading",
            state: "PA",
            zip: "19602",
            phoneNumber: "(610) 374-8511",
            url: URL(string: "http://judysoncherry.com/")!,
            webCamId: nil,
            contentStyle: .light,
            promotion: Promotion(
                name: "10% off $50 order",
                description: StyledText(text: "10% OFF YOUR MEAL TODAY", color: "#FFFFFF"),
                footer: StyledText(text: "while supplies last and purchased before 8PM with order. not redeemable on weekends or holidays. does not include extra nuts and whipped cream", color: "#FFFFFF"),
                backgroundColor: "#000000",
                logo: nil,
                image: "sweet",
                isImageFullSize: false,
                url: nil
            )
        ),
        Business(
            id: 5,
            name: "Winedown Cafe",
            description: "TODO: add description",
            photo: "wine1",
            address1: "622 Penn Ave",
            address2: nil,
            city: "West Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(610) 373-4907",
            url: URL(string: "http://winedowncafe.net/")!,
            webCamId: nil,
            contentStyle: .light,
            promotion: Promotion(
                name: "free house cab sav",
                description: StyledText(text: "Headline", color: "#FFFFFF"),
                footer: StyledText(text: "Footer", color: "#FFFFFF"),
                backgroundColor: "#000000",
                logo: nil,
                image: "sweet",
                isImageFullSize: false,
                url: nil
            )
        ),
        Business(
            id: 6,
            name: "West Reading Tavern",
            description: "TODO: add description",
            photo: "west2",
            address1: "606 Penn Ave",
            address2: nil,
            city: "West Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(610) 376-9232",
            url: URL(string: "http://westreadingtavern.com/")!,
            webCamId: nil,
            contentStyle: .light,
            promotion: Promotion(
                name: "free small pint of ale",
                description: StyledText(text: "Headline", color: "#FFFFFF"),
                footer: StyledText(text: "Footer", color: "#FFFFFF"),
                backgroundColor: "#000000",
                logo: nil,
                image: "sweet",
                isImageFullSize: false,
                url: nil
            )
        ),
        Business(
            id: 7,
            name: "Muddy Creek Soap",
            description: "TODO: add description",
            photo: "soap2",
            address1: "608 Penn Ave",
            address2: nil,
            city: "West Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(610) 816-7474",
            url: URL(string: "http://muddycreeksoapcompany.com/")!,
            webCamId: nil,
            contentStyle: .light,
            promotion: Promotion(
                name: "Buy 2 get one free",
                description: StyledText(text: "Headline", color: "#FFFFFF"),
                footer: StyledText(text: "Footer", color: "#FFFFFF"),
                backgroundColor: "#000000",
                logo: nil,
                image: "sweet",
                isImageFullSize: false,
                url: nil
            )
        ),
        Business(
            id: 8,
            name: "Goggle Works",
            description: "TODO: add description",
            photo: "g",
            address1: "201 Washington St",
            address2: nil,
            city: "Reading",
            state: "PA",
            zip: "19601",
            phoneNumber: "(610) 374-4600",
            url: URL(string: "https://goggleworks.org")!,
            webCamId: nil,
            contentStyle: .light,
            promotion: Promotion(
                name: "free bumper sticker",
                description: StyledText(text: "Headline", color: "#FFFFFF"),
                footer: StyledText(text: "Footer", color: "#FFFFFF"),
                backgroundColor: "#000000",
                logo: nil,
                image: "sweet",
                isImageFullSize: false,
                url: nil
            )
        ),
        Business(
            id: 9,
            name: "Bench  warmers Coffee",
            description: "TODO: add description",
            photo: "bench",
            address1: "400 Penn Ave",
            address2: nil,
            city: "West Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(610) 374-2326",
            url: URL(string: "https://benchwarmerscoffee.com/")!,
            webCamId: nil,
            contentStyle: .light,
            promotion: Promotion(
                name: "free small cafe mocha",
                description: StyledText(text: "Headline", color: "#FFFFFF"),
                footer: StyledText(text: "Footer", color: "#FFFFFF"),
                backgroundColor: "#000000",
                logo: nil,
                image: "sweet",
                isImageFullSize: false,
                url: nil
            )
        ),
        Business(
            id: 10,
            name: "Reading Public Museum",
            description: "TODO: add description",
            photo: "rpm3",
            address1: "500 Museum Rd",
            address2: nil,
            city: "Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(610) 371-5850",
            url: URL(string: "http://readingpublicmuseum.org/")!,
            webCamId: nil,
            contentStyle: .light,
            promotion: Promotion(
                name: "10% off admission",
                description: StyledText(text: "Reading Public Museum Promo", color: "#FFFFFF"),
                footer: StyledText(text: "Reading Public Museum Footer", color: "#FFFFFF"),
                backgroundColor: "#000000",
                logo: nil,
                image: "rpm",
                isImageFullSize: false,
                url: nil
            )
        )
    ]
}

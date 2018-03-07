//
//  BusinessDirectory.swift
//  apphere
//
//  Created by Tony Mann on 2/14/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import Foundation

class BusinessDirectory {
    static func get(withUUID uuid: UUID) -> Business? {
        return businesses.first { business in
            if let uuidString = business.proximityUUID, let businessUUID = UUID(uuidString: uuidString) {
                return uuid == businessUUID
            }
            
            return false
        }
    }
    
    static var businesses: [Business] = [
        Business(
            id: 1,
            name: "Santander Arena",
            photo: "san",
            activeCustomerCount: 598,
            dailyCustomerCount: 48,
            totalCustomerCount: 2020,
            address1: "700 Penn St",
            address2: nil,
            city: "Reading",
            state: "PA",
            zip: "19602",
            phoneNumber: "(610) 898-7469",
            url: "https://www.santander-arena.com/",
            contentStyle: .light,
            proximityUUID: "41786AA2-86D6-F55A-0515-EACFD49E1378",
            promotion: Promotion(
                name: "Free Reading Royals Hat",
                headline: StyledText(text: "FREE READING ROYALS HAT TODAY ONLY", color: "#FFFFFF"),
                footer: StyledText(text: "ticket sales and promotions are for entertainment purposes only. we are not sure what we want to say here so I will just keep typing as much as I feel like it.", color: "#FFFFFF"),
                backgroundColor: "#8856ED",
                logo: "sanlogo",
                image: "san",
                isImageFullSize: false,
                url: nil
            )
        ),
        Business(
            id: 13,
            name: "Triose, Inc.",
            photo: "scrub",
            activeCustomerCount: 45,
            dailyCustomerCount: 27,
            totalCustomerCount: 432,
            address1: "2001 State Hill Rd",
            address2: "Suite 205",
            city: "Reading",
            state: "PA",
            zip: "19610",
            phoneNumber: "(866) 241-2268",
            url: "https://www.triose.com/",
            contentStyle: .light,
            proximityUUID: nil,
            promotion: Promotion(
                name: "We Welcome Triose to Apphere",
                headline: StyledText(text: "We Welcome, CARL, IRA, and GERRY", color: "#FFFFFF"),
                footer: StyledText(text: "Derek and Tracy would like to thank you for your commitment to Apphere and we are excited to build this exciting new techology with you. welcome partners into this amazing journey.", color: "#FFFFFF"),
                backgroundColor: "#1c3f94",
                logo: "tlogo2",
                image: "ci",
                isImageFullSize: false,
                url: nil
            )
        ),

        Business(
            id: 2,
            name: "Sweet Ride Ice Cream",
            photo: "sweet2",
            activeCustomerCount: 12,
            dailyCustomerCount: 48,
            totalCustomerCount: 2020,
            address1: "542 Penn Ave",
            address2: nil,
            city: "West Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(484) 987-7338",
            url: "https://www.sweetrideicecream.com/",
            contentStyle: .light,
            proximityUUID: nil,
            promotion: Promotion(
                name: "free small vanilla scoop",
                headline: StyledText(text: "enjoy one free ice cream sundae", color: "#FFFFFF"),
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
            photo: "5",
            activeCustomerCount: 125,
            dailyCustomerCount: 48,
            totalCustomerCount: 2020,
            address1: "5th and Penn Street",
            address2: nil,
            city: "Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(484) 987-7338",
            url: "https://www.sweetrideicecream.com/",
            contentStyle: .light,
            proximityUUID: nil,
            promotion: Promotion(
                name: "learn about reading",
                headline: StyledText(text: "Headline", color: "#FFFFFF"),
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
            photo: "judy2",
            activeCustomerCount: 31,
            dailyCustomerCount: 62,
            totalCustomerCount: 4467,
            address1: "332 Cherry St",
            address2: nil,
            city: "Reading",
            state: "PA",
            zip: "19602",
            phoneNumber: "(610) 374-8511",
            url: "http://judysoncherry.com/",
            contentStyle: .light,
proximityUUID: nil,
            promotion: Promotion(
                name: "10% off $50 order",
                headline: StyledText(text: "10% OFF YOUR MEAL TODAY", color: "#FFFFFF"),
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
            photo: "wine1",
            activeCustomerCount: 17,
            dailyCustomerCount: 62,
            totalCustomerCount: 4467,
            address1: "622 Penn Ave",
            address2: nil,
            city: "West Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(610) 373-4907",
            url: "http://winedowncafe.net/",
            contentStyle: .light,
            proximityUUID: nil,
            promotion: Promotion(
                name: "free house cab sav",
                headline: StyledText(text: "Headline", color: "#FFFFFF"),
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
            photo: "west2",
            activeCustomerCount: 28,
            dailyCustomerCount: 62,
            totalCustomerCount: 4467,
            address1: "606 Penn Ave",
            address2: nil,
            city: "West Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(610) 376-9232",
            url: "http://westreadingtavern.com/",
            contentStyle: .light,
proximityUUID: nil,
            promotion: Promotion(
                name: "free small pint of ale",
                headline: StyledText(text: "Headline", color: "#FFFFFF"),
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
            photo: "soap2",
            activeCustomerCount: 5,
            dailyCustomerCount: 62,
            totalCustomerCount: 4467,
            address1: "608 Penn Ave",
            address2: nil,
            city: "West Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(610) 816-7474",
            url: "http://www.muddycreeksoapcompany.com/",
            contentStyle: .light,
proximityUUID: nil,
            promotion: Promotion(
                name: "Buy 2 get one free",
                headline: StyledText(text: "Headline", color: "#FFFFFF"),
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
            photo: "g",
            activeCustomerCount: 36,
            dailyCustomerCount: 62,
            totalCustomerCount: 4467,
            address1: "201 Washington St",
            address2: nil,
            city: "Reading",
            state: "PA",
            zip: "19601",
            phoneNumber: "(610) 374-4600",
            url: "https://goggleworks.org",
            contentStyle: .light,
proximityUUID: nil,
            promotion: Promotion(
                name: "free bumper sticker",
                headline: StyledText(text: "Headline", color: "#FFFFFF"),
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
            photo: "bench",
            activeCustomerCount: 12,
            dailyCustomerCount: 62,
            totalCustomerCount: 4467,
            address1: "400 Penn Ave",
            address2: nil,
            city: "West Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(610) 374-2326",
            url: "https://www.benchwarmerscoffee.com/",
            contentStyle: .light,
proximityUUID: nil,
            promotion: Promotion(
                name: "free small cafe mocha",
                headline: StyledText(text: "Headline", color: "#FFFFFF"),
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
            photo: "rpm3",
            activeCustomerCount: 42,
            dailyCustomerCount: 62,
            totalCustomerCount: 4467,
            address1: "500 Museum Rd",
            address2: nil,
            city: "Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(610) 371-5850",
            url: "http://www.readingpublicmuseum.org/",
            contentStyle: .light,
            proximityUUID: nil,
            promotion: Promotion(
                name: "10% off admission",
                headline: StyledText(text: "Reading Public Museum Promo", color: "#FFFFFF"),
                footer: StyledText(text: "Reading Public Museum Footer", color: "#FFFFFF"),
                backgroundColor: "#000000",
                logo: nil,
                image: "rpm",
                isImageFullSize: false,
                url: nil
            )
        ),
        Business(
            id: 11,
            name: "Lisa Tiger Century 21",
            photo: "lisa3",
            activeCustomerCount: 12,
            dailyCustomerCount: 62,
            totalCustomerCount: 4467,
            address1: "3970 Perkiomen Ave",
            address2: nil,
            city: "Reading",
            state: "PA",
            zip: "19606",
            phoneNumber: "(610) 207-6186",
            url: "https://www.lisatigerhomes.com/",
            contentStyle: .light,
proximityUUID: nil,
            promotion: Promotion(
                name: "free home consultation",
                headline: StyledText(text: "Headline", color: "#FFFFFF"),
                footer: StyledText(text: "Footer", color: "#FFFFFF"),
                backgroundColor: "#000000",
                logo: nil,
                image: "sweet",
                isImageFullSize: false,
                url: nil
            )
        ),
        Business(
            id: 12,
            name: "Tina’s Salon & Day Spa",
            photo: "hair",
            activeCustomerCount: 6,
            dailyCustomerCount: 62,
            totalCustomerCount: 4467,
            address1: "404 Penn Ave",
            address2: nil,
            city: "Reading",
            state: "PA",
            zip: "19611",
            phoneNumber: "(610) 374-5991",
            url: "http://gototinas.com/",
            contentStyle: .light,
            proximityUUID: nil,
            promotion: Promotion(
                name: "free coloring with perm",
                headline: StyledText(text: "Headline", color: "#FFFFFF"),
                footer: StyledText(text: "Footer", color: "#FFFFFF"),
                backgroundColor: "#000000",
                logo: nil,
                image: "sweet",
                isImageFullSize: false,
                url: nil
            )
        )
    ]
}

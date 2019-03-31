//
//  Constants.swift
//  RabbitHavenServices
//
//  Created by Patty Case on 9/14/18.
//  Copyright © 2018 Azure Horse Creations. All rights reserved.
//

import Foundation

class Constants {
    
    // MARK: - Rabbit Haven constants
    static var NAIL_TRIMS = "Nail Trims (Sunnyvale)"
    static var NAIL_TRIMS_1_RABBIT = "Nail Trim & Scent Gland Cleaning for 1 Rabbit (FOLT)"
    static var NAIL_TRIMS_2_RABBITS_NAME = "Nail Trim & Scent Gland Cleaning for 2 Rabbits (FOLT)"
    static var NAIL_TRIMS_3_RABBITS_NAME = "Nail Trim & Scent Gland Cleaning for 3 Rabbits (FOLT)"
    static var NAIL_TRIMS_4_RABBITS_NAME = "Nail Trim & Scent Gland Cleaning for 4 Rabbits (FOLT)"
    static var NAIL_TRIMS_5_RABBITS_NAME = "Nail Trim & Scent Gland Cleaning for 5 Rabbits (FOLT)"
    static var NAIL_TRIMS_6_RABBITS_NAME = "Nail Trim & Scent Gland Cleaning for 6 Rabbits (FOLT)"
    static var HOME_HEALTH_CHECKS = "Home Health Checks (Sunnyvale)"
    static var HOME_HEALTH_CHECKS_DEMONSTRATION_NAME = "Home Health Check Demonstration for 1 Rabbit (FOLT)"
    static var BUNNY_HOP = "Rabbit Haven Bunny Hop Event (San Jose)"
    static var BUNNY_HOP_PLAYTIME_NAME = "Bunny Hop Playtime - 1 hour for 1 rabbit"
    static var DONATION_AMOUNT = 5
    static var DONATION_AMOUNT_USD = 5.00
    static var DURATION_TIME = 10
    static var COMPANY = "azurehorsecreations"
    static var HOST = "http://simplybook.me/"
    static var BASE_URL = "https://user-api.simplybook.me/"
    static var LOGIN_URL = BASE_URL + "/login"
    static var API_KEY = "0fb8587f79818d57abe68fb821dab098a33dc8ce6f75aa7e74a40c69079915de"
    static var GET_TOKEN_METHOD = "getToken"
    
    // MARK: - Strings
    static var SPACE = " "
    static var RABBIT = "Rabbit"
    static var RABBITS = "Rabbits"
    static var MINUTES = "minutes"
    static var DOLLAR_SIGN = "$"
    static var S = "s"
    static var GET = "GET"
    static var POST = "POST"
    
    enum Types {
        case Organization, Person, Offer
    }
}

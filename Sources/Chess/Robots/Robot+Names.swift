//
//  File.swift
//  
//
//  Created by Douglas Pedley on 12/1/20.
//

import Foundation

// swiftlint:disable function_body_length
extension Chess.Robot {
    /// A utllity function to give the bots some unique first names.
    /// - Returns: A random string, one of the names below.
    static func randomFirstName() -> String {
        return [
            "Sherice",
            "Georgiann",
            "Carolee",
            "Jackeline",
            "Dean",
            "Kyle",
            "Vena",
            "Alaina",
            "Karyl",
            "Dawna",
            "Carli",
            "Gonzalo",
            "Jerica",
            "Cleveland",
            "Marietta",
            "Denisse",
            "Nannie",
            "Yulanda",
            "Katharina",
            "Latosha",
            "Adriene",
            "Sonja",
            "Maddie",
            "Yajaira",
            "Lizzette",
            "Charlsie",
            "Francis",
            "Elton",
            "Leeanna",
            "Ai",
            "Josefa",
            "Kazuko",
            "Kristofer",
            "Jasmin",
            "Adam",
            "Britta",
            "Marilee",
            "Francesca",
            "Krista",
            "Claudia",
            "Thuy",
            "Coleen",
            "Sharita",
            "Sun",
            "Elsie",
            "Jerlene",
            "Claudine",
            "Marcelene",
            "Saul",
            "Roselee"
        ].randomElement() ?? "Doug"
    }
}
// swiftlint:enable function_body_length

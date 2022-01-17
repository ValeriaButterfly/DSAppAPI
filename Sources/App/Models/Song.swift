//
//  Song.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Vapor

final class Song: Content {

    // MARK: - Public Properties

    var id: UUID?
    var title: String
    var genre: String
    var year: Int
    var timing: Float

    var userID: UUID

    // MARK: - Initializers

    init(title: String, genre: String, year: Int, timing: Float, userID: UUID) {
        self.title = title
        self.genre = genre
        self.year = year
        self.timing = timing

        self.userID = userID
    }
}

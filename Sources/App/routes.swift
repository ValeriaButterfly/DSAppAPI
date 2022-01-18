//
//  routes.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Vapor

func routes(_ app: Application) throws {
    let usersHostname: String
    let songsHostname: String

    if let users = Environment.get("USERS_HOSTNAME") {
        usersHostname = users
    } else {
        usersHostname = "localhost"
    }

    if let songs = Environment.get("SONGS_HOSTNAME") {
        songsHostname = songs
    } else {
        songsHostname = "localhost"
    }

    try app.register(collection: UsersController(
        userServiceHostname: usersHostname,
        songsServiceHostname: songsHostname))
    try app.register(collection: SongsController(
        songsServiceHostname: songsHostname,
        userServiceHostname: usersHostname))
}

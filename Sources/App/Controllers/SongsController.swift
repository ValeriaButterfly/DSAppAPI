//
//  SongsController.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Vapor

struct CreateSongData: Content {
    let title: String
    let genre: String
    let year: Int
    let timing: Float
}

// MARK: -

struct SongsController: RouteCollection {

    // MARK: - Public Properties

    let songsServiceURL: String
    let userServiceURL: String

    // MARK: - Initializers

    init(songsServiceHostname: String, userServiceHostname: String) {
        self.songsServiceURL = "http://\(songsServiceHostname):8082"
        self.userServiceURL = "http://\(userServiceHostname):8081"
    }

    // MARK: - Lifecycle

    func boot(routes: RoutesBuilder) throws {
        let songsGroup = routes.grouped("api", "songs")

        songsGroup.get(use: getAllHandler)
        songsGroup.get(":songID", use: getHandler)
        songsGroup.get(":songID", "user", use: getUserHandler)

        songsGroup.post(":userID", use: createHandler)

        songsGroup.put(":songID", use: updateHandler)

        songsGroup.delete(":songID", use: deleteHandler)
    }

    // MARK: - Public Methods

    func getAllHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(songsServiceURL)/")
    }

    func getHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("songID", as: UUID.self)
        return req.client.get("\(songsServiceURL)/\(id)")
    }

    func createHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        let userID = req.parameters.get("userID", as: String.self) ?? ""
        return req.client.post("\(songsServiceURL)/\(userID)") { createRequest in
            try createRequest.content.encode(req.content.decode(CreateSongData.self))
        }
    }

    func updateHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let songID = try req.parameters.require("songID", as: UUID.self)
        return req.client.put("\(songsServiceURL)/\(songID)") { updateRequest in
            try updateRequest.content.encode(req.content.decode(CreateSongData.self))
        }
    }

    func deleteHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let songID = try req.parameters.require("songID", as: UUID.self)
        return req.client.delete("\(songsServiceURL)/\(songID)")
    }

    func getUserHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let songID = try req.parameters.require("songID", as: UUID.self)
        return req.client.get("\(songsServiceURL)/\(songID)").flatMapThrowing { response in
            return try response.content.decode(Song.self)
        }.flatMap { song in
            return req.client.get("\(userServiceURL)/users/\(song.userID)")
        }
    }
}

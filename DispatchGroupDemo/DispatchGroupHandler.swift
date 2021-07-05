//
//  DispatchGroupHandler.swift
//  DispatchGroupDemo
//
//  Created by Duncan Champney on 6/6/21.
//

import Foundation
/*
 func collectMovieIds() {
   let group = DispatchGroup()
   var movieIds = Set<Int>()

   userService.fetchProfile(group: group) { profile in
     movieIds.insert(profile.allTimeFavorite)
   }

   userService.fetchFavorites(group: group) { favorites in
     for favorite in favorites {
       movieIds.insert(favorite.movie)
     }
   }

   userService.fetchTickets(group: group) { tickets in
     for ticket in tickets {
       movieIds.insert(ticket.movie)
     }
   }

   group.notify(queue: DispatchQueue.global()) {
     print("Completed work: \(movieIds)")
     // Kick off the movies API calls
     PlaygroundPage.current.finishExecution()
   }
 }

 */
class DispatchGroupHandler<InputData, ResultData> {

    var completionHandler: () -> Void
    let group = DispatchGroup()

    init(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
    }
    func listenForCompletion() {
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.completionHandler()
        }
    }
    
    func doWork(onData data: InputData, workItem: (InputData) -> ResultData) {
        group.enter()
        let _ = workItem(data)
        group.leave()
    }
}

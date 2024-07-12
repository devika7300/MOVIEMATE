//
//  ContentView.swift
//  MovieList
//
//  Created by Devika Shendkar on 3/18/23.
//

import SwiftUI


// This file contains the ContentView, which is a view that displays the MovieView. The MovieView is responsible for fetching and displaying a list of popular movies from The Movie Database (TMDb) API.
struct ContentView: View {
    var body: some View {
        NavigationStack{
            SignInView()
            //MovieView()
        }.navigationTitle("Movie List")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  VocabApp
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import NaturalLanguage
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Library")
                }

            Text("Dictionary")
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Dictionary")
                }
                .padding()

            Text("Study")
                .tabItem {
                    Image(systemName: "lightbulb.max.fill")
                    Text("Study")
                }
                .padding()

            Text("Settings")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .padding()
        }
//        NavigationStack {
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    NavigationLink("Library") {
//                        LibraryView()
//                    }
//
//                    Spacer()
//                    NavigationLink("Dictionary") {
//                        
//                    }
//                    Spacer()
//                }
//                Spacer()
//                
//                HStack {
//                    Spacer()
//                    NavigationLink("Study") {
//                        
//                    }
//                    Spacer()
//                    
//                    NavigationLink("Settings") {
//                        
//                    }
//                    Spacer()
//                }
//                Spacer()
//            }
//        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        ContentView()
            .modelContainer(for: [Story.self, VocabWord.self])
    }
}

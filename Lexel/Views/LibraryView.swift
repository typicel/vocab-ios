//
//  LibraryView.swift
//  Lexel
//
//  Created by enzo on 5/24/24.
//

import SwiftUI
import NaturalLanguage
import SwiftData

struct LibraryView: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var selectedStoryIdx: Int? = 1
    @State private var isShowingAddStorySheet: Bool = false
    @Query private var stories: [Story]
    
    func showSheet() { isShowingAddStorySheet = true }
    
    func deleteItem(_ item: Story) {
        context.delete(item)
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                List {
                    ForEach(stories.enumeratedArray(), id: \.offset) { offset, element in
                        NavigationLink(value: offset) {
                            VStack(alignment: .leading) {
                                HStack(alignment: .firstTextBaseline) {
                                    Text(element.title)
                                        .font(.title3)
                                        .bold()
                                
                                    Text(element.language.suffix(2))
                                        .font(.caption)
                                }
                                if let date = element.lastOpened {
                                    Text("\(self.relativeTimeString(for: date))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .onDelete { indexes in
                        for index in indexes {
                            deleteItem(stories[index])
                        }
                    }
                    
                }
                .navigationDestination(for: Int.self) {
                    VocabParagraph(story: stories[$0], translator: TranslationService(sourceLanguage: stories[$0].mlLanguage))
                }
                .navigationTitle("Lexel")
                .listStyle(.inset)
                
                Spacer()
                
                Button(action: showSheet) {
                    Label("Add Story", systemImage: "plus.circle")
                }
            }
        } detail: {
            if stories.isEmpty {
                ContentUnavailableView(label: {
                    Label("No Stories", systemImage: "book")
                }, description: {
                    Text("Add a story to start learning")
                }, actions: {
                    Button("Add Story") { isShowingAddStorySheet = true }
                })
            }
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $isShowingAddStorySheet) { AddStorySheet() }
        
    }
    
    func relativeTimeString(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        var string = formatter.localizedString(for: date, relativeTo: Date())
        if string == "in 0 seconds" {
            string = "Just now"
        }
        
        return string
    }
}



struct AddStorySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @State private var title: String = ""
    @State private var language: String = "en-US"
    @State private var text: String = "Add story text here"
    
    private var allowedLanguages: [(String, String)] = [
        ("English", "en-US"),
        ("German", "de-DE"),
        ("Spanish", "es-ES"),
        ("French", "fr-FR"),
        ("Korean", "ko-KR"),
        ("Japanese", "ja-JP")
    ]
    
    func addStory() {
        let newStory = Story(title: title, text: text, language: language) // this is never called if language is null so it's fine
        context.insert(newStory)
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Story Title", text: $title)
                    .autocorrectionDisabled()
                Picker("Source Language", selection: $language) {
                    ForEach(allowedLanguages.enumeratedArray(), id: \.offset) { _, lang in
                        Text(lang.0).tag(lang.1)
                    }
                }
                TextEditor(text: $text)
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                PasteButton(payloadType: String.self) { string in
                    self.text = string[0]
                }
                
            }
            .navigationTitle("New Story")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Add") { addStory() }
                        .disabled(title.isEmpty || text.isEmpty)
                }
            }
        }
    }
    
    
}

#Preview {
    MainActor.assumeIsolated {
        LibraryView()
            .modelContainer(for: [Story.self, VocabWord.self])
    }
}

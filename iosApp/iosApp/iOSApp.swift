import BibleKit
import SwiftUI

@main
struct iOSApp: App {
    // MARK: - Properties

    @Bindable var viewModel = SearchViewModel(
        bibleProvider: BibleProvider.create(
            url: Bundle.main.url(forResource: "bible", withExtension: "db")!
        )
    )

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            searchView
        }
    }

    private var searchView: some View {
        NavigationStack {
            Group {
                if viewModel.searchQuery.isEmpty {
                    VStack {
                        Spacer()
                        Text("Enter text to search through the Bible")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding()
                } else if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView("Searching through verses...")
                        Spacer()
                    }
                    .padding()
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Spacer()
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding()
                } else if viewModel.results.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No verses found matching your search")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding()
                } else {
                    List(viewModel.results, id: \.id) { verse in
                        Text("\(verse.id.bookChapterVerse())").bold() + Text(" \(verse.text)")
                    }
                    .scrollDismissesKeyboard(.immediately)
                }
            }
            .navigationTitle("Bible Search")
            .searchable(
                text: $viewModel.searchQuery,
                prompt: "Search through Bible verses..."
            )
        }
    }
}

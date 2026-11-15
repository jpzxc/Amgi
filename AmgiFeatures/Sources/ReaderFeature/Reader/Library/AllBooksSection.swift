//
//  AllBooksSection.swift
//  ReaderFeature
//
//  Created by Vladimir Gusev on 17.05.2026.
//

import Reader
import Theme
import SwiftUI

struct AllBooksSection: View {
    let items: [BookCellItem]
    let bookForId: (String) -> ReaderBook?
    let progress: ReaderProgressCoordinator

    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 14, alignment: .top),
        count: 3
    )

    @Environment(\.palette) private var palette
    /// Anchors each book's detail push to the cover the user tapped, so the
    /// screen grows out of that cover instead of cutting in from the edge.
    @Namespace private var coverTransition

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ALL BOOKS")
                .amgiFont(.captionBold)
                .tracking(1.4)
                .foregroundStyle(palette.textSecondary)
                .padding(.horizontal, 16)

            LazyVGrid(columns: columns, spacing: 18) {
                ForEach(items) { item in
                    if let book = bookForId(item.id) {
                        NavigationLink {
                            ReaderBookDetailView(book: book, progress: progress)
                                .modifier(ZoomNavigationTransitionModifier(id: item.id, namespace: coverTransition))
                        } label: {
                            AllBooksCell(item: item)
                        }
                        .buttonStyle(.pressScale)
                        .modifier(MatchedTransitionSourceModifier(id: item.id, namespace: coverTransition))
                    } else {
                        AllBooksCell(item: item)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct ZoomNavigationTransitionModifier: ViewModifier {
    let id: String
    let namespace: Namespace.ID

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 18.0, macOS 15.0, *) {
            content.navigationTransition(.zoom(sourceID: id, in: namespace))
        } else {
            content
        }
    }
}

private struct MatchedTransitionSourceModifier: ViewModifier {
    let id: String
    let namespace: Namespace.ID

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 18.0, macOS 15.0, *) {
            content.matchedTransitionSource(id: id, in: namespace)
        } else {
            content
        }
    }
}

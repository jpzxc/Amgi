//
//  ContinueReadingSection.swift
//  ReaderFeature
//
//  Created by Vladimir Gusev on 17.05.2026.
//

import Reader
import Theme
import SwiftUI

struct ContinueReadingSection: View {
    let items: [ContinueReadingItem]
    let bookForId: (String) -> ReaderBook?
    let progress: ReaderProgressCoordinator

    @Environment(\.palette) private var palette
    /// See `AllBooksSection` — the detail push grows from the tapped card.
    @Namespace private var coverTransition

    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            VStack(alignment: .leading, spacing: 10) {
                sectionHeader
                ScrollView(.horizontal, showsIndicators: false) {
                    // Lazy: an eager HStack builds — and decodes the cover for
                    // — every book in the row before any of it is on screen.
                    LazyHStack(alignment: .top, spacing: 14) {
                        ForEach(items) { item in
                            if let book = bookForId(item.id) {
                                NavigationLink {
                                    ReaderBookDetailView(book: book, progress: progress)
                                        .modifier(ZoomNavigationTransitionModifier(id: item.id, namespace: coverTransition))
                                } label: {
                                    ContinueReadingCard(item: item)
                                }
                                .buttonStyle(.pressScale)
                                .modifier(MatchedTransitionSourceModifier(id: item.id, namespace: coverTransition))
                            } else {
                                ContinueReadingCard(item: item)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    private var sectionHeader: some View {
        Text("CONTINUE READING")
            .amgiFont(.captionBold)
            .tracking(1.4)
            .foregroundStyle(palette.textSecondary)
            .padding(.horizontal, 16)
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

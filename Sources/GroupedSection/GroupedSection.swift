import SwiftUI

private struct SectionCellBackgroundColorKey: PreferenceKey {
    static func reduce(value: inout Color, nextValue: () -> Color) {
        value = nextValue()
    }

    static let defaultValue: Color = .clear
}

public struct GroupedSection<Content: View, Header: View, Footer: View>: View {
    let content: () -> Content
    let header: () -> Header
    let footer: () -> Footer

    var sectionPreference = GroupedSectionPreference()
    var rowPreference = GroupedSectionRowPreference()

    @MainActor
    public init(@ViewBuilder content: @escaping () -> Content,
                @ViewBuilder header: @escaping () -> Header,
                @ViewBuilder footer: @escaping () -> Footer) {
        self.content = content
        self.header = header
        self.footer = footer
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            if Header.self != EmptyView.self {
                header()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            _VariadicView.Tree(GroupSectionLayout(rowPreference: rowPreference),
                               content: content)
                .labelStyle(GroupSectionLabelStyle(rowPreference))
                .buttonStyle(GroupSectionButtonStyle(rowPreference))
                .font(rowPreference.titleFont)
                .frame(maxWidth: .infinity, alignment: .leading)

            if Footer.self != EmptyView.self {
                footer()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
//            Spacer().frame(height: sectionPreference.sectionSpacing)
        })
        .frame(maxWidth: .infinity)
        .background {
            if let color = rowPreference.rowBackgroundColor {
                color
            } else {
                Color.clear.background()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: sectionPreference.sectionRadius))
        .overlay(content: {
            if let color = sectionPreference.sectionBorderColor {
                RoundedRectangle(cornerRadius: sectionPreference.sectionRadius).stroke(color, lineWidth: sectionPreference.sectionBorderWidth)
            }
        })
        .padding(sectionPreference.sectionInsets)

//        Section(content: {
//            content()
//                .appSectionCellStylized()
//        }, header: {
//            header()
//                .appSectionHeaderStylized()
//        }, footer: {
//            footer()
//        })
    }
}

public extension GroupedSection where Header == EmptyView {
    @MainActor
    init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder footer: @escaping () -> Footer) {
        self.init(content: content, header: { EmptyView() }, footer: footer)
    }
}

public extension GroupedSection where Footer == EmptyView {
    @MainActor
    init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder header: @escaping () -> Header) {
        self.init(content: content, header: header, footer: { EmptyView() })
    }
}

public extension GroupedSection where Header == EmptyView, Footer == EmptyView {
    @MainActor
    init(@ViewBuilder content: @escaping () -> Content) {
        self.init(content: content, header: { EmptyView() }, footer: { EmptyView() })
    }
}

public extension View {
    func sectionCellBackgroundColor(_ color: Color?) -> some View {
        preference(key: SectionCellBackgroundColorKey.self, value: color ?? .clear)
    }
}

fileprivate extension View {
    func appSectionCellStylized() -> some View {
        font(.system(size: 16))
    }

    func appSectionHeaderStylized() -> some View {
        font(.system(size: 12))
//            .foregroundStyle(Color.dynamic(light: Color(0x1c1c1c).opacity(0.4), dark: Color.white.opacity(0.4)))
//            .textCase(nil)
    }
}

private struct GroupSectionLayout: _VariadicView_MultiViewRoot {
    @Environment(\.displayScale) var displayScale
    let rowPreference: GroupedSectionRowPreference

    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
        let lastId = children.last?.id
        ForEach(children) { child in
            child
//                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(rowPreference.rowInstes)

            if child.id != lastId, rowPreference.rowSeparatorVisibility != .hidden {
                Group {
                    if let color = rowPreference.rowSeparatorTint {
                        color.frame(height: 1)
                    } else {
                        Color.gray.opacity(0.5).frame(height: 1 / displayScale.nextUp)
                    }
                }
                .padding(rowPreference.rowSeparatorInsets)
            }
        }
    }
}

#Preview {
    @ViewBuilder
    func contentViews() -> some View {
        Text("123")
            .background(Color.red)

        Button(action: {}, label: {
            Text("Button")
                .background(Color.red)
        })

        NavigationLink(destination: EmptyView()) {
            Text("NavigationLink Text")
        }

        NavigationLink(destination: EmptyView()) {
            Label(
                title: { Text("NavigationLink X")
                    .background(Color.red)
                },
                icon: {
                    Image(systemName: "circle.grid.cross")
                        .background(Color.red)
                }
            )
        }

        NavigationLink(destination: EmptyView()) {
            Label(
                title: { Text("NavigationLink XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX") },
                icon: {
                    Image(systemName: "circle.grid.cross")
                        .background(Color.red)
//                        .font(.system(size: 30))
                }
            )
            .background(Color.green)
        }

        Text("456456456456456456456456456456456456456456456456456456456456456456")
    }

    return
        NavigationView {
            ZStack {
                Color.gray
                    .ignoresSafeArea()

                VStack {
                    GroupedSection {
                        contentViews()
                    }

                    if #available(iOS 16.0, *) {
                        List {
                            Section {
                                contentViews()
                            }
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
                .frame(height: 1000)
            }
        }
}

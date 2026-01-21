#if !os(WASI)

import CSSBuilder
import DesignTokens
import HTMLBuilder
import WebComponents
import WebTypes

private let baseRoute = Configuration.shared.baseRoute

public struct SidebarItem: Sendable {
    public let label: String
    public let url: String
    public let icon: (@Sendable (Length) -> [HTML])?
    
    public init(label: String, url: String, icon: (@Sendable (Length) -> [HTML])? = nil) {
        self.label = label
        self.url = url
        self.icon = icon
    }
}

public struct SidebarView: HTML {
    let items: [SidebarItem]
    let bottomItems: [SidebarItem]

    public init(items: [SidebarItem]? = nil, bottomItems: [SidebarItem]? = nil) {
        self.items = items ?? [
            SidebarItem(label: "Dashboard", url: baseRoute),
            SidebarItem(label: "Invites", url: "\(baseRoute)/invites"),
            SidebarItem(label: "Account Security", url: "\(baseRoute)/mfa/setup")
        ]
        self.bottomItems = bottomItems ?? [
            SidebarItem(label: "Back to site", url: "/", icon: { size in
                [PreviousIconView(width: size, height: size)]
            })
        ]
    }

    public func render(indent: Int = 0) -> String {
        aside {
            div {
                nav {
                    ul {
                        for item in items {
                            renderItem(item)
                        }

                        li {
                            div { "" }
                                .style {
                                    borderTop(borderWidthBase, borderStyleBase, borderColorSubtle)
                                    paddingTop(spacing8)
                                }
                        }

                        for item in bottomItems {
                            renderItem(item)
                        }
                    }
                    .style {
                        listStyle(.none)
                        padding(0)
                        margin(0)
                        display(.flex)
                        flexDirection(.column)
                        gap(spacing4)
                    }
                }
            }
            .style {
                padding(spacing16)
            }
        }
        .class("sidebar-view")
        .style {
            width(px(260))
            minWidth(px(260))
            height(vh(100))
            position(.sticky)
            top(0)
            left(0)
            backgroundColor(backgroundColorBase)
            borderRight(borderWidthBase, borderStyleBase, borderColorSubtle)
            display(.flex)
            flexDirection(.column)
            overflow(.auto)
        }
        .render(indent: indent)
    }

    @HTMLBuilder
    private func renderItem(_ item: SidebarItem) -> HTML {
        li {
            a {
                div {
                    if let icon = item.icon {
                        IconView(icon: { size in icon(size) }, size: .small)
                    }
                    span { item.label }
                }
                .style {
                    display(.flex)
                    alignItems(.center)
                    gap(spacing8)
                }
            }
            .href(item.url)
            .class("sidebar-link")
            .style { sidebarLinkStyle() }
        }
    }

    @CSSBuilder
    private func sidebarLinkStyle() -> [any CSS] {
        display(.block)
        padding(spacing12, spacing16)
        fontFamily(typographyFontSans)
        fontSize(fontSizeSmall14)
        fontWeight(500)
        color(colorBase)
        textDecoration(.none)
        borderRadius(borderRadiusBase)
        transition(transitionPropertyBase, transitionDurationBase, transitionTimingFunctionSystem)
        
        pseudoClass(.hover) {
            backgroundColor(backgroundColorInteractiveSubtleHover)
            color(colorBase)
        }
    }
}

#endif

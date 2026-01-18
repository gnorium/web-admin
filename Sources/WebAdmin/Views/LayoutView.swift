#if !os(WASI)

import CSSBuilder
import DesignTokens
import HTMLBuilder
import WebComponents
import WebTypes

/// Shared layout for the admin panel.
/// Provides the Sidebar + Navbar + Content structure.
public struct LayoutView: HTML {
    let siteName: String
    let username: String
    let content: HTML

    public init(
        siteName: String = "Admin",
        username: String,
        @HTMLBuilder content: () -> HTML
    ) {
        self.siteName = siteName
        self.username = username
        self.content = content()
    }

    public func render(indent: Int = 0) -> String {
        div {
            ContainerView(size: .xLarge) {
                div {
                    NavbarView(siteName: siteName, username: username)
                    
                    div {
                        SidebarView()
                        
                        main {
                            content
                        }
                        .style {
                            flex(1)
                            overflow(.auto)
                            padding(spacing32)
                        }
                    }
                    .style {
                        display(.flex)
                        flex(1)
                    }
                    
                    footer {
                        BreadcrumbView(items: [
                            .init(text: "Home", url: "/admin"),
                            .init(text: "Dashboard")
                        ])
                    }
                    .style {
                        padding(spacing16, spacing32)
                        backgroundColor(backgroundColorBase)
                        borderTop(borderWidthBase, borderStyleBase, borderColorSubtle)
                    }
                }
                .style {
                    display(.flex)
                    flexDirection(.column)
                    minHeight(vh(100))
                    backgroundColor(backgroundColorBase)
                }
            }
        }
        .style {
            backgroundColor(backgroundColorBase)
            color(colorBase)
            fontFamily(typographyFontSans)
            minHeight(vh(100))
        }
        .render(indent: indent)
    }
}

@CSSBuilder
public func tableHeaderCSS() -> [any CSS] {
    backgroundColor(backgroundColorNeutralSubtle)
    color(colorBase)
    textTransform(.uppercase)
    fontSize(fontSizeXSmall12)
    letterSpacing(em(0.05))
    fontWeight(fontWeightBold)
    padding(px(14), px(20)).important()
    borderBottom(px(1), .solid, rgba(0, 0, 0, 0.05))
    
    selector("a") {
        color(colorBase).important()
        textDecoration(.none)
    }
}

@CSSBuilder
public func tableRowCSS() -> [any CSS] {
    selector("td") {
        padding(spacing16, px(20))
        verticalAlign(.middle)
    }
}

#endif

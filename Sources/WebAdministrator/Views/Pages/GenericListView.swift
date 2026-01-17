#if !os(WASI)

import CSSBuilder
import DesignTokens
import HTMLBuilder
import WebComponents
import WebTypes

/// A generic list view for any admin model
public struct GenericListView: HTML {
    let admin: AnyModelAdmin
    let rows: [ListRow]
    
    public init(admin: AnyModelAdmin, rows: [ListRow]) {
        self.admin = admin
        self.rows = rows
    }
    
    public func render(indent: Int = 0) -> String {
        div {
            // Header
            header {
                h1 { "Manage \(admin.modelNamePlural)" }
                    .style {
                        fontFamily(typographyFontSans)
                        fontSize(px(24))
                        fontWeight(600)
                        color(colorBase)
                    }

                a {
                    ButtonView(label: "Add \(admin.modelName)", action: .progressive, weight: .primary, size: .large)
                }
                .href("/administrator/\(admin.urlPath)/new")
                .style {
                    textDecoration(.none)
                }
            }
            .style {
                display(.flex)
                justifyContent(.spaceBetween)
                alignItems(.center)
                marginBottom(spacing32)
            }

            // Table
            TableView(
                captionContent: "\(admin.modelNamePlural) list",
                hideCaption: true,
                columns: admin.listFields.map { field in
                    .init(id: field, label: admin.listHeaders[field] ?? field.capitalized, sortable: true)
                } + [.init(id: "actions", label: "Actions", align: .end)],
                thStyle: { _ in tableHeaderCSS() },
                class: "generic-list-table",
                tbody: {
                    if rows.isEmpty {
                        tr {
                            td {
                                div {
                                    div { "No \(admin.modelNamePlural.lowercased()) found" }
                                        .style {
                                            fontSize(fontSizeLarge18)
                                            fontWeight(600)
                                            marginBottom(spacing8)
                                        }
                                    div { "Click the button above to create one" }
                                }
                                .style {
                                    textAlign(.center)
                                    padding(spacing64, spacing24)
                                    color(colorSubtle)
                                }
                            }
                            .colspan(admin.listFields.count + 1)
                        }
                    } else {
                        for row in rows {
                            tr {
                                for field in admin.listFields {
                                    td {
                                        if let value = row.values[field] {
                                            // Special handling for specific field types if needed
                                            // For now, just text
                                            value
                                        }
                                    }
                                }
                                
                                // Actions
                                td {
                                    div {
                                        a { ButtonView(label: "Edit", weight: .quiet, size: .small) }
                                            .href("/administrator/\(admin.urlPath)/\(row.id)/edit")
                                            .style { textDecoration(.none) }

                                        a { 
                                            ButtonView(label: "Delete", action: .destructive, weight: .quiet, size: .small) 
                                        }
                                        .class("admin-delete-action")
                                        .href("/administrator/\(admin.urlPath)/\(row.id)/delete")
                                        .style { textDecoration(.none) }
                                    }
                                    .style {
                                        display(.flex)
                                        gap(spacing4)
                                        justifyContent(.flexEnd)
                                    }
                                }
                            }
                            .style {
                                tableRowCSS()
                            }
                        }
                    }
                }
            )
        }
        .class("generic-list-view")
        .render(indent: indent)
    }
}

#endif

#if os(WASI)

import WebAPIs
import EmbeddedSwiftUtilities

public class GenericListViewHydration: @unchecked Sendable {
    private var deleteLinks: [Element] = []

    public init() {
        hydrateDeleteActions()
    }

    public func hydrate() {
        hydrateDeleteActions()
    }

    private func hydrateDeleteActions() {
        let links = document.querySelectorAll(".admin-delete-action")

        for link in links {
            deleteLinks.append(link)
            _ = link.addEventListener(.click) { event in
                let confirmed = globalThis.confirm("Are you sure you want to delete this?")
                if !confirmed {
                    event.preventDefault()
                }
            }
        }
    }
}

#endif

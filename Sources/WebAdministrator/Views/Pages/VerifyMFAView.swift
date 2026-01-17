#if !os(WASI)

import HTMLBuilder
import CSSBuilder
import DesignTokens
import WebComponents
import WebTypes

/// MFA Verification View for login flow
/// Uses modern DSL patterns: lowercase tags, inline styles, design tokens
public struct VerifyMFAView: HTML {
	public let username: String
	public let error: String?

	public init(username: String, error: String? = nil) {
		self.username = username
		self.error = error
	}

	public func render(indent: Int = 0) -> String {
		html {
			head {
				title { "MFA Verification | Administration" }
				meta().charset(.UTF8)
				meta().name(.viewport).content("width=device-width, initial-scale=1")
			}
			body {
				div {
					verificationCard
				}
				.class("mfa-container")
				.style { containerCSS() }
			}
			.style {
				margin(0)
				padding(0)
				backgroundColor(backgroundColorBase)
				fontFamily(typographyFontSans)
				color(colorBase)
			}
		}
		.render(indent: indent)
	}

	@HTMLBuilder
	private var verificationCard: [HTML] {
		div {
			h1 { "Two-Factor Authentication" }
				.style { titleCSS() }

			p { "Please enter the 6-digit code from your authenticator app to complete the login process for " }
				.style { descriptionCSS() }

			strong { username }
				.style { usernameCSS() }

			// Error message
			if let error = error {
				div {
					p { error }
						.style { errorTextCSS() }
				}
				.style { errorContainerCSS() }
			}

			// Verification form
			form {
				input()
					.type(.hidden)
					.name("username")
					.value(username)

				div {
					label { "Verification Code" }
						.for("code")
						.style { labelCSS() }

					input()
						.type(.text)
						.name("code")
						.id("code")
						.placeholder("000000")
						.required(true)
						.style { inputCSS() }
				}
				.style { formGroupCSS() }

				button { "Verify & Login" }
					.type(.submit)
					.style { buttonCSS() }
			}
			.method(.post)
			.action("/administrator/mfa/verify")

			// Footer
			div {
				a { "Back to login" }
					.href("/administrator/login")
					.style { backLinkCSS() }
			}
			.style { footerCSS() }
		}
		.style { cardCSS() }
	}

	// MARK: - CSS Functions

	@CSSBuilder
	private func containerCSS() -> [CSS] {
		display(.flex)
		justifyContent(.center)
		alignItems(.center)
		minHeight(vh(80))
		padding(spacing24)
	}

	@CSSBuilder
	private func cardCSS() -> [CSS] {
		backgroundColor(backgroundColorNeutralSubtle)
		borderRadius(borderRadiusBase)
		padding(spacing48)
		width(px(400))
		maxWidth(perc(100))
		boxShadow(px(0), px(4), px(20), px(0), rgba(0, 0, 0, 0.1))
		textAlign(.center)
	}

	@CSSBuilder
	private func titleCSS() -> [CSS] {
		fontFamily(typographyFontSerif)
		fontSize(px(24))
		fontWeight(.normal)
		color(colorBase)
		marginBottom(spacing16)
	}

	@CSSBuilder
	private func descriptionCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		fontSize(fontSizeSmall14)
		lineHeight(1.5)
		color(colorSubtle)
		marginBottom(spacing8)
		display(.inline)
	}

	@CSSBuilder
	private func usernameCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		fontSize(fontSizeSmall14)
		color(colorBase)
		display(.block)
		marginBottom(spacing32)
	}

	@CSSBuilder
	private func formGroupCSS() -> [CSS] {
		display(.flex)
		flexDirection(.column)
		alignItems(.flexStart)
		marginBottom(spacing24)
	}

	@CSSBuilder
	private func labelCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		fontSize(fontSizeXSmall12)
		fontWeight(.semiBold)
		textTransform(.uppercase)
		letterSpacing(px(0.5))
		marginBottom(spacing8)
		color(colorSubtle)
	}

	@CSSBuilder
	private func inputCSS() -> [CSS] {
		fontFamily(typographyFontMono)
		width(perc(100))
		padding(spacing12)
		fontSize(px(24))
		textAlign(.center)
		letterSpacing(px(4))
		border(borderWidthBase, borderStyleBase, borderColorBase)
		borderRadius(borderRadiusBase)
		backgroundColor(backgroundColorNeutralSubtle)
		color(colorBase)
	}

	@CSSBuilder
	private func buttonCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		width(perc(100))
		padding(spacing12)
		backgroundColor(colorProgressive)
		color(hex(0xFFFFFF))
		border(.none)
		borderRadius(borderRadiusBase)
		fontSize(fontSizeMedium16)
		fontWeight(.semiBold)
		cursor(.pointer)
	}

	@CSSBuilder
	private func errorContainerCSS() -> [CSS] {
		backgroundColor(rgba(255, 59, 48, 0.1))
		border(px(1), .solid, rgba(255, 59, 48, 0.2))
		borderRadius(borderRadiusBase)
		padding(spacing12)
		marginBottom(spacing24)
	}

	@CSSBuilder
	private func errorTextCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		color(colorDestructive)
		fontSize(fontSizeSmall14)
		margin(0)
	}

	@CSSBuilder
	private func footerCSS() -> [CSS] {
		marginTop(spacing32)
		borderTop(borderWidthBase, borderStyleBase, borderColorBase)
		paddingTop(spacing24)
	}

	@CSSBuilder
	private func backLinkCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		fontSize(fontSizeSmall14)
		color(colorSubtle)
		textDecoration(.none)
	}
}

#endif

#if os(WASI)
 
 import WebAPIs
 import EmbeddedSwiftUtilities
 
 /// WASM Hydration for VerifyMFAView
 public class VerifyMFAHydration: @unchecked Sendable {
 	public init() {
 		hydrate()
 	}
 
 	public func hydrate() {
 		// Focus the code input field automatically
 		let codeInput = document.getElementById("code")
 		_ = codeInput?.focus()
 	}
 }
 
 #endif

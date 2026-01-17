#if !os(WASI)

import HTMLBuilder
import CSSBuilder
import DesignTokens
import WebComponents
import WebTypes

/// MFA Verification View for login flow
public struct VerifyMFAView: HTML {
	public let username: String
	public let error: String?

	public init(username: String, error: String? = nil) {
		self.username = username
		self.error = error
	}

	public func render(indent: Int = 0) -> String {
		LayoutView(siteName: "Verify MFA", username: username) {
			div {
				verificationCard
			}
			.class("mfa-container")
			.style {
				display(.flex)
				justifyContent(.center)
				alignItems(.center)
				padding(spacing32)
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
			.action("/admin/mfa/verify")

			// Footer
			div {
				a { "Back to login" }
					.href("/admin/login")
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
		backgroundColor(backgroundColorBase)
		border(borderWidthBase, borderStyleBase, borderColorBase)
		borderRadius(borderRadiusBase)
		padding(spacing48)
		width(px(400))
		maxWidth(perc(100))
		boxShadow(boxShadowLarge)
		textAlign(.center)
	}

	@CSSBuilder
	private func titleCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		fontSize(px(24))
		fontWeight(600)
		color(colorBase)
		marginBottom(spacing16)
		letterSpacing(px(-0.5))
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
 		if let codeInput = document.getElementById("code") {
 			codeInput.focus()
 		}
 	}
 }
 
 #endif

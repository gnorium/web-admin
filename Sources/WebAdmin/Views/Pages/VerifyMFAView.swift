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
		div {
			// verificationCard
			div {
				h1 { "Two-Factor Authentication" }
					.class("verify-mfa-title")
					.style {
						fontFamily(typographyFontSans)
						fontSize(px(24))
						fontWeight(600)
						color(colorBase)
						marginBottom(spacing16)
						letterSpacing(px(-0.5))
					}

				p { "Please enter the 6-digit code from your authenticator app to complete the login process for " }
					.class("verify-mfa-description")
					.style {
						fontFamily(typographyFontSans)
						fontSize(fontSizeSmall14)
						lineHeight(1.5)
						color(colorSubtle)
						marginBottom(spacing8)
						display(.inline)
					}

				strong { username }
					.class("verify-mfa-username")
					.style {
						fontFamily(typographyFontSans)
						fontSize(fontSizeSmall14)
						color(colorBase)
						display(.block)
						marginBottom(spacing32)
					}

				// Error message
				if let error = error {
					div {
						p { error }
							.class("verify-mfa-error-text")
							.style {
								fontFamily(typographyFontSans)
								color(colorDestructive)
								fontSize(fontSizeSmall14)
								margin(0)
							}
					}
					.class("verify-mfa-error-container")
					.style {
						backgroundColor(rgba(255, 59, 48, 0.1))
						border(px(1), .solid, rgba(255, 59, 48, 0.2))
						borderRadius(borderRadiusBase)
						padding(spacing12)
						marginBottom(spacing24)
					}
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
							.class("verify-mfa-label")
							.style {
								fontFamily(typographyFontSans)
								fontSize(fontSizeXSmall12)
								fontWeight(.semiBold)
								textTransform(.uppercase)
								letterSpacing(px(0.5))
								marginBottom(spacing8)
								color(colorSubtle)
							}

						input()
							.type(.text)
							.name("code")
							.id("code")
							.placeholder("000000")
							.required(true)
							.class("verify-mfa-input")
							.style {
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
					}
					.class("verify-mfa-form-group")
					.style {
						display(.flex)
						flexDirection(.column)
						alignItems(.flexStart)
						marginBottom(spacing24)
					}

					button { "Verify & Login" }
						.type(.submit)
						.class("verify-mfa-button")
						.style {
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
							transition("background-color", ms(200))

							pseudoClass(.hover) {
								backgroundColor(colorMix(in: .srgb, colorProgressive, (hex(0x000000), perc(10))))
							}
						}
				}
				.method(.post)
				.action("/admin/mfa/verify")

				// Footer
				div {
					a { "Back to login" }
						.href("/admin/login")
						.class("verify-mfa-back-link")
						.style {
							fontFamily(typographyFontSans)
							fontSize(fontSizeSmall14)
							color(colorSubtle)
							textDecoration(.none)
						}
				}
				.class("verify-mfa-footer")
				.style {
					marginTop(spacing32)
					borderTop(borderWidthBase, borderStyleBase, borderColorBase)
					paddingTop(spacing24)
				}
			}
			.class("verify-mfa-card")
			.style {
				backgroundColor(backgroundColorBase)
				border(borderWidthBase, borderStyleBase, borderColorBase)
				borderRadius(borderRadiusBase)
				padding(spacing48)
				width(px(400))
				maxWidth(perc(100))
				boxShadow(boxShadowLarge)
				textAlign(.center)
			}
		}
		.class("verify-mfa-view")
		.style {
			display(.flex)
			justifyContent(.center)
			alignItems(.center)
			minHeight(vh(80))
			padding(spacing24)
		}
		.render(indent: indent)
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

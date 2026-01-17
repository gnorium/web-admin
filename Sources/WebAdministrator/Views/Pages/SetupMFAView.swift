#if !os(WASI)

import HTMLBuilder
import CSSBuilder
import DesignTokens
import WebComponents
import WebTypes

/// MFA Setup View with QR code for authenticator app configuration
/// Uses LayoutView for consistent admin panel structure
public struct SetupMFAView: HTML {
	public let secret: String
	public let otpauthURL: String
	public let accountName: String
	public let issuer: String

	public init(secret: String, otpauthURL: String, accountName: String, issuer: String = "Gnorium") {
		self.secret = secret
		self.otpauthURL = otpauthURL
		self.accountName = accountName
		self.issuer = issuer
	}

	public func render(indent: Int = 0) -> String {
		LayoutView(siteName: "Setup MFA", username: accountName) {
			div {
				setupCard
			}
			.class("setup-container")
			.data("otpauth-url", otpauthURL)
			.style {
				display(.flex)
				justifyContent(.center)
				alignItems(.center)
				padding(spacing32)
			}

			// QR Code library (hydrated by WASM)
			script()
				.src("https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js")
		}
		.render(indent: indent)
	}

	@HTMLBuilder
	private var setupCard: [HTML] {
		div {
			h1 { "Secure Your Account" }
				.style { titleCSS() }

			p { "Multi-factor authentication (MFA) adds an extra layer of security to your admin account." }
				.style { subtitleCSS() }

			setupContent
			setupFooter
		}
		.class("setup-card")
		.style { cardCSS() }
	}

	@HTMLBuilder
	private var setupContent: [HTML] {
		div {
			// QR Code and Instructions Grid
			div {
				// QR Code (generated client-side)
				div {
					div()
						.id("qrcode")
						.style { qrcodeCanvasCSS() }
				}
				.style { qrcodeContainerCSS() }

				// Instructions
				div {
					h3 { "Step 1: Scan QR Code" }
						.style { stepHeadingCSS() }
					p { "Open your authenticator app (Google Authenticator, 1Password, Authy) and scan this QR code." }
						.style { stepTextCSS() }

					h3 { "Step 2: Backup Secret" }
						.style { stepHeadingCSS() }
					p { "If you can't scan the QR code, enter this secret manually:" }
						.style { stepTextCSS() }

					// Secret display
					div {
						code { secret }
							.style { secretTextCSS() }
						button { "Copy" }
							.style { copyButtonCSS() }
					}
					.style { secretContainerCSS() }
				}
			}
			.style { gridCSS() }

			// Verification form
			div {
				form {
					input()
						.type(.hidden)
						.name("secret")
						.value(secret)

					label { "Verify Setup" }
						.for("code")
						.style { labelCSS() }

					p { "Enter the 6-digit code from your app to confirm setup:" }
						.style { verifyTextCSS() }

					div {
						input()
							.type(.text)
							.name("code")
							.id("code")
							.placeholder("000000")
							.required(true)
							.style { inputCSS() }
					}

					button { "Enable MFA" }
						.type(.submit)
						.style { enableButtonCSS() }
				}
				.method(.post)
				.action("/admin/mfa/setup")
			}
			.style { verifySectionCSS() }
		}
	}

	@HTMLBuilder
	private var setupFooter: [HTML] {
		div {
			a { "Cancel and return to dashboard" }
				.href("/admin")
				.style { cancelLinkCSS() }
		}
		.style { footerCSS() }
	}

	// MARK: - CSS Functions

	@CSSBuilder
	private func containerCSS() -> [CSS] {
		display(.flex)
		justifyContent(.center)
		alignItems(.center)
		minHeight(vh(90))
		padding(spacing48)
	}

	@CSSBuilder
	private func cardCSS() -> [CSS] {
		backgroundColor(backgroundColorBase)
		border(borderWidthBase, borderStyleBase, borderColorBase)
		borderRadius(borderRadiusBase)
		padding(spacing48)
		width(px(540))
		maxWidth(perc(100))
		boxShadow(boxShadowLarge)
	}

	@CSSBuilder
	private func titleCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		fontSize(px(32))
		fontWeight(600)
		color(colorBase)
		textAlign(.center)
		marginBottom(spacing8)
		letterSpacing(px(-0.5))
	}

	@CSSBuilder
	private func subtitleCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		fontSize(fontSizeMedium16)
		color(colorSubtle)
		textAlign(.center)
		marginBottom(spacing48)
	}

	@CSSBuilder
	private func gridCSS() -> [CSS] {
		display(.grid)
		gridTemplateColumns("240px 1fr")
		gap(spacing48)
		marginBottom(spacing48)
		alignItems(.flexStart)
	}

	@CSSBuilder
	private func qrcodeContainerCSS() -> [CSS] {
		backgroundColor(hex(0xFFFFFF))
		padding(spacing16)
		borderRadius(borderRadiusBase)
		boxShadow(px(0), px(2), px(10), px(0), rgba(0, 0, 0, 0.05))
		display(.flex)
		justifyContent(.center)
		alignItems(.center)
	}

	@CSSBuilder
	private func qrcodeCanvasCSS() -> [CSS] {
		width(px(200))
		height(px(200))
	}

	@CSSBuilder
	private func stepHeadingCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		fontSize(fontSizeMedium16)
		fontWeight(.semiBold)
		color(colorBase)
		marginBottom(spacing8)
		marginTop(spacing24)
	}

	@CSSBuilder
	private func stepTextCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		fontSize(fontSizeSmall14)
		lineHeight(1.5)
		color(colorSubtle)
		margin(0)
	}

	@CSSBuilder
	private func secretContainerCSS() -> [CSS] {
		display(.flex)
		alignItems(.center)
		backgroundColor(backgroundColorNeutralSubtle)
		padding(spacing8, spacing12)
		borderRadius(borderRadiusBase)
		marginTop(spacing12)
		border(borderWidthBase, borderStyleBase, borderColorBase)
	}

	@CSSBuilder
	private func secretTextCSS() -> [CSS] {
		fontFamily(typographyFontMono)
		fontSize(fontSizeSmall14)
		color(colorProgressive)
		flexGrow(1)
	}

	@CSSBuilder
	private func copyButtonCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		fontSize(fontSizeXSmall12)
		padding(spacing4, spacing8)
		backgroundColor(backgroundColorBase)
		border(borderWidthBase, borderStyleBase, borderColorBase)
		borderRadius(borderRadiusSharp)
		cursor(.pointer)
	}

	@CSSBuilder
	private func verifySectionCSS() -> [CSS] {
		borderTop(borderWidthBase, borderStyleBase, borderColorBase)
		paddingTop(spacing32)
	}

	@CSSBuilder
	private func labelCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		fontSize(fontSizeMedium16)
		fontWeight(.semiBold)
		color(colorBase)
		display(.block)
		marginBottom(spacing8)
	}

	@CSSBuilder
	private func verifyTextCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		fontSize(fontSizeSmall14)
		color(colorSubtle)
		marginBottom(spacing16)
	}

	@CSSBuilder
	private func inputCSS() -> [CSS] {
		fontFamily(typographyFontMono)
		width(px(200))
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
	private func enableButtonCSS() -> [CSS] {
		fontFamily(typographyFontSans)
		marginTop(spacing24)
		padding(spacing12, spacing32)
		backgroundColor(colorProgressive)
		color(hex(0xFFFFFF))
		border(.none)
		borderRadius(borderRadiusBase)
		fontSize(fontSizeMedium16)
		fontWeight(.semiBold)
		cursor(.pointer)
	}

	@CSSBuilder
	private func footerCSS() -> [CSS] {
		marginTop(spacing48)
		textAlign(.center)
	}

	@CSSBuilder
	private func cancelLinkCSS() -> [CSS] {
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

/// WASM Hydration for SetupMFAView
public class SetupMFAHydration: @unchecked Sendable {
	public init() {
		hydrate()
	}

	public func hydrate() {
		let container = document.querySelector(".setup-container")
		guard let otpauthURL = container?.dataset["otpauth-url"] else { return }
		
		let qrcodeElement = document.getElementById("qrcode")
		guard let element = qrcodeElement else { return }

		QRCode(element, text: otpauthURL)
	}
}

#endif

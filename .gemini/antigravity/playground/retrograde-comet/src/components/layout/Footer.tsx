"use client";

import Link from "next/link";
import { useLanguage } from "@/components/common/LanguageProvider";

const footerLinks = [
    { key: "services", href: "/services" },
    { key: "work", href: "/work" },
    { key: "about", href: "/about" },
    { key: "careers", href: "/careers" },
    { key: "blog", href: "/blog" },
    { key: "contact", href: "/contact" },
];

const socialLinks = [
    {
        name: "GitHub",
        href: "https://github.com/harmanlabs",
        icon: (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z" />
            </svg>
        ),
    },
    {
        name: "LinkedIn",
        href: "https://linkedin.com/company/harmanlabs",
        icon: (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433a2.062 2.062 0 01-2.063-2.065 2.064 2.064 0 112.063 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
            </svg>
        ),
    },
    {
        name: "Twitter",
        href: "https://twitter.com/harmanlabs",
        icon: (
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
            </svg>
        ),
    },
];

export function Footer() {
    const { t, locale } = useLanguage();

    return (
        <footer
            style={{
                borderTop: "1px solid var(--border-subtle)",
                padding: "var(--space-3xl) 0 var(--space-xl)",
            }}
        >
            <div className="container">
                {/* Main footer content */}
                <div
                    style={{
                        display: "grid",
                        gridTemplateColumns: "repeat(1, 1fr)",
                        gap: "var(--space-xl)",
                        marginBottom: "var(--space-3xl)",
                    }}
                    className="footer-grid"
                >
                    {/* Brand column */}
                    <div>
                        <Link
                            href="/"
                            style={{
                                fontSize: "1.5rem",
                                fontWeight: 700,
                                letterSpacing: "-0.02em",
                                color: "var(--text-primary)",
                                display: "inline-block",
                                marginBottom: "var(--space-md)",
                            }}
                        >
                            harman<span style={{ color: "var(--accent-cyan)" }}>.</span>labs
                        </Link>
                        <p
                            style={{
                                color: "var(--text-secondary)",
                                maxWidth: "280px",
                                marginBottom: "var(--space-lg)",
                            }}
                        >
                            {t("footer.tagline")}
                        </p>
                        {/* Social links */}
                        <div style={{ display: "flex", gap: "var(--space-md)" }}>
                            {socialLinks.map((social) => (
                                <a
                                    key={social.name}
                                    href={social.href}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="btn-ghost"
                                    aria-label={social.name}
                                    style={{
                                        width: "40px",
                                        height: "40px",
                                        display: "flex",
                                        alignItems: "center",
                                        justifyContent: "center",
                                        border: "1px solid var(--border-subtle)",
                                    }}
                                >
                                    {social.icon}
                                </a>
                            ))}
                        </div>
                    </div>

                    {/* Navigation column */}
                    <div>
                        <h4
                            style={{
                                fontSize: "0.75rem",
                                fontWeight: 600,
                                textTransform: "uppercase",
                                letterSpacing: "0.1em",
                                color: "var(--text-muted)",
                                marginBottom: "var(--space-lg)",
                            }}
                        >
                            {locale === "tr" ? "Sayfalar" : "Pages"}
                        </h4>
                        <nav
                            style={{
                                display: "flex",
                                flexDirection: "column",
                                gap: "var(--space-md)",
                            }}
                        >
                            {footerLinks.map((link) => (
                                <Link
                                    key={link.key}
                                    href={link.href}
                                    style={{
                                        color: "var(--text-secondary)",
                                        fontSize: "0.875rem",
                                    }}
                                >
                                    {t(`nav.${link.key}`)}
                                </Link>
                            ))}
                        </nav>
                    </div>

                    {/* Contact column */}
                    <div>
                        <h4
                            style={{
                                fontSize: "0.75rem",
                                fontWeight: 600,
                                textTransform: "uppercase",
                                letterSpacing: "0.1em",
                                color: "var(--text-muted)",
                                marginBottom: "var(--space-lg)",
                            }}
                        >
                            {t("contact.title")}
                        </h4>
                        <a
                            href={`mailto:${t("contact.email")}`}
                            style={{
                                color: "var(--accent-cyan)",
                                fontSize: "0.875rem",
                            }}
                        >
                            {t("contact.email")}
                        </a>
                    </div>

                    {/* Newsletter column */}
                    <div>
                        <h4
                            style={{
                                fontSize: "0.75rem",
                                fontWeight: 600,
                                textTransform: "uppercase",
                                letterSpacing: "0.1em",
                                color: "var(--text-muted)",
                                marginBottom: "var(--space-lg)",
                            }}
                        >
                            {t("footer.newsletter.title")}
                        </h4>
                        <form
                            onSubmit={(e) => e.preventDefault()}
                            style={{
                                display: "flex",
                                gap: "var(--space-sm)",
                            }}
                        >
                            <input
                                type="email"
                                placeholder={t("footer.newsletter.placeholder")}
                                className="input"
                                style={{
                                    flex: 1,
                                    padding: "0.75rem 1rem",
                                    fontSize: "0.875rem",
                                }}
                            />
                            <button
                                type="submit"
                                className="btn btn-primary"
                                style={{
                                    padding: "0.75rem 1rem",
                                    fontSize: "0.75rem",
                                }}
                            >
                                {t("footer.newsletter.subscribe")}
                            </button>
                        </form>
                    </div>
                </div>

                {/* Bottom bar */}
                <div
                    style={{
                        paddingTop: "var(--space-xl)",
                        borderTop: "1px solid var(--border-subtle)",
                        display: "flex",
                        flexDirection: "column",
                        alignItems: "center",
                        gap: "var(--space-md)",
                        textAlign: "center",
                    }}
                    className="footer-bottom"
                >
                    <p
                        style={{
                            color: "var(--text-muted)",
                            fontSize: "0.75rem",
                        }}
                    >
                        {t("footer.copyright")}
                    </p>
                </div>
            </div>

            <style jsx>{`
        @media (min-width: 768px) {
          .footer-grid {
            grid-template-columns: 2fr 1fr 1fr 2fr !important;
          }
          .footer-bottom {
            flex-direction: row !important;
            justify-content: center !important;
          }
        }
      `}</style>
        </footer>
    );
}

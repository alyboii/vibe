"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useLanguage } from "@/components/common/LanguageProvider";
import { useTheme } from "@/components/common/ThemeProvider";
import { useState, useEffect } from "react";

const navLinks = [
    { key: "services", href: "/services" },
    { key: "work", href: "/work" },
    { key: "about", href: "/about" },
    { key: "careers", href: "/careers" },
    { key: "blog", href: "/blog" },
    { key: "contact", href: "/contact" },
];

export function Header() {
    const { locale, setLocale, t } = useLanguage();
    const { theme, toggleTheme } = useTheme();
    const pathname = usePathname();
    const [isScrolled, setIsScrolled] = useState(false);
    const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

    useEffect(() => {
        const handleScroll = () => {
            setIsScrolled(window.scrollY > 20);
        };

        window.addEventListener("scroll", handleScroll, { passive: true });
        return () => window.removeEventListener("scroll", handleScroll);
    }, []);

    // Close mobile menu on route change
    useEffect(() => {
        setIsMobileMenuOpen(false);
    }, [pathname]);

    return (
        <header
            style={{
                position: "fixed",
                top: 0,
                left: 0,
                right: 0,
                height: "var(--header-height)",
                display: "flex",
                alignItems: "center",
                padding: "0 var(--space-lg)",
                backgroundColor: isScrolled
                    ? "rgba(0, 0, 0, 0.8)"
                    : "transparent",
                backdropFilter: isScrolled ? "blur(12px)" : "none",
                borderBottom: isScrolled
                    ? "1px solid var(--border-subtle)"
                    : "1px solid transparent",
                transition: "all var(--duration-normal) var(--ease-out)",
                zIndex: 100,
            }}
        >
            <div
                className="container"
                style={{
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                    width: "100%",
                    maxWidth: "var(--max-width)",
                    margin: "0 auto",
                }}
            >
                {/* Logo */}
                <Link
                    href="/"
                    style={{
                        fontSize: "1.25rem",
                        fontWeight: 700,
                        letterSpacing: "-0.02em",
                        color: "var(--text-primary)",
                    }}
                    aria-label="harman.labs ana sayfa"
                >
                    harman<span style={{ color: "var(--accent-cyan)" }}>.</span>labs
                </Link>

                {/* Desktop Navigation */}
                <nav
                    style={{
                        display: "none",
                        alignItems: "center",
                        gap: "var(--space-xl)",
                    }}
                    className="desktop-nav"
                    aria-label="Ana navigasyon"
                >
                    {navLinks.map((link) => (
                        <Link
                            key={link.key}
                            href={link.href}
                            style={{
                                fontSize: "0.875rem",
                                fontWeight: 500,
                                color:
                                    pathname === link.href
                                        ? "var(--accent-cyan)"
                                        : "var(--text-secondary)",
                                transition: "color var(--duration-fast) var(--ease-out)",
                            }}
                        >
                            {t(`nav.${link.key}`)}
                        </Link>
                    ))}
                </nav>

                {/* Controls */}
                <div style={{ display: "flex", alignItems: "center", gap: "var(--space-md)" }}>
                    {/* Language Toggle */}
                    <button
                        onClick={() => setLocale(locale === "tr" ? "en" : "tr")}
                        className="btn-ghost"
                        aria-label={`Dil değiştir: ${locale === "tr" ? "English" : "Türkçe"}`}
                        style={{
                            fontSize: "0.75rem",
                            fontWeight: 600,
                            textTransform: "uppercase",
                            letterSpacing: "0.05em",
                        }}
                    >
                        {locale === "tr" ? "EN" : "TR"}
                    </button>

                    {/* Theme Toggle */}
                    <button
                        onClick={toggleTheme}
                        className="btn-ghost"
                        aria-label={theme === "dark" ? "Açık temaya geç" : "Koyu temaya geç"}
                        style={{
                            width: "32px",
                            height: "32px",
                            display: "flex",
                            alignItems: "center",
                            justifyContent: "center",
                        }}
                    >
                        {theme === "dark" ? (
                            <svg
                                width="18"
                                height="18"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                strokeWidth="2"
                                aria-hidden="true"
                            >
                                <circle cx="12" cy="12" r="5" />
                                <path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42" />
                            </svg>
                        ) : (
                            <svg
                                width="18"
                                height="18"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                strokeWidth="2"
                                aria-hidden="true"
                            >
                                <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
                            </svg>
                        )}
                    </button>

                    {/* Mobile Menu Toggle */}
                    <button
                        onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
                        className="btn-ghost mobile-menu-btn"
                        aria-label={isMobileMenuOpen ? "Menüyü kapat" : "Menüyü aç"}
                        aria-expanded={isMobileMenuOpen}
                        style={{
                            width: "32px",
                            height: "32px",
                            display: "flex",
                            alignItems: "center",
                            justifyContent: "center",
                        }}
                    >
                        {isMobileMenuOpen ? (
                            <svg
                                width="20"
                                height="20"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                strokeWidth="2"
                                aria-hidden="true"
                            >
                                <path d="M18 6L6 18M6 6l12 12" />
                            </svg>
                        ) : (
                            <svg
                                width="20"
                                height="20"
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                strokeWidth="2"
                                aria-hidden="true"
                            >
                                <path d="M3 12h18M3 6h18M3 18h18" />
                            </svg>
                        )}
                    </button>
                </div>
            </div>

            {/* Mobile Menu */}
            <div
                style={{
                    position: "fixed",
                    top: "var(--header-height)",
                    left: 0,
                    right: 0,
                    bottom: 0,
                    backgroundColor: "var(--void-black)",
                    transform: isMobileMenuOpen ? "translateX(0)" : "translateX(100%)",
                    transition: "transform var(--duration-normal) var(--ease-out)",
                    padding: "var(--space-xl)",
                    display: "flex",
                    flexDirection: "column",
                    gap: "var(--space-lg)",
                    zIndex: 99,
                }}
                aria-hidden={!isMobileMenuOpen}
            >
                {navLinks.map((link) => (
                    <Link
                        key={link.key}
                        href={link.href}
                        style={{
                            fontSize: "1.5rem",
                            fontWeight: 600,
                            color:
                                pathname === link.href
                                    ? "var(--accent-cyan)"
                                    : "var(--text-primary)",
                        }}
                        tabIndex={isMobileMenuOpen ? 0 : -1}
                    >
                        {t(`nav.${link.key}`)}
                    </Link>
                ))}
            </div>

            <style jsx>{`
        @media (min-width: 768px) {
          .desktop-nav {
            display: flex !important;
          }
          .mobile-menu-btn {
            display: none !important;
          }
        }
      `}</style>
        </header>
    );
}

"use client";

import { BrandLogo } from "@/components/BrandLogo";
import { sounds } from "@/components/AudioPlayer";

export function Footer() {
    const currentTrack = sounds[0];

    return (
        <footer
            style={{
                backgroundColor: "#111",
                borderTop: "1px solid #222",
                padding: "2rem",
                color: "#888",
            }}
        >
            <div
                style={{
                    maxWidth: "1200px",
                    margin: "0 auto",
                    display: "flex",
                    flexDirection: "column",
                    gap: "1.5rem",
                }}
            >
                {/* Logo - Small Size */}
                <div>
                    <BrandLogo size="small" theme="dark" />
                </div>

                {/* Links and Credits */}
                <div
                    style={{
                        display: "grid",
                        gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
                        gap: "2rem",
                    }}
                >
                    {/* Navigation */}
                    <div>
                        <h4 style={{ color: "#fff", fontSize: "0.75rem", textTransform: "uppercase", letterSpacing: "0.1em", marginBottom: "1rem" }}>
                            Sayfalar
                        </h4>
                        <nav style={{ display: "flex", flexDirection: "column", gap: "0.5rem" }}>
                            <a href="/work" style={{ color: "#888", fontSize: "0.875rem", textDecoration: "none" }}>Products</a>
                            <a href="/contact" style={{ color: "#888", fontSize: "0.875rem", textDecoration: "none" }}>Contact</a>
                        </nav>
                    </div>

                    {/* Music Credits */}
                    <div>
                        <h4 style={{ color: "#fff", fontSize: "0.75rem", textTransform: "uppercase", letterSpacing: "0.1em", marginBottom: "1rem" }}>
                            🎵 Music Credits
                        </h4>
                        <div style={{ fontSize: "0.75rem", lineHeight: 1.6 }}>
                            <p style={{ margin: "0 0 0.5rem 0" }}>
                                <strong style={{ color: "#aaa" }}>{currentTrack.credits.title}</strong>
                                <br />
                                by {currentTrack.credits.author}
                            </p>
                            <p style={{ margin: "0 0 0.5rem 0" }}>
                                Source:{" "}
                                <a
                                    href={currentTrack.credits.source}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    style={{ color: "#FF6B00" }}
                                >
                                    Pixabay Music
                                </a>
                            </p>
                            <p style={{ margin: 0, color: "#666" }}>
                                {currentTrack.credits.license}
                            </p>
                        </div>
                    </div>

                    {/* Contact */}
                    <div>
                        <h4 style={{ color: "#fff", fontSize: "0.75rem", textTransform: "uppercase", letterSpacing: "0.1em", marginBottom: "1rem" }}>
                            İletişim
                        </h4>
                        <a
                            href="mailto:hello@harman.labs"
                            style={{ color: "#FF6B00", fontSize: "0.875rem", textDecoration: "none" }}
                        >
                            hello@harman.labs
                        </a>
                    </div>
                </div>

                {/* Copyright */}
                <div
                    style={{
                        borderTop: "1px solid #222",
                        paddingTop: "1.5rem",
                        fontSize: "0.75rem",
                        color: "#555",
                    }}
                >
                    © {new Date().getFullYear()} harman.labs. All rights reserved.
                </div>
            </div>
        </footer>
    );
}

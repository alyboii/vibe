"use client";

import { useEffect } from "react";
import Link from "next/link";
import Image from "next/image";
import { useParams, useRouter } from "next/navigation";
import { BrandLogo } from "@/components/BrandLogo";

// App data
const apps: Record<string, {
    name: string;
    tagline: string;
    description: string[];
    recipeTech: string[];
    screenshots: { src: string; alt: string }[];
    nextAppUrl: string | null;
    status: "available" | "coming-soon" | "sold-out";
}> = {
    "fake-it": {
        name: "FAKE IT",
        tagline: "iOS APP - COMING SOON",
        description: [
            "Fake It is an iOS app that lets you create realistic fake conversations, calls, and notifications. Perfect for pranks, content creation, or just having fun with friends.",
            "Create convincing fake chat screenshots with customizable contacts, messages, and timestamps. Schedule fake incoming calls with custom caller IDs and ringtones.",
            "All data stays on your device. No cloud sync, no tracking. Your fake conversations are your business.",
        ],
        recipeTech: [
            "Swift & SwiftUI",
            "Core Data",
            "AVFoundation",
            "CallKit Integration",
            "Local Notifications",
            "On-Device Processing",
        ],
        screenshots: [
            { src: "/screenshots/ss1.png", alt: "Fake It - Chat List" },
            { src: "/screenshots/ss2.png", alt: "Fake It - Fake Call" },
            { src: "/screenshots/ss3.png", alt: "Fake It - App Preview" },
        ],
        nextAppUrl: null,
        status: "coming-soon",
    },
};

export default function ProductDetailPage() {
    const params = useParams();
    const router = useRouter();
    const slug = params.slug as string;
    const app = apps[slug];

    // Keyboard navigation for next app
    useEffect(() => {
        const handleKeyDown = (e: KeyboardEvent) => {
            if (e.key === "ArrowRight" && app?.nextAppUrl) {
                router.push(app.nextAppUrl);
            }
        };
        window.addEventListener("keydown", handleKeyDown);
        return () => window.removeEventListener("keydown", handleKeyDown);
    }, [app?.nextAppUrl, router]);

    if (!app) {
        return (
            <div
                style={{
                    minHeight: "100vh",
                    backgroundColor: "#E8D5C4",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    flexDirection: "column",
                    gap: "1rem",
                }}
            >
                <h1 style={{ fontSize: "2rem", color: "#333" }}>App not found</h1>
                <Link href="/work" style={{ color: "#FF6B00" }}>
                    ← Back to Products
                </Link>
            </div>
        );
    }

    return (
        <div
            style={{
                minHeight: "100vh",
                background: "linear-gradient(180deg, #F5E6D3 0%, #E8D5C4 100%)",
            }}
        >
            {/* Header with Large Logo */}
            <header
                style={{
                    padding: "2.5rem 2rem",
                    display: "flex",
                    justifyContent: "center",
                }}
            >
                <BrandLogo size="hero" theme="light" />
            </header>

            {/* Main Content */}
            <main
                style={{
                    maxWidth: "1200px",
                    margin: "0 auto",
                    padding: "2rem",
                }}
            >
                <div
                    style={{
                        display: "grid",
                        gridTemplateColumns: "400px 3px 1fr",
                        gap: "2.5rem",
                        alignItems: "start",
                    }}
                    className="product-grid"
                >
                    {/* Left: Vertical Scrolling Gallery */}
                    <div
                        style={{
                            display: "flex",
                            flexDirection: "column",
                            gap: "1rem",
                        }}
                    >
                        {app.screenshots.map((screenshot, index) => (
                            <div
                                key={index}
                                style={{
                                    position: "relative",
                                    width: "100%",
                                    aspectRatio: "1",
                                    backgroundColor: "#C4956A",
                                    borderRadius: "4px",
                                    overflow: "hidden",
                                }}
                            >
                                <Image
                                    src={screenshot.src}
                                    alt={screenshot.alt}
                                    fill
                                    style={{ objectFit: "cover" }}
                                    priority={index === 0}
                                />
                            </div>
                        ))}
                    </div>

                    {/* Orange Accent Line */}
                    <div
                        style={{
                            backgroundColor: "#FF6B00",
                            height: "100%",
                            minHeight: "600px",
                            borderRadius: "2px",
                        }}
                        className="accent-line"
                    />

                    {/* Right: Content */}
                    <div style={{ display: "flex", flexDirection: "column", gap: "1.5rem" }}>
                        {/* Title */}
                        <h1
                            style={{
                                fontSize: "clamp(1.75rem, 4vw, 2.5rem)",
                                fontWeight: 800,
                                color: "#1a1a1a",
                                letterSpacing: "-0.02em",
                                margin: 0,
                            }}
                        >
                            {app.name}
                        </h1>

                        {/* Tagline */}
                        <p
                            style={{
                                fontSize: "0.875rem",
                                color: "#666",
                                textTransform: "uppercase",
                                letterSpacing: "0.1em",
                                margin: 0,
                            }}
                        >
                            {app.tagline}
                        </p>

                        {/* Description */}
                        <div style={{ display: "flex", flexDirection: "column", gap: "1rem" }}>
                            {app.description.map((para, i) => (
                                <p
                                    key={i}
                                    style={{
                                        fontSize: "0.9375rem",
                                        lineHeight: 1.7,
                                        color: "#444",
                                        margin: 0,
                                    }}
                                >
                                    {para}
                                </p>
                            ))}
                        </div>

                        {/* Recipe Section */}
                        <div
                            style={{
                                marginTop: "1rem",
                                padding: "1.5rem",
                                backgroundColor: "rgba(255,255,255,0.5)",
                                borderRadius: "8px",
                            }}
                        >
                            <h3
                                style={{
                                    fontSize: "1rem",
                                    fontWeight: 700,
                                    color: "#1a1a1a",
                                    marginBottom: "0.75rem",
                                }}
                            >
                                Recipe
                            </h3>
                            <p
                                style={{
                                    fontSize: "0.75rem",
                                    color: "#888",
                                    textTransform: "uppercase",
                                    letterSpacing: "0.1em",
                                    marginBottom: "0.5rem",
                                }}
                            >
                                Built with:
                            </p>
                            <ul
                                style={{
                                    listStyle: "none",
                                    padding: 0,
                                    margin: 0,
                                    display: "flex",
                                    flexWrap: "wrap",
                                    gap: "0.5rem",
                                }}
                            >
                                {app.recipeTech.map((tech, i) => (
                                    <li
                                        key={i}
                                        style={{
                                            fontSize: "0.8125rem",
                                            color: "#555",
                                            backgroundColor: "rgba(255,107,0,0.1)",
                                            padding: "0.25rem 0.75rem",
                                            borderRadius: "4px",
                                        }}
                                    >
                                        {tech}
                                    </li>
                                ))}
                            </ul>

                            {/* GitHub Link */}
                            <a
                                href="https://github.com/alyboii"
                                target="_blank"
                                rel="noopener noreferrer"
                                style={{
                                    display: "inline-flex",
                                    alignItems: "center",
                                    gap: "0.5rem",
                                    marginTop: "1rem",
                                    color: "#666",
                                    fontSize: "0.75rem",
                                    textDecoration: "none",
                                    transition: "color 0.2s",
                                }}
                            >
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M12 0C5.374 0 0 5.373 0 12c0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z" />
                                </svg>
                                <span>github.com/alyboii</span>
                            </a>
                        </div>

                        {/* Next App Link */}
                        {app.nextAppUrl && (
                            <Link
                                href={app.nextAppUrl}
                                style={{
                                    alignSelf: "flex-end",
                                    color: "#FF6B00",
                                    fontSize: "0.875rem",
                                    textDecoration: "none",
                                    display: "flex",
                                    alignItems: "center",
                                    gap: "0.25rem",
                                }}
                            >
                                Next Item →
                            </Link>
                        )}

                        {/* Action Buttons */}
                        <div
                            style={{
                                display: "flex",
                                gap: "1rem",
                                marginTop: "1rem",
                            }}
                        >
                            {app.status === "coming-soon" ? (
                                <button
                                    disabled
                                    style={{
                                        flex: 1,
                                        padding: "0.875rem 1.5rem",
                                        backgroundColor: "#FF6B00",
                                        opacity: 0.6,
                                        color: "#fff",
                                        border: "none",
                                        borderRadius: "4px",
                                        fontSize: "0.875rem",
                                        fontWeight: 600,
                                        cursor: "not-allowed",
                                    }}
                                >
                                    Coming Soon
                                </button>
                            ) : app.status === "sold-out" ? (
                                <button
                                    disabled
                                    style={{
                                        flex: 1,
                                        padding: "0.875rem 1.5rem",
                                        backgroundColor: "#ccc",
                                        color: "#fff",
                                        border: "none",
                                        borderRadius: "4px",
                                        fontSize: "0.875rem",
                                        fontWeight: 600,
                                        cursor: "not-allowed",
                                    }}
                                >
                                    Sold Out
                                </button>
                            ) : (
                                <button
                                    style={{
                                        flex: 1,
                                        padding: "0.875rem 1.5rem",
                                        backgroundColor: "#FF6B00",
                                        color: "#fff",
                                        border: "none",
                                        borderRadius: "4px",
                                        fontSize: "0.875rem",
                                        fontWeight: 600,
                                        cursor: "pointer",
                                    }}
                                >
                                    Download
                                </button>
                            )}
                            <Link
                                href="/work"
                                style={{
                                    flex: 1,
                                    padding: "0.875rem 1.5rem",
                                    backgroundColor: "transparent",
                                    color: "#FF6B00",
                                    border: "2px solid #FF6B00",
                                    borderRadius: "4px",
                                    fontSize: "0.875rem",
                                    fontWeight: 600,
                                    textAlign: "center",
                                    textDecoration: "none",
                                }}
                            >
                                Keep Shopping
                            </Link>
                        </div>
                    </div>
                </div>
            </main>

            <style jsx>{`
        @media (max-width: 768px) {
          .product-grid {
            grid-template-columns: 1fr !important;
            gap: 2rem !important;
          }
          .accent-line {
            display: none !important;
          }
        }
      `}</style>
        </div>
    );
}

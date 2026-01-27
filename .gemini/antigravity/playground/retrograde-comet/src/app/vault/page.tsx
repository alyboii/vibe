"use client";

import { useState, useEffect } from "react";
import { BrandLogo } from "@/components/BrandLogo";

// Change this password
const VAULT_PASSWORD = "harman2024";

interface VaultContent {
    title: string;
    content: string;
    type: "text" | "link" | "secret";
    url?: string;
}

const vaultContents: VaultContent[] = [
    {
        title: "🔮 Upcoming Projects",
        content: "Q2 2024: New AI-powered app launching. Codename: ORACLE",
        type: "text",
    },
    {
        title: "📱 Beta Access",
        content: "Get early access to Fake It beta",
        type: "link",
        url: "https://testflight.apple.com",
    },
    {
        title: "🎨 Design Files",
        content: "Figma source files for all projects",
        type: "link",
        url: "https://figma.com",
    },
    {
        title: "🤫 Secret Message",
        content: "If you found this, you're one of us. Welcome to harman.labs inner circle.",
        type: "secret",
    },
];

export default function VaultPage() {
    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const [password, setPassword] = useState("");
    const [error, setError] = useState("");
    const [shake, setShake] = useState(false);

    // Check for saved auth
    useEffect(() => {
        const saved = sessionStorage.getItem("vault-auth");
        if (saved === "true") {
            setIsAuthenticated(true);
        }
    }, []);

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        if (password === VAULT_PASSWORD) {
            setIsAuthenticated(true);
            sessionStorage.setItem("vault-auth", "true");
            setError("");
        } else {
            setError("Wrong password");
            setShake(true);
            setTimeout(() => setShake(false), 500);
            setPassword("");
        }
    };

    const handleLogout = () => {
        setIsAuthenticated(false);
        sessionStorage.removeItem("vault-auth");
        setPassword("");
    };

    // Login Screen
    if (!isAuthenticated) {
        return (
            <div
                style={{
                    minHeight: "100vh",
                    backgroundColor: "#0a0a0a",
                    display: "flex",
                    flexDirection: "column",
                    alignItems: "center",
                    justifyContent: "center",
                    padding: "2rem",
                }}
            >
                {/* Scanlines effect */}
                <div
                    style={{
                        position: "fixed",
                        inset: 0,
                        background: `repeating-linear-gradient(
              0deg,
              transparent,
              transparent 2px,
              rgba(0,0,0,0.1) 2px,
              rgba(0,0,0,0.1) 4px
            )`,
                        pointerEvents: "none",
                        zIndex: 10,
                    }}
                />

                <BrandLogo size="medium" theme="dark" />

                <div
                    style={{
                        marginTop: "3rem",
                        padding: "2rem",
                        backgroundColor: "#111",
                        border: "1px solid #222",
                        maxWidth: "400px",
                        width: "100%",
                    }}
                >
                    <h1
                        style={{
                            fontSize: "1.25rem",
                            color: "#FF6B00",
                            marginBottom: "0.5rem",
                            fontFamily: "monospace",
                        }}
                    >
                        🔐 VAULT ACCESS
                    </h1>
                    <p style={{ color: "#666", fontSize: "0.75rem", marginBottom: "1.5rem" }}>
                        This area is restricted. Enter password to continue.
                    </p>

                    <form onSubmit={handleSubmit}>
                        <input
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            placeholder="Enter password..."
                            style={{
                                width: "100%",
                                padding: "1rem",
                                backgroundColor: "#000",
                                border: `1px solid ${error ? "#ff4444" : "#333"}`,
                                color: "#fff",
                                fontSize: "1rem",
                                fontFamily: "monospace",
                                outline: "none",
                                marginBottom: "1rem",
                                animation: shake ? "shake 0.5s ease" : "none",
                            }}
                            autoFocus
                        />
                        {error && (
                            <p style={{ color: "#ff4444", fontSize: "0.75rem", marginBottom: "1rem" }}>
                                {error}
                            </p>
                        )}
                        <button
                            type="submit"
                            style={{
                                width: "100%",
                                padding: "1rem",
                                backgroundColor: "#FF6B00",
                                border: "none",
                                color: "#fff",
                                fontSize: "0.875rem",
                                fontWeight: 600,
                                cursor: "pointer",
                                textTransform: "uppercase",
                                letterSpacing: "0.1em",
                            }}
                        >
                            Access Vault
                        </button>
                    </form>
                </div>

                <style jsx global>{`
          @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            50% { transform: translateX(10px); }
            75% { transform: translateX(-10px); }
          }
        `}</style>
            </div>
        );
    }

    // Vault Content
    return (
        <div
            style={{
                minHeight: "100vh",
                backgroundColor: "#0a0a0a",
                padding: "2rem",
            }}
        >
            {/* Header */}
            <header
                style={{
                    maxWidth: "800px",
                    margin: "0 auto 3rem",
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                }}
            >
                <BrandLogo size="medium" theme="dark" />
                <button
                    onClick={handleLogout}
                    style={{
                        padding: "0.5rem 1rem",
                        backgroundColor: "transparent",
                        border: "1px solid #333",
                        color: "#666",
                        fontSize: "0.75rem",
                        cursor: "pointer",
                    }}
                >
                    Logout
                </button>
            </header>

            {/* Vault Content */}
            <main style={{ maxWidth: "800px", margin: "0 auto" }}>
                <h1
                    style={{
                        fontSize: "2rem",
                        color: "#FF6B00",
                        marginBottom: "0.5rem",
                        fontFamily: "monospace",
                    }}
                >
                    🔓 VAULT UNLOCKED
                </h1>
                <p style={{ color: "#666", marginBottom: "2rem" }}>
                    Welcome to the inner circle. Here&apos;s what&apos;s inside.
                </p>

                <div style={{ display: "flex", flexDirection: "column", gap: "1rem" }}>
                    {vaultContents.map((item, index) => (
                        <div
                            key={index}
                            style={{
                                padding: "1.5rem",
                                backgroundColor: "#111",
                                border: "1px solid #222",
                                borderLeft: `3px solid ${item.type === "secret" ? "#FF6B00" : "#333"}`,
                            }}
                        >
                            <h3
                                style={{
                                    fontSize: "1rem",
                                    color: "#fff",
                                    marginBottom: "0.5rem",
                                }}
                            >
                                {item.title}
                            </h3>
                            <p style={{ color: "#888", fontSize: "0.875rem", marginBottom: item.url ? "1rem" : 0 }}>
                                {item.content}
                            </p>
                            {item.url && (
                                <a
                                    href={item.url}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    style={{
                                        color: "#FF6B00",
                                        fontSize: "0.75rem",
                                        textDecoration: "none",
                                    }}
                                >
                                    Open Link →
                                </a>
                            )}
                        </div>
                    ))}
                </div>
            </main>
        </div>
    );
}

"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { BrandLogo } from "@/components/BrandLogo";

export default function NotFoundPage() {
    const [glitchText, setGlitchText] = useState("404");

    useEffect(() => {
        const chars = "!@#$%^&*()_+-=[]{}|;:,.<>?";
        let interval: NodeJS.Timeout;

        const glitch = () => {
            let iterations = 0;
            interval = setInterval(() => {
                setGlitchText(
                    "404"
                        .split("")
                        .map((char, index) => {
                            if (index < iterations) return "404"[index];
                            return chars[Math.floor(Math.random() * chars.length)];
                        })
                        .join("")
                );
                iterations += 1 / 3;
                if (iterations >= 4) {
                    clearInterval(interval);
                    setGlitchText("404");
                }
            }, 50);
        };

        glitch();
        const repeatInterval = setInterval(glitch, 3000);

        return () => {
            clearInterval(interval);
            clearInterval(repeatInterval);
        };
    }, []);

    return (
        <div
            style={{
                minHeight: "100vh",
                backgroundColor: "#000",
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                justifyContent: "center",
                padding: "2rem",
                position: "relative",
                overflow: "hidden",
            }}
        >
            {/* Background Grid */}
            <div
                style={{
                    position: "absolute",
                    inset: 0,
                    backgroundImage: `
            linear-gradient(rgba(255,107,0,0.03) 1px, transparent 1px),
            linear-gradient(90deg, rgba(255,107,0,0.03) 1px, transparent 1px)
          `,
                    backgroundSize: "50px 50px",
                    animation: "gridMove 20s linear infinite",
                }}
            />

            {/* Logo */}
            <div style={{ marginBottom: "2rem", position: "relative", zIndex: 1 }}>
                <BrandLogo size="medium" theme="dark" />
            </div>

            {/* Glitch 404 */}
            <h1
                style={{
                    fontSize: "clamp(6rem, 20vw, 12rem)",
                    fontWeight: 900,
                    color: "#FF6B00",
                    margin: 0,
                    position: "relative",
                    zIndex: 1,
                    textShadow: `
            2px 2px 0 #fff,
            -2px -2px 0 #00ffff,
            4px 4px 0 rgba(255,107,0,0.3)
          `,
                    fontFamily: "monospace",
                }}
            >
                {glitchText}
            </h1>

            {/* Message */}
            <p
                style={{
                    fontSize: "1.25rem",
                    color: "#666",
                    marginTop: "1rem",
                    marginBottom: "2rem",
                    textAlign: "center",
                    position: "relative",
                    zIndex: 1,
                }}
            >
                Kaybolmuş görünüyorsun...
            </p>

            {/* Actions */}
            <div
                style={{
                    display: "flex",
                    gap: "1rem",
                    flexWrap: "wrap",
                    justifyContent: "center",
                    position: "relative",
                    zIndex: 1,
                }}
            >
                <Link
                    href="/"
                    style={{
                        padding: "0.875rem 2rem",
                        backgroundColor: "#FF6B00",
                        color: "#fff",
                        textDecoration: "none",
                        fontSize: "0.875rem",
                        fontWeight: 600,
                        textTransform: "uppercase",
                        letterSpacing: "0.1em",
                        transition: "transform 0.2s, box-shadow 0.2s",
                    }}
                >
                    Ana Sayfa
                </Link>
                <Link
                    href="/work"
                    style={{
                        padding: "0.875rem 2rem",
                        backgroundColor: "transparent",
                        border: "1px solid #FF6B00",
                        color: "#FF6B00",
                        textDecoration: "none",
                        fontSize: "0.875rem",
                        fontWeight: 600,
                        textTransform: "uppercase",
                        letterSpacing: "0.1em",
                        transition: "transform 0.2s, box-shadow 0.2s",
                    }}
                >
                    Ürünler
                </Link>
            </div>

            {/* Floating particles */}
            <div style={{ position: "absolute", inset: 0, pointerEvents: "none", overflow: "hidden" }}>
                {[...Array(20)].map((_, i) => (
                    <div
                        key={i}
                        style={{
                            position: "absolute",
                            width: "4px",
                            height: "4px",
                            backgroundColor: "#FF6B00",
                            borderRadius: "50%",
                            opacity: 0.3,
                            left: `${Math.random() * 100}%`,
                            top: `${Math.random() * 100}%`,
                            animation: `floatParticle ${3 + Math.random() * 4}s ease-in-out infinite`,
                            animationDelay: `${Math.random() * 2}s`,
                        }}
                    />
                ))}
            </div>

            <style jsx global>{`
        @keyframes gridMove {
          0% { transform: translate(0, 0); }
          100% { transform: translate(50px, 50px); }
        }
        @keyframes floatParticle {
          0%, 100% { transform: translateY(0) scale(1); opacity: 0.3; }
          50% { transform: translateY(-30px) scale(1.5); opacity: 0.6; }
        }
      `}</style>
        </div>
    );
}

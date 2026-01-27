"use client";

import { useEffect, useState } from "react";
import Image from "next/image";

interface LoadingScreenProps {
    onComplete?: () => void;
    duration?: number;
}

export function LoadingScreen({ onComplete, duration = 2500 }: LoadingScreenProps) {
    const [progress, setProgress] = useState(0);
    const [fadeOut, setFadeOut] = useState(false);

    useEffect(() => {
        const interval = setInterval(() => {
            setProgress((prev) => {
                if (prev >= 100) {
                    clearInterval(interval);
                    return 100;
                }
                return prev + 2;
            });
        }, duration / 50);

        return () => clearInterval(interval);
    }, [duration]);

    useEffect(() => {
        if (progress >= 100) {
            setTimeout(() => {
                setFadeOut(true);
                setTimeout(() => {
                    onComplete?.();
                }, 500);
            }, 300);
        }
    }, [progress, onComplete]);

    return (
        <div
            style={{
                position: "fixed",
                inset: 0,
                backgroundColor: "#000",
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                justifyContent: "center",
                zIndex: 9999,
                opacity: fadeOut ? 0 : 1,
                transition: "opacity 0.5s ease",
                pointerEvents: fadeOut ? "none" : "auto",
            }}
        >
            {/* Animated Logo */}
            <div
                style={{
                    animation: "pulse 1.5s ease-in-out infinite, float 3s ease-in-out infinite",
                    marginBottom: "3rem",
                }}
            >
                <Image
                    src="/brand/harman-labs-logo.png"
                    alt="harman.labs"
                    width={300}
                    height={120}
                    style={{
                        width: "auto",
                        height: "auto",
                        maxWidth: "80vw",
                        filter: "drop-shadow(0 0 30px rgba(255,107,0,0.5))",
                    }}
                    priority
                />
            </div>

            {/* Progress Bar */}
            <div
                style={{
                    width: "200px",
                    height: "3px",
                    backgroundColor: "#333",
                    borderRadius: "2px",
                    overflow: "hidden",
                }}
            >
                <div
                    style={{
                        width: `${progress}%`,
                        height: "100%",
                        backgroundColor: "#FF6B00",
                        transition: "width 0.1s ease",
                        boxShadow: "0 0 10px #FF6B00",
                    }}
                />
            </div>

            {/* Loading Text */}
            <p
                style={{
                    marginTop: "1rem",
                    color: "#666",
                    fontSize: "0.75rem",
                    letterSpacing: "0.2em",
                    textTransform: "uppercase",
                }}
            >
                Loading...
            </p>

            <style jsx global>{`
        @keyframes pulse {
          0%, 100% { transform: scale(1); opacity: 1; }
          50% { transform: scale(1.05); opacity: 0.8; }
        }
        @keyframes float {
          0%, 100% { transform: translateY(0); }
          50% { transform: translateY(-10px); }
        }
      `}</style>
        </div>
    );
}

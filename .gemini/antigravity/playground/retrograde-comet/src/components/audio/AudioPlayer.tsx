"use client";

import { useAudioStore } from "@/stores/audio-store";
import { useEffect, useState } from "react";

export function AudioPlayer() {
    const {
        isPlaying,
        isMuted,
        volume,
        hasInteracted,
        togglePlay,
        toggleMute,
        setVolume,
    } = useAudioStore();

    const [mounted, setMounted] = useState(false);
    const [showVolumeSlider, setShowVolumeSlider] = useState(false);

    useEffect(() => {
        setMounted(true);
    }, []);

    // Keyboard controls
    useEffect(() => {
        const handleKeyDown = (e: KeyboardEvent) => {
            // Only trigger if not typing in an input
            if (
                e.target instanceof HTMLInputElement ||
                e.target instanceof HTMLTextAreaElement
            ) {
                return;
            }

            if (e.code === "Space" && e.shiftKey) {
                e.preventDefault();
                togglePlay();
            } else if (e.code === "KeyM" && e.shiftKey) {
                e.preventDefault();
                toggleMute();
            }
        };

        window.addEventListener("keydown", handleKeyDown);
        return () => window.removeEventListener("keydown", handleKeyDown);
    }, [togglePlay, toggleMute]);

    if (!mounted) return null;

    // Don't show player until user has interacted
    if (!hasInteracted) return null;

    return (
        <div
            className="audio-player"
            role="region"
            aria-label="Müzik çalar"
            style={{
                position: "fixed",
                bottom: "24px",
                right: "24px",
                display: "flex",
                alignItems: "center",
                gap: "12px",
                padding: "12px 16px",
                backgroundColor: "var(--surface-elevated)",
                border: "1px solid var(--border-subtle)",
                zIndex: 50,
            }}
            onMouseEnter={() => setShowVolumeSlider(true)}
            onMouseLeave={() => setShowVolumeSlider(false)}
        >
            {/* Equalizer */}
            <div
                className="equalizer"
                aria-hidden="true"
                style={{
                    display: "flex",
                    alignItems: "flex-end",
                    gap: "2px",
                    height: "20px",
                }}
            >
                {isPlaying && !isMuted ? (
                    <>
                        <div className="equalizer-bar" />
                        <div className="equalizer-bar" />
                        <div className="equalizer-bar" />
                    </>
                ) : (
                    <>
                        <div
                            style={{
                                width: "3px",
                                height: "4px",
                                backgroundColor: "var(--text-muted)",
                                borderRadius: "1px",
                            }}
                        />
                        <div
                            style={{
                                width: "3px",
                                height: "8px",
                                backgroundColor: "var(--text-muted)",
                                borderRadius: "1px",
                            }}
                        />
                        <div
                            style={{
                                width: "3px",
                                height: "4px",
                                backgroundColor: "var(--text-muted)",
                                borderRadius: "1px",
                            }}
                        />
                    </>
                )}
            </div>

            {/* Track label */}
            <span
                className="text-mono"
                style={{
                    color: isPlaying ? "var(--text-secondary)" : "var(--text-muted)",
                    fontSize: "0.75rem",
                    minWidth: "60px",
                }}
            >
                ambient
            </span>

            {/* Play/Pause button */}
            <button
                onClick={togglePlay}
                className="btn-ghost"
                aria-label={isPlaying ? "Duraklat" : "Oynat"}
                style={{
                    width: "32px",
                    height: "32px",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                }}
            >
                {isPlaying ? (
                    <svg
                        width="16"
                        height="16"
                        viewBox="0 0 16 16"
                        fill="currentColor"
                        aria-hidden="true"
                    >
                        <rect x="3" y="2" width="4" height="12" />
                        <rect x="9" y="2" width="4" height="12" />
                    </svg>
                ) : (
                    <svg
                        width="16"
                        height="16"
                        viewBox="0 0 16 16"
                        fill="currentColor"
                        aria-hidden="true"
                    >
                        <polygon points="3,2 13,8 3,14" />
                    </svg>
                )}
            </button>

            {/* Mute/Unmute button */}
            <button
                onClick={toggleMute}
                className="btn-ghost"
                aria-label={isMuted ? "Sesi aç" : "Sesi kapat"}
                style={{
                    width: "32px",
                    height: "32px",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                }}
            >
                {isMuted ? (
                    <svg
                        width="16"
                        height="16"
                        viewBox="0 0 16 16"
                        fill="currentColor"
                        aria-hidden="true"
                    >
                        <path d="M8 2L4 5H1v6h3l4 3V2z" />
                        <line
                            x1="12"
                            y1="5"
                            x2="15"
                            y2="11"
                            stroke="currentColor"
                            strokeWidth="1.5"
                        />
                        <line
                            x1="15"
                            y1="5"
                            x2="12"
                            y2="11"
                            stroke="currentColor"
                            strokeWidth="1.5"
                        />
                    </svg>
                ) : (
                    <svg
                        width="16"
                        height="16"
                        viewBox="0 0 16 16"
                        fill="currentColor"
                        aria-hidden="true"
                    >
                        <path d="M8 2L4 5H1v6h3l4 3V2z" />
                        <path
                            d="M11 5.5c1 0.8 1.5 1.8 1.5 2.5s-0.5 1.7-1.5 2.5"
                            fill="none"
                            stroke="currentColor"
                            strokeWidth="1.5"
                        />
                    </svg>
                )}
            </button>

            {/* Volume slider */}
            <div
                style={{
                    overflow: "hidden",
                    width: showVolumeSlider ? "80px" : "0",
                    transition: "width 200ms ease-out",
                }}
            >
                <input
                    type="range"
                    min="0"
                    max="1"
                    step="0.01"
                    value={volume}
                    onChange={(e) => setVolume(parseFloat(e.target.value))}
                    aria-label="Ses seviyesi"
                    style={{
                        width: "80px",
                        height: "4px",
                        appearance: "none",
                        background: `linear-gradient(to right, var(--accent-cyan) ${volume * 100}%, var(--border-subtle) ${volume * 100}%)`,
                        cursor: "pointer",
                    }}
                />
            </div>

            {/* Keyboard hints */}
            <span className="sr-only">
                Klavye kısayolları: Shift+Boşluk ile oynat/duraklat, Shift+M ile sesi
                aç/kapat
            </span>
        </div>
    );
}

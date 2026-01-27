"use client";

import { useState, useEffect, useRef, useCallback } from "react";

const STORAGE_KEY = "harman-audio-prefs";

interface AudioPrefs {
    volume: number;
    isMuted: boolean;
    currentSoundId: string;
}

const sounds = [
    {
        id: "chill",
        name: "Chill Vibes",
        src: "/audio/bg.mp3",
        credits: {
            title: "Chill Abstract",
            author: "Coma-Media",
            source: "https://pixabay.com/music/",
            license: "Pixabay License - Free for commercial use"
        }
    },
    {
        id: "ocean",
        name: "Okyanus",
        src: "https://cdn.pixabay.com/audio/2022/05/31/audio_9bf8f5bf0d.mp3",
        credits: {
            title: "Ocean Waves",
            author: "Pixabay",
            source: "https://pixabay.com/sound-effects/",
            license: "Pixabay License - Free for commercial use"
        }
    },
    {
        id: "rain",
        name: "Yağmur",
        src: "https://cdn.pixabay.com/audio/2022/10/30/audio_4e3db93b39.mp3",
        credits: {
            title: "Rain Sounds",
            author: "Pixabay",
            source: "https://pixabay.com/sound-effects/",
            license: "Pixabay License - Free for commercial use"
        }
    },
];

export function AudioPlayer() {
    const [isPlaying, setIsPlaying] = useState(false);
    const [currentSound, setCurrentSound] = useState(sounds[0]);
    const [volume, setVolume] = useState(0.2);
    const [isMuted, setIsMuted] = useState(false);
    const [showPlayer, setShowPlayer] = useState(false);
    const [hasInteracted, setHasInteracted] = useState(false);
    const audioRef = useRef<HTMLAudioElement | null>(null);

    // Load preferences from localStorage
    useEffect(() => {
        if (typeof window !== "undefined") {
            const saved = localStorage.getItem(STORAGE_KEY);
            if (saved) {
                try {
                    const prefs: AudioPrefs = JSON.parse(saved);
                    setVolume(prefs.volume);
                    setIsMuted(prefs.isMuted);
                    const found = sounds.find((s) => s.id === prefs.currentSoundId);
                    if (found) setCurrentSound(found);
                } catch { }
            }
        }
    }, []);

    // Save preferences to localStorage
    const savePrefs = useCallback(() => {
        if (typeof window !== "undefined") {
            const prefs: AudioPrefs = {
                volume,
                isMuted,
                currentSoundId: currentSound.id,
            };
            localStorage.setItem(STORAGE_KEY, JSON.stringify(prefs));
        }
    }, [volume, isMuted, currentSound]);

    useEffect(() => {
        savePrefs();
    }, [savePrefs]);

    // Update audio volume
    useEffect(() => {
        if (audioRef.current) {
            audioRef.current.volume = isMuted ? 0 : volume;
        }
    }, [volume, isMuted]);

    // First interaction listener
    useEffect(() => {
        const handleInteraction = () => {
            if (!hasInteracted) {
                setHasInteracted(true);
            }
        };

        window.addEventListener("click", handleInteraction, { once: true });
        window.addEventListener("scroll", handleInteraction, { once: true });
        window.addEventListener("touchstart", handleInteraction, { once: true });

        return () => {
            window.removeEventListener("click", handleInteraction);
            window.removeEventListener("scroll", handleInteraction);
            window.removeEventListener("touchstart", handleInteraction);
        };
    }, [hasInteracted]);

    const togglePlay = () => {
        if (!audioRef.current) {
            audioRef.current = new Audio(currentSound.src);
            audioRef.current.loop = true;
            audioRef.current.volume = isMuted ? 0 : volume;
        }

        if (isPlaying) {
            audioRef.current.pause();
            setIsPlaying(false);
        } else {
            audioRef.current.play().catch(() => { });
            setIsPlaying(true);
            setShowPlayer(true);
        }
    };

    const toggleMute = () => {
        setIsMuted(!isMuted);
    };

    const changeSound = (sound: typeof sounds[0]) => {
        setCurrentSound(sound);
        if (audioRef.current) {
            const wasPlaying = isPlaying;
            audioRef.current.pause();
            audioRef.current.src = sound.src;
            if (wasPlaying) {
                audioRef.current.play().catch(() => { });
            }
        }
    };

    const handleVolumeChange = (newVolume: number) => {
        setVolume(newVolume);
        if (newVolume > 0 && isMuted) {
            setIsMuted(false);
        }
    };

    return (
        <>
            {/* Sound Toggle Button */}
            <button
                onClick={togglePlay}
                style={{
                    position: "fixed",
                    bottom: "2rem",
                    right: "2rem",
                    width: "50px",
                    height: "50px",
                    borderRadius: "50%",
                    backgroundColor: isPlaying ? "#FF6B00" : "rgba(0,0,0,0.8)",
                    border: "2px solid #fff",
                    color: "#fff",
                    cursor: "pointer",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    fontSize: "1.25rem",
                    zIndex: 1000,
                    boxShadow: "0 4px 12px rgba(0,0,0,0.3)",
                    transition: "all 0.2s ease",
                }}
                title={isPlaying ? "Pause" : "Play Music"}
                aria-label={isPlaying ? "Pause background music" : "Play background music"}
            >
                {isPlaying ? "⏸" : "▶"}
            </button>

            {/* Mini Player Panel */}
            {showPlayer && (
                <div
                    style={{
                        position: "fixed",
                        bottom: "6rem",
                        right: "2rem",
                        backgroundColor: "rgba(0,0,0,0.95)",
                        padding: "1.25rem",
                        borderRadius: "12px",
                        zIndex: 1000,
                        minWidth: "220px",
                        boxShadow: "0 8px 32px rgba(0,0,0,0.4)",
                        border: "1px solid rgba(255,255,255,0.1)",
                    }}
                >
                    {/* Header */}
                    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "1rem" }}>
                        <span style={{ color: "#fff", fontWeight: 600, fontSize: "0.875rem" }}>🎵 Music</span>
                        <button
                            onClick={() => setShowPlayer(false)}
                            style={{ background: "none", border: "none", color: "#888", cursor: "pointer", fontSize: "1.25rem", padding: 0 }}
                            aria-label="Close player"
                        >
                            ×
                        </button>
                    </div>

                    {/* Sound Options */}
                    <div style={{ display: "flex", flexDirection: "column", gap: "0.5rem", marginBottom: "1rem" }}>
                        {sounds.map((sound) => (
                            <button
                                key={sound.id}
                                onClick={() => changeSound(sound)}
                                style={{
                                    padding: "0.5rem 0.75rem",
                                    backgroundColor: currentSound.id === sound.id ? "#FF6B00" : "#333",
                                    border: "none",
                                    borderRadius: "6px",
                                    color: "#fff",
                                    cursor: "pointer",
                                    fontSize: "0.8rem",
                                    textAlign: "left",
                                    transition: "background-color 0.2s",
                                }}
                            >
                                {currentSound.id === sound.id && isPlaying ? "▶ " : ""}{sound.name}
                            </button>
                        ))}
                    </div>

                    {/* Volume Control */}
                    <div style={{ marginBottom: "0.75rem" }}>
                        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "0.5rem" }}>
                            <label style={{ color: "#aaa", fontSize: "0.75rem" }}>
                                Volume: {Math.round(volume * 100)}%
                            </label>
                            <button
                                onClick={toggleMute}
                                style={{
                                    background: "none",
                                    border: "none",
                                    color: isMuted ? "#FF6B00" : "#aaa",
                                    cursor: "pointer",
                                    fontSize: "1rem",
                                    padding: 0,
                                }}
                                aria-label={isMuted ? "Unmute" : "Mute"}
                            >
                                {isMuted ? "🔇" : "🔊"}
                            </button>
                        </div>
                        <input
                            type="range"
                            min="0"
                            max="1"
                            step="0.05"
                            value={volume}
                            onChange={(e) => handleVolumeChange(parseFloat(e.target.value))}
                            style={{ width: "100%", cursor: "pointer", accentColor: "#FF6B00" }}
                            aria-label="Volume slider"
                        />
                    </div>

                    {/* Credits */}
                    <div style={{ borderTop: "1px solid #333", paddingTop: "0.75rem" }}>
                        <p style={{ color: "#666", fontSize: "0.65rem", margin: 0 }}>
                            🎵 {currentSound.credits.title} by {currentSound.credits.author}
                        </p>
                        <p style={{ color: "#555", fontSize: "0.6rem", margin: "0.25rem 0 0 0" }}>
                            {currentSound.credits.license}
                        </p>
                    </div>
                </div>
            )}
        </>
    );
}

// Export sounds for use in footer credits
export { sounds };

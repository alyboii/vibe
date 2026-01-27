"use client";

import { createContext, useContext, useRef, useEffect, ReactNode } from "react";
import { useAudioStore } from "@/stores/audio-store";

interface AudioContextType {
    audioRef: React.RefObject<HTMLAudioElement | null>;
}

const AudioContext = createContext<AudioContextType | undefined>(undefined);

export function AudioProvider({ children }: { children: ReactNode }) {
    const audioRef = useRef<HTMLAudioElement | null>(null);
    const { isPlaying, isMuted, volume, hasInteracted, markInteracted, play, pause } =
        useAudioStore();

    // Initialize audio on mount
    useEffect(() => {
        if (!audioRef.current) {
            audioRef.current = new Audio("/audio/ambient-track.mp3");
            audioRef.current.loop = true;
            audioRef.current.volume = volume;
            audioRef.current.muted = isMuted;
        }

        return () => {
            if (audioRef.current) {
                audioRef.current.pause();
                audioRef.current = null;
            }
        };
    }, []);

    // Sync volume and muted state
    useEffect(() => {
        if (audioRef.current) {
            audioRef.current.volume = volume;
            audioRef.current.muted = isMuted;
        }
    }, [volume, isMuted]);

    // Handle play/pause
    useEffect(() => {
        if (audioRef.current) {
            if (isPlaying && hasInteracted && !isMuted) {
                audioRef.current.play().catch(() => {
                    // Browser blocked autoplay, that's expected
                    pause();
                });
            } else {
                audioRef.current.pause();
            }
        }
    }, [isPlaying, hasInteracted, isMuted, pause]);

    // Handle first interaction to enable audio
    useEffect(() => {
        const handleFirstInteraction = () => {
            if (!hasInteracted) {
                markInteracted();
            }
        };

        const events = ["click", "touchstart", "keydown", "scroll"];
        events.forEach((event) => {
            window.addEventListener(event, handleFirstInteraction, { once: false, passive: true });
        });

        return () => {
            events.forEach((event) => {
                window.removeEventListener(event, handleFirstInteraction);
            });
        };
    }, [hasInteracted, markInteracted]);

    // Auto-play on first interaction if user hasn't muted before
    useEffect(() => {
        const store = useAudioStore.getState();
        if (hasInteracted && !store.hasUserMutedOnce && !isPlaying) {
            play();
        }
    }, [hasInteracted, isPlaying, play]);

    return (
        <AudioContext.Provider value={{ audioRef }}>
            {children}
        </AudioContext.Provider>
    );
}

export function useAudio() {
    const context = useContext(AudioContext);
    if (context === undefined) {
        throw new Error("useAudio must be used within an AudioProvider");
    }
    return context;
}

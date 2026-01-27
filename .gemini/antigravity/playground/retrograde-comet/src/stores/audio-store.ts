import { create } from "zustand";
import { persist, createJSONStorage } from "zustand/middleware";

export interface AudioState {
    isPlaying: boolean;
    isMuted: boolean;
    volume: number;
    hasInteracted: boolean;
    hasUserMutedOnce: boolean;
}

export interface AudioActions {
    play: () => void;
    pause: () => void;
    togglePlay: () => void;
    mute: () => void;
    unmute: () => void;
    toggleMute: () => void;
    setVolume: (volume: number) => void;
    markInteracted: () => void;
}

export type AudioStore = AudioState & AudioActions;

const initialState: AudioState = {
    isPlaying: false,
    isMuted: false,
    volume: 0.2, // 20% default
    hasInteracted: false,
    hasUserMutedOnce: false,
};

export const useAudioStore = create<AudioStore>()(
    persist(
        (set, get) => ({
            ...initialState,

            play: () => {
                const { hasInteracted, hasUserMutedOnce } = get();
                if (hasInteracted && !hasUserMutedOnce) {
                    set({ isPlaying: true });
                } else if (hasInteracted) {
                    // User has muted before, only play if they explicitly hit play
                    set({ isPlaying: true, hasUserMutedOnce: false });
                }
            },

            pause: () => set({ isPlaying: false }),

            togglePlay: () => {
                const { isPlaying, hasInteracted } = get();
                if (!hasInteracted) return;

                if (isPlaying) {
                    set({ isPlaying: false });
                } else {
                    set({ isPlaying: true, hasUserMutedOnce: false });
                }
            },

            mute: () => set({ isMuted: true, hasUserMutedOnce: true, isPlaying: false }),

            unmute: () => set({ isMuted: false }),

            toggleMute: () => {
                const { isMuted } = get();
                if (isMuted) {
                    set({ isMuted: false });
                } else {
                    set({ isMuted: true, hasUserMutedOnce: true, isPlaying: false });
                }
            },

            setVolume: (volume: number) => {
                const clampedVolume = Math.max(0, Math.min(1, volume));
                set({ volume: clampedVolume });
            },

            markInteracted: () => {
                const { hasInteracted } = get();
                if (!hasInteracted) {
                    set({ hasInteracted: true });
                }
            },
        }),
        {
            name: "harman-labs-audio",
            storage: createJSONStorage(() => {
                if (typeof window !== "undefined") {
                    return localStorage;
                }
                // Return a no-op storage for SSR
                return {
                    getItem: () => null,
                    setItem: () => { },
                    removeItem: () => { },
                };
            }),
            partialize: (state) => ({
                isMuted: state.isMuted,
                volume: state.volume,
                hasInteracted: state.hasInteracted,
                hasUserMutedOnce: state.hasUserMutedOnce,
            }),
        }
    )
);

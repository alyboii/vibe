import { describe, it, expect, beforeEach } from "vitest";
import { useAudioStore, AudioState } from "@/stores/audio-store";

describe("Audio Store", () => {
    beforeEach(() => {
        // Reset the store before each test
        useAudioStore.setState({
            isPlaying: false,
            isMuted: false,
            volume: 0.2,
            hasInteracted: false,
            hasUserMutedOnce: false,
        });
    });

    describe("Initial State", () => {
        it("should have correct initial values", () => {
            const state = useAudioStore.getState();
            expect(state.isPlaying).toBe(false);
            expect(state.isMuted).toBe(false);
            expect(state.volume).toBe(0.2);
            expect(state.hasInteracted).toBe(false);
            expect(state.hasUserMutedOnce).toBe(false);
        });
    });

    describe("markInteracted", () => {
        it("should set hasInteracted to true", () => {
            const { markInteracted } = useAudioStore.getState();
            markInteracted();
            expect(useAudioStore.getState().hasInteracted).toBe(true);
        });

        it("should not change if already interacted", () => {
            useAudioStore.setState({ hasInteracted: true });
            const { markInteracted } = useAudioStore.getState();
            markInteracted();
            expect(useAudioStore.getState().hasInteracted).toBe(true);
        });
    });

    describe("play/pause", () => {
        it("should not play if user has not interacted", () => {
            const { play } = useAudioStore.getState();
            play();
            expect(useAudioStore.getState().isPlaying).toBe(false);
        });

        it("should play after interaction", () => {
            useAudioStore.setState({ hasInteracted: true });
            const { play } = useAudioStore.getState();
            play();
            expect(useAudioStore.getState().isPlaying).toBe(true);
        });

        it("should pause when pause is called", () => {
            useAudioStore.setState({ hasInteracted: true, isPlaying: true });
            const { pause } = useAudioStore.getState();
            pause();
            expect(useAudioStore.getState().isPlaying).toBe(false);
        });

        it("should toggle play state", () => {
            useAudioStore.setState({ hasInteracted: true, isPlaying: false });
            const { togglePlay } = useAudioStore.getState();
            togglePlay();
            expect(useAudioStore.getState().isPlaying).toBe(true);
            togglePlay();
            expect(useAudioStore.getState().isPlaying).toBe(false);
        });
    });

    describe("mute/unmute", () => {
        it("should mute and set hasUserMutedOnce", () => {
            const { mute } = useAudioStore.getState();
            mute();
            const state = useAudioStore.getState();
            expect(state.isMuted).toBe(true);
            expect(state.hasUserMutedOnce).toBe(true);
            expect(state.isPlaying).toBe(false);
        });

        it("should unmute", () => {
            useAudioStore.setState({ isMuted: true });
            const { unmute } = useAudioStore.getState();
            unmute();
            expect(useAudioStore.getState().isMuted).toBe(false);
        });

        it("should toggle mute state", () => {
            const { toggleMute } = useAudioStore.getState();
            toggleMute();
            expect(useAudioStore.getState().isMuted).toBe(true);
            toggleMute();
            expect(useAudioStore.getState().isMuted).toBe(false);
        });
    });

    describe("volume", () => {
        it("should set volume correctly", () => {
            const { setVolume } = useAudioStore.getState();
            setVolume(0.5);
            expect(useAudioStore.getState().volume).toBe(0.5);
        });

        it("should clamp volume to 0-1 range", () => {
            const { setVolume } = useAudioStore.getState();
            setVolume(1.5);
            expect(useAudioStore.getState().volume).toBe(1);
            setVolume(-0.5);
            expect(useAudioStore.getState().volume).toBe(0);
        });
    });

    describe("hasUserMutedOnce behavior", () => {
        it("should reset hasUserMutedOnce when user explicitly plays", () => {
            useAudioStore.setState({ hasInteracted: true, hasUserMutedOnce: true });
            const { togglePlay } = useAudioStore.getState();
            togglePlay();
            expect(useAudioStore.getState().hasUserMutedOnce).toBe(false);
        });
    });
});

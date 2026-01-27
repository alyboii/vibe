import "@testing-library/jest-dom";

// Mock localStorage
const localStorageMock = {
    getItem: vi.fn(),
    setItem: vi.fn(),
    removeItem: vi.fn(),
    clear: vi.fn(),
};
Object.defineProperty(window, "localStorage", { value: localStorageMock });

// Mock Audio
class MockAudio {
    src = "";
    loop = false;
    volume = 1;
    muted = false;
    play = vi.fn(() => Promise.resolve());
    pause = vi.fn();
}
global.Audio = MockAudio as unknown as typeof Audio;

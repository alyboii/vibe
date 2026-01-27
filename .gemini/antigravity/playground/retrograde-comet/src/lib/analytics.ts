// Analytics placeholder - replace with your preferred analytics provider
// Examples: Plausible, Fathom, PostHog, or custom

export interface AnalyticsEvent {
    name: string;
    properties?: Record<string, unknown>;
}

export function trackEvent(event: AnalyticsEvent): void {
    // In development, log to console
    if (process.env.NODE_ENV === "development") {
        console.log("[Analytics]", event.name, event.properties);
        return;
    }

    // In production, send to your analytics provider
    // Example with a generic analytics endpoint:
    // fetch('/api/analytics', {
    //   method: 'POST',
    //   headers: { 'Content-Type': 'application/json' },
    //   body: JSON.stringify(event),
    // });
}

export function trackPageView(path: string): void {
    trackEvent({
        name: "page_view",
        properties: { path },
    });
}

// Common events
export const analytics = {
    contactFormSubmit: () => trackEvent({ name: "contact_form_submit" }),
    careerApply: (position: string) => trackEvent({ name: "career_apply", properties: { position } }),
    languageChange: (locale: string) => trackEvent({ name: "language_change", properties: { locale } }),
    themeChange: (theme: string) => trackEvent({ name: "theme_change", properties: { theme } }),
    audioPlay: () => trackEvent({ name: "audio_play" }),
    audioPause: () => trackEvent({ name: "audio_pause" }),
    audioMute: () => trackEvent({ name: "audio_mute" }),
};

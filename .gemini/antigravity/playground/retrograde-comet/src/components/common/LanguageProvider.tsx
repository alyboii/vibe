"use client";

import { createContext, useContext, useState, useEffect, ReactNode } from "react";
import { translations, Locale, TranslationKey } from "@/content/data/translations";

interface LanguageContextType {
    locale: Locale;
    setLocale: (locale: Locale) => void;
    t: (key: TranslationKey) => string;
}

// Default translation function that uses Turkish as default
const defaultT = (key: TranslationKey): string => {
    const keys = key.split(".");
    let value: unknown = translations["tr"];

    for (const k of keys) {
        if (value && typeof value === "object" && k in value) {
            value = (value as Record<string, unknown>)[k];
        } else {
            return key;
        }
    }

    return typeof value === "string" ? value : key;
};

// Create context with default values to prevent undefined errors
const LanguageContext = createContext<LanguageContextType>({
    locale: "tr",
    setLocale: () => { },
    t: defaultT,
});

export function LanguageProvider({ children }: { children: ReactNode }) {
    const [locale, setLocaleState] = useState<Locale>("tr");
    const [mounted, setMounted] = useState(false);

    useEffect(() => {
        setMounted(true);
        const stored = localStorage.getItem("locale") as Locale | null;
        if (stored && (stored === "tr" || stored === "en")) {
            setLocaleState(stored);
        }
    }, []);

    const setLocale = (newLocale: Locale) => {
        setLocaleState(newLocale);
        if (typeof window !== "undefined") {
            localStorage.setItem("locale", newLocale);
            document.documentElement.lang = newLocale;
        }
    };

    const t = (key: TranslationKey): string => {
        const keys = key.split(".");
        let value: unknown = translations[locale];

        for (const k of keys) {
            if (value && typeof value === "object" && k in value) {
                value = (value as Record<string, unknown>)[k];
            } else {
                return key;
            }
        }

        return typeof value === "string" ? value : key;
    };

    return (
        <LanguageContext.Provider value={{ locale, setLocale, t }}>
            {children}
        </LanguageContext.Provider>
    );
}

export function useLanguage() {
    return useContext(LanguageContext);
}


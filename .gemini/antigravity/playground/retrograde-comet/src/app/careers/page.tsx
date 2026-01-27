"use client";

import Link from "next/link";
import { useLanguage } from "@/components/common/LanguageProvider";

// Open positions data
const positions = [
    {
        slug: "senior-frontend-engineer",
        title: { tr: "Kıdemli Frontend Mühendisi", en: "Senior Frontend Engineer" },
        department: { tr: "Mühendislik", en: "Engineering" },
        location: { tr: "İstanbul / Uzaktan", en: "Istanbul / Remote" },
        type: "hybrid",
    },
    {
        slug: "backend-engineer",
        title: { tr: "Backend Mühendisi", en: "Backend Engineer" },
        department: { tr: "Mühendislik", en: "Engineering" },
        location: { tr: "Uzaktan", en: "Remote" },
        type: "remote",
    },
    {
        slug: "ml-engineer",
        title: { tr: "ML Mühendisi", en: "ML Engineer" },
        department: { tr: "Yapay Zeka", en: "AI/ML" },
        location: { tr: "İstanbul / Uzaktan", en: "Istanbul / Remote" },
        type: "hybrid",
    },
    {
        slug: "product-designer",
        title: { tr: "Ürün Tasarımcısı", en: "Product Designer" },
        department: { tr: "Tasarım", en: "Design" },
        location: { tr: "İstanbul", en: "Istanbul" },
        type: "onsite",
    },
];

export default function CareersPage() {
    const { t, locale } = useLanguage();

    const getTypeLabel = (type: string) => {
        const labels: Record<string, { tr: string; en: string }> = {
            remote: { tr: "Uzaktan", en: "Remote" },
            hybrid: { tr: "Hibrit", en: "Hybrid" },
            onsite: { tr: "Ofis", en: "On-site" },
        };
        return labels[type]?.[locale] || type;
    };

    return (
        <div style={{ paddingTop: "var(--header-height)" }}>
            {/* Hero */}
            <section className="section" style={{ paddingBottom: "var(--space-xl)" }}>
                <div className="container">
                    <div className="animate-fade-up">
                        <h1 style={{ marginBottom: "var(--space-md)" }}>{t("careers.title")}</h1>
                        <p className="text-large" style={{ maxWidth: "600px" }}>
                            {t("careers.subtitle")}
                        </p>
                    </div>
                </div>
            </section>

            {/* Why Join Us */}
            <section className="section" style={{ backgroundColor: "var(--surface-elevated)", paddingTop: "var(--space-xl)" }}>
                <div className="container">
                    <h2 style={{ marginBottom: "var(--space-xl)" }}>
                        {locale === "tr" ? "Neden harman.labs?" : "Why harman.labs?"}
                    </h2>
                    <div className="grid grid-3 stagger-children">
                        {[
                            {
                                icon: (
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                                        <circle cx="12" cy="12" r="10" />
                                        <path d="M12 6v6l4 2" />
                                    </svg>
                                ),
                                title: { tr: "Esnek Çalışma", en: "Flexible Work" },
                                text: { tr: "Uzaktan veya hibrit çalışma seçenekleri.", en: "Remote or hybrid work options." },
                            },
                            {
                                icon: (
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                                        <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
                                    </svg>
                                ),
                                title: { tr: "Sürekli Öğrenme", en: "Continuous Learning" },
                                text: { tr: "Konferanslar, eğitimler ve kitap bütçesi.", en: "Conferences, training, and book budget." },
                            },
                            {
                                icon: (
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                                        <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 7a4 4 0 100 8 4 4 0 000-8zM23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75" />
                                    </svg>
                                ),
                                title: { tr: "Harika Ekip", en: "Great Team" },
                                text: { tr: "Tutkulu ve yetenekli mühendislerle çalışma.", en: "Work with passionate and talented engineers." },
                            },
                        ].map((item, index) => (
                            <div
                                key={index}
                                style={{
                                    padding: "var(--space-xl)",
                                    backgroundColor: "var(--void-black)",
                                    border: "1px solid var(--border-subtle)",
                                }}
                            >
                                <div style={{ color: "var(--accent-cyan)", marginBottom: "var(--space-md)" }}>
                                    {item.icon}
                                </div>
                                <h4 style={{ marginBottom: "var(--space-sm)" }}>{item.title[locale]}</h4>
                                <p style={{ fontSize: "0.875rem" }}>{item.text[locale]}</p>
                            </div>
                        ))}
                    </div>
                </div>
            </section>

            {/* Open Positions */}
            <section className="section">
                <div className="container">
                    <h2 style={{ marginBottom: "var(--space-xl)" }}>{t("careers.openPositions")}</h2>

                    {positions.length > 0 ? (
                        <div style={{ display: "flex", flexDirection: "column", gap: "var(--space-md)" }}>
                            {positions.map((position) => (
                                <Link
                                    key={position.slug}
                                    href={`/careers/${position.slug}`}
                                    style={{
                                        display: "flex",
                                        alignItems: "center",
                                        justifyContent: "space-between",
                                        padding: "var(--space-lg) var(--space-xl)",
                                        backgroundColor: "var(--surface-elevated)",
                                        border: "1px solid var(--border-subtle)",
                                        textDecoration: "none",
                                        transition: "border-color var(--duration-fast) var(--ease-out)",
                                        flexWrap: "wrap",
                                        gap: "var(--space-md)",
                                    }}
                                    className="position-card"
                                >
                                    <div>
                                        <h4 style={{ color: "var(--text-primary)", marginBottom: "var(--space-xs)" }}>
                                            {position.title[locale]}
                                        </h4>
                                        <div style={{ display: "flex", gap: "var(--space-md)", flexWrap: "wrap" }}>
                                            <span style={{ fontSize: "0.875rem", color: "var(--text-secondary)" }}>
                                                {position.department[locale]}
                                            </span>
                                            <span style={{ fontSize: "0.875rem", color: "var(--text-muted)" }}>•</span>
                                            <span style={{ fontSize: "0.875rem", color: "var(--text-secondary)" }}>
                                                {position.location[locale]}
                                            </span>
                                        </div>
                                    </div>
                                    <div style={{ display: "flex", alignItems: "center", gap: "var(--space-md)" }}>
                                        <span className="tag">{getTypeLabel(position.type)}</span>
                                        <svg
                                            width="20"
                                            height="20"
                                            viewBox="0 0 24 24"
                                            fill="none"
                                            stroke="currentColor"
                                            strokeWidth="2"
                                            style={{ color: "var(--text-muted)" }}
                                        >
                                            <path d="M5 12h14M12 5l7 7-7 7" />
                                        </svg>
                                    </div>
                                </Link>
                            ))}
                        </div>
                    ) : (
                        <div
                            style={{
                                padding: "var(--space-3xl)",
                                backgroundColor: "var(--surface-elevated)",
                                border: "1px solid var(--border-subtle)",
                                textAlign: "center",
                            }}
                        >
                            <p style={{ color: "var(--text-muted)" }}>{t("careers.noOpenings")}</p>
                        </div>
                    )}

                    <style jsx>{`
            .position-card:hover {
              border-color: var(--accent-cyan) !important;
            }
          `}</style>
                </div>
            </section>

            {/* Contact CTA */}
            <section className="section" style={{ backgroundColor: "var(--surface-elevated)" }}>
                <div className="container" style={{ textAlign: "center" }}>
                    <h2 style={{ marginBottom: "var(--space-md)" }}>
                        {locale === "tr" ? "Aradığınız pozisyon yok mu?" : "Don't see your role?"}
                    </h2>
                    <p style={{ color: "var(--text-secondary)", marginBottom: "var(--space-xl)", maxWidth: "500px", margin: "0 auto var(--space-xl)" }}>
                        {locale === "tr"
                            ? "Yeteneklere her zaman açığız. CV'nizi gönderin, uygun bir pozisyon açıldığında sizinle iletişime geçelim."
                            : "We're always open to talent. Send us your CV, and we'll reach out when a suitable position opens."}
                    </p>
                    <a href="mailto:careers@harman.labs" className="btn btn-primary">
                        {locale === "tr" ? "CV Gönder" : "Send CV"}
                    </a>
                </div>
            </section>
        </div>
    );
}

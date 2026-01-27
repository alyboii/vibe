"use client";

import Link from "next/link";
import { useLanguage } from "@/components/common/LanguageProvider";

// Extended service data
const services = [
    {
        key: "product",
        icon: (
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                <rect x="3" y="3" width="18" height="18" rx="2" />
                <path d="M3 9h18M9 21V9" />
            </svg>
        ),
        problem: {
            tr: "Fikriniz var ama teknik uygulamada zorlanıyorsunuz.",
            en: "You have an idea but struggle with technical implementation.",
        },
        approach: {
            tr: "Agile metodolojilerle iteratif geliştirme, kullanıcı odaklı tasarım ve sürdürülebilir mimari.",
            en: "Iterative development with agile methodologies, user-centered design, and sustainable architecture.",
        },
        deliverables: {
            tr: ["MVP / Tam ürün geliştirme", "Teknik mimari tasarım", "API tasarımı ve entegrasyonlar", "Performans optimizasyonu"],
            en: ["MVP / Full product development", "Technical architecture design", "API design and integrations", "Performance optimization"],
        },
    },
    {
        key: "ai",
        icon: (
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                <circle cx="12" cy="12" r="3" />
                <path d="M12 2v3M12 19v3M2 12h3M19 12h3M4.93 4.93l2.12 2.12M16.95 16.95l2.12 2.12M4.93 19.07l2.12-2.12M16.95 7.05l2.12-2.12" />
            </svg>
        ),
        problem: {
            tr: "Verilerinizden değer çıkarmak ve akıllı sistemler kurmak istiyorsunuz.",
            en: "You want to extract value from your data and build intelligent systems.",
        },
        approach: {
            tr: "Veri analizi, model geliştirme, MLOps pipeline'ları ve ürüne entegrasyon.",
            en: "Data analysis, model development, MLOps pipelines, and product integration.",
        },
        deliverables: {
            tr: ["Özel ML modelleri", "NLP / Computer Vision çözümleri", "LLM entegrasyonları", "Öneri sistemleri"],
            en: ["Custom ML models", "NLP / Computer Vision solutions", "LLM integrations", "Recommendation systems"],
        },
    },
    {
        key: "data",
        icon: (
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                <ellipse cx="12" cy="5" rx="9" ry="3" />
                <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3" />
                <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5" />
            </svg>
        ),
        problem: {
            tr: "Veriniz var ama anlamlı içgörüler çıkaramıyorsunuz.",
            en: "You have data but can't extract meaningful insights.",
        },
        approach: {
            tr: "Modern veri altyapısı, gerçek zamanlı pipeline'lar ve analitik dashboardlar.",
            en: "Modern data infrastructure, real-time pipelines, and analytics dashboards.",
        },
        deliverables: {
            tr: ["Veri ambarı tasarımı", "ETL/ELT pipeline'ları", "Gerçek zamanlı streaming", "BI dashboardlar"],
            en: ["Data warehouse design", "ETL/ELT pipelines", "Real-time streaming", "BI dashboards"],
        },
    },
    {
        key: "cloud",
        icon: (
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                <path d="M18 10h-1.26A8 8 0 109 20h9a5 5 0 000-10z" />
            </svg>
        ),
        problem: {
            tr: "Altyapınız ölçeklenemiyor veya maliyetler kontrol dışı.",
            en: "Your infrastructure doesn't scale or costs are out of control.",
        },
        approach: {
            tr: "Cloud-native mimari, Infrastructure as Code, ve DevOps best practices.",
            en: "Cloud-native architecture, Infrastructure as Code, and DevOps best practices.",
        },
        deliverables: {
            tr: ["AWS / GCP / Azure kurulumu", "Kubernetes / Docker", "CI/CD pipeline'ları", "Monitoring & Observability"],
            en: ["AWS / GCP / Azure setup", "Kubernetes / Docker", "CI/CD pipelines", "Monitoring & Observability"],
        },
    },
    {
        key: "design",
        icon: (
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                <rect x="3" y="3" width="7" height="7" />
                <rect x="14" y="3" width="7" height="7" />
                <rect x="14" y="14" width="7" height="7" />
                <rect x="3" y="14" width="7" height="7" />
            </svg>
        ),
        problem: {
            tr: "Ürününüz tutarsız ve geliştirme yavaş.",
            en: "Your product is inconsistent and development is slow.",
        },
        approach: {
            tr: "Atomic design, token-based sistemler ve dokümantasyonlu component kütüphaneleri.",
            en: "Atomic design, token-based systems, and documented component libraries.",
        },
        deliverables: {
            tr: ["Design token sistemi", "React/Vue component kütüphanesi", "Storybook dokümantasyonu", "Figma entegrasyonu"],
            en: ["Design token system", "React/Vue component library", "Storybook documentation", "Figma integration"],
        },
    },
    {
        key: "consulting",
        icon: (
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                <path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z" />
            </svg>
        ),
        problem: {
            tr: "Teknik kararlar almakta zorlanıyorsunuz veya ekibinize rehberlik gerekiyor.",
            en: "You struggle with technical decisions or need guidance for your team.",
        },
        approach: {
            tr: "Teknik denetim, mimari inceleme, kod review ve ekip mentorluk.",
            en: "Technical audit, architecture review, code review, and team mentoring.",
        },
        deliverables: {
            tr: ["Teknik due diligence", "Mimari değerlendirme raporu", "Kod kalitesi analizi", "Teknoloji yol haritası"],
            en: ["Technical due diligence", "Architecture assessment report", "Code quality analysis", "Technology roadmap"],
        },
    },
];

export default function ServicesPage() {
    const { t, locale } = useLanguage();

    return (
        <div style={{ paddingTop: "var(--header-height)" }}>
            {/* Hero */}
            <section className="section" style={{ paddingBottom: "var(--space-xl)" }}>
                <div className="container">
                    <div className="animate-fade-up">
                        <h1 style={{ marginBottom: "var(--space-md)" }}>{t("services.title")}</h1>
                        <p className="text-large" style={{ maxWidth: "600px" }}>
                            {t("services.subtitle")}
                        </p>
                    </div>
                </div>
            </section>

            {/* Services List */}
            <section className="section" style={{ paddingTop: 0 }}>
                <div className="container">
                    <div style={{ display: "flex", flexDirection: "column", gap: "var(--space-3xl)" }}>
                        {services.map((service, index) => (
                            <div
                                key={service.key}
                                className="animate-fade-up"
                                style={{
                                    display: "grid",
                                    gridTemplateColumns: "1fr",
                                    gap: "var(--space-xl)",
                                    paddingBottom: "var(--space-3xl)",
                                    borderBottom: index < services.length - 1 ? "1px solid var(--border-subtle)" : "none",
                                }}
                            >
                                {/* Header */}
                                <div style={{ display: "flex", alignItems: "flex-start", gap: "var(--space-lg)" }}>
                                    <div style={{ color: "var(--accent-cyan)" }}>{service.icon}</div>
                                    <div>
                                        <h2 style={{ fontSize: "clamp(1.5rem, 3vw, 2rem)" }}>
                                            {t(`services.categories.${service.key}.title`)}
                                        </h2>
                                        <p style={{ marginTop: "var(--space-sm)" }}>
                                            {t(`services.categories.${service.key}.description`)}
                                        </p>
                                    </div>
                                </div>

                                {/* Problem, Approach, Deliverables */}
                                <div
                                    style={{
                                        display: "grid",
                                        gridTemplateColumns: "repeat(1, 1fr)",
                                        gap: "var(--space-xl)",
                                    }}
                                    className="service-details"
                                >
                                    {/* Problem */}
                                    <div>
                                        <h4
                                            style={{
                                                fontSize: "0.75rem",
                                                fontWeight: 600,
                                                textTransform: "uppercase",
                                                letterSpacing: "0.1em",
                                                color: "var(--text-muted)",
                                                marginBottom: "var(--space-md)",
                                            }}
                                        >
                                            {locale === "tr" ? "Problem" : "Problem"}
                                        </h4>
                                        <p>{service.problem[locale]}</p>
                                    </div>

                                    {/* Approach */}
                                    <div>
                                        <h4
                                            style={{
                                                fontSize: "0.75rem",
                                                fontWeight: 600,
                                                textTransform: "uppercase",
                                                letterSpacing: "0.1em",
                                                color: "var(--text-muted)",
                                                marginBottom: "var(--space-md)",
                                            }}
                                        >
                                            {locale === "tr" ? "Yaklaşım" : "Approach"}
                                        </h4>
                                        <p>{service.approach[locale]}</p>
                                    </div>

                                    {/* Deliverables */}
                                    <div>
                                        <h4
                                            style={{
                                                fontSize: "0.75rem",
                                                fontWeight: 600,
                                                textTransform: "uppercase",
                                                letterSpacing: "0.1em",
                                                color: "var(--text-muted)",
                                                marginBottom: "var(--space-md)",
                                            }}
                                        >
                                            {locale === "tr" ? "Çıktılar" : "Deliverables"}
                                        </h4>
                                        <ul style={{ listStyle: "none", display: "flex", flexDirection: "column", gap: "var(--space-sm)" }}>
                                            {service.deliverables[locale].map((item, i) => (
                                                <li
                                                    key={i}
                                                    style={{
                                                        display: "flex",
                                                        alignItems: "center",
                                                        gap: "var(--space-sm)",
                                                        color: "var(--text-secondary)",
                                                    }}
                                                >
                                                    <span style={{ color: "var(--accent-cyan)" }}>→</span>
                                                    {item}
                                                </li>
                                            ))}
                                        </ul>
                                    </div>
                                </div>

                                <style jsx>{`
                  @media (min-width: 768px) {
                    .service-details {
                      grid-template-columns: repeat(3, 1fr) !important;
                    }
                  }
                `}</style>
                            </div>
                        ))}
                    </div>
                </div>
            </section>

            {/* CTA */}
            <section className="section" style={{ backgroundColor: "var(--surface-elevated)" }}>
                <div className="container" style={{ textAlign: "center" }}>
                    <h2 style={{ marginBottom: "var(--space-md)" }}>
                        {locale === "tr" ? "Projenizi tartışalım" : "Let's discuss your project"}
                    </h2>
                    <p style={{ color: "var(--text-secondary)", marginBottom: "var(--space-xl)", maxWidth: "500px", margin: "0 auto var(--space-xl)" }}>
                        {locale === "tr"
                            ? "Hangi hizmetin size uygun olduğunu birlikte belirleyelim."
                            : "Let's figure out which service is right for you."}
                    </p>
                    <Link href="/contact" className="btn btn-primary">
                        {locale === "tr" ? "İletişime Geç" : "Get in Touch"}
                    </Link>
                </div>
            </section>
        </div>
    );
}

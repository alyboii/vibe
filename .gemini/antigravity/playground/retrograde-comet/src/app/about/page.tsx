"use client";

import Link from "next/link";
import { useLanguage } from "@/components/common/LanguageProvider";

// Team members placeholder
const teamMembers = [
    { name: "A.K.", role: { tr: "Kurucu & CEO", en: "Founder & CEO" } },
    { name: "M.Y.", role: { tr: "CTO", en: "CTO" } },
    { name: "E.S.", role: { tr: "Tasarım Direktörü", en: "Design Director" } },
    { name: "B.T.", role: { tr: "Mühendislik Lideri", en: "Engineering Lead" } },
];

export default function AboutPage() {
    const { t, locale } = useLanguage();

    const principles = t("about.principles.items") as unknown as Array<{ title: string; text: string }>;
    const steps = t("about.howWeWork.steps") as unknown as Array<{ title: string; text: string }>;

    return (
        <div style={{ paddingTop: "var(--header-height)" }}>
            {/* Hero */}
            <section className="section" style={{ paddingBottom: "var(--space-xl)" }}>
                <div className="container">
                    <div className="animate-fade-up">
                        <h1 style={{ marginBottom: "var(--space-md)" }}>{t("about.title")}</h1>
                    </div>
                </div>
            </section>

            {/* Story Section */}
            <section className="section" style={{ paddingTop: "var(--space-xl)" }}>
                <div className="container">
                    <div
                        style={{
                            display: "grid",
                            gridTemplateColumns: "1fr",
                            gap: "var(--space-3xl)",
                            alignItems: "center",
                        }}
                        className="about-grid"
                    >
                        <div>
                            <h2 style={{ marginBottom: "var(--space-lg)" }}>{t("about.story.title")}</h2>
                            <p className="text-large" style={{ lineHeight: 1.8 }}>
                                {t("about.story.text")}
                            </p>
                        </div>
                        <div
                            style={{
                                aspectRatio: "4/3",
                                backgroundColor: "var(--surface-elevated)",
                                border: "1px solid var(--border-subtle)",
                                display: "flex",
                                alignItems: "center",
                                justifyContent: "center",
                                color: "var(--text-muted)",
                                fontSize: "0.875rem",
                                textTransform: "uppercase",
                                letterSpacing: "0.1em",
                            }}
                        >
                            {locale === "tr" ? "Görsel" : "Image"}
                        </div>
                    </div>

                    <style jsx>{`
            @media (min-width: 768px) {
              .about-grid {
                grid-template-columns: 1fr 1fr !important;
              }
            }
          `}</style>
                </div>
            </section>

            {/* Principles Section */}
            <section className="section" style={{ backgroundColor: "var(--surface-elevated)" }}>
                <div className="container">
                    <h2 style={{ marginBottom: "var(--space-xl)", textAlign: "center" }}>
                        {t("about.principles.title")}
                    </h2>
                    <div className="grid grid-2 stagger-children">
                        {Array.isArray(principles) && principles.map((principle, index) => (
                            <div
                                key={index}
                                style={{
                                    padding: "var(--space-xl)",
                                    backgroundColor: "var(--void-black)",
                                    border: "1px solid var(--border-subtle)",
                                }}
                            >
                                <div
                                    style={{
                                        display: "flex",
                                        alignItems: "center",
                                        gap: "var(--space-md)",
                                        marginBottom: "var(--space-md)",
                                    }}
                                >
                                    <span
                                        style={{
                                            color: "var(--accent-cyan)",
                                            fontSize: "1.5rem",
                                            fontWeight: 700,
                                        }}
                                    >
                                        {String(index + 1).padStart(2, "0")}
                                    </span>
                                    <h4>{principle.title}</h4>
                                </div>
                                <p>{principle.text}</p>
                            </div>
                        ))}
                    </div>
                </div>
            </section>

            {/* Team Section */}
            <section className="section">
                <div className="container">
                    <h2 style={{ marginBottom: "var(--space-md)" }}>{t("about.team.title")}</h2>
                    <p style={{ color: "var(--text-secondary)", marginBottom: "var(--space-xl)", maxWidth: "600px" }}>
                        {t("about.team.text")}
                    </p>
                    <div className="grid grid-2 stagger-children" style={{ maxWidth: "800px" }}>
                        {teamMembers.map((member, index) => (
                            <div
                                key={index}
                                style={{
                                    display: "flex",
                                    alignItems: "center",
                                    gap: "var(--space-lg)",
                                }}
                            >
                                <div
                                    style={{
                                        width: "80px",
                                        height: "80px",
                                        backgroundColor: "var(--surface-elevated)",
                                        border: "1px solid var(--border-subtle)",
                                        display: "flex",
                                        alignItems: "center",
                                        justifyContent: "center",
                                        color: "var(--accent-cyan)",
                                        fontSize: "1.25rem",
                                        fontWeight: 700,
                                    }}
                                >
                                    {member.name}
                                </div>
                                <div>
                                    <h4 style={{ fontSize: "1rem" }}>{member.name}</h4>
                                    <p style={{ fontSize: "0.875rem" }}>{member.role[locale]}</p>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </section>

            {/* How We Work Section */}
            <section className="section" style={{ backgroundColor: "var(--surface-elevated)" }}>
                <div className="container">
                    <h2 style={{ marginBottom: "var(--space-xl)", textAlign: "center" }}>
                        {t("about.howWeWork.title")}
                    </h2>
                    <div
                        style={{
                            display: "grid",
                            gridTemplateColumns: "repeat(1, 1fr)",
                            gap: "var(--space-lg)",
                        }}
                        className="process-grid"
                    >
                        {Array.isArray(steps) && steps.map((step, index) => (
                            <div
                                key={index}
                                style={{
                                    display: "flex",
                                    alignItems: "flex-start",
                                    gap: "var(--space-lg)",
                                    padding: "var(--space-xl)",
                                    backgroundColor: "var(--void-black)",
                                    border: "1px solid var(--border-subtle)",
                                }}
                            >
                                <div
                                    style={{
                                        flexShrink: 0,
                                        width: "48px",
                                        height: "48px",
                                        display: "flex",
                                        alignItems: "center",
                                        justifyContent: "center",
                                        backgroundColor: "var(--accent-cyan)",
                                        color: "var(--void-black)",
                                        fontSize: "1.25rem",
                                        fontWeight: 700,
                                    }}
                                >
                                    {index + 1}
                                </div>
                                <div>
                                    <h4 style={{ marginBottom: "var(--space-sm)" }}>{step.title}</h4>
                                    <p style={{ fontSize: "0.875rem" }}>{step.text}</p>
                                </div>
                            </div>
                        ))}
                    </div>

                    <style jsx>{`
            @media (min-width: 768px) {
              .process-grid {
                grid-template-columns: repeat(2, 1fr) !important;
              }
            }
            @media (min-width: 1024px) {
              .process-grid {
                grid-template-columns: repeat(4, 1fr) !important;
              }
            }
          `}</style>
                </div>
            </section>

            {/* CTA */}
            <section className="section">
                <div className="container" style={{ textAlign: "center" }}>
                    <h2 style={{ marginBottom: "var(--space-md)" }}>
                        {locale === "tr" ? "Bize katılmak ister misiniz?" : "Want to join us?"}
                    </h2>
                    <p style={{ color: "var(--text-secondary)", marginBottom: "var(--space-xl)" }}>
                        {locale === "tr"
                            ? "Açık pozisyonlarımıza göz atın."
                            : "Check out our open positions."}
                    </p>
                    <Link href="/careers" className="btn btn-primary">
                        {locale === "tr" ? "Kariyer Fırsatları" : "Career Opportunities"}
                    </Link>
                </div>
            </section>
        </div>
    );
}

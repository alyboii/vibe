"use client";

import Link from "next/link";
import { useParams } from "next/navigation";
import { useLanguage } from "@/components/common/LanguageProvider";

// Position details data
const positionsData: Record<string, {
    title: { tr: string; en: string };
    department: { tr: string; en: string };
    location: { tr: string; en: string };
    type: string;
    description: { tr: string; en: string };
    responsibilities: { tr: string[]; en: string[] };
    requirements: { tr: string[]; en: string[] };
    niceToHave: { tr: string[]; en: string[] };
    benefits: { tr: string[]; en: string[] };
}> = {
    "senior-frontend-engineer": {
        title: { tr: "Kıdemli Frontend Mühendisi", en: "Senior Frontend Engineer" },
        department: { tr: "Mühendislik", en: "Engineering" },
        location: { tr: "İstanbul / Uzaktan", en: "Istanbul / Remote" },
        type: "hybrid",
        description: {
            tr: "Modern web teknolojileri kullanarak müşteri projelerimizde yer alacak, deneyimli bir frontend mühendisi arıyoruz.",
            en: "We're looking for an experienced frontend engineer to work on our client projects using modern web technologies.",
        },
        responsibilities: {
            tr: [
                "React ve Next.js ile ölçeklenebilir web uygulamaları geliştirmek",
                "Tasarım ekibiyle yakın çalışarak pixel-perfect UI uygulamaları yapmak",
                "Kod incelemeleri yapmak ve ekip üyelerine mentorluk sağlamak",
                "Performans optimizasyonu ve erişilebilirlik standartlarına uyum",
                "Teknik dokümantasyon hazırlamak",
            ],
            en: [
                "Build scalable web applications with React and Next.js",
                "Work closely with the design team for pixel-perfect UI implementation",
                "Conduct code reviews and mentor team members",
                "Performance optimization and accessibility compliance",
                "Prepare technical documentation",
            ],
        },
        requirements: {
            tr: [
                "5+ yıl frontend geliştirme deneyimi",
                "React ve TypeScript'te güçlü yetkinlik",
                "Modern CSS (Tailwind, styled-components vb.) bilgisi",
                "Test yazma deneyimi (Jest, Testing Library, Cypress)",
                "Git ve CI/CD süreçlerine hakimiyet",
            ],
            en: [
                "5+ years of frontend development experience",
                "Strong proficiency in React and TypeScript",
                "Knowledge of modern CSS (Tailwind, styled-components, etc.)",
                "Experience writing tests (Jest, Testing Library, Cypress)",
                "Familiarity with Git and CI/CD processes",
            ],
        },
        niceToHave: {
            tr: [
                "Next.js App Router deneyimi",
                "Design system oluşturma tecrübesi",
                "GraphQL bilgisi",
                "Figma kullanımı",
            ],
            en: [
                "Next.js App Router experience",
                "Design system creation experience",
                "GraphQL knowledge",
                "Figma proficiency",
            ],
        },
        benefits: {
            tr: [
                "Rekabetçi maaş",
                "Esnek çalışma saatleri",
                "Uzaktan çalışma imkanı",
                "Eğitim ve konferans bütçesi",
                "Sağlık sigortası",
            ],
            en: [
                "Competitive salary",
                "Flexible working hours",
                "Remote work option",
                "Training and conference budget",
                "Health insurance",
            ],
        },
    },
    "backend-engineer": {
        title: { tr: "Backend Mühendisi", en: "Backend Engineer" },
        department: { tr: "Mühendislik", en: "Engineering" },
        location: { tr: "Uzaktan", en: "Remote" },
        type: "remote",
        description: {
            tr: "Node.js ve Python ekosisteminde deneyimli, ölçeklenebilir backend sistemleri geliştirebilecek bir mühendis arıyoruz.",
            en: "We're looking for an engineer experienced in the Node.js and Python ecosystem who can develop scalable backend systems.",
        },
        responsibilities: {
            tr: [
                "RESTful ve GraphQL API'lar tasarlamak ve geliştirmek",
                "Mikroservis mimarileri oluşturmak",
                "Veritabanı tasarımı ve optimizasyonu",
                "CI/CD pipeline'ları kurmak ve yönetmek",
                "Teknik tasarım dokümanları hazırlamak",
            ],
            en: [
                "Design and develop RESTful and GraphQL APIs",
                "Build microservice architectures",
                "Database design and optimization",
                "Set up and manage CI/CD pipelines",
                "Prepare technical design documents",
            ],
        },
        requirements: {
            tr: [
                "3+ yıl backend geliştirme deneyimi",
                "Node.js veya Python'da güçlü yetkinlik",
                "PostgreSQL veya benzeri RDBMS deneyimi",
                "Docker ve Kubernetes bilgisi",
                "AWS, GCP veya Azure deneyimi",
            ],
            en: [
                "3+ years of backend development experience",
                "Strong proficiency in Node.js or Python",
                "PostgreSQL or similar RDBMS experience",
                "Docker and Kubernetes knowledge",
                "AWS, GCP, or Azure experience",
            ],
        },
        niceToHave: {
            tr: [
                "Event-driven architecture deneyimi",
                "Message queue sistemleri (RabbitMQ, Kafka)",
                "Terraform veya Pulumi",
                "Observability araçları (Datadog, Grafana)",
            ],
            en: [
                "Event-driven architecture experience",
                "Message queue systems (RabbitMQ, Kafka)",
                "Terraform or Pulumi",
                "Observability tools (Datadog, Grafana)",
            ],
        },
        benefits: {
            tr: [
                "Rekabetçi maaş",
                "Tam uzaktan çalışma",
                "Eğitim ve konferans bütçesi",
                "Ekipman desteği",
                "Sağlık sigortası",
            ],
            en: [
                "Competitive salary",
                "Fully remote work",
                "Training and conference budget",
                "Equipment support",
                "Health insurance",
            ],
        },
    },
    "ml-engineer": {
        title: { tr: "ML Mühendisi", en: "ML Engineer" },
        department: { tr: "Yapay Zeka", en: "AI/ML" },
        location: { tr: "İstanbul / Uzaktan", en: "Istanbul / Remote" },
        type: "hybrid",
        description: {
            tr: "Makine öğrenmesi modellerini üretime taşıyacak ve MLOps süreçlerini yönetecek bir mühendis arıyoruz.",
            en: "We're looking for an engineer to bring ML models to production and manage MLOps processes.",
        },
        responsibilities: {
            tr: [
                "ML modelleri geliştirmek ve optimize etmek",
                "MLOps pipeline'ları kurmak",
                "Model performansını izlemek ve iyileştirmek",
                "Veri bilimcilerle yakın çalışmak",
                "ML sistemlerinin ölçeklenebilirliğini sağlamak",
            ],
            en: [
                "Develop and optimize ML models",
                "Build MLOps pipelines",
                "Monitor and improve model performance",
                "Work closely with data scientists",
                "Ensure scalability of ML systems",
            ],
        },
        requirements: {
            tr: [
                "3+ yıl ML/AI deneyimi",
                "Python ve ML framework'leri (TensorFlow, PyTorch)",
                "MLOps araçları deneyimi",
                "SQL ve veri işleme becerileri",
                "Bulut platformlarında ML servisleri bilgisi",
            ],
            en: [
                "3+ years of ML/AI experience",
                "Python and ML frameworks (TensorFlow, PyTorch)",
                "MLOps tools experience",
                "SQL and data processing skills",
                "Knowledge of ML services on cloud platforms",
            ],
        },
        niceToHave: {
            tr: [
                "LLM fine-tuning deneyimi",
                "Computer Vision veya NLP uzmanlığı",
                "Kubernetes deneyimi",
                "A/B testing deneyimi",
            ],
            en: [
                "LLM fine-tuning experience",
                "Computer Vision or NLP expertise",
                "Kubernetes experience",
                "A/B testing experience",
            ],
        },
        benefits: {
            tr: [
                "Rekabetçi maaş",
                "Esnek çalışma saatleri",
                "GPU kaynaklarına erişim",
                "Araştırma projelerine katılım",
                "Sağlık sigortası",
            ],
            en: [
                "Competitive salary",
                "Flexible working hours",
                "Access to GPU resources",
                "Participation in research projects",
                "Health insurance",
            ],
        },
    },
    "product-designer": {
        title: { tr: "Ürün Tasarımcısı", en: "Product Designer" },
        department: { tr: "Tasarım", en: "Design" },
        location: { tr: "İstanbul", en: "Istanbul" },
        type: "onsite",
        description: {
            tr: "Kullanıcı deneyimini ön planda tutan, araştırma odaklı bir ürün tasarımcısı arıyoruz.",
            en: "We're looking for a research-driven product designer who prioritizes user experience.",
        },
        responsibilities: {
            tr: [
                "Kullanıcı araştırması yapmak",
                "Wireframe ve prototip oluşturmak",
                "Design system geliştirmek ve sürdürmek",
                "Mühendislik ekibiyle yakın çalışmak",
                "Kullanılabilirlik testleri yürütmek",
            ],
            en: [
                "Conduct user research",
                "Create wireframes and prototypes",
                "Develop and maintain design systems",
                "Work closely with the engineering team",
                "Conduct usability tests",
            ],
        },
        requirements: {
            tr: [
                "4+ yıl ürün tasarımı deneyimi",
                "Figma'da güçlü yetkinlik",
                "Design system deneyimi",
                "Kullanıcı araştırması metodolojileri bilgisi",
                "Güçlü portfolyo",
            ],
            en: [
                "4+ years of product design experience",
                "Strong proficiency in Figma",
                "Design system experience",
                "Knowledge of user research methodologies",
                "Strong portfolio",
            ],
        },
        niceToHave: {
            tr: [
                "Framer veya prototyping araçları deneyimi",
                "Temel frontend bilgisi (HTML, CSS)",
                "Motion design becerileri",
                "B2B SaaS deneyimi",
            ],
            en: [
                "Framer or prototyping tools experience",
                "Basic frontend knowledge (HTML, CSS)",
                "Motion design skills",
                "B2B SaaS experience",
            ],
        },
        benefits: {
            tr: [
                "Rekabetçi maaş",
                "Modern ofis ortamı",
                "Tasarım konferanslarına katılım",
                "En son araçlara erişim",
                "Sağlık sigortası",
            ],
            en: [
                "Competitive salary",
                "Modern office environment",
                "Design conference attendance",
                "Access to latest tools",
                "Health insurance",
            ],
        },
    },
};

export default function CareerDetailPage() {
    const { t, locale } = useLanguage();
    const params = useParams();
    const slug = params.slug as string;
    const position = positionsData[slug];

    if (!position) {
        return (
            <div style={{ paddingTop: "var(--header-height)" }}>
                <section className="section" style={{ textAlign: "center" }}>
                    <div className="container">
                        <h1>{t("common.notFound")}</h1>
                        <p style={{ marginTop: "var(--space-md)", marginBottom: "var(--space-xl)" }}>
                            {locale === "tr" ? "Bu pozisyon bulunamadı." : "This position was not found."}
                        </p>
                        <Link href="/careers" className="btn btn-outline">
                            {t("careers.backToCareers")}
                        </Link>
                    </div>
                </section>
            </div>
        );
    }

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
            {/* Back link */}
            <section style={{ paddingTop: "var(--space-xl)" }}>
                <div className="container">
                    <Link
                        href="/careers"
                        style={{
                            display: "inline-flex",
                            alignItems: "center",
                            gap: "var(--space-sm)",
                            color: "var(--text-secondary)",
                            fontSize: "0.875rem",
                        }}
                    >
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M19 12H5M12 19l-7-7 7-7" />
                        </svg>
                        {t("careers.backToCareers")}
                    </Link>
                </div>
            </section>

            {/* Hero */}
            <section className="section" style={{ paddingBottom: "var(--space-xl)" }}>
                <div className="container">
                    <div className="animate-fade-up">
                        <div style={{ display: "flex", gap: "var(--space-md)", marginBottom: "var(--space-lg)", flexWrap: "wrap" }}>
                            <span className="tag">{position.department[locale]}</span>
                            <span className="tag">{getTypeLabel(position.type)}</span>
                        </div>
                        <h1 style={{ marginBottom: "var(--space-md)" }}>{position.title[locale]}</h1>
                        <p style={{ color: "var(--text-secondary)", display: "flex", alignItems: "center", gap: "var(--space-sm)" }}>
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z" />
                                <circle cx="12" cy="10" r="3" />
                            </svg>
                            {position.location[locale]}
                        </p>
                    </div>
                </div>
            </section>

            {/* Content */}
            <section className="section" style={{ paddingTop: 0 }}>
                <div className="container">
                    <div
                        style={{
                            display: "grid",
                            gridTemplateColumns: "1fr",
                            gap: "var(--space-3xl)",
                        }}
                        className="career-content"
                    >
                        {/* Main content */}
                        <div style={{ display: "flex", flexDirection: "column", gap: "var(--space-xl)" }}>
                            {/* Description */}
                            <div>
                                <p className="text-large">{position.description[locale]}</p>
                            </div>

                            {/* Responsibilities */}
                            <div>
                                <h3 style={{ marginBottom: "var(--space-md)" }}>
                                    {locale === "tr" ? "Sorumluluklar" : "Responsibilities"}
                                </h3>
                                <ul style={{ listStyle: "none", display: "flex", flexDirection: "column", gap: "var(--space-sm)" }}>
                                    {position.responsibilities[locale].map((item, index) => (
                                        <li
                                            key={index}
                                            style={{
                                                display: "flex",
                                                alignItems: "flex-start",
                                                gap: "var(--space-sm)",
                                                color: "var(--text-secondary)",
                                            }}
                                        >
                                            <span style={{ color: "var(--accent-cyan)", flexShrink: 0 }}>→</span>
                                            {item}
                                        </li>
                                    ))}
                                </ul>
                            </div>

                            {/* Requirements */}
                            <div>
                                <h3 style={{ marginBottom: "var(--space-md)" }}>
                                    {locale === "tr" ? "Gereksinimler" : "Requirements"}
                                </h3>
                                <ul style={{ listStyle: "none", display: "flex", flexDirection: "column", gap: "var(--space-sm)" }}>
                                    {position.requirements[locale].map((item, index) => (
                                        <li
                                            key={index}
                                            style={{
                                                display: "flex",
                                                alignItems: "flex-start",
                                                gap: "var(--space-sm)",
                                                color: "var(--text-secondary)",
                                            }}
                                        >
                                            <span style={{ color: "var(--accent-cyan)", flexShrink: 0 }}>→</span>
                                            {item}
                                        </li>
                                    ))}
                                </ul>
                            </div>

                            {/* Nice to Have */}
                            <div>
                                <h3 style={{ marginBottom: "var(--space-md)" }}>
                                    {locale === "tr" ? "Tercih Edilenler" : "Nice to Have"}
                                </h3>
                                <ul style={{ listStyle: "none", display: "flex", flexDirection: "column", gap: "var(--space-sm)" }}>
                                    {position.niceToHave[locale].map((item, index) => (
                                        <li
                                            key={index}
                                            style={{
                                                display: "flex",
                                                alignItems: "flex-start",
                                                gap: "var(--space-sm)",
                                                color: "var(--text-secondary)",
                                            }}
                                        >
                                            <span style={{ color: "var(--text-muted)", flexShrink: 0 }}>○</span>
                                            {item}
                                        </li>
                                    ))}
                                </ul>
                            </div>
                        </div>

                        {/* Sidebar */}
                        <div>
                            <div
                                style={{
                                    position: "sticky",
                                    top: "calc(var(--header-height) + var(--space-xl))",
                                    padding: "var(--space-xl)",
                                    backgroundColor: "var(--surface-elevated)",
                                    border: "1px solid var(--border-subtle)",
                                }}
                            >
                                <h4 style={{ marginBottom: "var(--space-lg)" }}>
                                    {locale === "tr" ? "Yan Haklar" : "Benefits"}
                                </h4>
                                <ul style={{ listStyle: "none", display: "flex", flexDirection: "column", gap: "var(--space-sm)", marginBottom: "var(--space-xl)" }}>
                                    {position.benefits[locale].map((item, index) => (
                                        <li
                                            key={index}
                                            style={{
                                                display: "flex",
                                                alignItems: "center",
                                                gap: "var(--space-sm)",
                                                fontSize: "0.875rem",
                                                color: "var(--text-secondary)",
                                            }}
                                        >
                                            <span style={{ color: "var(--accent-cyan)" }}>✓</span>
                                            {item}
                                        </li>
                                    ))}
                                </ul>
                                <a
                                    href={`mailto:careers@harman.labs?subject=${encodeURIComponent(position.title[locale])}`}
                                    className="btn btn-primary"
                                    style={{ width: "100%", justifyContent: "center" }}
                                >
                                    {t("careers.apply")}
                                </a>
                            </div>
                        </div>
                    </div>

                    <style jsx>{`
            @media (min-width: 1024px) {
              .career-content {
                grid-template-columns: 2fr 1fr !important;
              }
            }
          `}</style>
                </div>
            </section>
        </div>
    );
}

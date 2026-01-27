"use client";

import Link from "next/link";
import { useParams } from "next/navigation";
import { useLanguage } from "@/components/common/LanguageProvider";

const blogPostsData: Record<string, {
    title: { tr: string; en: string };
    date: string;
    readTime: number;
    tags: string[];
    content: { tr: string; en: string };
}> = {
    "building-scalable-systems": {
        title: { tr: "Ölçeklenebilir Sistemler Nasıl İnşa Edilir?", en: "How to Build Scalable Systems?" },
        date: "2024-01-15",
        readTime: 8,
        tags: ["Architecture", "Backend"],
        content: {
            tr: `Ölçeklenebilir sistemler inşa etmek, modern yazılım mühendisliğinin en kritik becerilerinden biridir.

## Temel Prensipler

### 1. Yatay Ölçekleme
Dikey ölçekleme (daha güçlü sunucu) yerine yatay ölçeklemeyi (daha fazla sunucu) tercih edin. Bu yaklaşım daha esnek ve maliyet-etkin bir büyüme sağlar.

### 2. Stateless Tasarım
Sunucularınızı stateless tutun. Oturum verilerini Redis gibi harici sistemlerde saklayın. Bu sayede herhangi bir sunucu herhangi bir isteği işleyebilir.

### 3. Önbellek Stratejileri
- **CDN**: Statik içerikler için
- **Application Cache**: Sık erişilen veriler için
- **Database Cache**: Sorgu sonuçları için

### 4. Asenkron İşleme
Uzun süren işlemleri message queue'lara (RabbitMQ, Kafka) taşıyın. Kullanıcı deneyimini bozmadan arka planda işlem yapın.

## Sonuç

Ölçeklenebilirlik bir son hedef değil, sürekli bir yolculuktur. Erken optimizasyondan kaçının, ama büyüme planlarınızı baştan düşünün.`,
            en: `Building scalable systems is one of the most critical skills in modern software engineering.

## Core Principles

### 1. Horizontal Scaling
Prefer horizontal scaling (more servers) over vertical scaling (more powerful server). This approach provides more flexible and cost-effective growth.

### 2. Stateless Design
Keep your servers stateless. Store session data in external systems like Redis. This way any server can handle any request.

### 3. Caching Strategies
- **CDN**: For static content
- **Application Cache**: For frequently accessed data
- **Database Cache**: For query results

### 4. Asynchronous Processing
Move long-running operations to message queues (RabbitMQ, Kafka). Process in the background without affecting user experience.

## Conclusion

Scalability is not a destination but a continuous journey. Avoid premature optimization, but plan for growth from the start.`,
        },
    },
    "ai-in-production": {
        title: { tr: "Yapay Zekayı Üretime Taşımak", en: "Taking AI to Production" },
        date: "2024-01-08",
        readTime: 12,
        tags: ["AI", "MLOps"],
        content: {
            tr: `ML modellerini laboratuvardan üretime taşımak, birçok mühendislik zorluğu içerir.

## MLOps Temelleri

### Model Versiyonlama
Modellerinizi kod gibi versiyonlayın. MLflow veya DVC gibi araçlar kullanın.

### CI/CD Pipeline
- Otomatik eğitim pipeline'ları
- Model validasyonu
- A/B testing altyapısı

### Monitoring
- Model drift tespiti
- Performans metrikleri
- Prediction logging

## En İyi Pratikler

1. Feature store kullanın
2. Model serving için optimize edin
3. Rollback stratejileri planlayın`,
            en: `Taking ML models from lab to production involves many engineering challenges.

## MLOps Fundamentals

### Model Versioning
Version your models like code. Use tools like MLflow or DVC.

### CI/CD Pipeline
- Automated training pipelines
- Model validation
- A/B testing infrastructure

### Monitoring
- Model drift detection
- Performance metrics
- Prediction logging

## Best Practices

1. Use a feature store
2. Optimize for model serving
3. Plan rollback strategies`,
        },
    },
    "design-systems-guide": {
        title: { tr: "Design System Rehberi", en: "Design Systems Guide" },
        date: "2023-12-20",
        readTime: 15,
        tags: ["Design", "Frontend"],
        content: {
            tr: `Tutarlı ve ölçeklenebilir ürünler için design system şart.

## Neden Design System?

- Tutarlılık
- Hız
- Ölçeklenebilirlik

## Temel Bileşenler

### Design Tokens
Renkler, tipografi, spacing değerlerini tokenize edin.

### Component Library
Atomic design prensiplerini takip edin.

### Documentation
Storybook ile canlı dokümantasyon oluşturun.`,
            en: `Design systems are essential for consistent and scalable products.

## Why Design Systems?

- Consistency
- Speed
- Scalability

## Core Components

### Design Tokens
Tokenize colors, typography, and spacing values.

### Component Library
Follow atomic design principles.

### Documentation
Create live documentation with Storybook.`,
        },
    },
};

export default function BlogPostPage() {
    const { t, locale } = useLanguage();
    const params = useParams();
    const slug = params.slug as string;
    const post = blogPostsData[slug];

    const formatDate = (dateStr: string) => {
        const date = new Date(dateStr);
        return date.toLocaleDateString(locale === "tr" ? "tr-TR" : "en-US", {
            year: "numeric", month: "long", day: "numeric",
        });
    };

    if (!post) {
        return (
            <div style={{ paddingTop: "var(--header-height)" }}>
                <section className="section" style={{ textAlign: "center" }}>
                    <div className="container">
                        <h1>{t("common.notFound")}</h1>
                        <Link href="/blog" className="btn btn-outline" style={{ marginTop: "var(--space-xl)" }}>
                            {t("blog.backToBlog")}
                        </Link>
                    </div>
                </section>
            </div>
        );
    }

    return (
        <div style={{ paddingTop: "var(--header-height)" }}>
            <section style={{ paddingTop: "var(--space-xl)" }}>
                <div className="container">
                    <Link href="/blog" style={{ display: "inline-flex", alignItems: "center", gap: "var(--space-sm)", color: "var(--text-secondary)", fontSize: "0.875rem" }}>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <path d="M19 12H5M12 19l-7-7 7-7" />
                        </svg>
                        {t("blog.backToBlog")}
                    </Link>
                </div>
            </section>

            <section className="section" style={{ paddingBottom: "var(--space-xl)" }}>
                <div className="container" style={{ maxWidth: "800px" }}>
                    <div style={{ display: "flex", gap: "var(--space-md)", marginBottom: "var(--space-lg)" }}>
                        {post.tags.map((tag) => (<span key={tag} className="tag">{tag}</span>))}
                    </div>
                    <h1 style={{ marginBottom: "var(--space-md)" }}>{post.title[locale]}</h1>
                    <div style={{ display: "flex", gap: "var(--space-md)", fontSize: "0.875rem", color: "var(--text-muted)" }}>
                        <span>{formatDate(post.date)}</span>
                        <span>•</span>
                        <span>{post.readTime} {t("blog.readTime")}</span>
                    </div>
                </div>
            </section>

            <section className="section" style={{ paddingTop: 0 }}>
                <div className="container prose" style={{ maxWidth: "800px" }}>
                    {post.content[locale].split("\n\n").map((paragraph, i) => {
                        if (paragraph.startsWith("## ")) {
                            return <h2 key={i}>{paragraph.slice(3)}</h2>;
                        } else if (paragraph.startsWith("### ")) {
                            return <h3 key={i}>{paragraph.slice(4)}</h3>;
                        } else if (paragraph.startsWith("- ")) {
                            return (
                                <ul key={i}>
                                    {paragraph.split("\n").map((item, j) => (
                                        <li key={j}>{item.slice(2)}</li>
                                    ))}
                                </ul>
                            );
                        } else if (paragraph.match(/^\d\./)) {
                            return (
                                <ol key={i}>
                                    {paragraph.split("\n").map((item, j) => (
                                        <li key={j}>{item.slice(3)}</li>
                                    ))}
                                </ol>
                            );
                        }
                        return <p key={i}>{paragraph}</p>;
                    })}
                </div>
            </section>
        </div>
    );
}

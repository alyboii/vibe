"use client";

import Link from "next/link";
import { useLanguage } from "@/components/common/LanguageProvider";

const blogPosts = [
    {
        slug: "building-scalable-systems",
        title: { tr: "Ölçeklenebilir Sistemler Nasıl İnşa Edilir?", en: "How to Build Scalable Systems?" },
        excerpt: {
            tr: "Milyonlarca kullanıcıyı destekleyecek sistemler tasarlarken dikkat edilmesi gereken temel prensipler.",
            en: "Key principles to consider when designing systems that support millions of users.",
        },
        date: "2024-01-15",
        readTime: 8,
        tags: ["Architecture", "Backend"],
    },
    {
        slug: "ai-in-production",
        title: { tr: "Yapay Zekayı Üretime Taşımak", en: "Taking AI to Production" },
        excerpt: {
            tr: "ML modellerini gerçek dünya uygulamalarında başarıyla deploy etmenin yolları.",
            en: "Ways to successfully deploy ML models in real-world applications.",
        },
        date: "2024-01-08",
        readTime: 12,
        tags: ["AI", "MLOps"],
    },
    {
        slug: "design-systems-guide",
        title: { tr: "Design System Rehberi", en: "Design Systems Guide" },
        excerpt: {
            tr: "Tutarlı ve ölçeklenebilir tasarım sistemleri oluşturmak için kapsamlı rehber.",
            en: "A comprehensive guide to creating consistent and scalable design systems.",
        },
        date: "2023-12-20",
        readTime: 15,
        tags: ["Design", "Frontend"],
    },
];

export default function BlogPage() {
    const { t, locale } = useLanguage();

    const formatDate = (dateStr: string) => {
        const date = new Date(dateStr);
        return date.toLocaleDateString(locale === "tr" ? "tr-TR" : "en-US", {
            year: "numeric",
            month: "long",
            day: "numeric",
        });
    };

    return (
        <div style={{ paddingTop: "var(--header-height)" }}>
            <section className="section" style={{ paddingBottom: "var(--space-xl)" }}>
                <div className="container">
                    <div className="animate-fade-up">
                        <h1 style={{ marginBottom: "var(--space-md)" }}>{t("blog.title")}</h1>
                        <p className="text-large" style={{ maxWidth: "600px" }}>
                            {t("blog.subtitle")}
                        </p>
                    </div>
                </div>
            </section>

            <section className="section" style={{ paddingTop: 0 }}>
                <div className="container">
                    <div className="grid grid-2 stagger-children">
                        {blogPosts.map((post) => (
                            <Link
                                key={post.slug}
                                href={`/blog/${post.slug}`}
                                className="card"
                                style={{ display: "flex", flexDirection: "column", gap: "var(--space-md)", textDecoration: "none" }}
                            >
                                <div
                                    style={{
                                        aspectRatio: "16/9",
                                        backgroundColor: "var(--void-black)",
                                        border: "1px solid var(--border-subtle)",
                                        display: "flex",
                                        alignItems: "center",
                                        justifyContent: "center",
                                        color: "var(--text-muted)",
                                        fontSize: "0.75rem",
                                    }}
                                >
                                    {locale === "tr" ? "Görsel" : "Image"}
                                </div>
                                <div style={{ display: "flex", gap: "var(--space-md)", fontSize: "0.75rem", color: "var(--text-muted)" }}>
                                    <span>{formatDate(post.date)}</span>
                                    <span>•</span>
                                    <span>{post.readTime} {t("blog.readTime")}</span>
                                </div>
                                <h3 style={{ color: "var(--text-primary)", fontSize: "1.25rem" }}>{post.title[locale]}</h3>
                                <p style={{ fontSize: "0.875rem", flex: 1 }}>{post.excerpt[locale]}</p>
                                <div style={{ display: "flex", gap: "var(--space-sm)", flexWrap: "wrap" }}>
                                    {post.tags.map((tag) => (<span key={tag} className="tag">{tag}</span>))}
                                </div>
                            </Link>
                        ))}
                    </div>
                </div>
            </section>
        </div>
    );
}

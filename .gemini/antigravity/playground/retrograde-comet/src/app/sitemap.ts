import { MetadataRoute } from "next";

export default function sitemap(): MetadataRoute.Sitemap {
    const baseUrl = "https://harman.labs";
    const currentDate = new Date();

    // Static pages
    const staticPages = [
        { route: "", priority: 1.0 },
        { route: "/work", priority: 0.9 },
        { route: "/contact", priority: 0.8 },
    ].map(({ route, priority }) => ({
        url: `${baseUrl}${route}`,
        lastModified: currentDate,
        changeFrequency: "weekly" as const,
        priority,
    }));

    // Products / Apps
    const products = [
        "fake-it",
    ].map((slug) => ({
        url: `${baseUrl}/work/${slug}`,
        lastModified: currentDate,
        changeFrequency: "monthly" as const,
        priority: 0.7,
    }));

    return [...staticPages, ...products];
}

"use client";

import Image from "next/image";
import Link from "next/link";
import { BrandLogo } from "@/components/BrandLogo";
import { GitHubIcon } from "@/components/icons/GitHubIcon";

const products = [
    {
        id: 1,
        slug: "fake-it",
        title: "FAKE IT - iOS APP",
        image: "/images/fake-it.png",
        status: "Coming Soon"
    },
];

export default function WorkPage() {
    return (
        <div
            style={{
                minHeight: "100vh",
                display: "flex",
            }}
        >
            {/* Sidebar - Dark Red */}
            <aside
                style={{
                    width: "200px",
                    minHeight: "100vh",
                    backgroundColor: "#8B2500",
                    padding: "2rem 1.5rem",
                    position: "fixed",
                    top: 0,
                    left: 0,
                    display: "flex",
                    flexDirection: "column",
                    justifyContent: "space-between",
                }}
            >
                <div style={{ display: "flex", flexDirection: "column", gap: "2rem" }}>
                    {/* Logo - Navbar Size */}
                    <BrandLogo size="medium" theme="dark" />
                </div>

                {/* GitHub Link at Bottom */}
                <a
                    href="https://github.com/alyboii"
                    target="_blank"
                    rel="noopener noreferrer"
                    style={{
                        display: "flex",
                        alignItems: "center",
                        gap: "0.5rem",
                        color: "rgba(255,255,255,0.7)",
                        fontSize: "0.75rem",
                        textDecoration: "none",
                        transition: "color 0.2s",
                    }}
                    onMouseEnter={(e) => (e.currentTarget.style.color = "#fff")}
                    onMouseLeave={(e) => (e.currentTarget.style.color = "rgba(255,255,255,0.7)")}
                >
                    <GitHubIcon size={16} />
                    <span>alyboii</span>
                </a>
            </aside>

            {/* Main Content - Beige */}
            <main
                style={{
                    flex: 1,
                    marginLeft: "200px",
                    minHeight: "100vh",
                    backgroundColor: "#D4A574",
                    padding: "2rem",
                }}
            >
                <div
                    style={{
                        display: "grid",
                        gridTemplateColumns: "repeat(auto-fill, minmax(300px, 1fr))",
                        gap: "1.5rem",
                    }}
                >
                    {products.map((product) => (
                        <Link
                            key={product.id}
                            href={`/work/${product.slug}`}
                            style={{ textDecoration: "none" }}
                        >
                            <div
                                style={{
                                    backgroundColor: "#C4956A",
                                    padding: "1rem",
                                    display: "flex",
                                    flexDirection: "column",
                                    gap: "0.75rem",
                                    position: "relative",
                                    cursor: "pointer",
                                    transition: "transform 0.2s, box-shadow 0.2s",
                                }}
                                className="product-card"
                            >
                                {/* Status Badge */}
                                {product.status && (
                                    <span
                                        style={{
                                            position: "absolute",
                                            top: "1.5rem",
                                            left: "1.5rem",
                                            backgroundColor: "#FF6B00",
                                            color: "#fff",
                                            padding: "0.25rem 0.75rem",
                                            fontSize: "0.75rem",
                                            fontWeight: 600,
                                            textTransform: "uppercase",
                                            zIndex: 1,
                                        }}
                                    >
                                        {product.status}
                                    </span>
                                )}

                                {/* Product Image */}
                                <div
                                    style={{
                                        position: "relative",
                                        aspectRatio: "1",
                                        backgroundColor: "#B8956A",
                                        overflow: "hidden",
                                    }}
                                >
                                    <Image
                                        src={product.image}
                                        alt={product.title}
                                        fill
                                        style={{ objectFit: "cover" }}
                                    />
                                </div>

                                {/* Product Title */}
                                <h3
                                    style={{
                                        fontSize: "0.875rem",
                                        fontWeight: 600,
                                        textAlign: "center",
                                        color: "#000",
                                        textTransform: "uppercase",
                                        letterSpacing: "0.05em",
                                    }}
                                >
                                    {product.title}
                                </h3>
                            </div>
                        </Link>
                    ))}
                </div>
            </main>

            <style jsx>{`
        @media (max-width: 768px) {
          aside {
            width: 100% !important;
            position: relative !important;
            min-height: auto !important;
            padding: 1rem !important;
            flex-direction: row !important;
            justify-content: space-between !important;
            align-items: center !important;
          }
          main {
            margin-left: 0 !important;
          }
        }
        .product-card:hover {
          transform: translateY(-4px);
          box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
      `}</style>
        </div>
    );
}

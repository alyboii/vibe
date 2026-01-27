"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import Image from "next/image";
import { LoadingScreen } from "@/components/LoadingScreen";
import { BrandLogo } from "@/components/BrandLogo";

export default function HomePage() {
  const [loading, setLoading] = useState(true);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    // Check if already loaded in this session
    const hasLoaded = sessionStorage.getItem("site-loaded");
    if (hasLoaded) {
      setLoading(false);
    }
    setMounted(true);
  }, []);

  const handleLoadingComplete = () => {
    setLoading(false);
    sessionStorage.setItem("site-loaded", "true");
  };

  return (
    <>
      {loading && <LoadingScreen onComplete={handleLoadingComplete} />}

      <div
        style={{
          minHeight: "100vh",
          backgroundImage: "url('/images/hero-bg.jpg')",
          backgroundSize: "cover",
          backgroundPosition: "center",
          backgroundRepeat: "no-repeat",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          padding: "2rem",
          position: "relative",
          opacity: loading ? 0 : 1,
          transition: "opacity 0.5s ease",
        }}
      >
        {/* Content */}
        <div
          style={{
            position: "relative",
            zIndex: 1,
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
          }}
        >
          {/* Hero Logo */}
          <div
            style={{
              marginBottom: "3rem",
            }}
            className={mounted && !loading ? "fade-in" : ""}
          >
            <BrandLogo size="hero" linkToHome={false} theme="dark" />
          </div>

          {/* Navigation Links */}
          <nav
            style={{
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              gap: "1rem",
            }}
          >
            <Link
              href="/work"
              style={{
                fontSize: "1.25rem",
                fontWeight: 700,
                letterSpacing: "0.3em",
                textTransform: "uppercase",
                color: "#fff",
                textDecoration: "none",
                padding: "0.75rem 2rem",
                backgroundColor: "rgba(0,0,0,0.7)",
                transition: "all 0.2s ease",
                textShadow: "1px 1px 2px #000",
              }}
              className="nav-link"
            >
              Enter
            </Link>
            <Link
              href="/contact"
              style={{
                fontSize: "1.25rem",
                fontWeight: 700,
                letterSpacing: "0.3em",
                textTransform: "uppercase",
                color: "#fff",
                textDecoration: "none",
                padding: "0.75rem 2rem",
                backgroundColor: "rgba(0,0,0,0.7)",
                transition: "all 0.2s ease",
                textShadow: "1px 1px 2px #000",
              }}
              className="nav-link"
            >
              Contact
            </Link>
          </nav>
        </div>

        <style jsx>{`
          .fade-in {
            animation: fadeIn 1s ease forwards;
          }
          @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
          }
          .nav-link:hover {
            background-color: #FF6B00 !important;
            transform: scale(1.05);
          }
        `}</style>
      </div>
    </>
  );
}

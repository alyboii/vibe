"use client";

import Link from "next/link";
import Image from "next/image";

interface LogoProps {
    variant?: "dark" | "light";
    width?: number;
    height?: number;
    className?: string;
    linkToHome?: boolean;
}

export function Logo({
    variant = "dark",
    width = 150,
    height = 60,
    className = "",
    linkToHome = true
}: LogoProps) {
    // Use the fire-style logo we have
    const logoSrc = "/images/logo.png";

    const logoImage = (
        <Image
            src={logoSrc}
            alt="harman.labs logo"
            width={width}
            height={height}
            style={{
                width: "100%",
                height: "auto",
                maxWidth: width,
                // Add glow effect for light backgrounds
                filter: variant === "light" ? "drop-shadow(0 0 8px rgba(0,0,0,0.3))" : "drop-shadow(0 0 8px rgba(255,107,0,0.3))",
            }}
            priority
            className={className}
        />
    );

    if (linkToHome) {
        return (
            <Link href="/" style={{ display: "inline-block" }}>
                {logoImage}
            </Link>
        );
    }

    return logoImage;
}

"use client";

import Link from "next/link";
import Image from "next/image";
import { useState, useCallback } from "react";
import { useRouter } from "next/navigation";

type LogoSize = "small" | "medium" | "large" | "hero";

interface BrandLogoProps {
    size?: LogoSize;
    linkToHome?: boolean;
    className?: string;
    theme?: "dark" | "light" | "auto";
    enableEasterEgg?: boolean;
}

const sizeConfig: Record<LogoSize, { mobile: number; desktop: number }> = {
    small: { mobile: 20, desktop: 28 },
    medium: { mobile: 28, desktop: 42 },
    large: { mobile: 36, desktop: 48 },
    hero: { mobile: 60, desktop: 120 },
};

const EASTER_EGG_CLICKS = 7;
const CLICK_TIMEOUT = 2000; // Reset after 2 seconds of no clicks

export function BrandLogo({
    size = "medium",
    linkToHome = true,
    className = "",
    theme = "auto",
    enableEasterEgg = true,
}: BrandLogoProps) {
    const router = useRouter();
    const [clickCount, setClickCount] = useState(0);
    const [lastClickTime, setLastClickTime] = useState(0);
    const { mobile, desktop } = sizeConfig[size];

    const aspectRatio = 3;
    const mobileWidth = mobile * aspectRatio;
    const desktopWidth = desktop * aspectRatio;

    const getFilter = () => {
        switch (theme) {
            case "dark":
                return "drop-shadow(0 0 12px rgba(255,255,255,0.2)) drop-shadow(0 2px 8px rgba(0,0,0,0.3))";
            case "light":
                return "drop-shadow(0 2px 10px rgba(0,0,0,0.25))";
            default:
                return "drop-shadow(0 2px 8px rgba(0,0,0,0.2))";
        }
    };

    const handleClick = useCallback((e: React.MouseEvent) => {
        if (!enableEasterEgg) return;

        const now = Date.now();

        // Reset if too much time passed
        if (now - lastClickTime > CLICK_TIMEOUT) {
            setClickCount(1);
        } else {
            setClickCount((prev) => prev + 1);
        }

        setLastClickTime(now);

        // Check for easter egg
        if (clickCount + 1 >= EASTER_EGG_CLICKS) {
            e.preventDefault();
            e.stopPropagation();

            // Visual feedback
            document.body.style.transition = "filter 0.3s";
            document.body.style.filter = "hue-rotate(180deg)";

            setTimeout(() => {
                document.body.style.filter = "";
                router.push("/vault");
            }, 300);

            setClickCount(0);
        }
    }, [clickCount, lastClickTime, enableEasterEgg, router]);

    const logoImage = (
        <div onClick={handleClick} style={{ cursor: enableEasterEgg ? "pointer" : undefined }}>
            <Image
                src="/brand/harman-labs-logo.png"
                alt="harman.labs logo"
                width={desktopWidth}
                height={desktop}
                style={{
                    height: "auto",
                    width: "auto",
                    maxHeight: desktop,
                    filter: getFilter(),
                    transition: "filter 0.2s, transform 0.1s",
                    transform: clickCount > 0 ? `scale(${1 + clickCount * 0.02})` : "scale(1)",
                }}
                className={className}
                priority
            />
        </div>
    );

    if (linkToHome && !enableEasterEgg) {
        return (
            <Link
                href="/"
                style={{
                    display: "inline-flex",
                    alignItems: "center",
                    textDecoration: "none",
                }}
                aria-label="Go to home page"
            >
                {logoImage}
            </Link>
        );
    }

    // When easter egg is enabled, clicking goes to vault after 7 clicks
    // Single click still navigates home
    if (linkToHome && enableEasterEgg) {
        return (
            <div
                onClick={(e) => {
                    if (clickCount < EASTER_EGG_CLICKS - 1) {
                        // Only navigate home on first click if not doing easter egg
                        if (clickCount === 0) {
                            // Don't navigate, just count
                        }
                    }
                    handleClick(e);
                }}
                style={{
                    display: "inline-flex",
                    alignItems: "center",
                    cursor: "pointer",
                }}
            >
                {logoImage}
            </div>
        );
    }

    return logoImage;
}

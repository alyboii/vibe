"use client";

import Image from "next/image";

interface Screenshot {
    src: string;
    alt: string;
}

interface VerticalGalleryProps {
    screenshots: Screenshot[];
}

export function VerticalGallery({ screenshots }: VerticalGalleryProps) {
    return (
        <div
            style={{
                display: "flex",
                flexDirection: "column",
                gap: "1rem",
            }}
        >
            {screenshots.map((screenshot, index) => (
                <div
                    key={index}
                    style={{
                        position: "relative",
                        width: "100%",
                        aspectRatio: "1",
                        backgroundColor: "#C4956A",
                        borderRadius: "4px",
                        overflow: "hidden",
                    }}
                >
                    <Image
                        src={screenshot.src}
                        alt={screenshot.alt}
                        fill
                        style={{ objectFit: "cover" }}
                        priority={index === 0}
                    />
                </div>
            ))}
        </div>
    );
}

"use client";

import { useCallback, useEffect, useState } from "react";
import useEmblaCarousel from "embla-carousel-react";
import Image from "next/image";

interface Screenshot {
    src: string;
    alt: string;
}

interface CarouselProps {
    screenshots: Screenshot[];
}

export function ScreenshotCarousel({ screenshots }: CarouselProps) {
    const [emblaRef, emblaApi] = useEmblaCarousel({ loop: true });
    const [selectedIndex, setSelectedIndex] = useState(0);

    const scrollPrev = useCallback(() => {
        if (emblaApi) emblaApi.scrollPrev();
    }, [emblaApi]);

    const scrollNext = useCallback(() => {
        if (emblaApi) emblaApi.scrollNext();
    }, [emblaApi]);

    const scrollTo = useCallback(
        (index: number) => {
            if (emblaApi) emblaApi.scrollTo(index);
        },
        [emblaApi]
    );

    const onSelect = useCallback(() => {
        if (!emblaApi) return;
        setSelectedIndex(emblaApi.selectedScrollSnap());
    }, [emblaApi]);

    useEffect(() => {
        if (!emblaApi) return;
        onSelect();
        emblaApi.on("select", onSelect);
        return () => {
            emblaApi.off("select", onSelect);
        };
    }, [emblaApi, onSelect]);

    return (
        <div style={{ position: "relative" }}>
            {/* Carousel Container */}
            <div
                ref={emblaRef}
                style={{
                    overflow: "hidden",
                    borderRadius: "8px",
                    backgroundColor: "#C4956A",
                }}
            >
                <div style={{ display: "flex" }}>
                    {screenshots.map((screenshot, index) => (
                        <div
                            key={index}
                            style={{
                                flex: "0 0 100%",
                                minWidth: 0,
                                position: "relative",
                                aspectRatio: "3/4",
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
            </div>

            {/* Navigation Arrows */}
            <button
                onClick={scrollPrev}
                style={{
                    position: "absolute",
                    left: "10px",
                    top: "50%",
                    transform: "translateY(-50%)",
                    width: "40px",
                    height: "40px",
                    borderRadius: "50%",
                    backgroundColor: "rgba(0,0,0,0.5)",
                    border: "none",
                    color: "#fff",
                    cursor: "pointer",
                    fontSize: "1.25rem",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                }}
                aria-label="Previous"
            >
                ‹
            </button>
            <button
                onClick={scrollNext}
                style={{
                    position: "absolute",
                    right: "10px",
                    top: "50%",
                    transform: "translateY(-50%)",
                    width: "40px",
                    height: "40px",
                    borderRadius: "50%",
                    backgroundColor: "rgba(0,0,0,0.5)",
                    border: "none",
                    color: "#fff",
                    cursor: "pointer",
                    fontSize: "1.25rem",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                }}
                aria-label="Next"
            >
                ›
            </button>

            {/* Dot Indicators */}
            <div
                style={{
                    display: "flex",
                    justifyContent: "center",
                    gap: "8px",
                    marginTop: "1rem",
                }}
            >
                {screenshots.map((_, index) => (
                    <button
                        key={index}
                        onClick={() => scrollTo(index)}
                        style={{
                            width: "10px",
                            height: "10px",
                            borderRadius: "50%",
                            backgroundColor: selectedIndex === index ? "#FF6B00" : "#ccc",
                            border: "none",
                            cursor: "pointer",
                            transition: "background-color 0.2s",
                        }}
                        aria-label={`Go to slide ${index + 1}`}
                    />
                ))}
            </div>
        </div>
    );
}

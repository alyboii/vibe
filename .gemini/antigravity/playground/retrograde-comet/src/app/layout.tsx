import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { AudioPlayer } from "@/components/AudioPlayer";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

export const metadata: Metadata = {
  title: "harman.labs",
  description: "Dijital Ürün Mühendisliği",
  icons: {
    icon: "/icon.png",
    apple: "/icon.png",
  },
  openGraph: {
    title: "harman.labs",
    description: "Dijital Ürün Mühendisliği",
    url: "https://harman.labs",
    siteName: "harman.labs",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "harman.labs",
    description: "Dijital Ürün Mühendisliği",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="tr">
      <body className={`${inter.variable}`} style={{ margin: 0, padding: 0 }}>
        {children}
        <AudioPlayer />
      </body>
    </html>
  );
}

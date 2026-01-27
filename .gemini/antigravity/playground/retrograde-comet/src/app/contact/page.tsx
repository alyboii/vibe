"use client";

import { useState } from "react";
import Link from "next/link";
import { BrandLogo } from "@/components/BrandLogo";

export default function ContactPage() {
    const [formData, setFormData] = useState({
        firstName: "",
        lastName: "",
        email: "",
        orderNumber: "",
        subject: "",
        message: "",
    });
    const [sent, setSent] = useState(false);

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        setSent(true);
    };

    const inputStyle = {
        padding: "1rem",
        fontSize: "1rem",
        backgroundColor: "#fff",
        border: "1px solid #000",
        color: "#000",
        outline: "none",
        width: "100%",
    };

    return (
        <div
            style={{
                minHeight: "100vh",
                backgroundColor: "#000",
                color: "#fff",
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                padding: "3rem 2rem",
            }}
        >
            {/* Logo */}
            <div style={{ marginBottom: "4rem" }}>
                <BrandLogo size="hero" linkToHome={true} theme="dark" />
            </div>

            {/* Form Container */}
            <div style={{ width: "100%", maxWidth: "700px" }}>
                {sent ? (
                    <div style={{ textAlign: "center" }}>
                        <p style={{ fontSize: "1.25rem", marginBottom: "2rem" }}>
                            Message sent. Thank you.
                        </p>
                        <Link
                            href="/"
                            style={{
                                color: "#fff",
                                textDecoration: "underline",
                                fontSize: "0.875rem",
                            }}
                        >
                            Back Home
                        </Link>
                    </div>
                ) : (
                    <form onSubmit={handleSubmit}>
                        {/* Row 1: First Name / Last Name */}
                        <div
                            style={{
                                display: "grid",
                                gridTemplateColumns: "1fr 1fr",
                                gap: "1rem",
                                marginBottom: "1rem",
                            }}
                        >
                            <input
                                type="text"
                                placeholder="First Name"
                                required
                                value={formData.firstName}
                                onChange={(e) => setFormData({ ...formData, firstName: e.target.value })}
                                style={inputStyle}
                            />
                            <input
                                type="text"
                                placeholder="Last Name"
                                required
                                value={formData.lastName}
                                onChange={(e) => setFormData({ ...formData, lastName: e.target.value })}
                                style={inputStyle}
                            />
                        </div>

                        {/* Row 2: Email / Order Number */}
                        <div
                            style={{
                                display: "grid",
                                gridTemplateColumns: "1fr 1fr",
                                gap: "1rem",
                                marginBottom: "1rem",
                            }}
                        >
                            <input
                                type="email"
                                placeholder="Email Address"
                                required
                                value={formData.email}
                                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                                style={inputStyle}
                            />
                            <input
                                type="text"
                                placeholder="Order Number"
                                value={formData.orderNumber}
                                onChange={(e) => setFormData({ ...formData, orderNumber: e.target.value })}
                                style={inputStyle}
                            />
                        </div>

                        {/* Row 3: Subject */}
                        <div style={{ marginBottom: "1rem" }}>
                            <input
                                type="text"
                                placeholder="Subject"
                                required
                                value={formData.subject}
                                onChange={(e) => setFormData({ ...formData, subject: e.target.value })}
                                style={inputStyle}
                            />
                        </div>

                        {/* Row 4: Message */}
                        <div style={{ marginBottom: "2rem" }}>
                            <textarea
                                placeholder="Message"
                                required
                                rows={6}
                                value={formData.message}
                                onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                                style={{
                                    ...inputStyle,
                                    resize: "vertical",
                                    minHeight: "150px",
                                }}
                            />
                        </div>

                        {/* Actions: Back Home / Send */}
                        <div
                            style={{
                                display: "flex",
                                justifyContent: "space-between",
                                alignItems: "center",
                            }}
                        >
                            <Link
                                href="/"
                                style={{
                                    color: "#fff",
                                    textDecoration: "none",
                                    fontSize: "0.875rem",
                                    padding: "0.5rem 0",
                                }}
                            >
                                Back Home
                            </Link>
                            <button
                                type="submit"
                                style={{
                                    background: "none",
                                    border: "none",
                                    color: "#fff",
                                    fontSize: "0.875rem",
                                    cursor: "pointer",
                                    padding: "0.5rem 0",
                                }}
                            >
                                Send
                            </button>
                        </div>
                    </form>
                )}
            </div>
        </div>
    );
}

export type Locale = "tr" | "en";

export type TranslationKey = string;

export const translations = {
    tr: {
        nav: {
            home: "Ana Sayfa",
            services: "Hizmetler",
            work: "Projeler",
            about: "Hakkımızda",
            careers: "Kariyer",
            blog: "Blog",
            contact: "İletişim",
        },
        hero: {
            tagline: "Dijital Ürün Mühendisliği",
            description:
                "Yazılım, yapay zeka ve veri ile geleceğin ürünlerini inşa ediyoruz.",
        },
        manifesto: {
            title: "Ne İnşa Ediyoruz?",
            text: "Karmaşık problemlere zarif çözümler sunuyoruz. Kod yazıyoruz, ama asıl yaptığımız fark yaratmak. Her projede mühendislik mükemmelliğini sanat ile buluşturuyoruz. Sade, işlevsel, zamansız.",
        },
        services: {
            title: "Hizmetlerimiz",
            subtitle: "İhtiyaçlarınıza özel çözümler",
            viewAll: "Tümünü Gör",
            categories: {
                product: {
                    title: "Ürün Mühendisliği",
                    description: "Ölçeklenebilir, sürdürülebilir yazılım çözümleri",
                },
                ai: {
                    title: "Yapay Zeka & ML",
                    description: "Akıllı sistemler ve makine öğrenmesi çözümleri",
                },
                data: {
                    title: "Veri Mühendisliği",
                    description: "Veri altyapısı, analitik ve görselleştirme",
                },
                cloud: {
                    title: "Bulut Çözümleri",
                    description: "Modern bulut mimarisi ve DevOps",
                },
                design: {
                    title: "Tasarım Sistemleri",
                    description: "Tutarlı, ölçeklenebilir UI/UX sistemleri",
                },
                consulting: {
                    title: "Teknik Danışmanlık",
                    description: "Strateji, mimari ve kod incelemeleri",
                },
            },
        },
        work: {
            title: "Projeler",
            subtitle: "Seçilmiş çalışmalarımız",
            viewAll: "Tümünü Gör",
            filters: {
                all: "Tümü",
                fintech: "Fintech",
                healthcare: "Sağlık",
                ecommerce: "E-Ticaret",
                saas: "SaaS",
            },
            cta: "Detayları Gör",
        },
        caseStudy: {
            context: "Bağlam",
            challenge: "Zorluk",
            solution: "Çözüm",
            impact: "Etki",
            stack: "Teknoloji Yığını",
            backToWork: "Projelere Dön",
        },
        trustedBy: {
            title: "Güvenilen Ortaklarımız",
        },
        about: {
            title: "Hakkımızda",
            story: {
                title: "Hikayemiz",
                text: "harman.labs, mühendislik tutkusu ve tasarım hassasiyetini bir araya getiren bir dijital ürün stüdyosudur. 2020'den bu yana startuplardan kurumsal şirketlere kadar geniş bir yelpazede müşterilerimizle çalışıyoruz.",
            },
            principles: {
                title: "İlkelerimiz",
                items: [
                    {
                        title: "Mühendislik Mükemmelliği",
                        text: "Kod kalitesinden asla ödün vermeyiz.",
                    },
                    {
                        title: "Şeffaflık",
                        text: "Her aşamada açık iletişim kurarız.",
                    },
                    {
                        title: "Sürdürülebilirlik",
                        text: "Uzun vadeli düşünür, ölçeklenebilir çözümler üretiriz.",
                    },
                    {
                        title: "İnovasyon",
                        text: "Yeni teknolojileri araştırır ve uygularız.",
                    },
                ],
            },
            team: {
                title: "Ekip",
                text: "Deneyimli mühendisler, tasarımcılar ve strateji uzmanlarından oluşan ekibimiz.",
            },
            howWeWork: {
                title: "Nasıl Çalışıyoruz?",
                steps: [
                    {
                        title: "Keşif",
                        text: "İhtiyaçlarınızı anlar, hedeflerinizi belirleriz.",
                    },
                    {
                        title: "Strateji",
                        text: "Çözüm yol haritası ve mimari tasarım.",
                    },
                    {
                        title: "Uygulama",
                        text: "Agile metodolojilerle iteratif geliştirme.",
                    },
                    {
                        title: "Teslimat",
                        text: "Kalite güvencesi ve sürekli destek.",
                    },
                ],
            },
        },
        careers: {
            title: "Kariyer",
            subtitle: "Geleceği birlikte inşa edelim",
            noOpenings: "Şu anda açık pozisyon bulunmuyor.",
            openPositions: "Açık Pozisyonlar",
            apply: "Başvur",
            backToCareers: "Kariyer Sayfasına Dön",
            location: "Konum",
            type: "Çalışma Şekli",
            remote: "Uzaktan",
            hybrid: "Hibrit",
            onsite: "Ofis",
        },
        blog: {
            title: "Blog",
            subtitle: "Düşünceler, içgörüler ve haberler",
            readMore: "Devamını Oku",
            backToBlog: "Blog'a Dön",
            published: "Yayınlandı",
            readTime: "dk okuma",
        },
        contact: {
            title: "İletişim",
            subtitle: "Konuşalım",
            description:
                "Yeni bir proje mi planlıyorsunuz? Birlikte neler yapabileceğimizi konuşalım.",
            form: {
                name: "Adınız",
                email: "E-posta",
                company: "Şirket (İsteğe bağlı)",
                message: "Mesajınız",
                submit: "Gönder",
                sending: "Gönderiliyor...",
                success: "Mesajınız gönderildi. En kısa sürede dönüş yapacağız.",
                error: "Bir hata oluştu. Lütfen tekrar deneyin.",
            },
            social: {
                title: "Sosyal Medya",
            },
            email: "merhaba@harman.labs",
        },
        footer: {
            tagline: "Dijital ürün mühendisliği.",
            copyright: "© 2024 harman.labs. Tüm hakları saklıdır.",
            newsletter: {
                title: "Bülten",
                placeholder: "E-posta adresiniz",
                subscribe: "Abone Ol",
            },
        },
        common: {
            loading: "Yükleniyor...",
            error: "Bir hata oluştu",
            notFound: "Sayfa bulunamadı",
            backHome: "Ana Sayfaya Dön",
            learnMore: "Daha Fazla",
        },
    },
    en: {
        nav: {
            home: "Home",
            services: "Services",
            work: "Work",
            about: "About",
            careers: "Careers",
            blog: "Blog",
            contact: "Contact",
        },
        hero: {
            tagline: "Digital Product Engineering",
            description:
                "We build the products of tomorrow with software, AI, and data.",
        },
        manifesto: {
            title: "What Do We Build?",
            text: "We deliver elegant solutions to complex problems. We write code, but what we really do is make a difference. In every project, we merge engineering excellence with artistry. Simple, functional, timeless.",
        },
        services: {
            title: "Our Services",
            subtitle: "Tailored solutions for your needs",
            viewAll: "View All",
            categories: {
                product: {
                    title: "Product Engineering",
                    description: "Scalable, sustainable software solutions",
                },
                ai: {
                    title: "AI & Machine Learning",
                    description: "Intelligent systems and ML solutions",
                },
                data: {
                    title: "Data Engineering",
                    description: "Data infrastructure, analytics, and visualization",
                },
                cloud: {
                    title: "Cloud Solutions",
                    description: "Modern cloud architecture and DevOps",
                },
                design: {
                    title: "Design Systems",
                    description: "Consistent, scalable UI/UX systems",
                },
                consulting: {
                    title: "Technical Consulting",
                    description: "Strategy, architecture, and code reviews",
                },
            },
        },
        work: {
            title: "Work",
            subtitle: "Selected projects",
            viewAll: "View All",
            filters: {
                all: "All",
                fintech: "Fintech",
                healthcare: "Healthcare",
                ecommerce: "E-Commerce",
                saas: "SaaS",
            },
            cta: "View Details",
        },
        caseStudy: {
            context: "Context",
            challenge: "Challenge",
            solution: "Solution",
            impact: "Impact",
            stack: "Tech Stack",
            backToWork: "Back to Work",
        },
        trustedBy: {
            title: "Trusted By",
        },
        about: {
            title: "About Us",
            story: {
                title: "Our Story",
                text: "harman.labs is a digital product studio that combines engineering passion with design precision. Since 2020, we've worked with clients ranging from startups to enterprise companies.",
            },
            principles: {
                title: "Our Principles",
                items: [
                    {
                        title: "Engineering Excellence",
                        text: "We never compromise on code quality.",
                    },
                    {
                        title: "Transparency",
                        text: "Open communication at every stage.",
                    },
                    {
                        title: "Sustainability",
                        text: "We think long-term, build scalable solutions.",
                    },
                    {
                        title: "Innovation",
                        text: "We research and apply new technologies.",
                    },
                ],
            },
            team: {
                title: "Team",
                text: "Our team of experienced engineers, designers, and strategists.",
            },
            howWeWork: {
                title: "How We Work",
                steps: [
                    {
                        title: "Discovery",
                        text: "Understanding your needs, defining goals.",
                    },
                    {
                        title: "Strategy",
                        text: "Solution roadmap and architecture design.",
                    },
                    {
                        title: "Implementation",
                        text: "Iterative development with agile methodologies.",
                    },
                    {
                        title: "Delivery",
                        text: "Quality assurance and ongoing support.",
                    },
                ],
            },
        },
        careers: {
            title: "Careers",
            subtitle: "Let's build the future together",
            noOpenings: "No open positions at the moment.",
            openPositions: "Open Positions",
            apply: "Apply",
            backToCareers: "Back to Careers",
            location: "Location",
            type: "Work Type",
            remote: "Remote",
            hybrid: "Hybrid",
            onsite: "On-site",
        },
        blog: {
            title: "Blog",
            subtitle: "Thoughts, insights, and news",
            readMore: "Read More",
            backToBlog: "Back to Blog",
            published: "Published",
            readTime: "min read",
        },
        contact: {
            title: "Contact",
            subtitle: "Let's Talk",
            description:
                "Planning a new project? Let's discuss what we can build together.",
            form: {
                name: "Your Name",
                email: "Email",
                company: "Company (Optional)",
                message: "Your Message",
                submit: "Send",
                sending: "Sending...",
                success: "Your message has been sent. We'll get back to you soon.",
                error: "An error occurred. Please try again.",
            },
            social: {
                title: "Social Media",
            },
            email: "hello@harman.labs",
        },
        footer: {
            tagline: "Digital product engineering.",
            copyright: "© 2024 harman.labs. All rights reserved.",
            newsletter: {
                title: "Newsletter",
                placeholder: "Your email address",
                subscribe: "Subscribe",
            },
        },
        common: {
            loading: "Loading...",
            error: "An error occurred",
            notFound: "Page not found",
            backHome: "Back to Home",
            learnMore: "Learn More",
        },
    },
} as const;

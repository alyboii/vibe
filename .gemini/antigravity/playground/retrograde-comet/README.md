# harman.labs

Minimalist, music-enabled website for harman.labs.

## Quick Start

```bash
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000)

---

## 🎨 Brand Logo

### Location
- **Primary logo:** `public/brand/harman-labs-logo.png`

### How to Replace Logo
1. Replace `public/brand/harman-labs-logo.png` with your new logo
2. **Requirements:**
   - PNG format with transparent background (alpha channel)
   - Recommended resolution: 600x200px minimum for crisp retina display
   - Aspect ratio: ~3:1 (width:height)

### BrandLogo Component
Located at: `src/components/BrandLogo.tsx`

```tsx
import { BrandLogo } from "@/components/BrandLogo";

// Navbar (medium - 28-42px height)
<BrandLogo size="medium" theme="dark" />

// Footer (small - 20-28px height)
<BrandLogo size="small" theme="dark" />

// Hero section (hero - 60-120px height)
<BrandLogo size="hero" theme="dark" linkToHome={false} />

// Without home link
<BrandLogo size="medium" linkToHome={false} />
```

### Size Options
| Size | Mobile Height | Desktop Height |
|------|---------------|----------------|
| small | 20px | 28px |
| medium | 28px | 42px |
| large | 36px | 48px |
| hero | 60px | 120px |

### Theme Options (CSS Effects)
- `dark`: Light glow for dark backgrounds
- `light`: Dark shadow for light backgrounds
- `auto`: Neutral shadow (works on most backgrounds)

---

## 🎵 Background Music

### Location
- Default track: `public/audio/bg.mp3`
- Online fallbacks: Pixabay CDN URLs

### How to Swap Music
1. Place your audio file at `public/audio/bg.mp3`
2. Update credits in `src/components/AudioPlayer.tsx`

### Features
- ✅ No autoplay - starts only after user interaction
- ✅ Persistent mini player (bottom-right)
- ✅ Play/Pause, Mute, Volume slider
- ✅ Preferences saved to localStorage
- ✅ Multiple track options

### Music Sources (Copyright-Safe)
- [Pixabay Music](https://pixabay.com/music/) - Free for commercial use
- [YouTube Audio Library](https://studio.youtube.com/channel/audio)

---

## 📝 Credits

### Where to Edit
- **Music credits:** `src/components/AudioPlayer.tsx` (sounds array)
- **Footer display:** `src/components/Footer.tsx`

---

## 📁 Project Structure

```
public/
├── brand/
│   └── harman-labs-logo.png   # Main brand logo (transparent PNG)
├── images/
│   ├── hero-bg.jpg            # Homepage background
│   └── fake-it.png            # Product image
└── audio/
    └── bg.mp3                 # Background music (optional)

src/
├── app/
│   ├── page.tsx               # Homepage (hero logo)
│   ├── work/page.tsx          # Products (navbar logo)
│   └── contact/page.tsx       # Contact (navbar logo + footer)
└── components/
    ├── BrandLogo.tsx          # Reusable logo component
    ├── Footer.tsx             # Footer with logo + credits
    └── AudioPlayer.tsx        # Music player
```

---

## 🚀 Deployment

```bash
npm run build
npm start
```

---

## License

Private - All rights reserved.

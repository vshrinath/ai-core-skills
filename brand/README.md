# Brand Assets

This folder contains brand identity files that marketing skills reference.

## Structure

```
brand/
├── brand-template.md    # Template for your brand guide
├── assets/              # Brand assets (logos, images, etc.)
│   ├── logo.svg
│   ├── logo-dark.svg
│   ├── favicon.ico
│   ├── favicon.svg
│   └── og-default.png
└── README.md
```

## Setup

1. Copy `brand-template.md` to `brand/brand.md`
2. Replace all bracketed placeholders with your brand details
3. Add your brand assets to `brand/assets/`

## Required Assets

- **logo.svg** - Primary logo (SVG format)
- **logo-dark.svg** - Logo variant for dark backgrounds (optional)
- **favicon.ico** - Standard favicon (16x16, 32x32, 48x48)
- **favicon.svg** - Modern SVG favicon
- **og-default.png** - Default Open Graph image (1200×630px)

## Usage

Marketing skills (`@video`, `@video-ai`, `@writer`, `@seo`, `@perf`) automatically reference `brand/brand.md` for:
- Voice and tone guidelines
- Visual identity (colors, typography)
- Audience characteristics
- Content pillars
- Platform presence

## Example

```bash
# Copy template
cp brand/brand-template.md brand/brand.md

# Edit with your brand details
# Add your assets to brand/assets/

# Marketing skills will now use your brand guide
```

## Notes

- Keep `brand-template.md` as reference
- Commit `brand/brand.md` to your project repository
- Update `brand/brand.md` when brand guidelines change
- Marketing skills read this file automatically - no need to reference it explicitly

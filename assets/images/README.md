# Assets Directory

This directory contains all the image assets for the Aurame Beauty App.

## Directory Structure

```
assets/images/
├── icons/          # App icons and small graphics
├── logos/          # App logo variations
├── onboarding/     # Onboarding screen images
├── banners/        # Promotional banners
└── README.md       # This file
```

## Asset Guidelines

### Icons (`icons/`)
- Use PNG format for better transparency support
- Recommend sizes: 24x24, 32x32, 48x48, 64x64
- Use consistent styling and color scheme

### Logos (`logos/`)
- App logo in various formats (PNG, SVG)
- Different variations: light, dark, mono
- Sizes: 128x128, 256x256, 512x512

### Onboarding (`onboarding/`)
- Illustrations for onboarding screens
- High quality PNG or SVG
- Consistent art style

### Banners (`banners/`)
- Promotional images for home screen
- Aspect ratio: 16:9 or 3:2
- High resolution for different screen densities

## Asset Naming Convention

Use descriptive names with underscores:
- `app_logo_light.png`
- `onboarding_welcome.png`
- `icon_search_24.png`
- `banner_special_offer.jpg`

## Optimization

- Compress images to reduce app size
- Use appropriate formats (PNG for transparency, JPG for photos)
- Consider using SVG for scalable graphics
- Use `flutter_svg` package for SVG support

## Adding Assets

1. Place image files in appropriate subdirectories
2. Update `pubspec.yaml` asset declarations if needed
3. Reference assets in code using full path: `assets/images/icons/app_icon.png`
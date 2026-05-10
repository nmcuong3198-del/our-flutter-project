# Design System Documentation: The Gentle Guardian

## 1. Overview & Creative North Star
This design system is built upon the **"Gentle Guardian"** philosophy. In the crowded space of childcare apps, we move away from "infantile" aesthetics and "generic" SaaS templates. Instead, we embrace a high-end editorial approach that balances the clinical precision of pediatric nutrition with the warmth of a modern home.

### The Creative North Star: "Soft Precision"
The interface should feel like a premium physical journal—tactile, breathable, and authoritative. We break the rigid grid through intentional asymmetry and high-contrast typography scales. We replace harsh containment lines with "tonal zones," creating a sense of flow that reduces cognitive load for busy parents. This is not just a tool; it is a sophisticated digital companion.

---

## 2. Colors: Tonal Architecture
We utilize a palette that evokes trust through deep blues and energy through vibrant ochre.

### The Palette
*   **Primary Anchor:** `primary` (#003e74) and `primary_container` (#1A5694). Use these for high-authority elements and core navigation.
*   **Secondary Atmosphere:** `secondary_container` (#d3e2ed). This light blue provides the "breath" between content blocks.
*   **Tertiary Vitality:** `tertiary_fixed_dim` (#ffb870). A sophisticated interpretation of orange, used sparingly for CTAs and nutritional highlights.
*   **Surface Logic:** `surface` (#f9f9ff) serves as our canvas, while `surface_container` tiers define our hierarchy.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders for sectioning or containment. Boundaries must be defined solely through background color shifts. For example, a `surface_container_low` card should sit on a `surface` background. If you feel the need to draw a line, you have failed to use your white space or color tokens effectively.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Use the surface-container tiers (Lowest to Highest) to create "nested" depth:
1.  **Level 0 (Background):** `surface`
2.  **Level 1 (Main Content Area):** `surface_container_low`
3.  **Level 2 (Active Cards):** `surface_container_lowest` (White) to provide a soft "pop."

### Signature Textures
Avoid flat, dead colors. Use subtle linear gradients (e.g., transitioning from `primary` to `primary_container` at a 135-degree angle) for main CTAs or hero sections. This adds "visual soul" and a sense of premium light-refraction.

---

## 3. Typography: Editorial Authority
Our type system pairs the geometric clarity of **Inter** with the modern, expressive personality of **Plus Jakarta Sans**.

*   **Display & Headlines:** Use **Plus Jakarta Sans**. These should be bold and large (`display-lg` at 3.5rem). The goal is to feel like a high-end health magazine.
*   **Titles & Body:** Use **Inter**. It provides exceptional legibility for nutritional data and instructions.
*   **Hierarchy as Identity:** By using extreme scale (a huge `display-sm` next to a refined `body-md`), we create an "Editorial Path" for the eye, making the app feel curated rather than cluttered.

---

## 4. Elevation & Depth: Tonal Layering
We do not use shadows to create "3D objects"; we use them to simulate ambient light.

*   **The Layering Principle:** Stacking is the primary method of hierarchy. A `surface_container_highest` element on a `surface_dim` background creates a natural lift without a single pixel of drop shadow.
*   **Ambient Shadows:** When a floating effect is required (e.g., a bottom navigation bar), use extra-diffused shadows.
    *   **Blur:** 24px - 40px
    *   **Opacity:** 4% - 6%
    *   **Color:** Tint the shadow with `on_surface` (a deep navy/grey) rather than pure black to keep the UI "clean."
*   **The "Ghost Border" Fallback:** If a boundary is strictly required for accessibility, use the `outline_variant` token at **15% opacity**. High-contrast, 100% opaque borders are forbidden.
*   **Glassmorphism:** For overlays or "Quick Action" menus, use `surface_container_lowest` with a 70% opacity and a `backdrop-filter: blur(12px)`. This allows the vibrant colors of the app to bleed through, softening the interface.

---

## 5. Components

### Buttons
*   **Primary:** High-gloss. Use `primary` background with a subtle gradient to `primary_container`. Corner radius: `full`.
*   **Secondary:** Glass-style. `secondary_container` background with `on_secondary_container` text.
*   **Tertiary (Highlight):** `tertiary_container` for nutritional alerts or high-priority CTA.

### Cards & Narrative Blocks
*   **Radius:** Always use `lg` (2rem) or `xl` (3rem) for parent containers to evoke a "friendly/soft" feel.
*   **Spacing:** Content within cards must have a minimum of 24px padding.
*   **No Dividers:** Never use horizontal rules. Separate list items using vertical white space or alternating tonal shifts between `surface_container_low` and `surface_container_lowest`.

### Input Fields
*   **State:** Use `surface_container_highest` for the background.
*   **Focus:** Instead of a thick border, use a 2px `surface_tint` "Ghost Border" and a subtle inner glow.
*   **Corners:** `md` (1.5rem) to maintain the "soft" brand language.

### Specialized App Components
*   **Nutrition Progress Rings:** Use `tertiary` for the "active" fill and `secondary_fixed_dim` for the track.
*   **Care Timeline:** Use a thick (4px) soft-blue line (`primary_fixed`) with large, circular `primary` nodes.

---

## 6. Do's and Don'ts

### Do
*   **DO** use whitespace as a functional element. If a screen feels "busy," add 16px of padding between elements rather than adding a divider.
*   **DO** use "Plus Jakarta Sans" for all numerical data to give it a modern, tech-forward feel.
*   **DO** align text to a generous left margin to create a clean, editorial "spine" for the app.

### Don't
*   **DON'T** use pure black (#000000) for text or shadows. Use `on_surface` or `on_background` for a natural, premium look.
*   **DON'T** use sharp corners. Anything under 16px (`DEFAULT`) is too aggressive for a childcare context.
*   **DON'T** crowd the edges. Ensure a minimum "Safe Zone" of 24px from the edge of the mobile screen.
*   **DON'T** use 1px dividers. If you need to separate content, use a background color change or a 12px vertical gap.
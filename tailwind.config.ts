import type { Config } from 'tailwindcss';
import colors from 'tailwindcss/colors';

export default {
  content: ['./app/**/*.{slim,rb}', './app/javascript/**/*.{js,ts}'],

  theme: {
    extend: {
      screens: {
        '3xl': '1920px',
      },

      // TODO: Remove this when Tailwind CSS 3.4 is out
      // https://github.com/tailwindlabs/tailwindcss/pull/11317
      minHeight: {
        dvh: '100dvh',
      },

      transitionProperty: {
        'max-height': 'max-height',
      },

      colors: {
        green: colors.emerald,
        yellow: colors.amber,
        purple: colors.violet,
      },

      typography: {
        DEFAULT: {
          css: {
            a: {
              textUnderlineOffset: 2,
            },
          },
        },
      },
    },
  },

  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/forms'),
  ],
} satisfies Config;

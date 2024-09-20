/* eslint-env node */
require('@rushstack/eslint-patch/modern-module-resolution')

module.exports = {
  root: true,
  extends: [
    'plugin:vue/vue3-essential',
    'eslint:recommended',
    '@vue/eslint-config-prettier/skip-formatting'
  ],
  'vue/no-v-html': 'off',
  'vue/multi-word-component-names': 'off',
  'prettier/prettier': ['error', { endOfLine: 'auto' }],
  'vue/require-default-prop': 'off',
  'no-unused-vars': [
    'warn',
    {
      args: 'after-used',
      ignoreRestSiblings: true,
      destructuredArrayIgnorePattern: '^_',
      argsIgnorePattern: '^_',
      varsIgnorePattern: '^_|(props)'
    }
  ],
  parserOptions: {
    ecmaVersion: 'latest'
  }
}

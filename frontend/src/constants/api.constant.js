export const AUTH_BASE = import.meta.env.VITE_PUBLIC_AUTH_API_URL || 'http://localhost:3000' // Auth URL
export const ADMIN_BASE = import.meta.env.VITE_PUBLIC_API_URL || 'http://localhost:3000' // API URL
export const COUNTRY_BASE =
  import.meta.env.VITE_PUBLIC_COUNTRY_API_URL || 'https://countriesnow.space/api/v0.1'
export const STRIPE_KEY = import.meta.env.VITE_PUBLIC_STRIPE_PUBLISHABLE_KEY
export const STRIPE_TOKEN_API =
  import.meta.env.VITE_STRIPE_TOKEN_API || 'https://api.stripe.com/v1/tokens'
export const STRIPE_PAYMENT_METHOD_API =
  import.meta.env.VITE_STRIPE_PAYMENT_METHOD_API || 'https://api.stripe.com/v1/payment_methods'

/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'utfs.io',
        port: ''
      },
      {
        protocol: 'https',
        hostname: 'api.training-move-intern.madlab.tech',
        port: ''
      },
      {
        protocol: 'https',
        hostname: 'move-project.s3.us-east-1.amazonaws.com',
        port: ''
      }
    ]
  },
  transpilePackages: ['geist']
};

module.exports = nextConfig;

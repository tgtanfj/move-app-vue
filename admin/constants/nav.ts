import { NavItem } from '@/types';

export const navItems: NavItem[] = [
  {
    title: 'Dashboard',
    url: '/dashboard/overview',
    icon: 'dashboard',
    isActive: false,
    items: []
  },
  {
    title: 'User management',
    url: '/dashboard/user-management',
    icon: 'user',
    isActive: false,
    items: []
  },
  {
    title: 'Video management',
    url: '/dashboard/video-management',
    icon: 'product',
    isActive: false,
    items: []
  },
  {
    title: 'Payment management',
    url: '/dashboard/payment-management',
    icon: 'billing',
    isActive: true,

    items: [
      {
        title: 'Payment Management',
        url: '/dashboard/payment-management',
        icon: 'userPen'
      },
      {
        title: 'Withdraw Management',
        url: '/dashboard/withdraw-management',
        icon: 'login'
      },
      {
        title: 'Revenue Management',
        url: '/dashboard/revenue-management',
        icon: 'login'
      }
    ]
  },
  {
    title: 'Content management',
    url: '/dashboard/content-management',
    icon: 'product',
    isActive: false,
    items: []
  }
];

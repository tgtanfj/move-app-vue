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
    url: '#',
    icon: 'billing',
    isActive: true,

    items: [
      {
        title: 'Profile',
        url: '/dashboard/profile',
        icon: 'userPen'
      },
      {
        title: 'Login',
        url: '/',
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

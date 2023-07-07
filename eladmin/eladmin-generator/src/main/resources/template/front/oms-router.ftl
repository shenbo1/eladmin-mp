// route.config.ts
import type { IRoute } from '@/types/route';



const routes: IRoute[] = [
  {
    path: '/${package}',
    routes: [
      {
        path: '/${moduleName}/list',
        component: '@/modules/${package}/pages/${moduleName}/list.tsx',
      },
      {
        path: '/${moduleName}/:type/:code?',
        component: '@/modules/${package}/pages/${moduleName}/detail.tsx',
      }
    ],
  },
];

export default routes;

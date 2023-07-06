-- route.config.ts
import type { IRoute } from '@/types/route';
<#assign str =  "${className}">
<#assign firstChar = str[0]?lower_case>
<#assign convertedStr = firstChar + str[1..]>

const routes: IRoute[] = [
  {
    path: '/${convertedStr}',
    routes: [
      {
        path: '/${convertedStr}/list',
        component: '@/modules/${convertedStr}/pages/${convertedStr}/list.tsx',
      },
      {
        path: '/${convertedStr}/:type/:code?',
        component: '@/modules/${convertedStr}/pages/${convertedStr}/detail.tsx',
      }
    ],
  },
];

export default routes;

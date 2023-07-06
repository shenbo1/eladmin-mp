<#assign str =  "${className}">
<#assign firstChar = str[0]?lower_case>
<#assign convertedStr = firstChar + str[1..]>
import type { IWebService } from '@/system';
import { webModule } from '@/system';

interface I${className}Module {
  ${convertedStr}?: {
    /** 创建 */
    create?: IWebService;
    /** 获取详情 */
    get?: IWebService;
    /** 修改 */
    update?: IWebService;
    /** 分页查询 */
    pageList?: IWebService;
    /** 删除 */
   // delete?: IWebService;
  };
 }


export const ${convertedStr}Module = webModule<I${className}Module>('/${convertedStr}/v2.0', 'no_case');
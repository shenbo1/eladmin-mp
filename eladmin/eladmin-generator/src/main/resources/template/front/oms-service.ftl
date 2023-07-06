<#assign str =  "${className}">
<#assign firstChar = str[0]?lower_case>
<#assign convertedStr = firstChar + str[1..]>
import type { IWebService } from '@/system';
import { webModule } from '@/system';

<#assign className =  "${className}">
<#assign author =  "${author}">

<#if author!='' >
    <#assign className =  author>
</#if>
<#assign changeClassName =  className?uncap_first>

<#assign str = "${apiAlias}">

<#assign parts = str?split("|")>
<#assign string1 = parts[0]?trim>
<#assign string2 = parts[1]?trim>
<#assign string3 = parts[2]?trim>

interface I${className}Module {
  ${changeClassName}?: {
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



export const ${changeClassName}Module = webModule<I${className}Module>('/${string1}/${string2}', '${string3}');
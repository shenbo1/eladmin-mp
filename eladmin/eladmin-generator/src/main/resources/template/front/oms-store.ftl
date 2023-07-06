import { deserialize, list, object, primitive, serializable, serialize } from '@/utils/serializr';
import type { LabeledValue } from 'antd/lib/select';
import _ from 'lodash';
import { action, IObservableArray, observable, runInAction } from 'mobx';
import moment from 'moment';
import { Moment } from 'moment';
import { Module as module } from '../../service';
import { Dictionary } from '@/utils/dictionary';
<#assign str =  "${className}">
<#assign firstChar = str[0]?lower_case>
<#assign convertedStr = firstChar + str[1..]>

<#assign dictList = []>

// ${className}.store.tsx
export class ${className}Store{
    <#if columns??>
      <#list columns as column>

     <#assign columnType = column.columnType>
     <#if columnType == "String">
       <#assign result = "string">
     <#elseif columnType == "Integer" || columnType == "Decimal" || columnType == "Float"|| columnType == "Long">
       <#assign result = "number">
     <#elseif columnType == "Timestamp">
       <#assign result = "Moment">
     <#else>
       <#assign result = "string">
     </#if>
        <#if column.changeColumnName != 'id'  && column.changeColumnName != 'modifyAt'  && column.changeColumnName != 'modifyBy'
         && column.changeColumnName != 'deletedBy'  && column.changeColumnName != 'deletedAt' && column.changeColumnName!= 'deleted'
         && (column.formShow)
        >
         /* ${column.remark} */
         @serializable
         @observable
        ${column.changeColumnName}:${result}

        <#if (column.dictName)?? && (column.dictName)!=""  && (column.queryType)??  && column.queryType = '='>
        @observable
        ${column.dictName}Options : IObservableArray<LabeledValue> = observable.array([]);
        <#assign newItem = "${column.dictName}">
        <#assign dictList = dictList + [newItem]>
        </#if>
     </#if>
      </#list>


         @action
          async init() {
          <#if (dictList?size > 0)>
            const result = await Promise.all([
             <#list dictList as column>
              Dictionary.getData('${column?substring(0, 1)?upper_case + column?substring(1)}'),
             </#list>
            ]);
            const config = _.chain(result)
                .reduce((s, c = []) => s.concat(c), [])
                .map((item) => ({
                  dictionary_code: item?.dictionary_code,
                  value: item?.setting_code,
                  label: item?.setting_name,
                }))
                .groupBy('dictionary_code')
                .value();

            runInAction(() => {
               <#list dictList as column>
                 this.${column}Options.replace(config.${column?substring(0, 1)?upper_case + column?substring(1)});
               </#list>
            });
            </#if>
          }

              @action
              async getDetail(${convertedStr}Code: string) {
                const data = await module.${convertedStr}.get.get({ ${convertedStr}Code });

                runInAction(() => {
                  _.merge(this, data);
                });
              }

            @action
            async save() {
              const params = serialize(this);
              if (params.${convertedStr}Code) {
                await module.${convertedStr}.update.post(params);
              } else {
                await module.${convertedStr}.create.post(params);
              }
               return true;
            }


    </#if>
}
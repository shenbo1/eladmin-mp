
<#assign className =  "${className}">
<#assign author =  "${author}">

<#if author!='' >
    <#assign className =  author>
</#if>


import User from '@/components/Common/User';
import { column } from '@/components/ListView';
import { FormOperation } from '@/components/Web';
import { message } from 'antd';
import _ from 'lodash';
import React from 'react';
import { Moment } from 'moment';
import { TableOperation, TableOperationMode } from '@/components/Web';
import { AppStore } from '@/modules/common';
import { getEnumName } from '@/utils';
import { Inject } from '@/utils/mobx-provider';
import _ from 'lodash';
import { toJS } from 'mobx';
import {  ${className}Store } from '../../stores/${moduleName}/${moduleName}-store';



export enum ${className}OperationType {
  新增 = 'create',
  编辑 = 'edit',
  查看 = 'view'
}
<#assign stateType =  ''>
 <#if columns??>
      <#list columns as column>
             <#if column.changeColumnName = 'state'>
               <#assign stateType = column.columnType>
             </#if>
       </#list>
  </#if>

 <#if stateType!='' && stateType!='bool'>
 export enum ${author}State {
   生效 = 10,
   失效 = 20
 }
 </#if>

 <#if columns??>
      <#list columns as column>
        <#if (column.dictName)?? && (column.dictName)!=""  && (column.queryType)??  && column.queryType != '=' && (column.formType = 'Select' || column.formType = 'Radio') >
export enum ${column.dictName}{

}
     </#if>
</#list>
 </#if>

const app = Inject(AppStore);
let treeData: any[] = [];
treeData = [
  {
    key: 'all',
    label: '全部',
    order: -1,
    selectable: false,
    title: '全部',
    value: 'all',
    children: toJS(app.storeManager.storeTreeData),
  },
];

// list-column.tsx
export class ${className}Column{

    @column({
        title: '门店',
        valueType: 'treeSelect',
        search: true,
        hideInTable: true,
        request: async () => treeData,
        fieldProps: {
          treeDefaultExpandAll: true,
          placeholder: '请选择门店（可搜索）',
          treeCheckable: false,
          showSearch: true,
          showArrow: true,
          allowClear: true,
          maxTagCount: 'responsive',
          filterTreeNode: (v, treeNode) => {
            const { label, value } = treeNode.props;
            return _.includes(label, v) || _.includes(value, v);
          },
        },
      })
      storeCodes: string[];

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
        <#if column.changeColumnName != 'id'   && column.changeColumnName != 'modifyBy'
         && column.changeColumnName != 'deletedBy'  && column.changeColumnName != 'deletedAt' && column.changeColumnName!= 'deleted'
         && (column.queryType?? || column.columnShow)
        >
        @column({
            title: '${column.remark}',
             <#--  配置查询方式 -->
            <#if column.queryType?? && column.queryType!='BetWeen'>search: true,</#if>
            <#--  列表字段 不配置 -->
            <#if !column.columnShow>hideInTable: true,</#if>
            <#--  表单类型 查询方式 和关联字典 -->
           <#if column.queryType?? && column.formType?? && column.formType = 'Select' &&  (column.dictName)?? && (column.dictName)!="" >
            valueType: 'select',
            valueDictionary: '${column.dictName}',
            </#if>
            <#if column.changeColumnName='createBy'>render: (text, record: ${className}Column) => <User code={record.createBy} />,</#if>
            <#if column.changeColumnName=uniColName>render: (text, record: ${className}Column) => <Link to={'/${package}/${moduleName}/'+${className}OperationType.查看+"/"+ record.${uniColName}}>{record.${uniColName}}</Link>,</#if>
        })
        ${column.changeColumnName}:${result}

         <#if column.queryType?? && column.queryType == 'BetWeen'  && column.formType?? && column.formType = 'Date'>
           @column({
              title: '${column.remark}',
              valueType: 'dateRange',
              search: true,
              hideInTable: true,
              searchTransform: (value) => ({
                   ${column.changeColumnName}StartTime: value?.[0] ? value?.[0]+` 00:00:00` : value?.[0],
                   ${column.changeColumnName}EndTime: value?.[1] ? value?.[1]+` 23:59:59` : value?.[1],
               }),
               fieldProps: () => ({
                   placeholder: ['开始时间', '结束时间'],
              }),
           })
            ${column.changeColumnName}Range:${result}
         </#if>

        <#--  如果是Select 并且 配置了字典，自动生成一个查询 -->
        <#if column.queryType?? && column.formType?? && column.formType = 'Select' &&  (column.dictName)?? && (column.dictName)!="" >
        @column({
            title: '${column.remark}',
         })
        ${column.changeColumnName}Name:string
        </#if>
     </#if>
      </#list>

      @column((store: ${className}Store) => ({
         title: '操作',
         // width: 160,
         render: (_text, record: ${className}Column, _index, action) => {
           return (
             <TableOperation
               mode={TableOperationMode.noDropdown}
               menu={[
                 {
                   title: '编辑',
                   type: 'link',
                  link: '/${package}/${moduleName}/'+${className}OperationType.编辑+"/"+ record.${uniColName},
                    // onClick: async () => {
                     //  await store.getDetail(record.${uniColName});
                    // },
                 },
                 {
                   title: '详情',
                   type: 'link',
                   link: '/${package}/${moduleName}/'+${className}OperationType.查看+"/"+ record.${uniColName},
                 },
                 <#if stateType!='' && stateType!='bool'>
                 {
                   title: record.state === ${className}State.失效 ? '生效' : '失效',
                   type: 'link',
                   confirm: true,
                   onClick: async () => {
                    // await store.enabled(record.${uniColName}, record.state);
                     message.success('操作成功');
                     action.reload();
                   },
                 },
                  </#if>
               ]}
             />
           );
         },
       }))
       operation: string;
    </#if>
}
<#if author!='' >
    <#assign className =  author>
</#if>
<#assign changeClassName =  className?uncap_first>
<#assign dictList = []>

 <#if columns??>
      <#list columns as column>
        <#if (column.dictName)?? && (column.dictName)!=""  && (column.queryType)??  && column.queryType = 'enum' && (column.formType = 'Select' || column.formType = 'Radio') >
         <#assign dictList = dictList + [column.dictName]>
     </#if>
</#list>
 </#if>
 <#assign result = ''>
   <#list dictList as dict>
    <#assign result = result+','+dict>
   </#list>

import { getEnumOptions } from '@/components/AntdPlus/util';
import Attachment from '@/components/Common/Attachment';
import StoreSelectOption from '@/components/Common/StoreSelectOption';
import FooterToolbar from '@/components/FooterToolbar';
import { Page } from '@/components/Page';
import { Button } from '@/components/Web';
import { ExclamationCircleFilled } from '@ant-design/icons';
import ProForm, {
  ProFormDateTimePicker,
  ProFormDateTimeRangePicker,
  ProFormDatePicker,
  ProFormDigit,
  ProFormRadio,
  ProFormSelect,
  ProFormText,
  ProFormTextArea,
} from '@ant-design/pro-form';
import { Col, message, Row, Tooltip } from 'antd';
import _ from 'lodash';
import { runInAction, toJS } from 'mobx';
import { observer } from 'mobx-react';
import moment from 'moment';
import React from 'react';
import { useHistory, useParams } from 'react-router';
import { useAsync } from 'react-use';
import {  ${className}Store } from '../../stores/${moduleName}/detail-store';

import { ${className}Column,${className}OperationType${result} } from './list-column';


 <#assign filterColumns = []>

     <#if columns??>
             <#list columns as column >
                <#if column.formShow && column.formType?? && column.formType!=''>
                   <#assign filterColumns = filterColumns + [column]>
                 </#if>
            </#list>
   </#if>
const ${className}DetailPage = observer(() => {
  const history = useHistory();

  const { type, code } = useParams<{ type: ${className}OperationType; code: string }>();

 const pageTitle = {
    [${className}OperationType.新增]: '新增',
    [${className}OperationType.查看]: '查看',
    [${className}OperationType.编辑]: '编辑',
  };

   const { value: store, loading } = useAsync(async () => {
      const ${changeClassName}Store = new ${className}Store();
      await ${changeClassName}Store.init();
      if (type !== ${className}OperationType.新增) {
        await ${changeClassName}Store.getDetail(code);
      }
      return ${changeClassName}Store;
    }, [code]);


  const disabled = React.useMemo(
    () => type === ${className}OperationType.查看 ,
    [type]
  );

  const fields = _.map(store && toJS(store), (value, name) => ({ name, value }));

  const onValuesChange = (values) => {
    runInAction(() => {
      _.assign(store, values);
    });
  };

   return (
      !loading && (
        <Page title={pageTitle[type]} storeSelectorHidden>
                 <ProForm
                      fields={fields}
                      onValuesChange={onValuesChange}
                      layout="horizontal"
                      submitter={{
                        render: (props) => {
                          const actions = [
                            <Button key="back" onClick={() =>   history.goBack()}>
                              返回
                            </Button>,
                          ];
                          if (type !==  ${className}OperationType.查看) {
                            actions.push(
                              <Button
                                type="primary"
                                key="submit"
                                htmlType="submit"
                                onClick={() => {
                                  props?.form
                                    ?.validateFields?.()
                                    .then(async () => {
                                      if (type ===  ${className}OperationType.新增) {
                                        await store?.save();
                                        message.success('新增成功');
                                        history.goBack();
                                      } else if (type ===  ${className}OperationType.编辑) {
                                        await store?.save();
                                        message.success('编辑成功');
                                        history.goBack();
                                      }
                                    })
                                    .catch((error) => {
                                      if (error?.errorFields?.length > 0) {
                                        message.error('请检查填写必填项!');
                                      }
                                    });
                                }}
                              >
                                保存
                              </Button>
                            );
                          }
                          return <FooterToolbar style={{ padding: '0 40%' }}>{actions}</FooterToolbar>;
                        },
                      }}
                    >
                     <#if columns??>

                          <#list filterColumns as column >

                              <#if column?index % 3 == 0>
                                 <Row>
                               </#if>
                                <Col span={8}>
                                    <#if column.formType = 'Input'>
                                        <ProFormText
                                           <#if column.istNotNull>
                                            required
                                            rules={[{ required: true }]}
                                            </#if>
                                            label="${column.remark}"
                                            name="${column.changeColumnName}"
                                            disabled={disabled}
                                         />
                                    <#elseif column.formType = 'InputNumber'>
                                        <ProFormDigit
                                            fieldProps={{ min: 0, decimalSeparator: '0' }}
                                            <#if column.istNotNull>
                                            required
                                            rules={[{ required: true }]}
                                            </#if>
                                            label="${column.remark}"
                                            name="${column.changeColumnName}"
                                            disabled={disabled}
                                         />
                                    <#elseif column.formType = 'Date'>
                                         <ProFormDatePicker
                                              <#if column.istNotNull>
                                              required
                                              rules={[{ required: true }]}
                                              </#if>
                                              label="${column.remark}"
                                              name="${column.changeColumnName}"
                                              disabled={disabled}
                                          />
                                    <#elseif column.formType = 'Textarea'>
                                         <ProFormTextArea
                                             <#if column.istNotNull>
                                             required
                                             rules={[{ required: true }]}
                                             </#if>
                                             label="${column.remark}"
                                             name="${column.changeColumnName}"
                                             disabled={disabled}
                                              fieldProps={{
                                                 showCount: true,
                                                 maxLength: 200,
                                               }}
                                         />
                                    <#elseif column.formType = 'Select'>
                                         <ProFormSelect
                                              fieldProps={{
                                               <#if (column.dictName)?? && (column.dictName)!="">
                                                   <#--  如果是等于 直接取store,不然就是枚举 -->
                                                 <#if column.queryType = 'enum'>
                                                 options: getEnumOptions(${column.dictName}),
                                                <#else>
                                                 options: store?.${column.dictName}Options.slice(),
                                                 </#if>
                                               </#if>
                                                 showSearch: true,
                                                 onClear: () => {
                                                   store.${column.changeColumnName} = undefined;
                                                 },
                                               }}
                                               <#if column.istNotNull>
                                               required
                                               rules={[{ required: true }]}
                                               </#if>
                                               label="${column.remark}"
                                               name="${column.changeColumnName}"
                                               disabled={disabled}
                                            />
                                    <#elseif column.formType = 'Radio'>
                                         <ProFormRadio.Group
                                         <#if (column.dictName)?? && (column.dictName)!="">
                                            <#--  如果是等于 直接取store,不然就是枚举 -->
                                          <#if column.queryType = 'enum'>
                                          options =   getEnumOptions(${column.dictName})
                                         <#else>
                                          options = store?.${column.dictName}Options.slice()
                                          </#if>
                                        </#if>
                                          <#if column.istNotNull>
                                          required
                                          rules={[{ required: true }]}
                                          </#if>
                                          label="${column.remark}"
                                          name="${column.changeColumnName}"
                                          disabled={disabled}
                                       />
                                    <#elseif column.formType = 'Image'>
                                        <ProForm.Item

                                          label="${column.remark}"
                                          name={'${column.changeColumnName}Code'}
                                        >
                                          <Attachment
                                            attachmentType="Activity"
                                            disabled={disabled}
                                            otherCode={store.${uniColName}}
                                            count={1}
                                            maxFileSize={0.128}
                                            listType="picture-card"
                                            // noGetData={store.${uniColName}}
                                            // deleteLocal
                                            accept="image/x-png,image/jpeg"
                                            onChangeMapping={(list) => {
                                              if (!store) {
                                                return;
                                              }
                                              store.${column.changeColumnName} = list[0]?.fileCode;
                                            }}
                                            onRemove={() => {
                                              store.${column.changeColumnName} = undefined;
                                            }}
                                          />
                                        {/*  <span style={{ color: '#999' }}>建议尺寸256*256p x；大小建议小于128k</span>*/}
                                        </ProForm.Item>
                                    </#if>
                                 </Col>
                                 <#if (column?index + 1) % 3 == 0 || column?index == filterColumns?size - 1>
                                     </Row>
                                   </#if>

                          </#list>
                       </#if>
              </ProForm>
        </Page>
    )
  );
});

  export default ${className}DetailPage;
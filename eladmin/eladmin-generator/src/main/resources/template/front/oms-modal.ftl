 -- detail.tsx
 <#assign str =  "${className}">
 <#assign firstChar = str[0]?lower_case>
 <#assign convertedStr = firstChar + str[1..]>

import Attachment from '@/components/Common/Attachment';
import StoreSelectOption from '@/components/Common/StoreSelectOption';
import FooterToolbar from '@/components/FooterToolbar';
import { Page } from '@/components/Page';
import { Button } from '@/components/Web';
import { ExclamationCircleFilled } from '@ant-design/icons';
import ProForm, {
  ProFormDateTimePicker,
  ProFormDateTimeRangePicker,
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
import { ${className}Store } from '../../stores/${convertedStr}/${convertedStr}.store';
import type { DialogComponentProps } from '@/components/Dialog';
import { ${className}Column,${className}OperationType } from './list-column';

interface IAdd${className}ModalProps  extends DialogComponentProps {
  store?: ${className}Store;
   operateType:${className}OperationType;
}

const Add${className}Modal: React.FC<IAdd${className}ModalProps> = observer(({ onFinish, store }) => {
  const onValuesChange = (values) => {
    runInAction(() => {
      _.assign(store, values);
    });
  };

  const fields = _.map(store && toJS(store), (value, name) => ({ name, value }));

  return (
    <ModalForm
      title={getEnumName(${className}OperationType, operateType)}
      visible={store.modalVisible}
      layout="horizontal"
      fields={fields}
      onValuesChange={onValuesChange}
      onVisibleChange={(e) => {
        if (!isVisible) {
            callback(new Error('cancel'));
       }
      }}
      modalProps={{ maskClosable: false }}
      onFinish={async () => {
        const res = await store.save();
         if (res) {
           callback(null, 'success');
         }
      }}
    >
      <>
        -- form
      </>
    </ModalForm>
  );
});

export default Add${className}Modal;
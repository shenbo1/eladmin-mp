<#assign str =  "${className}">
<#assign firstChar = str[0]?lower_case>
<#assign convertedStr = firstChar + str[1..]>

import { ListView } from '@/components/ListView';
import { useQuery } from '@/utils/hooks';
import { Button, Modal } from 'antd-legacy';
import _ from 'lodash';
import { observer } from 'mobx-react';
import React, { useState } from 'react';
import { useHistory, useLocation, useParams } from 'react-router';
import { ${convertedStr}Module as module } from '../../service';
import { ${className}Column,${className}OperationType } from './list-column';
import type { ActionType } from '@/components/ListView';
import { showDialog } from '@/components/Dialog';
import type { ProFormInstance } from '@ant-design/pro-form';

// list.tsx
const ${className}ListPage = observer(() => {
  const { code } = useParams<{ code: string }>();
  const location = useLocation();
  const [query, setQuery] = useQuery();
  const history = useHistory();
 const store = new ${className}Store();
  const actionRef = React.createRef<ActionType>();
 const formRef = React.createRef<ProFormInstance>();

  return (
    <div>
      <ListView
      actionRef={actionRef}
      formRef={formRef}
        storeSelectorHidden
        api={module.${convertedStr}.pageList}
        apiTransform={{
          requestTransform: (v) => ({
            ..._.omit(v, 'current'),
            pageIndex: _.toNumber(v.current),
            pageSize: _.toNumber(v.pageSize)
          }),
        }}
        modelSchema={${className}Column}
        rowKey="${convertedStr}Code"
        scroll={{ x: 'max-content' }}
        toolBarRender={(action) => [
            <Button
              key="create"
              type="primary"
              onClick={() => {
               // history.push('/${convertedStr}/${convertedStr}/'+${className}OperationType.新增);
                const result = await showDialog(Add${className}Modal, {
                    operateType:${className}OperationType.新增,
                  });
                  if (result) {
                    message.success('新增成功');
                    actionRef?.current.reload();
                  }
              }}
            >
              新增
            </Button>,

        ]}
      />

    </div>
  );
});
export default ${className}ListPage;

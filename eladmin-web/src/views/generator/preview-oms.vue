<template>
  <el-tabs v-model="activeName" type="card">
    <el-tab-pane v-for="item in data" :key="item.name" :lazy="true" :label="item.name" :name="item.name">
      <Java :value="item.content" :height="height" />
    </el-tab-pane>
  </el-tabs>
</template>

<script>
import Java from '@/components/JavaEdit/index'
import { generatorOMS } from '@/api/generator/generator'
export default {
  name: 'Preview',
  components: { Java },
  data() {
    return {
      data: null, height: '', activeName: 'oms-router'
    }
  },
  created() {
    this.height = document.documentElement.clientHeight - 180 + 'px'
    const tableName = this.$route.params.tableName
    generatorOMS(tableName, 1).then(data => {
      this.data = data
    }).catch(() => {
      this.$router.go(-1)
    })
  }
}
</script>

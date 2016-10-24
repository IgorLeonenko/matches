<template>
  <div>
    <div v-if="user.authenticated">
      <p>
        Welcome, {{user.data.username}} |
        <a href='#' @click='logout()'>Logout</a>
      </p>
      <router-link :to="{name: 'matches'}">Matches</router-link>
      <router-link :to="{name: 'tournaments'}">Tournaments</router-link>
    </div>
    <div v-else>
      <router-link to='/login'>Login</router-link>
    </div>
  </div>
</template>

<script>
import auth from '../auth'
export default {
  data () {
    return {
      user: auth.user
    }
  },
  methods: {
    logout () {
      auth.logout()
    }
  }
}
</script>

<style>
</style>

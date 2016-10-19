<template>
  <div class="login">
    <h1>Login</h1>
    <div class="form-group">
      <input type="text" class="form-control"
             placeholder="Enter your email" v-model="email">
    </div>
    <div class="form-group">
      <input type="password" class="form-control"
             placeholder="Enter your password" v-model="password">
    </div>
    <button type='button' @click="submit()">Login</button>
  </div>
</template>

<script>
  import auth from '../auth'

  export default {
    data () {
      return {
        email: '',
        password: ''
      }
    },
    methods: {
      submit () {
        auth.login(this.email, this.password)
      }
    }
  }
</script>

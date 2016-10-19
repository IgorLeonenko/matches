<template>
  <div id="app">
    <img src="./assets/logo.png">
    <navigation></navigation>
    <router-view></router-view>
  </div>
</template>

<script>
import auth from './auth'
import Navigation from './components/Nav'
import Hello from './components/Hello'

export default {
  data () {
    return {
      user: auth.user
    }
  },
  name: 'app',
  components: {
    Navigation,
    Hello
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>

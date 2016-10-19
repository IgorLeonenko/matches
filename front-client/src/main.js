import Vue from 'vue'
import App from './App'
import VueRouter from 'vue-router'

import Login from './components/Login'
import Matches from './components/Matches'
import auth from './auth'
import api from './api'

Vue.use(VueRouter)

const routes = [
  {
    path: '/login',
    name: 'login',
    component: Login
  },
  {
    path: '/matches',
    name: 'matches',
    component: Matches
  }

]

export const router = new VueRouter({
  routes
})

new Vue({
  router,
  beforeMount () {
    var token = auth.getToken()
    if (token) {
      auth.user.authenticated = true
      auth.user.data = JSON.parse(localStorage.getItem('user'))
      api.logIn()
      this.$router.push('/matches')
    } else {
      auth.user.authenticated = false
      auth.user.data = ''
      api.logOut()
      this.$router.push('/login')
    }
  },
  render: h => h(App)
}).$mount('#app')

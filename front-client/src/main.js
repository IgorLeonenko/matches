import Vue from 'vue'
import App from './App'
import VueRouter from 'vue-router'

import Hello from './components/Hello'
import Login from './components/Login'
import Matches from './components/Matches'

Vue.use(VueRouter)

const routes = [
  { path: '/home', component: Hello },
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

const router = new VueRouter({
  routes
})

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')

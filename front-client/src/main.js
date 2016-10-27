import Vue from 'vue'
import App from './App'
import VueRouter from 'vue-router'
import store from './vuex/store'

import Login from './components/Login'
import Matches from './components/Matches'
import showMatch from './components/ShowMatch'
import Tournaments from './components/Tournaments'
import Tournament from './components/Tournament'
import newTournament from './components/NewTournament'
import updateTournament from './components/UpdateTournament'
import tournamentInfo from './components/TournamentInfo'
import tournamentTeams from './components/TournamentTeams'
import tournamentMatches from './components/TournamentMatches'
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
  },
  {
    path: '/matches/:id',
    name: 'showMatch',
    component: showMatch
  },
  {
    path: '/tournaments',
    name: 'tournaments',
    component: Tournaments
  },
  {
    path: 'tournaments/new',
    name: 'tournamentNew',
    component: newTournament
  },
  {
    path: '/tournaments/:id',
    name: 'Tournament',
    component: Tournament,
    children: [
      {
        path: 'info',
        name: 'tournamentInfo',
        component: tournamentInfo
      },
      {
        path: 'teams',
        name: 'tournamentTeams',
        component: tournamentTeams
      },
      {
        path: 'matches',
        name: 'tournamentMatches',
        component: tournamentMatches
      },
      {
        path: 'edit',
        name: 'tournamentUpdate',
        component: updateTournament
      }
    ]
  }
]

export const router = new VueRouter({
  routes
})

router.beforeEach((to, from, next) => {
  if (to.path === '/login') {
    next()
  } else {
    if (auth.user.authenticated === true) {
      next()
    } else {
      next({ path: '/login' })
    }
  }
})

new Vue({
  router,
  store,
  async beforeMount () {
    auth.checkAuth()
    if (auth.user.authenticated === true) {
      auth.user.data = JSON.parse(localStorage.getItem('user'))
      api.logIn()
      this.$router.push('/tournaments')
      store.dispatch('getTournaments')
      store.dispatch('getGames')
    } else {
      localStorage.removeItem('user')
      api.logOut()
      this.$router.push('/')
    }
  },
  render: h => h(App)
}).$mount('#app')

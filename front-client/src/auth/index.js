import axios from 'axios'
import api from '../api'
import store from '../vuex/store'
import {router} from '../main'

const LOGIN_PATH = 'http://localhost:3000/user_token'

export default {
  user: {
    authenticated: false
  },
  login (email, password) {
    axios.post(LOGIN_PATH, {auth: {email: email, password: password}}).then(response => {
      store.dispatch('createSession', [response.data.knock.jwt, response.data.user])
      localStorage.setItem('id_token', response.data.knock.jwt)
      localStorage.setItem('user', JSON.stringify(response.data.user))
      this.user.authenticated = true
      this.user.data = JSON.parse(localStorage.getItem('user'))
      api.logIn()
      store.dispatch('getUsers')
      store.dispatch('getMatches')
      store.dispatch('getTournaments')
      store.dispatch('getGames')
      router.push('/tournaments')
    })
  },
  logout () {
    localStorage.removeItem('id_token')
    localStorage.removeItem('user')
    this.user.authenticated = false
    api.logOut()
    router.push('/')
  },
  checkAuth () {
    var jwt = localStorage.getItem('id_token')
    if (jwt) {
      this.user.authenticated = true
    } else {
      this.user.authenticated = false
    }
  }
}

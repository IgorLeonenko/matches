import axios from 'axios'

const LOGIN_PATH = 'http://localhost:3000/user_token'

export default {
  user: {
    authenticated: false
  },

  login (email, password) {
    axios.post(LOGIN_PATH, {auth: {email: email, password: password}}).then(response => {
      localStorage.setItem('id_token', response.data.knock.jwt)
      this.user.authenticated = true
      this.user.data = response.data.user
    })
  },
  logout () {
    localStorage.removeItem('id_token')
    this.user.authenticated = false
  }
}

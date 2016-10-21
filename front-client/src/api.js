import axios from 'axios'
import auth from './auth'
import router from './main'

const API_PATH = 'http://localhost:3000/api/v1'

axios.defaults.baseURL = API_PATH

axios.interceptors.response.use(response => {
  return response
}, error => {
  if (error.response.status === 401 || error.response.status === 403) {
    auth.logout()
    router.push('/login')
  }
})

export default {
  logIn () {
    axios.defaults.headers.common['Authorization'] = 'Bearer ' + localStorage.getItem('id_token')
  },
  logOut () {
    axios.defaults.headers.common['Authorization'] = ''
  },
  async getMatches () {
    return (await axios.get(API_PATH + '/matches'))
  },
  async getMatch (id) {
    return (await axios.get(API_PATH + '/matches/' + id))
  },
  async getTournaments () {
    return (await axios.get(API_PATH + '/tournaments'))
  },
  async getTournament (id) {
    return (await axios.get(API_PATH + '/tournaments/' + id))
  }
}

import axios from 'axios'
import auth from './auth'
import router from './main'

const API_PATH = 'http://localhost:3000/api/v1'

axios.defaults.baseURL = API_PATH

export const getMatches = () => axios.get('/matches')

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
  }
}

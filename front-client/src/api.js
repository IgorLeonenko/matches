import axios from 'axios'

const API_PATH = 'http://localhost:3000/api/v1'

axios.defaults.baseURL = API_PATH

export const getMatches = () => axios.get('/matches')

export default {
  logIn () {
    axios.defaults.headers.common['Authorization'] = 'Bearer ' + localStorage.getItem('id_token')
  },
  logOut () {
    axios.defaults.headers.common['Authorization'] = ''
  }
}

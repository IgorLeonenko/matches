import axios from 'axios'
import auth from './auth'
import router from './main'
import store from './vuex/store'

const API_PATH = 'http://localhost:3000/api/v1'

axios.defaults.baseURL = API_PATH

axios.interceptors.response.use(response => {
  store.dispatch('errors', '')
  return response
}, error => {
  if (error.response.status === 401 || error.response.status === 403) {
    auth.logout()
    router.push('/login')
  } else if (error.response.status === 422) {
    store.dispatch('errors', error.response.data.errors)
  }
})

export default {
  logIn () {
    axios.defaults.headers.common['Authorization'] = 'Bearer ' + localStorage.getItem('id_token')
  },
  logOut () {
    axios.defaults.headers.common['Authorization'] = ''
  },
  async getGames () {
    return await axios.get(API_PATH + '/games')
  },
  async getUsers () {
    return await axios.get(API_PATH + '/users')
  },
  async createUser (params) {
    return await axios.post(API_PATH + '/users/', {user: params})
  },
  async getMatches () {
    return await axios.get(API_PATH + '/matches')
  },
  async updateMatch (params, id) {
    return await axios.patch(API_PATH + '/matches/' + id, {match: params})
  },
  async createFriendlyMatch (params) {
    return await axios.post(API_PATH + '/matches', {match: params})
  },
  async getTournaments () {
    return await axios.get(API_PATH + '/tournaments')
  },
  async createTournament (params) {
    return await axios.post(API_PATH + '/tournaments/', {tournament: params})
  },
  async updateTournament (params, id) {
    return await axios.patch(API_PATH + '/tournaments/' + id, {tournament: params})
  },
  async addTeam (id, params) {
    return await axios.post(API_PATH + '/tournaments/' + id + '/teams', {team: params})
  },
  async removeTeam (tournamentId, teamId) {
    return await axios.delete(API_PATH + '/tournaments/' + tournamentId + '/teams/' + teamId)
  },
  async addUserToTeam (tournamentId, teamId, userId) {
    return await axios.patch(API_PATH + '/tournaments/' + tournamentId + '/teams/' + teamId, {team: {user_ids: [userId]}})
  },
  async removeUser (tournamentId, teamId, userId) {
    return await axios.delete(API_PATH + '/tournaments/' + tournamentId + '/teams/' + teamId + '/remove_user/' + userId)
  }
}

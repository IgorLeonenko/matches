import Vue from 'vue'
import Vuex from 'vuex'
import api from '../api'
import { router } from '../main'
import auth from '../auth'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    tournaments: [],
    matches: [],
    games: [],
    errors: [],
    users: []
  },
  mutations: {
    SET_USERS_LIST (state, users) {
      state.users = users.data
    },
    SET_GAMES_LIST (state, games) {
      state.games = games.data
    },
    SET_TOURNAMENTS_LIST (state, tournaments) {
      state.tournaments = tournaments.data
    },
    ADD_TOURNAMENT (state, tournament) {
      state.tournaments.push(tournament)
    },
    EDIT_TOURNAMENT (state, tournament) {
      let index = state.tournaments.findIndex(({ id }) => id === tournament.id)
      state.tournaments.splice(index, 1, tournament)
    },
    ADD_MATCH (state, match) {
      state.matches.push(match)
    },
    ADD_TEAM (state, {tournamentId, team}) {
      let index = state.tournaments.findIndex(({ id }) => id === tournamentId)
      let tournament = state.tournaments[index]
      tournament.teams.push(team.data)
    },
    REMOVE_TEAM (state, {tournamentId, team}) {
      let tournamentIndex = state.tournaments.findIndex(({ id }) => id === tournamentId)
      let tournament = state.tournaments[tournamentIndex]
      let teamIndex = tournament.teams.findIndex(({ id }) => id === team.data.id)
      tournament.teams.splice(teamIndex, 1)
    },
    ADD_USER (state, user) {
      state.users.push(user)
    },
    ADD_USER_TO_TEAM (state, {tournamentId, team}) {
      let tournamentIndex = state.tournaments.findIndex(({ id }) => id === tournamentId)
      let tournament = state.tournaments[tournamentIndex]
      let teamIndex = tournament.teams.findIndex(({ id }) => id === team.data.id)
      tournament.teams.splice(teamIndex, 1, team.data)
    },
    REMOVE_USER (state, {tournamentId, team, user}) {
      let tournamentIndex = state.tournaments.findIndex(({ id }) => id === tournamentId)
      let tournament = state.tournaments[tournamentIndex]
      let teamIndex = tournament.teams.findIndex(({ id }) => id === team.data.id)
      if (team.data.users.length === 0) {
        tournament.teams.splice(teamIndex, 1)
      } else {
        tournament.teams.splice(teamIndex, 1, team.data)
      }
    },
    SET_MATCHES_LIST (state, matches) {
      state.matches = matches.data
    },
    EDIT_MATCH (state, match) {
      let index = state.matches.findIndex(({ id }) => id === match.id)
      state.matches.splice(index, 1, match)
    },
    ADD_ERRORS (state, errors) {
      state.errors.splice(0)
      state.errors.push(errors)
    },
    REMOVE_ERRORS (state) {
      state.errors = []
    }
  },
  actions: {
    async getUsers ({commit}) {
      let users = await api.getUsers()
      commit('SET_USERS_LIST', users)
    },
    async getGames ({commit}) {
      let games = await api.getGames()
      commit('SET_GAMES_LIST', games)
    },
    async getTournaments ({commit}) {
      let tournaments = await api.getTournaments()
      commit('SET_TOURNAMENTS_LIST', tournaments)
    },
    async getMatches ({commit}) {
      let matches = await api.getMatches()
      commit('SET_MATCHES_LIST', matches)
    },
    async createMatch ({commit}, match) {
      match = await api.createFriendlyMatch(match)
      if (match) {
        commit('ADD_MATCH', match.data)
        router.push({name: 'matches'})
      }
    },
    async updateMatch ({commit}, [params, match]) {
      match = await api.updateMatch(params, match.id)
      if (match) {
        commit('EDIT_MATCH', match.data)
      }
    },
    async addTournament ({commit}, tournament) {
      tournament = await api.createTournament(tournament)
      if (tournament) {
        commit('ADD_TOURNAMENT', tournament.data)
        router.push({name: 'tournaments'})
      }
    },
    async createUser ({commit}, user) {
      user = await api.createUser(user)
      if (user) {
        commit('ADD_USER', user.data)
        auth.login(user.data.email, user.data.password)
      }
    },
    async updateTournament ({commit}, tournament) {
      tournament = await api.updateTournament(tournament, tournament.id)
      if (tournament) {
        commit('EDIT_TOURNAMENT', tournament.data)
        router.push({name: 'tournamentInfo', params: {id: tournament.data.id}})
      }
    },
    async addTeam ({commit}, [tournamentId, teamParams]) {
      let team = await api.addTeam(tournamentId, teamParams)
      if (team) {
        commit('ADD_TEAM', {tournamentId, team})
      }
    },
    async removeTeam ({commit}, [tournamentId, teamId]) {
      let team = await api.removeTeam(tournamentId, teamId)
      if (team) {
        commit('REMOVE_TEAM', {tournamentId, team})
      }
    },
    async addUser ({commit}, [tournamentId, teamId, userId]) {
      let team = await api.addUserToTeam(tournamentId, teamId, userId)
      if (team) {
        commit('ADD_USER_TO_TEAM', {tournamentId, team})
      }
    },
    async removeUser ({commit}, [tournamentId, teamId, userId]) {
      let team = await api.removeUser(tournamentId, teamId, userId)
      if (team) {
        commit('REMOVE_USER', {tournamentId, team})
      }
    },
    errors ({commit}, errors) {
      if (errors) {
        commit('ADD_ERRORS', errors)
      } else {
        commit('REMOVE_ERRORS')
      }
    }
  }
})

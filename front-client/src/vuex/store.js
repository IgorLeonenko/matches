import Vue from 'vue'
import Vuex from 'vuex'
import api from '../api'
import { router } from '../main'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    tournaments: [],
    games: [],
    errors: []
  },
  mutations: {
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
    ADD_ERRORS (state, errors) {
      state.errors.splice(0)
      state.errors.push(errors)
    }
  },
  actions: {
    async getGames ({commit}) {
      let games = await api.getGames()
      commit('SET_GAMES_LIST', games)
    },
    async getTournaments ({commit}) {
      let tournaments = await api.getTournaments()
      commit('SET_TOURNAMENTS_LIST', tournaments)
    },
    async addTournament ({commit}, tournament) {
      tournament = await api.createTournament(tournament)
      if (tournament) {
        commit('ADD_TOURNAMENT', tournament.data)
        router.push({name: 'tournaments'})
      }
    },
    async updateTournament ({commit}, tournament) {
      tournament = await api.updateTournament(tournament, tournament.id)
      if (tournament) {
        commit('EDIT_TOURNAMENT', tournament.data)
        router.push({name: 'tournamentInfo', params: {id: tournament.data.id}})
      }
    },
    errors ({commit}, errors) {
      if (errors) {
        commit('ADD_ERRORS', errors)
      }
    }
  }
})
